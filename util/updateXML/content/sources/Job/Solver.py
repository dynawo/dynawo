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


from ..Par.Parset import Parset


class Solver:
    """
    Represents a solver

    Attributes
    ----------
    __job_xml_element : lxml.etree._Element
        solver XML element in Job file
    parset : Parset
        parset related to the solver
    """
    def __init__(self, job_xml_element, parset_tree):
        self.__job_xml_element = job_xml_element
        self.parset = Parset(parset_tree)

    # ---------------------------------------------------------------
    #   USER METHOD
    # ---------------------------------------------------------------

    def set_lib_name(self, new_lib_name):
        self.__job_xml_element.attrib['lib'] = new_lib_name
