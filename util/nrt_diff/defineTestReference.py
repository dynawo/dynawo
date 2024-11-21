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
import fnmatch
import sys
import XMLUtils
from shutil import copyfile
from optparse import OptionParser

from nrtDiff import TestCase, REFERENCE_DATA_DIRECTORY_NAME, CompareTwoFiles, LogsSeparator, IDENTICAL

# No need to test DYNAWO_BRANCH_NAME as already done in nrtDiff
if os.getenv("DYNAWO_NRT_DIR") is None:
    print("environment variable DYNAWO_NRT_DIR needs to be defined")
    sys.exit(1)

branch_name = os.environ["DYNAWO_BRANCH_NAME"]
output_dir_all_nrt = os.path.join(os.environ["DYNAWO_NRT_DIR"], "output")
nrt_results_dir = os.path.join(os.environ["DYNAWO_NRT_DIR"], "output",branch_name)

def findOutputFile(testcase):
    files = []
    # Parse jobs file
    (jobs_root, ns, prefix) = XMLUtils.ImportXMLFileExtended(testcase.jobs_file_)
    for job in XMLUtils.FindAll(jobs_root, prefix, "job", ns):
        # Get outputs
        for outputs in XMLUtils.FindAll(job, prefix, "outputs", ns):
            if (not "directory" in outputs.attrib):
                printout("Fail to generate NRT ref: outputs directory is missing in jobs file " + testcase.jobs_file_ + os.linesep, BLACK)
                sys.exit(1)
            output_dir = outputs.get("directory")
            # timeline
            for timeline in XMLUtils.FindAll(outputs, prefix, "timeline", ns):
                    if (not "exportMode" in timeline.attrib):
                        printout("Fail to generate NRT ref for " + testcase.jobs_file_ + ": a timeline element does not have an export mode " + os.linesep, BLACK)
                        sys.exit(1)
                    if(timeline.get("exportMode") == "CSV"):
                        files.append(os.path.join(output_dir, "timeLine", "timeline.csv" ))
                    elif(timeline.get("exportMode") == "XML"):
                        files.append(os.path.join(output_dir, "timeLine", "timeline.xml" ))
                    elif(timeline.get("exportMode") == "TXT"):
                        files.append(os.path.join(output_dir, "timeLine", "timeline.log" ))
            # curves
            for curves in XMLUtils.FindAll(outputs, prefix, "curves", ns):
                if (not "exportMode" in curves.attrib):
                    printout("Fail to generate NRT ref for " + testcase.jobs_file_ + " : a curve element does not have an export mode " + os.linesep, BLACK)
                    sys.exit(1)
                if(curves.get("exportMode") == "CSV"):
                        files.append(os.path.join(output_dir, "curves", "curves.csv" ))
                elif(curves.get("exportMode") == "XML"):
                    files.append(os.path.join(output_dir, "curves", "curves.xml" ))

            # logs
            for appender in XMLUtils.FindAll(outputs, prefix, "appender", ns):
                if (not "file" in appender.attrib):
                    printout("Fail to generate NRT ref for " + testcase.jobs_file_ + " : an appender of output is not an attribute in file " + os.linesep, BLACK)
                    sys.exit(1)
                if appender.get("tag") == "":
                    files.append(os.path.join(output_dir, "logs", appender.get("file") ))
    return files

##
# define the reference of a testcase
def define_reference(testcase):
    case_dir = os.path.dirname (testcase.jobs_file_)
    case_ref_dir = os.path.join(case_dir, REFERENCE_DATA_DIRECTORY_NAME)
    files = findOutputFile(testcase)
    for relative_file_path in files:
        print("        Copying " + relative_file_path)
        if not os.path.exists(os.path.dirname(os.path.join(case_ref_dir, relative_file_path))):
            os.makedirs(os.path.dirname(os.path.join(case_ref_dir, relative_file_path)))
        copyfile(os.path.join(case_dir,relative_file_path) , os.path.join(case_ref_dir, relative_file_path))

##
# redefine the reference of a testcase
def redefine_reference(testcase):
    case_dir = os.path.dirname (testcase.jobs_file_)
    case_ref_dir = os.path.join(case_dir, REFERENCE_DATA_DIRECTORY_NAME)
    logs_separator = LogsSeparator (case_dir)
    for root, _, filenames in os.walk(case_ref_dir):
        for file_name in filenames:
            relative_file_path = os.path.join(os.path.relpath(root, case_ref_dir), file_name)
            (diff_status, _) = CompareTwoFiles (os.path.join(case_dir,relative_file_path),\
                                           logs_separator, os.path.join(case_ref_dir, relative_file_path), logs_separator)
            if diff_status != IDENTICAL:
                print("        Copying " + relative_file_path)
                copyfile(os.path.join(case_dir,relative_file_path) , os.path.join(case_ref_dir, relative_file_path))
