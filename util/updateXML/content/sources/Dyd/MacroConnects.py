from ..utils.Common import *


class MacroConnects:
    """
    Class to interact with macroConnect elements related to a model

    Attributes
    ----------
    __parent_xml_tree : lxml.etree._Element
        parent element tree containing the macroConnect element
    __model_id : str
        model id related to the macroConnect
    """
    def __init__(self, parent_xml_tree, model_id):
        self.__parent_xml_tree = parent_xml_tree
        self.__model_id = model_id

    # ---------------------------------------------------------------
    #   USER METHOD
    # ---------------------------------------------------------------

    def remove_macro_connect(self, connector):
        for idx in ["1", "2"]:
            macro_connect_xpath = './dyn:macroConnect[@connector="' + connector + '" and @id' + idx + '="' + \
                                    self.__model_id + '"]'
            macroconnects = self.__parent_xml_tree.xpath(macro_connect_xpath, namespaces=NAMESPACE_URI)
            for macroconnect in macroconnects:
                macroconnect.getparent().remove(macroconnect)
