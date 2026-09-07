# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.


import os

from ..utils.Common import *
from ..Par.Parset import Parset
from .Connects import ConnectType, Connects
from .MacroConnects import MacroConnects
from .StaticRefs import StaticRefs
from .MacroStaticRefs import MacroStaticRefs
from ..Job.Curves import Curves
from ..Job.FinalStateValues import FinalStateValues
from ..utils.UpdateXMLExceptions import *


class ModelTemplateExpansion:
    """
    Represents a modelTemplateExpansion XML element

    Attributes
    ----------
    __xml_element : lxml.etree._Element
        modelTemplateExpansion XML element
    __unit_dynamic_models : list[UnitDynamicModel]
        list of unitDynamicModels contained in the modelTemplateExpansion XML element
    parset : Parset
        parset related to the modelTemplateExpansion
    connects : Connects
        attribute to manipulate connects related to the modelTemplateExpansion via the Dyd XML tree
    macro_connects : MacroConnects
        attribute to manipulate macroconnects related to the modelTemplateExpansion via the Dyd XML tree
    static_refs : StaticRefs
        attribute to manipulate staticRefs related to the modelTemplateExpansion via the Dyd XML tree
    macro_static_refs : MacroStaticRefs
        attribute to manipulate macroStaticRefs related to the modelTemplateExpansion via the Dyd XML tree
    curves : Curves
        curves data of the job
    final_state_values : FinalStateValues
        final state values data of the job
    """
    def __init__(self, xml_element, job_parent_directory, par_files, curves_collection, final_state_values_collection):
        self.__xml_element = xml_element
        par_absolute_path = os.path.join(job_parent_directory, self.__xml_element.attrib['parFile'])
        model_template_expansion_parset = get_parset(par_absolute_path, self.__xml_element.attrib['parId'], par_files)
        self.parset = Parset(model_template_expansion_parset)
        self.connects = Connects(ConnectType.connect, self.__xml_element.getparent(), self.__xml_element.attrib['id'])
        self.macro_connects = MacroConnects(self.__xml_element.getparent(), self.__xml_element.attrib['id'])
        self.static_refs = StaticRefs(self.__xml_element)
        self.macro_static_refs = MacroStaticRefs(self.__xml_element)
        self.curves = Curves(curves_collection, self.get_id())
        self.final_state_values = FinalStateValues(final_state_values_collection, self.get_id())

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def get_id(self):
        return self.__xml_element.attrib["id"]

    def get_template_id(self):
        return self.__xml_element.attrib["templateId"]

    def get_unit_dynamic_models(self, func):
        selected_unit_dynamic_models = list()
        for model in self.__unit_dynamic_models:
            if func(model):
                selected_unit_dynamic_models.append(model)
        return selected_unit_dynamic_models