##
# (Re)Define automatically the nrt references in the following cases:
#    - reference not yet defined
#    - testcases that finish as intended and for which the comparison is within tolerance
#    - testcases that finish as intended and for which the comparison is KO (difference to be first validated by the user)
def main():
    print("toto")
    usage=u""" Usage: %prog --new_reference=<comma separated path list> --update_all_references_within_tolerance --force_reference_update=<comma separated path list>
    (Re)Define automatically the nrt references in the following cases:
     - reference not yet defined
     - testcases that finish as intended and for which the comparison is within tolerance
     - testcases that finish as intended and for which the comparison is KO (difference to be first validated by the user)
    """
    parser = OptionParser(usage)
    parser.add_option( '--new_reference', dest='new_references_path_list',
                       help=u"directory in which reference should be defined")
    parser.add_option( '--update_all_references_within_tolerance', action="store_true", dest='update_all_references_within_tolerance',
                       help=u"if set automatically redefine references for testcases that finish as intended and for which the comparison is within tolerance")
    parser.add_option( '--force_reference_update', dest='force_reference_update_path_list',
                       help=u"directory in which reference replacement should be forced")
    (options, args) = parser.parse_args()

    define_new_ref = False
    redefine_ref_within_tol = False
    redefine_ko_ref = False
    force_reference_update_path_list = []
    new_references_path_list = []
    if options.new_references_path_list != None:
        define_new_ref = True
        tmp = options.new_references_path_list.split(',')
        for path in tmp:
            new_references_path_list.append(os.path.realpath(path))
    if options.update_all_references_within_tolerance != None:
        redefine_ref_within_tol = True
    if options.force_reference_update_path_list != None:
        redefine_ko_ref = True
        tmp = options.force_reference_update_path_list.split(',')
        for path in tmp:
            path_to_add = path
            if os.path.isfile(path):
                path_to_add = os.path.dirname(path)+"/*" #needed as sometime bash add a filename after a wildcard...
            force_reference_update_path_list.append(os.path.realpath(path_to_add))

    list_cases_no_ref = []
    list_cases_ref_within_tol = []
    list_cases_ref_ko = []
    print("here")
    for root, dirs, files in os.walk(nrt_results_dir):
        for file in files:
            if "info.txt" == file:
                print(nrt_results_dir)
                test_case = TestCase("dummy")
                test_case.get_case_info(os.path.join(root, file))
                if define_new_ref and test_case.status_ == "OK" and test_case.cmp_status_ == "NoReference":
                    list_cases_no_ref.append(test_case)
                elif redefine_ref_within_tol and test_case.status_ == "OK" and test_case.cmp_status_ == "Warn":
                    list_cases_ref_within_tol.append(test_case)
                elif redefine_ko_ref and test_case.status_ == "OK" and test_case.cmp_status_ == "KO":
                    list_cases_ref_ko.append(test_case)

    filtered_list_cases_ref_ko = []
    for case in list_cases_ref_ko:
        case_dir = os.path.dirname (case.jobs_file_)
        for pattern in force_reference_update_path_list:
            if fnmatch.fnmatch(os.path.realpath(case_dir), pattern) and case not in filtered_list_cases_ref_ko:
                filtered_list_cases_ref_ko.append(case)

    filtered_list_cases_missing_ref = []
    for case in list_cases_no_ref:
        case_dir = os.path.dirname (case.jobs_file_)
        for pattern in new_references_path_list:
            if fnmatch.fnmatch(os.path.realpath(case_dir), pattern) and case not in filtered_list_cases_missing_ref:
                filtered_list_cases_missing_ref.append(case)

    if define_new_ref and len(filtered_list_cases_missing_ref) > 0:
        print("Definition of references")
        for testcase in filtered_list_cases_missing_ref:
            print("    Definition of " + testcase.name_)
            define_reference(testcase)

    if redefine_ref_within_tol and len(list_cases_ref_within_tol) > 0:
        print("Redefinition of references of testcases within tolerance")
        for testcase in list_cases_ref_within_tol:
            print("    Redefinition of " + testcase.name_)
            redefine_reference(testcase)

    if redefine_ko_ref and len(filtered_list_cases_ref_ko) > 0:
        print("Redefinition of references of testcases with failing comparison")
        for testcase in filtered_list_cases_ref_ko:
            print("    Redefinition of " + testcase.name_)
            redefine_reference(testcase)


# the main function
if __name__ == "__main__":
    main()
