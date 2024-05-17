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


from ..utils.Common import *
from .StaticRefs import StaticRefs
from .MacroStaticRefs import MacroStaticRefs
from .UnitDynamicModel import UnitDynamicModel


class ModelTemplate:
    """
    Represents a modelTemplate XML element

    WORK IN PROGRESS

    Attributes
    ----------
    __xml_element : lxml.etree._Element
        modelTemplate XML element
    __unit_dynamic_models : list[UnitDynamicModel]
        list of unitDynamicModels contained in the modelTemplate XML element
    static_refs : StaticRefs
        list of staticRefs contained in the modelTemplate XML element
    macro_static_refs : MacroStaticRefs
        list of macroStaticReferences contained in the modelTemplate XML element
    """
    def __init__(self, xml_element):
        self.__xml_element = xml_element
        self.static_refs = StaticRefs(self.__xml_element)
        self.macro_static_refs = MacroStaticRefs(self.__xml_element)

        self.__unit_dynamic_models = list()
        unit_dynamic_model_xml_elements = self.__xml_element.findall(xmlns(XML_UNITDYNAMICMODEL))
        for unit_dynamic_model_xml_element in unit_dynamic_model_xml_elements:
            unit_dynamic_model = UnitDynamicModel(unit_dynamic_model_xml_element)
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
