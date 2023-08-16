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
        list of unitDynamicModels contained in the modelTemplateExpansion XML element
    """
    def __init__(self, xml_element):
        self.__xml_element = xml_element
        self.static_refs = StaticRefs(self.__xml_element)
        self.macro_static_refs = MacroStaticRefs(self.__xml_element)

        self.__unit_dynamic_models = list()
        unit_dynamic_model_xml_elements = self.__xml_element.findall(xmlns("unitDynamicModel"))
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
