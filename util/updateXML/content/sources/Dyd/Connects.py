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


from enum import Enum, auto

from ..utils.Common import *
from ..utils.UpdateXMLExceptions import *


class ConnectType(Enum):
    initConnect = auto()
    connect = auto()


class Connects:
    """
    Class to interact with connect/initConnect elements related to a model

    Attributes
    ----------
    __connect_type : ConnectType
        connect or initConnect
    __parent_xml_tree : lxml.etree._Element
        parent element tree containing the connect/initConnect element
    __model_id : str
        model id related to the connect/initConnect
    """
    def __init__(self, connect_type, parent_xml_tree, model_id):
        self.__connect_type = connect_type
        self.__parent_xml_tree = parent_xml_tree
        self.__model_id = model_id

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def change_var_name(self, current_var, new_var):
        """
        Modify var attribute

        Parameters:
            current_var (str): current var name to change
            new_var (str): new var name to change
        """
        connect_to_modify = list()
        for idx in ["1", "2"]:

            connect_xpath = './dyn:' + self.__connect_type.name + '[@id' + idx + '="' + self.__model_id + \
                            '" and @var' + idx + '="' + current_var + '"]'
            connect = self.__parent_xml_tree.xpath(connect_xpath, namespaces=NAMESPACE_URI)
            connect_to_modify.extend(connect)

            macro_connects_xpath = './dyn:macroConnect[@id' + idx + '="' + self.__model_id + '"]'
            macro_connects = self.__parent_xml_tree.xpath(macro_connects_xpath, namespaces=NAMESPACE_URI)
            for macro_connect in macro_connects:
                macro_connector_connect_xpath = './dyn:macroConnector[@id="' + macro_connect.attrib['connector'] + \
                                                    '"]/dyn:connect[@var' + idx + '="' + current_var + '"]'
                macro_connector_connect = self.__parent_xml_tree.xpath(macro_connector_connect_xpath, namespaces=NAMESPACE_URI)
                connect_to_modify.extend(macro_connector_connect)

            if len(connect_to_modify) == 0:
                pass  # nothing to do
            elif len(connect_to_modify) == 1:
                connect_to_modify[0].attrib['var' + idx] = new_var
                connect_to_modify.clear()
            else:
                raise DuplicateConnectorsError(self.__model_id, current_var, self.__parent_xml_tree.base)

    def remove_connect(self, var):
        """
        Remove a connect

        Parameters:
            var (str): var corresponding to the connect to remove
            number_of_indentation (int): number of indentation for the closing element
        """
        connect_to_remove = list()
        for idx in ["1", "2"]:
            connect_xpath = './dyn:' + self.__connect_type.name + '[@id' + idx + '="' + self.__model_id + \
                            '" and @var' + idx + '="' + var + '"]'
            connect = self.__parent_xml_tree.xpath(connect_xpath, namespaces=NAMESPACE_URI)
            connect_to_remove.extend(connect)

            macro_connects_xpath = './dyn:macroConnect[@id' + idx + '="' + self.__model_id + '"]'
            macro_connects = self.__parent_xml_tree.xpath(macro_connects_xpath, namespaces=NAMESPACE_URI)
            for macro_connect in macro_connects:
                macro_connector_connect_xpath = './dyn:macroConnector[@id="' + macro_connect.attrib['connector'] + \
                                                    '"]/dyn:connect[@var' + idx + '="' + var + '"]'
                macro_connector_connect = self.__parent_xml_tree.xpath(macro_connector_connect_xpath, namespaces=NAMESPACE_URI)
                connect_to_remove.extend(macro_connector_connect)

            if len(connect_to_remove) == 0:
                pass  # nothing to do
            elif len(connect_to_remove) == 1:
                connect_to_remove[0].getparent().remove(connect_to_remove[0])
                connect_to_remove.clear()
            else:
                raise DuplicateConnectorsError(self.__model_id, var, self.__parent_xml_tree.base)

    def get_connects(self):
        if self.__connect_type != ConnectType.connect:
            raise GetConnectMethodNotCallableError
        return self.__get_connect_type_connects()

    def get_init_connects(self):
        if self.__connect_type != ConnectType.initConnect:
            raise GetInitConnectMethodNotCallableError
        return self.__get_connect_type_connects()

    # ---------------------------------------------------------------
    #   UTILITY METHOD
    # ---------------------------------------------------------------

    def __get_connect_type_connects(self):
        connects_list = list()
        for idx in ["1", "2"]:
            connect_xpath = './dyn:' + self.__connect_type.name + '[@id' + idx + '="' + self.__model_id + '"]'
            connects = self.__parent_xml_tree.xpath(connect_xpath, namespaces=NAMESPACE_URI)
            connects_list.extend(connects)
        return connects_list
