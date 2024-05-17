# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


import os
import lxml.etree

from ..utils.Common import *
from .Solver import Solver
from .Network import Network
from ..Dyd.DydData import DydData
from ..utils.UpdateXMLExceptions import *


class JobData:
    """
    Represents a job

    Attributes
    ---------
    __jobname : str
        name of the job
    __xml_element : lxml.etree._Element
        job XML element in Job file
    __parent_directory : str
        path of the job file parent directory
    solver : Solver
        solver data of the job
    network : Network
        network data of the job
    """
    def __init__(self,
                    jobname,
                    xml_element,
                    parent_directory,
                    dyds_collection,
                    par_files_collection,
                    curves_collection,
                    final_state_values_collection):
        """
        Parse the job XML element

        Parameters:
            jobname (str): name of the job
            xml_element (lxml.etree._Element): job XML element in Job file
            parent_directory (str): path of the job file parent directory
            dyds_collection (list[DydData]): list of parsed Dyd files
            par_files_collection (dict[str, Par]): collection of parsed Par files
            curves_collection (dict[str, lxml.etree._ElementTree]): collection of curves trees
            final_state_values_collection (dict[str, lxml.etree._ElementTree]): collection of final state values trees
        """
        self.__jobname = jobname
        self.__xml_element = xml_element
        self.__parent_directory = parent_directory
        self.__parse_curves_file(curves_collection)
        self.__parse_final_state_values_file(final_state_values_collection)

        number_of_dyds = 0
        number_of_solvers = 0
        number_of_modelers = 0
        number_of_networks = 0
        for job_subelement in self.__xml_element:
            if isinstance(job_subelement, lxml.etree._Comment):
                continue
            if job_subelement.tag == xmlns('solver'):
                number_of_solvers += 1
                if number_of_solvers >= 2:
                    raise MoreThanOneSolverGivenError
                solver_absolute_path = os.path.join(self.__parent_directory, job_subelement.attrib['parFile'])
                solver_parset = get_parset(solver_absolute_path, job_subelement.attrib['parId'], par_files_collection)
                self.solver = Solver(job_subelement, solver_parset)
            elif job_subelement.tag == xmlns('modeler'):
                number_of_modelers += 1
                if number_of_modelers >= 2:
                    raise MoreThanOneModelerGivenError
                for modeler_element in job_subelement:
                    if isinstance(modeler_element, lxml.etree._Comment):
                        continue
                    if modeler_element.tag == xmlns('network'):
                        number_of_networks += 1
                        if number_of_networks >= 2:
                            raise MoreThanOneNetworkGivenError
                        network_parset = None
                        if 'parFile' in modeler_element.attrib and 'parId' in modeler_element.attrib:
                            network_par_file_absolute_path = os.path.join(self.__parent_directory,
                                                                            modeler_element.attrib['parFile'])
                            network_parset = get_parset(network_par_file_absolute_path,
                                                        modeler_element.attrib['parId'],
                                                        par_files_collection)
                        else:
                            if 'parFile' in modeler_element.attrib and 'parId' not in modeler_element.attrib:
                                raise MissingAttributeError('parId', modeler_element.tag, self.__xml_element.base)
                            if 'parFile' not in modeler_element.attrib and 'parId' in modeler_element.attrib:
                                raise MissingAttributeError('parFile', modeler_element.tag, self.__xml_element.base)
                        self.network = Network(network_parset, curves_collection, final_state_values_collection)
                    elif modeler_element.tag == xmlns('dynModels'):
                        number_of_dyds += 1
                        dyd_absolute_path = os.path.join(self.__parent_directory, modeler_element.attrib['dydFile'])
                        if dyd_absolute_path not in dyds_collection:
                            dyds_collection[dyd_absolute_path] = DydData(dyd_absolute_path,
                                                                            self.__parent_directory,
                                                                            par_files_collection,
                                                                            curves_collection,
                                                                            final_state_values_collection)
                    elif modeler_element.tag in [xmlns('precompiledModels'),
                                                    xmlns('modelicaModels'),
                                                    xmlns('initialState')]:
                        pass  # nothing to do
                    else:
                        raise UnknownJobElementError(modeler_element.tag)
            elif job_subelement.tag == xmlns('outputs') or \
                    job_subelement.tag == xmlns('simulation') or \
                    job_subelement.tag == xmlns('localInit'):
                pass  # nothing to do
            else:
                raise UnknownJobElementError(job_subelement.tag)
        if number_of_dyds == 0:
            raise NoDydError(self.__jobname, self.__xml_element.base)

    def __parse_curves_file(self, curves_collection):
        curves_elem = self.__xml_element.xpath('./dyn:outputs/dyn:curves', namespaces=NAMESPACE_URI)
        if len(curves_elem) == 1:
            curves_absolute_path = os.path.join(self.__parent_directory, curves_elem[0].attrib['inputFile'])
            if curves_absolute_path not in curves_collection:
                try:
                    curves_collection[curves_absolute_path] = lxml.etree.parse(curves_absolute_path)
                except OSError as exc:
                    raise CurvesFileDoesNotExistError(curves_absolute_path) from exc
        elif len(curves_elem) == 0:
            pass  # nothing to do
        else:
            raise DuplicateCurvesFilesError(curves_elem[0].attrib['inputFile'], self.__xml_element.base)

    def __parse_final_state_values_file(self, final_state_values_collection):
        self._final_state_values_tree = None
        final_state_values_elem = self.__xml_element.xpath("./dyn:outputs/dyn:finalStateValues", namespaces=NAMESPACE_URI)
        if len(final_state_values_elem) == 1:
            final_state_values_absolute_path = os.path.join(self.__parent_directory,
                                                            final_state_values_elem[0].attrib['inputFile'])
            if final_state_values_absolute_path not in final_state_values_collection:
                try:
                    final_state_values_collection[final_state_values_absolute_path] = lxml.etree.parse(final_state_values_absolute_path)
                except OSError as exc:
                    raise FinalStateValuesFileDoesNotExistError(final_state_values_absolute_path) from exc
        elif len(final_state_values_elem) == 0:
            pass  # nothing to do
        else:
            raise DuplicateFinalStateValuesFilesError(final_state_values_elem[0].attrib['inputFile'], self.__xml_element.base)
