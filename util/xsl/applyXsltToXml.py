# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
import re
from optparse import OptionParser

try:
    nrtDiff_dir = os.path.join(os.environ["DYNAWO_HOME"], "util", "nrt_diff")
    sys.path.append(nrtDiff_dir)
    import nrtUtils

    sys.path.remove(nrtDiff_dir)
except:
    try:
        nrtDiff_dir = os.path.join(os.environ["DYNAWO_HOME"], "sbin", "nrt", "nrt_diff")
        sys.path.append(nrtDiff_dir)
        import nrtUtils

        sys.path.remove(nrtDiff_dir)
    except:
        try:
            if os.getenv("DYNAWO_NRT_DIFF_DIR") is not None:
                nrtDiff_dir = os.environ["DYNAWO_NRT_DIFF_DIR"]
                sys.path.append(nrtDiff_dir)
                import nrtUtils

                sys.path.remove(nrtDiff_dir)
            else:
                print("Failed to find nrtUtils script")
        except:
            print("Failed to import nrtUtils script")
            sys.exit(1)


def collect_xsl(directory, file_types, xsl_ids):
    xsl_to_apply = {file_type: [] for file_type in file_types}
    for file_name in os.listdir(directory):
        for file_type in file_types:
            if file_name.endswith("." + file_type + ".xsl"):
                xsl_id = file_name.replace("." + file_type + ".xsl", "")
                if not xsl_ids or xsl_id in xsl_ids or xsl_id.split('.')[0] in xsl_ids:
                    xsl_to_apply[file_type].append(os.path.join(directory, file_name))

    for file_type in file_types:
        xsl_to_apply[file_type].sort()
    return xsl_to_apply


def apply_xsl(xml_file, xsl_file):
    print("Applying " + xsl_file + " to " + xml_file)
    cmd = "xsltproc -o " + xml_file + " " + xsl_file + " " + xml_file
    os.system(cmd)


def update_xml_file(xml_file, xsl_to_apply):
    _, file_type = os.path.splitext(xml_file)
    if file_type:
        _, file_type = file_type.split('.')
    for xsl_file in xsl_to_apply.get(file_type, []):
        apply_xsl(xml_file, xsl_file)


def update_test_case(test_case, xsl_to_apply):
    for file_type, xsl_files in xsl_to_apply.items():
        if file_type == "jobs":
            for xsl_file in xsl_files:
                apply_xsl(test_case.jobs_file_, xsl_file)
        else:
            xml_files = []
            for job in test_case.jobs_:
                if file_type == "dyd":
                    xml_files = job.dyd_files_
                elif file_type == "crv":
                    xml_files = job.curves_files_
                elif file_type == "par":
                    xml_files = job.par_files_
                for xsl_file in xsl_files:
                    for xml_file in xml_files:
                        apply_xsl(xml_file, xsl_file)


def is_dir_filtered(relative_dir, directory_names, directory_patterns):
    filtered = not directory_names and not directory_patterns
    if not filtered:
        filtered = directory_names and any(dir_name in relative_dir for dir_name in directory_names)
    if not filtered:
        filtered = directory_patterns and any(re.search(pattern, relative_dir) is not None
                                              for pattern in directory_patterns)
    return filtered


