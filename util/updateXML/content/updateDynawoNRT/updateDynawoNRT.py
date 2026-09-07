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
python_cmd = os.environ["DYNAWO_PYTHON_COMMAND"]


def main():
    parser = OptionParser()
    parser.add_option('--origin', dest="origin", help=u"dynawo origin version")
    parser.add_option('--version', dest="version", help=u"dynawo version")
    parser.add_option('--tickets', dest="tickets_to_update", help=u"selected tickets to update")
    parser.add_option('--scriptfolders', dest="scriptfolders", help=u"folders containing update scripts")
    options, _ = parser.parse_args()

    if not options.origin or not options.version:
        if not options.origin:
            print("Error : No input dynawo origin (use --origin option)")
        if not options.version:
            print("Error : No input dynawo version (use --version option)")
        sys.exit(1)

    dynawo_origin_str = str(options.origin)
    dynawo_version_str = str(options.version)

    update_message = "Updating NRT from " + dynawo_origin_str + " to " + dynawo_version_str
    if options.tickets_to_update:
        if len(options.tickets_to_update.split(',')) == 1:
            update_message += " applying ticket " + options.tickets_to_update
        else:
            update_message += " applying tickets " + options.tickets_to_update
    update_message += " :"
    print(update_message)
    data_dir = os.path.join(os.environ["DYNAWO_NRT_DIR"], "data")
    for case_dir in os.listdir(data_dir):
        case_path = os.path.join(data_dir, case_dir)
        if os.path.isdir(case_path) is True:
            sys.path.append(case_path)
            try:
                import cases
                sys.path.remove(case_path)  # remove from path because all files share the same name

                for case_name, _, job_file, _, _, _ in cases.test_cases:
                    cmd_to_execute = [python_cmd, update_xml_script,
                                        "--job", job_file,
                                        "--origin", dynawo_origin_str,
                                        "--version", dynawo_version_str,
                                        "--update-nrt"]
                    if options.tickets_to_update:
                        cmd_to_execute.extend(["--tickets", options.tickets_to_update])
                    if options.scriptfolders:
                        cmd_to_execute.extend(["--scriptfolders", options.scriptfolders])
                    print("    Updating " + case_name)
                    subprocess.run(cmd_to_execute, check=True)

                del sys.modules['cases']  # delete load module in order to load another module with the same name
            except:
                print("Error during loading case path " + case_path)
                pass


if __name__ == "__main__":
    main()
