class UnknownJobElementError(Exception):
    def __init__(self, unknown_element):
        self.__unknown_element = unknown_element

    def __str__(self):
        return "Unknown Job element was found : " + self.__unknown_element


class DydFileDoesNotExistError(Exception):
    def __init__(self, dyd_file):
        self.__dyd_file = dyd_file

    def __str__(self):
        return "Dyd file '" + self.__dyd_file + "' does not exist"


class DuplicateCurvesFilesError(Exception):
    def __init__(self, curves_filename, job_filename):
        self.__curves_filename = curves_filename
        self.__job_filename = job_filename

    def __str__(self):
        return "Two or more Curves files with same name '" + self.__curves_filename + "' are in Job file '" + \
                self.__job_filename + "'"


class DuplicateFinalStateValuesFilesError(Exception):
    def __init__(self, final_state_values_filename, job_file):
        self.__final_state_values_filename = final_state_values_filename
        self.__job_file = job_file

    def __str__(self):
        return "Two or more FSV files with same name '" + self.__final_state_values_filename + \
                "' are in Job '" + self.__job_file + "'"


class UnknownDydElementError(Exception):
    def __init__(self, unknown_element):
        self.__unknown_element = unknown_element

    def __str__(self):
        return "Unknown Dyd element was found : " + self.__unknown_element


class ParFileDoesNotExistError(Exception):
    def __init__(self, par_file):
        self.__par_file = par_file

    def __str__(self):
        return "Par file " + self.__par_file + " does not exist"


class CurvesFileDoesNotExistError(Exception):
    def __init__(self, curves_file):
        self.__curves_file = curves_file

    def __str__(self):
        return "Curves file " + self.__curves_file + " does not exist"


class FinalStateValuesFileDoesNotExistError(Exception):
    def __init__(self, final_state_values_file):
        self.__final_state_values_file = final_state_values_file

    def __str__(self):
        return "FinalStateValues file " + self.__final_state_values_file + " does not exist"


class MoreThanOneNetworkGivenError(Exception):
    def __str__(self):
        return "Job file contains several network XML element. Only one network XML element is allowed."


class MoreThanOneSolverGivenError(Exception):
    def __str__(self):
        return "Job file contains several solver XML elements. Only one solver XML element is allowed."


class MoreThanOneModelerGivenError(Exception):
    def __str__(self):
        return "Job file contains several modeler XML elements. Only one modeler XML element is allowed."


class UnknownReferenceOrigDataError(Exception):
    def __init__(self, ref_orig_data):
        self.__ref_orig_data = ref_orig_data

    def __str__(self):
        return "Reference has unknown origData attribute : " + self.__ref_orig_data + \
                ". origData attribute should be IIDM or PAR"


class IIDMReferenceUnexpectedAttributesError(Exception):
    def __str__(self):
        return "Unexpected attributes in reference with IIDM origin data. The reference should not have 'parId' nor" + \
                "'parFile' attributes."


class ParReferenceMissingAttributesError(Exception):
    def __str__(self):
        return "Missing attributes in reference with PAR origin data. The reference should have 'parId' and 'parFile' attributes."


class ParsetNotFoundError(Exception):
    def __init__(self, par_id, par_file):
        self.__par_id = par_id
        self.__par_file = par_file

    def __str__(self):
        return "Parset " + self.__par_id + " not found in Par file " + self.__par_file


class ParameterNotFoundError(Exception):
    def __init__(self, par_name, par_id, par_file):
        self.__par_name = par_name
        self.__par_id = par_id
        self.__par_file = par_file

    def __str__(self):
        return "Parameter " + self.__par_name + " in parset " + self.__par_id + " not found in Par file " + self.__par_file


class IncorrectlySpecifiedTypeError(Exception):
    def __init__(self, param_name, parset, par_file, param_type, param_value):
        self.__param_name = param_name
        self.__parset = parset
        self.__par_file = par_file
        self.__param_type = param_type
        self.__param_value = param_value

    def __str__(self):
        return "Parameter " + self.__param_name + " in parset " + self.__parset + " in Par file " + self.__par_file + \
                " is not " + self.__param_type + ". Its value is : " + self.__param_value


class TypeMismatchError(Exception):
    def __init__(self, expected_type, value):
        self.__expected_type = expected_type
        self.__value = value
        self.__value_type = type(value).__name__

    def __str__(self):
        return "Expected type " + self.__expected_type + ", but received value " + str(self.__value) + \
                " of type " + self.__value_type


class UnknownParTypeError(Exception):
    def __init__(self, par_type):
        self.__par_type = par_type

    def __str__(self):
        return "Unknown type : " + str(self.__par_type)


class UnknownParameterTypeError(Exception):
    def __init__(self, param_name, parset_id, par_file, par_type):
        self.__param_name = param_name
        self.__parset_id = parset_id
        self.__par_file = par_file
        self.__par_type = par_type

    def __str__(self):
        return "Parameter " + self.__param_name + " in parset " + self.__parset_id + " in Par file " + \
                self.__par_file + " has an unknown type : " + self.__par_type


