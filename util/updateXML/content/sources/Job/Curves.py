from ..utils.Common import *
from ..utils.UpdateXMLExceptions import *


class Curves:
    """
    Class to interact with curve elements related to a model

    Attributes
    ----------
    __curves_collection : dict[str, lxml.etree._ElementTree]
        Curves trees collection containing the curve elements. The Curves trees are used to manipulate the
        curve elements related to a model.
    __model_id : str
        id of the model to interact with the curves tree
    """
    def __init__(self, curves_collection, model_id):
        self.__curves_collection = curves_collection
        self.__model_id = model_id

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def change_variable_name(self, current_name, new_name):
        """
        Change the variable attribute of the curve XML element

        Parameters:
            current_name (str): current value of curve XML element variable
            new_name (str): new value of curve XML element variable
        """
        for curves_tree in self.__curves_collection.values():
            input_xpath = '/dyn:curvesInput/dyn:curve[@model="' + self.__model_id + '" and @variable="' + current_name + '"]'
            curves_variable = curves_tree.xpath(input_xpath, namespaces=NAMESPACE_URI)
            if len(curves_variable) == 1:
                curves_variable[0].attrib['variable'] = new_name
            elif len(curves_variable) >= 2:
                raise DuplicateCurvesVariableError(current_name, self.__model_id, curves_tree.docinfo.URL)
            else:
                pass  # nothing to do

    def remove_variable(self, variable_name):
        """
        Remove a curve XML element in the CRV file using variable_name value

        Parameter:
            variable_name (str): variable value of the curve XML element to remove
        """
        for curves_tree in self.__curves_collection.values():
            input_xpath = '/dyn:curvesInput/dyn:curve[@model="' + self.__model_id + '" and @variable="' + variable_name + '"]'
            curves_variable = curves_tree.xpath(input_xpath, namespaces=NAMESPACE_URI)
            if len(curves_variable) == 1:
                curves_tree_element = curves_tree.getroot()
                curves_tree_element.remove(curves_variable[0])
            elif len(curves_variable) == 0:
                pass  # nothing to do
            else:
                raise DuplicateCurvesVariableError(variable_name, self.__model_id, curves_tree.docinfo.URL)
