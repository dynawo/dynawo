from ..Par.Parset import Parset
from .Connects import ConnectType, Connects
from .MacroConnects import MacroConnects
from .StaticRefs import StaticRefs
from .MacroStaticRefs import MacroStaticRefs
from ..Job.Curves import Curves
from ..Job.FinalStateValues import FinalStateValues


class BlackBoxModel:
    """
    Represents a blackBoxModel XML element

    Attributes
    ----------
    __xml_element : lxml.etree._Element
        blackBoxModel XML element in Dyd file
    parset : Parset
        parset related to the blackBoxModel
    connects : Connects
        attribute to manipulate connects related to the blackBoxModel via the Dyd XML tree
    macro_connects : MacroConnects
        attribute to manipulate macroconnects related to the blackBoxModel via the Dyd XML tree
    static_refs : StaticRefs
        attribute to manipulate staticRefs related to the blackBoxModel via the Dyd XML tree
    macro_static_refs : MacroConnects
        attribute to manipulate macroStaticRefs related to the blackBoxModel via the Dyd XML tree
    curves : Curves
        curves data of the job
    final_state_values : FinalStateValues
        final state values data of the job
    """
    def __init__(self, xml_element, parset_tree, curves_collection, final_state_values_collection):
        self.__xml_element = xml_element
        self.parset = Parset(parset_tree)
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
        """
        Get blackBoxModel id
        """
        return self.__xml_element.attrib['id']

    def get_lib_name(self):
        """
        Get blackBoxModel lib
        """
        return self.__xml_element.attrib['lib']

    def set_lib_name(self, new_lib_name):
        """
        Set blackBoxModel lib

        Parameter:
            new_lib_name (str): new blackBoxModel lib name
        """
        self.__xml_element.attrib['lib'] = new_lib_name