class UnknownXMLElementError(Exception):
    def __init__(self, elem_type):
        self.__elem_type = elem_type

    def __str__(self):
        return "Unknown XML element : " + str(self.__elem_type)


class DuplicateStaticRefsError(Exception):
    def __init__(self, var, model_id, dyd_file):
        self.__var = var
        self.__model_id = model_id
        self.__dyd_file = dyd_file

    def __str__(self):
        return "Two or more staticRefs with same var '" + self.__var + "' are in blackBoxModel of id " + \
                self.__model_id + " in Dyd file " + self.__dyd_file


class DuplicateConnectorsError(Exception):
    def __init__(self, id, var, dyd_file):
        self.__id = id
        self.__var = var
        self.__dyd_file = dyd_file

    def __str__(self):
        return "Two or more connectors with same id " + self.__id + " and same var " + self.__var + \
                " found in Dyd file " + self.__dyd_file


class DuplicateParsetError(Exception):
    def __init__(self, id, par_file):
        self.__id = id
        self.__par_file = par_file

    def __str__(self):
        return "Two or more parset with same id " + str(self.__id) + " found in file Par file " + self.__par_file


class DuplicateParametersError(Exception):
    def __init__(self, param_name, parset_id, par_file):
        self.__param_name = param_name
        self.__parset_id = parset_id
        self.__par_file = par_file

    def __str__(self):
        return "Two or more parameters/references named " + self.__param_name + " in parset " + self.__parset_id + \
                " were found in Par file " + self.__par_file


class DuplicateCurvesVariableError(Exception):
    def __init__(self, variable, model, curves_file):
        self.__variable = variable
        self.__model = model
        self.__curves_file = curves_file

    def __str__(self):
        return "Curves variable " + self.__variable + " appears twice or more for model " + self.__model + \
                " in curves file " + self.__curves_file


class DuplicateFinalStateValuesVariableError(Exception):
    def __init__(self, variable, model, final_state_values_file):
        self.__variable = variable
        self.__model = model
        self.__final_state_values_file = final_state_values_file

    def __str__(self):
        return "FinalStateValues variable " + self.__variable + " appears twice or more for model " + self.__model + \
                " in final state values file " + self.__final_state_values_file


class DuplicateMacroConnectorsError(Exception):
    def __init__(self, macroconnector_id, dyd_file):
        self.__macroconnector_id = macroconnector_id
        self.__dyd_file = dyd_file

    def __str__(self):
        return "Two or more macroConnectors with same id " + self.__macroconnector_id + " in Dyd file " + self.__dyd_file


class DuplicateMacroStaticRefsError(Exception):
    def __init__(self, macro_static_ref_id, model_id, dyd_file):
        self.__macro_static_ref_id = macro_static_ref_id
        self.__model_id = model_id
        self.__dyd_file = dyd_file

    def __str__(self):
        return "Two or more macroStaticRefs with same id " + self.__macro_static_ref_id + " in model of id " + \
                self.__model_id + " in Dyd file " + self.__dyd_file


class DuplicateMacroStaticReferencesError(Exception):
    def __init__(self, macro_static_reference_id, dyd_file):
        self.__macro_static_reference_id = macro_static_reference_id
        self.__dyd_file = dyd_file

    def __str__(self):
        return "Two or more macroStaticReference with same id " + self.__macro_static_reference_id + \
                " in Dyd file " + self.__dyd_file


class GetConnectMethodNotCallableError(Exception):
    def __str__(self):
        return "get_connects method must be called with connect elements"


class GetInitConnectMethodNotCallableError(Exception):
    def __str__(self):
        return "get_init_connects method must be called with initConnect elements"


class NoJobError(Exception):
    def __init__(self, job_file_path):
        self.__job_file_path = job_file_path

    def __str__(self):
        return "Job file " + self.__job_file_path + " doesn't contain any job"


class NoDydError(Exception):
    def __init__(self, jobname, job_file_path):
        self.__jobname = jobname
        self.__job_file_path = job_file_path

    def __str__(self):
        return "Job '" + self.__jobname + "' in Job file " + self.__job_file_path + " doesn't contain any Dyd"


class ParsetDoesNotExistError(Exception):
    def __init__(self, method_name):
        self.__method_name = method_name

    def __str__(self):
        return "Can't call '" + self.__method_name + "' method because the parset doesn't exist"


class MissingAttributeError(Exception):
    def __init__(self, missing_attribute, element, xml_file):
        self.__missing_attribute = missing_attribute
        self.__element = element
        self.__xml_file = xml_file

    def __str__(self):
        return "The '" + self.__missing_attribute + "' attribute is missing in '" + self.__element + \
                "' XML element in file " + self.__xml_file
