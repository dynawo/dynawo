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
from .BlackBoxModel import BlackBoxModel
from .ModelicaModel import ModelicaModel
from .ModelTemplateExpansion import ModelTemplateExpansion
from .ModelTemplate import ModelTemplate
from ..utils.UpdateXMLExceptions import *


class DydData:
    """
    Represents a Dyd file

    Attributes
    ----------
    _filename : str
        name of the Dyd file
    __job_parent_directory : str
        absolute filepath of the job parent directory
    _dydtree : lxml.etree._ElementTree
        lxml ElementTree of Dyd XML file
    __bbms : list[BlackBoxModel]
        list of blackBoxModels defined in Dyd XML file
    __modelica_models : list[ModelicaModel]
        list of modelicaModel defined in Dyd XML file
    __model_template_expansions : list[ModelTemplateExpansion]
        list of modelTemplateExpansion defined in Dyd XML file
    """
    def __init__(self, filepath, job_parent_directory, par_files_collection, curves_collection, final_state_values_collection):
        """
        Parse the Dyd file

        Parameters:
            filepath (str): absolute filepath of the Dyd file to parse
            job_parent_directory (str): absolute filepath of the Job parent directory
            par_files_collection (dict[str, Par]): par files content (key : Par file path, value : Par object)
            curves_collection (dict[str, lxml.etree._ElementTree]): curves files content (key : CRV file path, value : CRV element tree)
            final_state_values_collection (dict[str, lxml.etree._ElementTree]): final state values file content (key : FSV file path, value : FSV element tree)
        """
        self._filename = os.path.basename(filepath)
        self.__job_parent_directory = job_parent_directory

        try:
            self._dydtree = lxml.etree.parse(filepath)
        except OSError as exc:
            raise DydFileDoesNotExistError(filepath) from exc

        self.__bbms = list()
        self.__modelica_models = list()
        self.__model_templates = list()
        self.__model_template_expansions = list()

        root_element =  self._dydtree.getroot()
        for dyd_element in root_element:
            if isinstance(dyd_element, lxml.etree._Comment):
                continue
            if dyd_element.tag == xmlns(XML_BLACKBOXMODEL):
                self.__parse_bbm(dyd_element, par_files_collection, curves_collection, final_state_values_collection)
            elif dyd_element.tag == xmlns(XML_MODELICAMODEL):
                self.__parse_modelica_model(dyd_element, par_files_collection, curves_collection, final_state_values_collection)
            elif dyd_element.tag == xmlns(XML_MODELTEMPLATEEXPANSION):
                self.__parse_model_template_expansion(dyd_element, par_files_collection, curves_collection, final_state_values_collection)
            elif dyd_element.tag == xmlns(XML_MODELTEMPLATE):
                self.__parse_model_template(dyd_element)
            elif dyd_element.tag in [xmlns(XML_CONNECT),
                                        xmlns(XML_MACROCONNECT),
                                        xmlns(XML_MACROCONNECTOR),
                                        xmlns(XML_MACROSTATICREFERENCE)]:
                pass  # nothing to do
            else:
                raise UnknownDydElementError(dyd_element.tag)

    def _get_bbms(self, func):
        """
        Get a list of blackBoxModels matching the input function 'func'
        Example :
            myDyds.get_bbms(lambda bbm: bbm.get_id() == "_LOAD___2_EC")

        Parameter:
            func (function): function to match blackBoxModels

        Returns:
            List of blackBoxModels matching the input function 'func'
        """
        selected_bbms = list()
        for model in self.__bbms:
            if func(model):
                selected_bbms.append(model)
        return selected_bbms

    def _get_modelica_models(self, func):
        """
        Get a list of modelicaModel matching the input function 'func'
        Example :
            myDyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")

        Parameter:
            func (function): function to match modelicaModels

        Returns:
            List of modelicaModels matching the input function 'func'
        """
        selected_modelica_models = list()
        for model in self.__modelica_models:
            if func(model):
                selected_modelica_models.append(model)
        return selected_modelica_models

    def _get_model_templates(self, func):
        selected_model_templates = list()
        for model_template in self.__model_templates:
            if func(model_template):
                selected_model_templates.append(model_template)
        return selected_model_templates

    def _get_model_template_expansions(self, func):
        """
        Get a list of modelTemplateExpansion matching the input function 'func'
        Example :
            myDyds.get_model_template_expansion(lambda model_template_expansion: model_template_expansion.get_template_id() == "MachineThreeWindingsTemplate")

        Parameter:
            func (function): function to match modelTemplateExpansions

        Returns:
            List of modelTemplateExpansions matching the input function 'func'
        """
        selected_model_template_expansions = list()
        for model_template_expansion in self.__model_template_expansions:
            if func(model_template_expansion):
                selected_model_template_expansions.append(model_template_expansion)
        return selected_model_template_expansions

    def _remove_macro_connector(self, id):
        """
        Remove macroConnector using given id, then remove related macroConnects

        Parameter:
            id (str): macroConnector id
        """
        dydtree_root = self._dydtree.getroot()
        macro_connector_xpath = './dyn:macroConnector[@id="' + id + '"]'
        macroconnector = self._dydtree.xpath(macro_connector_xpath, namespaces=NAMESPACE_URI)
        if len(macroconnector) == 1:
            dydtree_root.remove(macroconnector[0])
        elif len(macroconnector) == 0:
            pass  # nothing to do
        else:
            raise DuplicateMacroConnectorsError(id, self._dydtree.docinfo.URL)

        macro_connects_xpath = '//dyn:macroConnect[@connector="' + id + '"]'
        macroconnects = self._dydtree.xpath(macro_connects_xpath, namespaces=NAMESPACE_URI)
        for macroconnect in macroconnects:
            macroconnect.getparent().remove(macroconnect)

    def _remove_macro_static_reference(self, id):
        """
        Remove macroStaticReference using given id, then remove related macroStaticRefs

        Parameter:
            id (str): macroConnector id
        """
        dydtree_root = self._dydtree.getroot()
        macro_static_reference_xpath = './dyn:macroStaticReference[@id="' + id + '"]'
        macro_static_reference = self._dydtree.xpath(macro_static_reference_xpath, namespaces=NAMESPACE_URI)
        if len(macro_static_reference) == 1:
            dydtree_root.remove(macro_static_reference[0])
        elif len(macro_static_reference) == 0:
            pass  # nothing to do
        else:
            raise DuplicateMacroStaticReferencesError(id, self._dydtree.docinfo.URL)

        macro_static_refs_xpath = '//dyn:macroStaticRef[@id="' + id + '"]'
        macro_static_refs = self._dydtree.xpath(macro_static_refs_xpath, namespaces=NAMESPACE_URI)
        for macro_static_ref in macro_static_refs:
            macro_static_ref.getparent().remove(macro_static_ref)

    def __parse_bbm(self, bbm_xml_element, par_files_collection, curves_collection, final_state_values_collection):
        """
        Parse the blackBoxModels XML element

        Parameter:
            bbm_xml_element (lxml.etree._Element): blackBoxModel XML element to parse
            par_files_collection (dict[str, Par]): collection of parsed Par files
            curves_collection (dict[str, lxml.etree._ElementTree]): collection of curves trees
            final_state_values_collection (dict[str, lxml.etree._ElementTree]): collection of final state values trees
        """
        parset = None
        if 'parFile' in bbm_xml_element.attrib and 'parId' in bbm_xml_element.attrib:
            par_absolute_path = os.path.join(self.__job_parent_directory, bbm_xml_element.attrib['parFile'])
            parset = get_parset(par_absolute_path, bbm_xml_element.attrib['parId'], par_files_collection)
        else:
            if 'parFile' in bbm_xml_element.attrib and 'parId' not in bbm_xml_element.attrib:
                raise MissingAttributeError('parId', bbm_xml_element.tag, self._dydtree.docinfo.URL)
            if 'parFile' not in bbm_xml_element.attrib and 'parId' in bbm_xml_element.attrib:
                raise MissingAttributeError('parFile', bbm_xml_element.tag, self._dydtree.docinfo.URL)
        bbm = BlackBoxModel(bbm_xml_element, parset, curves_collection, final_state_values_collection)
        self.__bbms.append(bbm)

    def __parse_modelica_model(self,
                                modelica_model_xml_element,
                                par_files_collection,
                                curves_collection,
                                final_state_values_collection):
        """
        Parse the modelicaModel XML element

        Parameter:
            modelica_model_xml_element (lxml.etree._Element): modelicaModel XML element to parse
            par_files_collection (dict[str, Par]): collection of parsed Par files
            curves_collection (dict[str, lxml.etree._ElementTree]): collection of curves trees
            final_state_values_collection (dict[str, lxml.etree._ElementTree]): collection of final state values trees
        """
        modelica_model = ModelicaModel(modelica_model_xml_element,
                                        self.__job_parent_directory,
                                        par_files_collection,
                                        curves_collection,
                                        final_state_values_collection)
        self.__modelica_models.append(modelica_model)

    def __parse_model_template_expansion(self,
                                            model_template_expansion_xml_element,
                                            par_files_collection,
                                            curves_collection,
                                            final_state_values_collection):
        """
        Parse the modelTemplateExpansion XML element

        Parameter:
            model_template_expansion_xml_element (lxml.etree._Element): modelTemplateExpansion XML element to parse
            par_files_collection (dict[str, Par]): collection of parsed Par files
            curves_collection (dict[str, lxml.etree._ElementTree]): collection of curves trees
            final_state_values_collection (dict[str, lxml.etree._ElementTree]): collection of final state values trees
        """
        model_template_expansion = ModelTemplateExpansion(model_template_expansion_xml_element,
                                                            self.__job_parent_directory,
                                                            par_files_collection,
                                                            curves_collection,
                                                            final_state_values_collection)
        self.__model_template_expansions.append(model_template_expansion)

    def __parse_model_template(self, model_template_xml_element):
        """
        Parse the modelTemplate XML element

        Parameter:
            model_template_xml_element (lxml.etree._Element): modelTemplate XML element to parse
        """
        model_template = ModelTemplate(model_template_xml_element)
        self.__model_templates.append(model_template)
