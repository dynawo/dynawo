# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


import re
from optparse import OptionParser

from ..Par.Par import Par
from .UpdateXMLExceptions import *


# General
NAMESPACE_PREFIX = "{http://www.rte-france.com/dynawo}"
NAMESPACE_URI = {"dyn": "http://www.rte-france.com/dynawo"}
PYTHON_FILE_EXTENSION = ".py"
XML_ESCAPE_SEQUENCE = '\n'
XML_SIMPLE_INDENTATION = "\n  "
XML_DOUBLE_INDENTATION = "\n    "

# Dyd
XML_BLACKBOXMODEL = 'blackBoxModel'
XML_MODELICAMODEL = 'modelicaModel'
XML_MODELTEMPLATE = "modelTemplate"
XML_MODELTEMPLATEEXPANSION = "modelTemplateExpansion"
XML_CONNECT = "connect"
XML_MACROCONNECT = "macroConnect"
XML_MACROCONNECTOR = "macroConnector"
XML_MACROSTATICREFERENCE = "macroStaticReference"
NETWORK_ID = "NETWORK"

# Par
XML_SET = "set"
XML_PARAMETER = "par"
XML_REFERENCE = "reference"
XML_DOUBLE = "DOUBLE"
XML_INT = "INT"
XML_BOOL = "BOOL"
XML_STRING = "STRING"
REF_ORIG_DATA_IIDM = "IIDM"
REF_ORIG_DATA_PAR = "PAR"
XML_TRUE = "true"
XML_FALSE = "false"


def xmlns(xml_element_name):
    """
    Prepend namespace to XML element name

    Parameter:
        xml_element_name (str): XML element name to prepend the namespace

    Returns:
        XML element name with namespace
    """
    return NAMESPACE_PREFIX + xml_element_name


def get_command_line_options():
    """
    Get command line options input while building Jobs object

    Returns:
        optparse.Values object containing options values
    """
    parser = OptionParser()
    parser.add_option('--job', dest="job", help=u"job to update")
    parser.add_option('--origin', dest="origin", help=u"dynawo origin version")
    parser.add_option('--version', dest="version", help=u"dynawo version")
    parser.add_option('-o', dest="outputs_path", help=u"outputs path")
    parser.add_option('--scriptfolders', dest="scriptfolders", help=u"folders containing update scripts")
    parser.add_option('--log', action="store_true", dest="log", help=u"generate an applied_tickets.log file to list the numbers of applied tickets")
    parser.add_option('--update-nrt', action="store_true", dest="update_nrt", help=u"generate output files without gathering them in an output folder to replace")
    options, _ = parser.parse_args()
    return options


def get_parset(par_absolute_path, par_id, par_files_collection):
    """
    Get a parset of a specific Par id in a specific Par file

    Parameter:
        par_absolute_path (str): Par absolute filepath
        par_id (str) : parset Par id
        par_files_collection (dict[str, Par]) : collection of already parsed Par objects
    Returns:
        Par object corresponding to input Par id and Par file
    """
    if par_absolute_path not in par_files_collection:
        par_files_collection[par_absolute_path] = Par(par_absolute_path)
    parset_xpath = '/dyn:parametersSet/dyn:set[@id="' + str(par_id) + '"]'
    parset = par_files_collection[par_absolute_path]._partree.xpath(parset_xpath, namespaces=NAMESPACE_URI)
    if len(parset) == 0:
        raise ParsetNotFoundError(par_id, par_files_collection[par_absolute_path]._partree.docinfo.URL)
    if len(parset) >= 2:
        raise DuplicateParsetError(par_id, par_absolute_path)
    return parset[0]


def is_float(string):
    return bool(re.match(r'^-?[0-9]*\.?[0-9]+$', string))


def is_int(string):
    return bool(re.match(r'^-?[0-9]+$', string))


def convert_bool_to_str(boolean):
    return str(boolean).lower()
