# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.


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
