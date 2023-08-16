from ..utils.Common import *
from ..utils.UpdateXMLExceptions import *


class FinalStateValues:
    """
    Class to interact with finalStateValue elements related to a model

    Attributes
    ----------
    __final_state_values_collection : dict[str, lxml.etree._ElementTree]
        Final state values trees collection containing the finalStateValue elements. The final state values trees are
        used to manipulate the finalStateValue elements related to a model.
    __model_id : str
        id of the model to interact with the final state values tree
    """
    def __init__(self, final_state_values_collection, model_id):
        self.__final_state_values_collection = final_state_values_collection
        self.__model_id = model_id

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def change_variable_name(self, current_name, new_name):
        """
        Change the variable attribute of the finalStateValue XML element

        Parameters:
            current_name (str): current value of finalStateValue XML element variable
            new_name (str): new value of finalStateValue XML element variable
        """
        for final_state_values_tree in self.__final_state_values_collection.values():
            input_xpath = '/dyn:finalStateValuesInput/dyn:finalStateValue[@model="' + self.__model_id + '" and @variable="' + current_name + '"]'
            final_state_values_variable = final_state_values_tree.xpath(input_xpath, namespaces=NAMESPACE_URI)
            if len(final_state_values_variable) == 1:
                final_state_values_variable[0].attrib['variable'] = new_name
            elif len(final_state_values_variable) >= 2:
                raise DuplicateFinalStateValuesVariableError(current_name,
                                                                self.__model_id,
                                                                final_state_values_tree.docinfo.URL)
            else:
                pass  # nothing to do

    def remove_variable(self, variable_name):
        """
        Change the variable attribute of the finalStateValue XML element

        Parameters:
            current_name (str): current value of finalStateValue XML element variable
            new_name (str): new value of finalStateValue XML element variable
        """
        for final_state_values_tree in self.__final_state_values_collection.values():
            input_xpath = '/dyn:finalStateValuesInput/dyn:finalStateValue[@model="' + self.__model_id + '" and @variable="' + variable_name + '"]'
            final_state_values_variable = final_state_values_tree.xpath(input_xpath, namespaces=NAMESPACE_URI)
            if len(final_state_values_variable) == 1:
                final_state_values_tree_element = final_state_values_tree.getroot()
                final_state_values_tree_element.remove(final_state_values_variable[0])
            elif len(final_state_values_variable) == 0:
                pass  # nothing to do
            else:
                raise DuplicateFinalStateValuesVariableError(variable_name,
                                                                self.__model_id,
                                                                final_state_values_tree.docinfo.URL)
