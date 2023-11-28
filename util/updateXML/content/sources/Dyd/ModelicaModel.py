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

from ..utils.Common import *
from .Connects import ConnectType, Connects
from .MacroConnects import MacroConnects
from .StaticRefs import StaticRefs
from .MacroStaticRefs import MacroStaticRefs
from .UnitDynamicModel import UnitDynamicModel
from ..Job.Curves import Curves
from ..Job.FinalStateValues import FinalStateValues


class ModelicaModel:
    """
    Represents a modelicaModel XML element

    Attributes
    ----------
    __xml_element : lxml.etree._Element
        modelicaModel XML element
    __unit_dynamic_models : list[UnitDynamicModel]
        list of unitDynamicModels contained in the modelicaModel XML element
    connects : Connects
        attribute to manipulate connects related to the modelicaModel via the Dyd XML tree
    macro_connects : MacroConnects
        attribute to manipulate macroconnects related to the modelicaModel via the Dyd XML tree
    static_refs : StaticRefs
        attribute to manipulate staticRefs related to the modelicaModel via the Dyd XML tree
    macro_static_refs : MacroStaticRefs
        attribute to manipulate macroStaticRefs related to the modelicaModel via the Dyd XML tree
    curves : Curves
        curves data of the job
    final_state_values : FinalStateValues
        final state values data of the job
    """
    def __init__(self, xml_element, job_parent_directory, par_files, curves_collection, final_state_values_collection):
        self.__xml_element = xml_element
        self.connects = Connects(ConnectType.connect, self.__xml_element.getparent(), self.__xml_element.attrib['id'])
        self.macro_connects = MacroConnects(self.__xml_element.getparent(), self.__xml_element.attrib['id'])
        self.static_refs = StaticRefs(self.__xml_element)
        self.macro_static_refs = MacroStaticRefs(self.__xml_element)
        self.curves = Curves(curves_collection, self.get_id())
        self.final_state_values = FinalStateValues(final_state_values_collection, self.get_id())
        self.__unit_dynamic_models = list()

        unit_dynamic_model_xml_elements = self.__xml_element.findall(xmlns("unitDynamicModel"))
        for unit_dynamic_model_xml_element in unit_dynamic_model_xml_elements:
            unit_dynamic_model_parset = None
            if 'parFile' in unit_dynamic_model_xml_element.attrib and 'parId' in unit_dynamic_model_xml_element.attrib:
                par_absolute_path = os.path.join(job_parent_directory, unit_dynamic_model_xml_element.attrib['parFile'])
                unit_dynamic_model_parset = get_parset(par_absolute_path,
                                                        unit_dynamic_model_xml_element.attrib['parId'],
                                                        par_files)
            else:
                if 'parFile' in unit_dynamic_model_xml_element.attrib and 'parId' not in unit_dynamic_model_xml_element.attrib:
                    raise MissingAttributeError('parId', unit_dynamic_model_xml_element.tag, self.__xml_element.base)
                if 'parFile' not in unit_dynamic_model_xml_element.attrib and 'parId' in unit_dynamic_model_xml_element.attrib:
                    raise MissingAttributeError('parFile', unit_dynamic_model_xml_element.tag, self.__xml_element.base)
            unit_dynamic_model = UnitDynamicModel(unit_dynamic_model_xml_element, unit_dynamic_model_parset)
            self.__unit_dynamic_models.append(unit_dynamic_model)

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def get_id(self):
        return self.__xml_element.attrib["id"]

    def get_unit_dynamic_models(self, func):
        selected_unit_dynamic_models = list()
        for model in self.__unit_dynamic_models:
            if func(model):
                selected_unit_dynamic_models.append(model)
        return selected_unit_dynamic_models