def main():
    usage = u""" Usage: %prog

    Script to update Dynawo inputs to latest format
    """

    options = {('-d', '--directory'): {'dest': 'data_directory', 'default': '',
                                       'help': 'main data directory where to apply update'},
               ('-n', '--name'): {'dest': 'directory_names', 'action': 'append',
                                  'help': 'name filter to restrict update to subdir'},
               ('-p', '--pattern'): {'dest': 'directory_patterns', 'action': 'append',
                                     'help': 'regular expression filter to restrict update to subdir'},
               ('-t', '--type'): {'dest': 'types', 'action': 'append',
                                  'help': 'type of files to update (jobs, dyd, par, crv)'},
               ('-i', '--id'): {'dest': 'xsl_ids', 'action': 'append',
                                'help': 'xsl id to apply'},
               ('-j', '--jobs'): {'dest': 'jobs_patterns', 'action': 'append',
                                  'help': 'regular expression filter to specify jobs files to update'},
               ('-f', '--file'): {'dest': 'file_patterns', 'action': 'append',
                                  'help': 'regular expression filter to specify xml files to update'}}

    parser = OptionParser(usage)
    for param, option in options.items():
        parser.add_option(*param, **option)
    (options, args) = parser.parse_args()

    log_message = "Applying xsl"

    xsl_ids = set(options.xsl_ids or [])
    if xsl_ids:
        log_message += " with id(s) " + ", ".join(xsl_ids)

    possible_types = ["jobs", "dyd", "crv", "par"]
    file_types = {file_type.lower() for file_type in options.types or []}
    bad_types = [file_type for file_type in file_types if file_type not in possible_types]
    if bad_types:
        print("error: types should be among " + ", ".join(possible_types) + " (found " + ", ".join(bad_types) + ")")
        exit(1)
    if file_types:
        log_message += (" and" if xsl_ids else " with") + " type(s) '" + "', '".join(file_types) + "'"
    file_types = file_types or possible_types

    data_directory = options.data_directory or ""
    if not data_directory:
        if os.getenv("DYNAWO_NRT_DIR") is None:
            print("error: environment variable DYNAWO_NRT_DIR needs to be defined... or use option -d")
            sys.exit(1)

        data_directory = os.path.join(os.environ["DYNAWO_NRT_DIR"], "data")

    if not os.path.isdir(data_directory):
        print("error: main data directory '" + data_directory + "' doesn't exist")
        sys.exit(1)

    jobs_patterns = set(options.jobs_patterns or [])
    file_patterns = set(options.file_patterns or [])
    if jobs_patterns or file_patterns:
        if jobs_patterns:
            log_message += " to jobs file(s) '" + "' '".join(jobs_patterns) + "'"
        if file_patterns:
            log_message += (" and" if jobs_patterns else " to") + " xml file(s) '" + "' '".join(file_patterns) + "'"
    else:
        log_message += " to jobs file(s) from testcases"

    log_message += " in '" + data_directory + "'"

    directory_names = set(options.directory_names or [])
    if directory_names:
        log_message += " with '" + "' '".join(directory_names) + "' name filter(s)"

    directory_patterns = set(options.directory_patterns or [])
    if directory_patterns:
        log_message += (" or '" if directory_names else " with '"
                        ) + "' '".join(directory_patterns) + "' pattern filter(s)"

    print(log_message)
    xsl_to_apply = collect_xsl(os.path.dirname(os.path.realpath(__file__)), file_types, xsl_ids)

    if jobs_patterns or file_patterns:
        for dir_path, _, filenames in os.walk(data_directory):
            if is_dir_filtered(os.path.relpath(dir_path, data_directory), directory_names, directory_patterns):
                for filename in filenames:
                    if any(re.search(pattern, filename) is not None for pattern in jobs_patterns):
                        try:
                            current_test = nrtUtils.TestCase("case", "customCase", "",
                                                             os.path.join(dir_path, filename), "0", "", "")
                        except:
                            pass
                        else:
                            if current_test.jobs_:
                                update_test_case(current_test, xsl_to_apply)
                                continue
                    if any(re.search(pattern, filename) is not None for pattern in file_patterns):
                        update_xml_file(os.path.join(dir_path, filename), xsl_to_apply)
    else:
        num_case = 0
        # Loop on testcases
        for case_dir in os.listdir(data_directory):
            case_path = os.path.join(data_directory, case_dir)
            # In order to check that we are dealing with a repository and not a file, .svn repository is filtered
            if os.path.isdir(case_path) and case_dir not in [".git", ".svn"]:

                # Get needed info to build object TestCase
                sys.path.append(case_path)
                try:
                    import cases
                    sys.path.remove(case_path)  # Remove from path because all files share the same name

                    for case_name, case_description, job_file, estimated_computation_time, return_code_type, \
                            expected_return_codes in cases.test_cases:

                        # check if job must be kept
                        if is_dir_filtered(os.path.relpath(os.path.dirname(job_file), data_directory),
                                           directory_names, directory_patterns):
                            current_test = nrtUtils.TestCase("case_" + str(num_case), case_name, case_description,
                                                             job_file, estimated_computation_time, return_code_type,
                                                             expected_return_codes)
                            update_test_case(current_test, xsl_to_apply)
                            num_case += 1

                    del sys.modules['cases']  # Delete load module in order to load another module with the same name
                except:
                    pass


if __name__ == "__main__":
    main()
