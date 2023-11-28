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


from ..Par.Parset import Parset
from .Connects import ConnectType, Connects
from .MacroConnects import MacroConnects


class UnitDynamicModel:
    """
    Represents a unitDynamicModel XML element

    Attributes
    ----------
    __xml_element : lxml.etree._Element
        unitDynamicModel XML element
    parset : Parset
        parset related to the unitDynamicModel
    init_connects : Connects
        attribute to manipulate initConnects related to the unitDynamicModel via the Dyd XML tree
    connects : Connects
        attribute to manipulate connects related to the unitDynamicModel via the Dyd XML tree
    macro_connects : MacroConnects
        attribute to manipulate macroConnects related to the unitDynamicModel via the Dyd XML tree
    """
    def __init__(self, xml_element, parset=None):
        self.__xml_element = xml_element
        if parset is not None:
            self.parset = Parset(parset)  # UnitDynamicModel class has parset attribute if parset argument is not None
        self.init_connects = Connects(ConnectType.initConnect, self.__xml_element.getparent(), self.get_id())
        self.connects = Connects(ConnectType.connect, self.__xml_element.getparent(), self.get_id())
        self.macro_connects = MacroConnects(self.__xml_element.getparent(), self.__xml_element.attrib['id'])

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def get_id(self):
        return self.__xml_element.attrib['id']

    def set_id(self, id):
        self.__xml_element.attrib['id'] = id

    def get_name(self):
        return self.__xml_element.attrib['name']

    def set_name(self, name):
        self.__xml_element.attrib['name'] = name
