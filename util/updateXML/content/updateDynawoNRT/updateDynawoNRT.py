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


""" Update Dynawo files

This script is intended to be launched from util/envDynawo.sh with nrt-update option.

Its aim is to update every nrt input files.

"""

import os
import sys
import subprocess
from optparse import OptionParser


update_xml_dir = os.environ["DYNAWO_UPDATE_XML_DIR"]
update_xml_script = os.path.join(update_xml_dir, "update.py")


def main():
    parser = OptionParser()
    parser.add_option('--origin', dest="origin", help=u"dynawo origin version")
    parser.add_option('--version', dest="version", help=u"dynawo version")
    options, _ = parser.parse_args()

    if not options.origin or not options.version:
        if not options.origin:
            print("Error : No input dynawo origin (use --origin option)")
        if not options.version:
            print("Error : No input dynawo version (use --version option)")
        sys.exit(1)

    dynawo_origin_str = str(options.origin)
    dynawo_version_str = str(options.version)

    print("Updating NRT from " + dynawo_origin_str + " to " + dynawo_version_str + " :")
    data_dir = os.path.join(os.environ["DYNAWO_NRT_DIR"], "data")
    python_cmd = os.environ["DYNAWO_PYTHON_COMMAND"]
    for case_dir in os.listdir(data_dir):
        case_path = os.path.join(data_dir, case_dir)
        if os.path.isdir(case_path) == True:
            sys.path.append(case_path)
            try:
                import cases
                sys.path.remove(case_path)  # remove from path because all files share the same name

                for case_name, _, job_file, _, _, _ in cases.test_cases:
                    job_dir = os.path.dirname(job_file)
                    print("    Updating " + case_name)
                    subprocess.run([python_cmd, update_xml_script,
                                    "--job", job_file,
                                    "--origin", dynawo_origin_str,
                                    "--version", dynawo_version_str,
                                    "-o", job_dir,
                                    "--update-nrt"], check=True)

                del sys.modules['cases']  # delete load module in order to load another module with the same name
            except:
                print("Error during loading case path " + case_path)
                pass


if __name__ == "__main__":
    main()
