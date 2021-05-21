# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Libxml, a library to handle XML files parsing.

project(XML_common CXX)

set(CPACK_COMPONENT_SAX-COMMON_DISPLAY_NAME "XML common headers")

install(DIRECTORY include/xml
  DESTINATION ${LibXML_INSTALL_INCLUDE}
  COMPONENT sax-common
  FILES_MATCHING PATTERN "*.h"
)
