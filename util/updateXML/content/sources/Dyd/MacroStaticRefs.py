from ..utils.Common import *
from ..utils.UpdateXMLExceptions import *


class MacroStaticRefs:
    """
    Class to interact with macroStaticRef elements related to a model

    Attributes
    ----------
    __model_xml_tree : lxml.etree._Element
        model element tree containing the macroStaticRef element
    """
    def __init__(self, model_xml_tree):
        self.__model_xml_tree = model_xml_tree

    # ---------------------------------------------------------------
    #   USER METHOD
    # ---------------------------------------------------------------

    def remove_macro_static_ref(self, macro_static_ref_id):
        macro_static_ref_xpath = './dyn:macroStaticRef[@id="' + macro_static_ref_id + '"]'
        macro_static_ref = self.__model_xml_tree.xpath(macro_static_ref_xpath, namespaces=NAMESPACE_URI)
        if len(macro_static_ref) == 0:
            pass  # nothing to do
        elif len(macro_static_ref) == 1:
            macro_static_ref[0].getparent().remove(macro_static_ref[0])
        else:
            raise DuplicateMacroStaticRefsError(macro_static_ref_id,
                                                self.__model_xml_tree.attrib['id'],
                                                self.__model_xml_tree.base)
