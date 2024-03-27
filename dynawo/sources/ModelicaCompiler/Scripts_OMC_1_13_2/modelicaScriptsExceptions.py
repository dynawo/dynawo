class UnknownExtVar(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown ExtVar element was found : " + self.unknown_element_


class FmiModelDescriptionElementNotFound(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "fmiModelDescription element not found : " + self.unknown_element_ + " was found instead"


class UnknownFmiModelDescriptionElement(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown element was found in fmiModelDescription element : " + self.unknown_element_


class UnknownModelVariablesElement(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown element was found in ModelVariables element : " + self.unknown_element_


class UnexpectedScalarVariableElement(Exception):
    def __init__(self, unknown_element, expected_element):
        self.unknown_element_ = unknown_element
        self.expected_element_ = expected_element

    def __str__(self):
        message = "Unexpected element was found in ScalarVariable element : " + self.unknown_element_ + "\n" + \
                    self.expected_element_ + " was expected"
        return message


class ModelElementNotFound(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "fmiModelDescription element not found : " + self.unknown_element_ + " was found instead"


class UnknownModelElement(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown element was found in model element : " + self.unknown_element_


class UnknownElementsElement(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown element was found in elements element : " + self.unknown_element_


class UnknownTerminalElement(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown element was found in terminal element : " + self.unknown_element_


class UnknownStructElement(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown element was found in struct element : " + self.unknown_element_


class UnknownSubnodesElement(Exception):
    def __init__(self, unknown_element):
        self.unknown_element_ = unknown_element

    def __str__(self):
        return "Unknown element was found in subnodes element : " + self.unknown_element_


class StructHasMoreThanOneName(Exception):
    def __str__(self):
        return "The struct contains several names. Only one name is allowed."


class TerminalHasMoreThanOneName(Exception):
    def __str__(self):
        return "The terminal contains several names. Only one name is allowed."


class TerminalHasMoreThanOneConnector(Exception):
    def __str__(self):
        return "The terminal contains several connectors. Only one connector is allowed."
