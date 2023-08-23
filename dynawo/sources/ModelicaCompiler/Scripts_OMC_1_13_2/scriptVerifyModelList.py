# -*- coding: utf-8 -*-

# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os
from optparse import OptionParser

try:
  from lxml import etree
  print("running with lxml.etree")
except ImportError:
  try:
    # Python 2.5
    import xml.etree.cElementTree as etree
    print("running with cElementTree on Python 2.5+")
  except ImportError:
    try:
      # Python 2.5
      import xml.etree.ElementTree as etree
      print("running with ElementTree on Python 2.5+")
    except ImportError:
      try:
        # normal cElementTree install
        import cElementTree as etree
        print("running with cElementTree")
      except ImportError:
        try:
          # normal ElementTree install
          import elementtree.ElementTree as etree
          print("running with ElementTree")
        except ImportError:
          print("Failed to import ElementTree from any known place")

##
# Script to verify a model list file
def main():
    usage="""

    Script to verify a model list file

    """
    parser = OptionParser(usage)
    parser.add_option( '--dyd',     dest = "dydFileName",     default="",    metavar="<dydFileName>",
                       help="dydFileName")
    parser.add_option( '--model', dest = "modelListfile", default="",    metavar="<modelListfile>",
                       help="modelListfile")

    (options, args) = parser.parse_args()

    global dyd_file_name
    global model_list_file

    dyd_file_name = options.dydFileName
    model_list_file = options.modelListfile

    print(dyd_file_name, model_list_file)
    if( os.path.isfile(options.modelListfile) ):
      dyd = open(dyd_file_name,"wb")
      modellist = open(model_list_file,"r")
    else:
      print("Error: modelListfile not valid.")
      return

    root = etree.parse(modellist).getroot()
    output_tree = etree.ElementTree(root)
    output_tree.write(dyd, encoding = 'UTF-8', xml_declaration=True)

    modellist.close()
    dyd.close()

    print("Verified Model List File: "+ dyd_file_name)


if __name__ == "__main__":
    main()
