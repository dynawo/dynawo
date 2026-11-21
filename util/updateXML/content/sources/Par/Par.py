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


import os
import lxml.etree

from ..utils.UpdateXMLExceptions import *


class Par:
    """
    Represents a Par file

    Attributes
    ----------
    _filename : str
        name of the Par file
    _partree : lxml.etree._ElementTree
        lxml ElementTree of par XML file
    """
    def __init__(self, filepath):
        """
        Parse the Par file

        Parameter:
            filepath (str): filepath of the Par file to parse
        """
        self._filename = os.path.basename(filepath)
        try:
            self._partree = lxml.etree.parse(filepath)
        except OSError as exc:
            raise ParFileDoesNotExistError(filepath) from exc
