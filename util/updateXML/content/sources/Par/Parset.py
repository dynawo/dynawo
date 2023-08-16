import lxml.etree

from ..utils.Common import *
from ..utils.UpdateXMLExceptions import *


class Parset:
    """
    Attribute
    ----------
    __parset : lxml.etree._Element
        parset content
    """
    def __init__(self, parset):
        self.__parset = parset

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def add_param(self, param_type, param_name, param_value):
        """
        Add a parameter in a specific parset in a Par file

        Parameters:
            param_type (str): type of the parameter to add
            param_name (str): name of the parameter to add
            param_value (str or int or float): value of the parameter to add
        """
        if param_type == XML_DOUBLE:
            if not isinstance(param_value, float) and not isinstance(param_value, int):
                raise TypeMismatchError(param_type, param_value)
            param_xml_value = str(param_value)
        elif param_type == XML_INT:
            if not isinstance(param_value, int):
                raise TypeMismatchError(param_type, param_value)
            param_xml_value = str(param_value)
        elif param_type == XML_BOOL:
            if not isinstance(param_value, bool):
                raise TypeMismatchError(param_type, param_value)
            if param_value:
                param_xml_value = "true"
            else:
                param_xml_value = "false"
        elif param_type == XML_STRING:
            if not isinstance(param_value, str):
                raise TypeMismatchError(param_type, param_value)
            param_xml_value = param_value
        else:
            raise UnknownParTypeError(param_type)

        if self.__parset is None:
            raise ParsetDoesNotExistError(self.add_param.__name__)

        params_with_same_name = self.__parset.xpath('./dyn:par[@name="' + param_name + '"]', namespaces=NAMESPACE_URI)
        if len(params_with_same_name) == 0:
            lxml.etree.SubElement(self.__parset,
                                    xmlns(XML_PARAMETER),
                                    {'type': param_type, 'name': param_name, 'value': param_xml_value})
        elif len(params_with_same_name) >= 2:
            raise DuplicateParametersError(param_name, self.__parset.attrib['id'], self.__parset.base)
        else:
            pass  # nothing to do

    def add_ref(self, ref_type, ref_name, orig_data, orig_name, component_id=None, par_id=None, par_file=None):
        """
        Add a reference in a specific parset in a Par file

        Parameters:
            ref_type (str): type of the reference to add
            ref_name (str): name of the reference to add
            orig_data (str): origin data of the reference to add
            orig_name (str): origin name of the reference to add
            component_id (str): component id of the reference to add
            par_id (str): par id of the reference to add
            par_file (str): par file of the reference to add
        """
        if orig_data == REF_ORIG_DATA_IIDM:
            if par_id or par_file:
                raise IIDMReferenceUnexpectedAttributesError
        elif orig_data == REF_ORIG_DATA_PAR:
            if par_id is None or par_file is None:
                raise ParReferenceMissingAttributesError
        else:
            raise UnknownReferenceOrigDataError(orig_data)

        if self.__parset is None:
            raise ParsetDoesNotExistError(self.add_ref.__name__)

        refs_with_same_name = self.__parset.xpath('./dyn:reference[@name="' + ref_name + '"]', namespaces=NAMESPACE_URI)
        if len(refs_with_same_name) == 0:
            ref_attributes = {'type': ref_type, 'name': ref_name, 'origData': orig_data, 'origName': orig_name}
            if component_id:
                ref_attributes['componentId'] = component_id
            if par_id:
                ref_attributes['parId'] = par_id
            if par_file:
                ref_attributes['par_file'] = par_file
            lxml.etree.SubElement(self.__parset, xmlns("reference"), ref_attributes)
        elif len(refs_with_same_name) >= 2:
            raise DuplicateParametersError(ref_name, self.__parset.attrib['id'], self.__parset.base)
        else:
            pass  # nothing to do

    def remove_param_or_ref(self, param_name):
        """
        Remove a parameter from a library

        Parameter:
            param_name (str): name of the parameter to remove
        """
        if self.__parset is None:
            raise ParsetDoesNotExistError(self.remove_param_or_ref.__name__)

        input_xpath = './*[self::dyn:par or self::dyn:reference][@name="' + param_name + '"]'
        elem = self.__parset.xpath(input_xpath, namespaces=NAMESPACE_URI)
        if len(elem) == 1:
            self.__parset.remove(elem[0])
        elif len(elem) == 0:
            pass  # nothing to do
        else:
            raise DuplicateParametersError(param_name, self.__parset.attrib['id'], self.__parset.base)

    def change_param_or_ref_name(self, current_name, new_name):
        """
        Change the name of a parameter or a reference

        Parameters:
            current_name (str): current name of the parameter/reference to change
            new_name (str): new name of the parameter/reference to change
        """
        if self.__parset is None:
            raise ParsetDoesNotExistError(self.change_param_or_ref_name.__name__)

        input_xpath = './*[self::dyn:par or self::dyn:reference][@name="' + current_name + '"]'
        elem = self.__parset.xpath(input_xpath, namespaces=NAMESPACE_URI)
        if len(elem) == 1:
            elem[0].attrib['name'] = new_name
        elif len(elem) == 0:
            pass  # nothing to do
        else:
            raise DuplicateParametersError(current_name, self.__parset.attrib['id'], self.__parset.base)

    def get_param_value(self, param_name):
        if self.__parset is None:
            raise ParsetDoesNotExistError(self.get_param_value.__name__)

        input_xpath = './dyn:par[@name="' + param_name + '"]'
        elem = self.__parset.xpath(input_xpath, namespaces=NAMESPACE_URI)
        if len(elem) == 1:
            elem_type = elem[0].attrib['type']
            current_elem_value = elem[0].attrib['value']
            if elem_type == "INT":
                if not is_int(current_elem_value):
                    raise IncorrectlySpecifiedTypeError(param_name,
                                                        self.__parset.attrib['id'],
                                                        self.__parset.base,
                                                        elem_type,
                                                        current_elem_value)
                param_value = int(current_elem_value)
            elif elem_type == XML_DOUBLE:
                if not is_float(current_elem_value):
                    raise IncorrectlySpecifiedTypeError(param_name,
                                                        self.__parset.attrib['id'],
                                                        self.__parset.base,
                                                        elem_type,
                                                        current_elem_value)
                param_value = float(current_elem_value)
            elif elem_type == XML_BOOL:
                param_value = self.__convert_str_to_bool(param_name, current_elem_value)
            elif elem_type == XML_STRING:
                param_value = current_elem_value
            else:
                raise UnknownParameterTypeError(param_name, self.__parset.attrib['id'], self.__parset.base, elem_type)
            return param_value
        elif len(elem) == 0:
            raise ParameterNotFoundError(param_name, self.__parset.attrib['id'], self.__parset.base)
        else:
            raise DuplicateParametersError(param_name, self.__parset.attrib['id'], self.__parset.base)

    def change_param_value(self, param_name, new_value):
        if self.__parset is None:
            raise ParsetDoesNotExistError(self.change_param_value.__name__)

        input_xpath = './dyn:par[@name="' + param_name + '"]'
        parameter = self.__parset.xpath(input_xpath, namespaces=NAMESPACE_URI)
        if len(parameter) == 1:
            parameter_xml_elem = parameter[0]
            if parameter_xml_elem.attrib['type'] == XML_DOUBLE:
                if not isinstance(new_value, float) and not isinstance(new_value, int):
                    raise TypeMismatchError(XML_DOUBLE, new_value)
                parameter_xml_elem.attrib['value'] = str(new_value)
            elif parameter_xml_elem.attrib['type'] == XML_INT:
                if not isinstance(new_value, int):
                    raise TypeMismatchError(XML_INT, new_value)
                parameter_xml_elem.attrib['value'] = str(new_value)
            elif parameter_xml_elem.attrib['type'] == XML_BOOL:
                if not isinstance(new_value, bool):
                    raise TypeMismatchError(XML_BOOL, new_value)
                parameter_xml_elem.attrib['value'] = convert_bool_to_str(new_value)
            elif parameter_xml_elem.attrib['type'] == XML_STRING:
                if not isinstance(new_value, str):
                    raise TypeMismatchError(XML_STRING, new_value)
                parameter_xml_elem.attrib['value'] = new_value
            else:
                raise UnknownParameterTypeError(parameter_xml_elem.attrib['name'],
                                                self.__parset.attrib['id'],
                                                self.__parset.base,
                                                parameter_xml_elem.attrib['type'])
        elif len(parameter) == 0:
            raise ParameterNotFoundError(param_name, self.__parset.attrib['id'], self.__parset.base)
        else:
            raise DuplicateParametersError(param_name, self.__parset.attrib['id'], self.__parset.base)

    def check_if_param_exists(self, param_name):
        if self.__parset is None:
            raise ParsetDoesNotExistError(self.check_if_param_exists.__name__)
        does_param_exist = self.__check_if_parset_elem_exists(XML_PARAMETER, param_name)
        return does_param_exist

    def check_if_ref_exists(self, ref_name):
        if self.__parset is None:
            raise ParsetDoesNotExistError(self.check_if_ref_exists.__name__)
        does_ref_exist = self.__check_if_parset_elem_exists(XML_REFERENCE, ref_name)
        return does_ref_exist

    # ---------------------------------------------------------------
    #   UTILITY METHODS
    # ---------------------------------------------------------------

    def __check_if_parset_elem_exists(self, elem_type, elem_name):
        if elem_type not in [XML_PARAMETER, XML_REFERENCE]:
            raise UnknownXMLElementError(elem_type)
        input_xpath = './dyn:' + elem_type + '[@name="' + elem_name + '"]'
        elem = self.__parset.xpath(input_xpath, namespaces=NAMESPACE_URI)
        if len(elem) == 1:
            return True
        elif len(elem) == 0:
            return False
        else:
            raise DuplicateParametersError(elem_name, self.__parset.attrib['id'], self.__parset.base)

    def __convert_str_to_bool(self, param_name, param_value):
        if param_value == XML_TRUE:
            param_value = True
        elif param_value == XML_FALSE:
            param_value = False
        else:
            raise IncorrectlySpecifiedTypeError(param_name, self.__parset.attrib['id'], self.__parset.base, XML_BOOL, param_value)
        return param_value
