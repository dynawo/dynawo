# -*- coding: utf-8 -*-

# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os
import sys

##
# Correct the cobertura python coverage file by replacing the paths found in install by the path from the sources
def main():
    coverage_file = os.path.join(os.environ["DYNAWO_HOME"], "build/coverage-sonar/coverage-python/coverage.xml")
    print("### Handling file " + coverage_file)

    python_script_to_sources_path = {}
    for root, dirs, files in os.walk(os.path.join(os.environ["DYNAWO_HOME"], os.path.join("dynawo","sources"))):
        for file in files:
            if file.endswith(".py"):
                python_script_to_sources_path[file] = os.path.join(root, file)
    python_script_to_install_path = {}
    for root, dirs, files in os.walk(os.path.join(os.environ["DYNAWO_HOME"], "install")):
        for file in files:
            if file.endswith(".py") and "TestCoverage" in root:
                python_script_to_install_path[file] = os.path.join(root, file)
    python_script_to_build_path = {}
    for root, dirs, files in os.walk(os.path.join(os.environ["DYNAWO_HOME"], "build")):
        for file in files:
            if file.endswith(".py") and "TestCoverage" in root:
                python_script_to_build_path[file] = os.path.join(root, file)

    f = open(coverage_file,'r')
    filedata = f.read()
    f.close()

    newdata = filedata
    for script_filename in  python_script_to_install_path:
        if script_filename in python_script_to_sources_path:
            print("    ### replacing " + "filename=\""+python_script_to_install_path[script_filename] + "=>" + "filename=\""+python_script_to_sources_path[script_filename])
            newdata = newdata.replace("filename=\""+python_script_to_install_path[script_filename],"filename=\""+python_script_to_sources_path[script_filename])

    for script_filename in  python_script_to_build_path:
        if script_filename in python_script_to_sources_path:
            print("    ### replacing " + "filename=\""+python_script_to_build_path[script_filename] + "=>" + "filename=\""+python_script_to_sources_path[script_filename])
            newdata = newdata.replace("filename=\""+python_script_to_build_path[script_filename],"filename=\""+python_script_to_sources_path[script_filename])

    f = open(coverage_file,'w')
    f.write(newdata)
    f.close()


# the main function
if __name__ == "__main__":
    main()
