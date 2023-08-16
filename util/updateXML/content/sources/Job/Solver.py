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
