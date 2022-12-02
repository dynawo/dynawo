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

# Generic Python
import csv
import datetime
import filecmp

import os
import re
import sys
import shutil
import threading
import time
import webbrowser
from optparse import OptionParser
import iidmDiff
import constraintsDiff
import finalStateValuesDiff
import settings
import XMLUtils

try:
    transposer_dir = os.path.join(os.path.dirname(__file__))
    sys.path.append(transposer_dir)
    import transposer
except Exception as exc:
    print("Failed to import transposer : " + str(exc))
    sys.exit(1)

def natural_sort_key(s, _nsre=re.compile('([0-9]+)')):
    return [int(text) if text.isdigit() else text.lower()
            for text in re.split(_nsre, s)]

#### Code to handle xml parsing
resources_dir = os.path.join(os.path.dirname(__file__), "..", "..","nrt", "resources")
web_browser = os.getenv ('DYNAWO_BROWSER', 'firefox')
files_included = set(settings.files_included)
files_excluded = set(settings.files_excluded)

IDENTICAL, MISSING_DATA_BOTH_SIDES, MISSING_DATA_LEFT, MISSING_DATA_RIGHT, \
           WITHIN_TOLERANCE, DIFFERENT, SAME_LOG_WITH_DIFFERENT_TIMESTAMP, LOG_DIFFERENT_WITHIN_TOLERANCE, \
           NO_FILES_TO_COMPARE, UNABLE_TO_CHECK = range(10)
##
# Convert the status into a string
# @param status : the diff status (as one of the values in the range above)
# @param is_reference_check : whether the function is called from a reference data check, or a standard diff check
def toString (status, is_reference_check):
    if (status == UNABLE_TO_CHECK):
        return "unable to check"

    elif (status == NO_FILES_TO_COMPARE):
        return "no reference data"

    elif (status == IDENTICAL) or (status == SAME_LOG_WITH_DIFFERENT_TIMESTAMP):
        return "OK"

    elif (status == MISSING_DATA_BOTH_SIDES):
        return "some data missing on both sides"

    elif (status == MISSING_DATA_LEFT) or (status == MISSING_DATA_RIGHT):
        right_hand_name = "right"
        if (is_reference_check):
            right_hand_name = "reference"
        return "some data missing on the " + ("left" if (status == MISSING_DATA_LEFT) else right_hand_name) + " side"

    elif (status == WITHIN_TOLERANCE) or (status == LOG_DIFFERENT_WITHIN_TOLERANCE):
        return "within tolerance"

    elif (status == DIFFERENT):
        return "KO"

    elif (status == None):
        return "DIFF BUG - NONE"

##
# Generate a list of diff statuses linked with an error
# @param is_reference_check : whether the function is called from a reference data check, or a standard diff check
def diff_error_statuses (is_reference_check):
    if (is_reference_check):
        return [MISSING_DATA_BOTH_SIDES, MISSING_DATA_LEFT, DIFFERENT]
    else:
        return [MISSING_DATA_BOTH_SIDES, MISSING_DATA_LEFT, MISSING_DATA_RIGHT, DIFFERENT]

##
# Generate a list of diff statuses linked with a warning
def diff_warn_statuses():
    return [WITHIN_TOLERANCE, LOG_DIFFERENT_WITHIN_TOLERANCE]

##
# Generate a list of diff statuses linked with no diff process at all
def diff_neutral_statuses():
    return [UNABLE_TO_CHECK, NO_FILES_TO_COMPARE]

##
# Generate a list of diff statuses linked with a diff with no major difference
# @param is_reference_check : whether the function is called from a reference data check, or a standard diff check
def diff_ok_statuses (is_reference_check):
    if (is_reference_check):
        return [IDENTICAL, SAME_LOG_WITH_DIFFERENT_TIMESTAMP, MISSING_DATA_RIGHT]
    else:
        return [IDENTICAL, SAME_LOG_WITH_DIFFERENT_TIMESTAMP]

##
# Convert a given time to string
def timeToString(time):
    nb_seconds_total = int(time)
    nb_minutes = nb_seconds_total / 60
    nb_seconds = nb_seconds_total % 60

    if nb_minutes > 0:
        time_string = "%imin %is" % (nb_minutes, nb_seconds)
    else:
        time_string = "%is" % nb_seconds

    return time_string

REFERENCE_DATA_DIRECTORY_NAME = 'reference' # Name of the reference directory

class ActivePool(object):
    def __init__(self):
        super(ActivePool, self).__init__()
        self.active = []
        self.lock = threading.Lock()
    def makeActive(self, name):
        with self.lock:
            self.active.append(name)
    def makeInactive(self, name):
        with self.lock:
            self.active.remove(name)

class TestCase:
    def __init__(self,case_name):
        self.name_ = case_name
        self.case_ = ""
        self.directory_ = case_name
        self.description_ = ""
        self.status_ = ""
        self.cmp_status_ = ""
        self.jobs_file_ = ""
        self.compared_files_ = []
        self.error_ = False
        self.warning_= False
        self.number_of_files_= 0
        self.number_of_files_withDiff_= 0
        self.ok_ = True
        self.diff_message_ = ""

    # Get case identification info if available
    def get_case_info(self, info_file_path):
        if os.path.isfile(info_file_path):
            info_file = open (info_file_path, "r")
            # First line : case identification info
            case_info = info_file.readline().split('|')
            self.directory_ = case_info[0] + "/" + case_info[1]
            self.name_ = case_info[2]
            self.description_ = case_info[3]
            self.status_ = case_info[4]
            self.cmp_status_ = case_info[5].rstrip()
            # Second line : path to jobs file
            case_jobs_file = info_file.readline()
            self.jobs_file_ = case_jobs_file
            info_file.close()

    # Compare case identification info of two info files
    def compare_case_info(self, info_file_1, info_file_2):
        f1 = open(info_file_1,"r")
        f2 = open(info_file_2,"r")
        # Compare first line of both info files
        first_line_info_1 = f1.readline()
        first_line_info_2 = f2.readline()
        cmp_case_info = (first_line_info_1 == first_line_info_2)
        return cmp_case_info

    # Get compiler log file to be excluded from nrt comparison
    def get_case_CompilerLogFile(self):
        # Parse the jobs file
        try:
            (jobs_root, ns, prefix) = XMLUtils.ImportXMLFileExtended(self.jobs_file_)
        except:
            print("Fail to import XML file " + self.jobs_file_)
            sys.exit(1)

        compilerLogFile = ""
        for job in XMLUtils.FindAll(jobs_root, prefix, "job", ns):
            if (not "name" in job.attrib):
                print("Fail to run nrtDiff : job without name in file  " + os.path.basename(self.jobs_file_))
                sys.exit(1)
            if self.name_ == job.get("name"):
                for outputs in XMLUtils.FindAll(job, prefix, "outputs", ns):
                    if (not "directory" in outputs.attrib):
                        print("Fail to run nrtDiff : outputs directory is missing for job " + self.name_)
                        sys.exit(1)
                    # Get compiler log file name from appenders if exists
                    for appender in XMLUtils.FindAll(outputs, prefix, "appender", ns):
                        if ("tag" in appender.attrib):
                            if ( appender.get("tag") == "COMPILE" ):
                                if (not "file" in appender.attrib):
                                    print("Fail to run nrtDiff for " + self.name_ + "(file = "+os.path.basename(self.jobs_file_)+") : an appender of output has not an attribut file")
                                    sys.exit(1)
                                compilerLogFile = os.path.basename(appender.get("file"))
                                return compilerLogFile

        return compilerLogFile

class ComparedFile:
    def __init__(self,file_name, left_path, right_path, diff_status, diff_message):
        self.name_ = file_name
        self.left_path_ = left_path
        self.right_path_ = right_path
        self.diff_status_ = diff_status
        self.diff_message_ = diff_message

# Maximum number of threads to use
maximumNumberOfThreads = int(os.getenv ('DYNAWO_NB_PROCESSORS_USED', settings.maximum_threads_nb))

##
# Make a diff between two non-regression test outputs
def main():
    global maximumNumberOfThreads
    global firstDirectory
    global secondDirectory
    global listCases
    global totalTime

    usage=u""" Usage: %prog --firstDirectory=<directory> --secondDirectory=<directory> --outputDir=<directory> --displayMissingDirectories
    Compare two launches of non-regression test and check if there are differences between their outputs
    """
    parser = OptionParser(usage)
    parser.add_option( '--firstDirectory', dest='firstDirectory',
                       help=u"directory where the outputs of the first non-regression test are located")
    parser.add_option( '--secondDirectory', dest='secondDirectory',
                       help=u"directory where the outputs of the second non-regression test are located")
    parser.add_option( '--outputDir', dest='outputDir',
                       help=u"directory where the resulting files will be stored (default: <current_folder>/nrt-diff-output)")
    parser.add_option( '--displayMissingDirectories', dest='display_missing_directory',
                       help=u"if True files or directories present in one folder but not in the other will be shown as error in the report (default value=False)")
    (options, args) = parser.parse_args()
    if options.firstDirectory == None:
        parser.error("First directory is not set")
    if options.secondDirectory == None:
        parser.error("Second directory is not set")
    if options.outputDir == None:
        output_dir_all_nrt = os.path.join(os.getcwd(), "nrt-diff-output")
    else:
        output_dir_all_nrt = options.outputDir

    display_missing_directory= False
    if options.display_missing_directory != None:
        display_missing_directory = options.display_missing_directory == 'True'
    if display_missing_directory:
        print("[INFO] Missing files will be considered as an error ")
    else:
        print("[INFO] Only common files will be compared")

    # Output configuration
    output_dir = output_dir_all_nrt
    html_output = os.path.join(output_dir, "nrtDiff.html")

    print("[INFO] output dir: " + output_dir)
    firstDirectory  = os.path.realpath (os.path.expanduser(options.firstDirectory))
    secondDirectory = os.path.realpath (os.path.expanduser(options.secondDirectory))

    if (firstDirectory == secondDirectory):
        parser.error("The two directories are the same !")

    listCases = []

    if (not CheckAllSettings()):
        return False

    if (not StartLogWriting()):
        return False

    time_begin = time.time()

    # Test whether the output repository exists, otherwise create it
    if os.path.isdir(output_dir_all_nrt) == False:
        os.mkdir(output_dir_all_nrt)

    # Repository is deleted from outputs and then is created
    if os.path.isdir(output_dir) == True:
        shutil.rmtree(output_dir)

    os.mkdir(output_dir)

    # Resources are copied in outputs repository
    shutil.copytree(resources_dir, os.path.join(output_dir,"resources"))

    # Loop on repositories
    first_dirs = []
    for first_dir in os.listdir (firstDirectory) + os.listdir (secondDirectory):
        if (os.path.isdir(os.path.join(firstDirectory, first_dir))) or (os.path.isdir(os.path.join(secondDirectory, first_dir))):
            if (not first_dir in first_dirs) and (DirectoryIsIncluded(first_dir)):
                first_dirs.append(first_dir)

    index = 1
    multi_threaded = True
    threads_list = []
    semaphore = threading.Semaphore (maximumNumberOfThreads)
    pool = ActivePool()
    for first_dir in sorted(first_dirs, reverse = True):
        index += 1
        if (os.path.isdir(os.path.join(secondDirectory, first_dir))) and (os.path.isdir(os.path.join(firstDirectory, first_dir))):
            nrt_left_first = os.path.join (firstDirectory, first_dir)
            nrt_right_first = os.path.join (secondDirectory, first_dir)
            second_dirs = []

            for second_dir in os.listdir(nrt_left_first) + os.listdir(nrt_right_first):
                if (os.path.isdir(os.path.join(nrt_left_first, second_dir))) or (os.path.isdir(os.path.join(nrt_right_first, second_dir))):
                    if (not second_dir in second_dirs) and (DirectoryIsIncluded(os.path.join(first_dir, second_dir))):
                        second_dirs.append(second_dir)

            for second_dir in sorted(second_dirs):
                case_name = first_dir + "/" + second_dir
                if os.path.isdir(os.path.join(nrt_left_first, second_dir)) and os.path.isdir(os.path.join(nrt_right_first, second_dir)):

                    if (multi_threaded):
                        thread = threading.Thread (target = DirectoryDiffJobMultiThread, name = first_dir + "/" + second_dir, args = (first_dir, second_dir, semaphore, pool, display_missing_directory))
                        threads_list.append(thread)
                        thread.start()

                    else:
                        DirectoryDiffJob (first_dir, second_dir, display_missing_directory)

                elif display_missing_directory and os.path.isdir(os.path.join(nrt_left_first, second_dir)):
                    WriteLogMessage (case_name + " only on left side" + "\n", True)
                    test_case = TestCase(case_name)
                    test_case.ok_ = False
                    test_case.error_ = True
                    test_case.get_case_info(os.path.join(nrt_left_first, second_dir,'info.txt'))
                    test_case.diff_message_ = "test case only on left side"
                    test_case.case_ = "case_" + str(len(listCases))
                    listCases.append(test_case)

                elif display_missing_directory and os.path.isdir(os.path.join(nrt_right_first, second_dir)):
                    WriteLogMessage (case_name + " only on right side" + "\n", True)
                    test_case = TestCase(case_name)
                    test_case.ok_ = False
                    test_case.error_ = True
                    test_case.get_case_info(os.path.join(nrt_right_first, second_dir,'info.txt'))
                    test_case.diff_message_ = "test case only on right side"
                    test_case.case_ = "case_" + str(len(listCases))
                    listCases.append(test_case)

        elif (display_missing_directory and os.path.isdir(os.path.join(firstDirectory, first_dir))):
            WriteLogMessage (first_dir + " only on left side", True)
            test_case = TestCase(first_dir)
            test_case.ok_ = False
            test_case.error_ = True
            test_case.diff_message_ = first_dir + " only on left side"
            test_case.case_ = "case_" + str(len(listCases))
            listCases.append(test_case)

        elif (display_missing_directory and os.path.isdir(os.path.join(secondDirectory, first_dir))):
            WriteLogMessage (first_dir + " only on right side", True)
            test_case = TestCase(first_dir)
            test_case.ok_ = False
            test_case.error_ = True
            test_case.diff_message_ = first_dir + " only on right side"
            test_case.case_ = "case_" + str(len(listCases))
            listCases.append(test_case)

    for thread in threads_list:
        thread.join()

    if (not EndLogWriting()):
        return False

    time_end = time.time()
    totalTime = time_end - time_begin
    print ("total comparison time : " + str (totalTime))

    listCases.sort (key=lambda x: x.name_.lower())

    # Results are exported as an html file
    print ("exporting results to html ...")
    exportHTML(output_dir, html_output)



##
# Job for non-regression diff, allowing for multi-thread call
# @param first_dir : the directory on the left side
# @param second_dir : the directory on the right side
# @param semaphore : the semaphore used for multi-thread
# @param pool : the pool used for multi-thread
def DirectoryDiffJobMultiThread (first_dir, second_dir, semaphore, pool, display_missing_directory=True):
    with semaphore:
        name = threading.currentThread().getName()
        pool.makeActive(name)
        DirectoryDiffJob (first_dir, second_dir, display_missing_directory)
        pool.makeInactive(name)

##
# General job for comparing two directories
# @param first_dir : the directory on the left side
# @param second_dir : the directory on the right side
# @param display_missing_directory : whether to display missing files/directories in the report
def DirectoryDiffJob (first_dir, second_dir, display_missing_directory=True):

    case_name = first_dir + "/" + second_dir
    test_case = TestCase(case_name)

    comparing_same_case = True
    nrt_left_second = os.path.join(firstDirectory, first_dir, second_dir)
    nrt_right_second = os.path.join(secondDirectory, first_dir, second_dir)
    info_path_left = os.path.join(nrt_left_second, 'info.txt')
    info_path_right = os.path.join(nrt_right_second, 'info.txt')

    if os.path.isfile(info_path_left) and os.path.isfile(info_path_right):
        comparing_same_case = test_case.compare_case_info(info_path_left, info_path_right)

        if comparing_same_case == False:
            print("diff " + case_name + "\n")
            test_case.ok_ = False
            test_case.error_ = True
            return_message = "test case " + test_case.name_ + " has two different identification infos between left and right side"
            test_case.diff_message_ = return_message
            WriteLogMessage ("======================================", True)
            WriteLogMessage (case_name , True)
            WriteLogMessage ("======================================", True)
            WriteLogMessage (return_message, True)
            test_case.case_ = "case_" + str(len(listCases))
            listCases.append(test_case)
            return
        else:
            test_case.get_case_info(info_path_left)
            compiler_log_file = test_case.get_case_CompilerLogFile()
            # exclude compiler log file from comparison
            if compiler_log_file != "" :
                files_excluded.add(compiler_log_file)

    print("diff " + test_case.directory_ + "\n")

    (diff_statuses, return_message, file_names, left_paths, right_paths, diff_messages) = DirectoryDiff (nrt_left_second, nrt_right_second, False, display_missing_directory)

    WriteLogMessage ("======================================", True)
    WriteLogMessage (first_dir + "/" + second_dir , True)
    WriteLogMessage ("======================================", True)
    WriteLogMessage (return_message, True)

    diff_ok = diff_ok_statuses (False)
    diff_warn = diff_warn_statuses ()
    diff_error = diff_error_statuses (False)
    if (len (file_names) != 0):
        for i in range(0,len(file_names)):
            compared_file = ComparedFile(file_names[i], left_paths[i], right_paths[i], diff_statuses[i], diff_messages[i])
            test_case.compared_files_.append(compared_file)
            if (compared_file.diff_status_ in diff_error):
                test_case.error_= True
                test_case.number_of_files_withDiff_ += 1
            elif (compared_file.diff_status_ in diff_warn):
                test_case.warning_= True
                test_case.number_of_files_withDiff_ += 1
    else:
        test_case.diff_message_ = "No files to compare"
    if test_case.error_ or test_case.warning_:
        test_case.ok_= False
    test_case.number_of_files_= len (file_names)
    test_case.case_ = "case_" + str(len(listCases))
    listCases.append(test_case)


##
# Compare a given directory
# For reference data checks, the 'reference' directory will not be taken into account from the root
# For reference data checks, the reference data directory should be on the right
# @param directory_left : the directory on the left side
# @param directory_right : the directory on the right side (should be the reference directory for reference checks)
# @param is_reference_check : whether the function is called within a reference check (or a standard diff)
# @param display_missing_directory : whether to display missing files/directories in the report
def DirectoryDiff (directory_left, directory_right, is_reference_check, display_missing_directory=True):
    identical_dir = True # whether the directories contain identical data (apart from timestamps)
    close_enough_dir = True # whether the directory is close enough (with respect to numeric values comparison)
    file_names = [] # list of relative path of compared files
    left_paths = [] # list of left side path of compared files
    right_paths = [] # list of right side path of  compared files
    diff_statuses = [] # list of diff statuses of  compared files
    diff_messages = [] # list of return messages of compared file
    return_message_str = "" # global return message as a string

    if (not os.path.isdir(directory_left)):
        raise IOError

    if (not os.path.isdir(directory_right)):
        raise IOError

    logs_separator_left = LogsSeparator (directory_left)
    logs_separator_right = LogsSeparator (directory_right)

    for root, directories, filenames in os.walk(directory_left):
        for file_name in filenames:
            relative_file_path = os.path.join(os.path.relpath(root, directory_left), file_name)
            if (keepPathForComparison (directory_left, relative_file_path, is_reference_check)):
                file_names.append(relative_file_path)

    for root, directories, filenames in os.walk(directory_right):
        for file_name in filenames:
            if (not os.path.join(os.path.relpath(root, directory_right), file_name) in file_names):
                relative_file_path = os.path.join(os.path.relpath(root, directory_right), file_name)
                if (keepPathForComparison (directory_right, relative_file_path, is_reference_check)):
                    file_names.append(relative_file_path)

    for file_name in file_names:
        left_path = os.path.join(directory_left, file_name)
        right_path = os.path.join(directory_right, file_name)

        diff_status = None
        if (os.path.isfile(left_path)) and (os.path.isfile(right_path)):
            left_paths.append(left_path)
            right_paths.append(right_path)
            (diff_status, message) = CompareTwoFiles (left_path, logs_separator_left, right_path, logs_separator_right)

            message_added = ""
            if (message != ""):
                message_added = " (" + message + ")"

            if (diff_status == IDENTICAL) or (diff_status == SAME_LOG_WITH_DIFFERENT_TIMESTAMP):
                do_nothing = True
                message_added = ""

            elif (diff_status == MISSING_DATA_BOTH_SIDES) or (diff_status == MISSING_DATA_LEFT) or (diff_status == MISSING_DATA_RIGHT):
                identical_dir = False
                message_added = str(os.path.relpath(left_path, directory_left) + " does not have the same number of curves (but curves present in both are within tolerance)" + message_added + "\n")
                return_message_str += message_added

            elif (diff_status == WITHIN_TOLERANCE) or (diff_status == LOG_DIFFERENT_WITHIN_TOLERANCE):
                identical_dir = False
                return_message_str += str(os.path.relpath(left_path, directory_left) + " within error margin" + message_added + "\n")
                if diff_status == WITHIN_TOLERANCE:
                    message_added = ""
                else:
                    message_added = str(os.path.relpath(left_path, directory_left) + " within error margin\n")

            elif (diff_status == DIFFERENT):
                return_message_str += str(file_name + " DIFFERENT" + message_added + "\n")
                message_added = message_added.strip(" ()")
                identical_dir = False
                close_enough_dir = False

        elif (os.path.isfile(left_path)) and (not os.path.isfile(right_path)):
            if display_missing_directory:
                identical_dir = False
                close_enough_dir = False
                diff_status = MISSING_DATA_RIGHT
            else:
                diff_status = IDENTICAL
            left_paths.append(left_path)
            right_paths.append("")
            return_message_str += str(os.path.relpath(left_path, directory_left) + " only on left side" + "\n")
            message_added = os.path.basename(left_path) + " only on left side"

        elif (not os.path.isfile(left_path)) and (os.path.isfile(right_path)):
            if display_missing_directory:
                identical_dir = False
                close_enough_dir = False
                diff_status = MISSING_DATA_LEFT
            else:
                diff_status = IDENTICAL
            left_paths.append("")
            right_paths.append(right_path)
            return_message_str += str(os.path.relpath(right_path, directory_right) + " only on right side" + "\n")
            message_added = os.path.basename(right_path) + " only on right side"

        diff_statuses.append(diff_status)
        diff_messages.append(message_added)

    if (len (file_names) == 0):
        diff_statuses.append(NO_FILES_TO_COMPARE)

    if (identical_dir):
        return_message_str += str("=> Ok" + "\n")
    else:
        return_message_str += str("(all other files are identical)" + "\n")

    return (diff_statuses, return_message_str, file_names, left_paths, right_paths, diff_messages)

## Find the log separator for a given test case directory
# @param test_dir : the directory for which to conduct the separator search
# @return : the separator as a string
def LogsSeparator (test_dir):
    separator = settings.logs_default_separator

    # look for a jobs file
    list_files = [f for f in os.listdir(test_dir) if os.path.isfile(os.path.join(test_dir, f)) and f.endswith('.jobs')]

    # look for the first appender of the first file, and consider it as the reference for separator
    for name in list_files:
        file_path = os.path.join (test_dir, name)

        (file_content, ns, prefix) = XMLUtils.ImportXMLFileExtended(file_path)
        for item in XMLUtils.FindAll(file_content, prefix, "appender", ns):
            if 'separator' in item.attrib:
                separator = item.attrib['separator']
                break

        return separator.lstrip().rstrip()

    return separator.lstrip().rstrip()

## Remove time stamps from log files in order to ease diff readability
# @param file_path : path to input log file
# @param output_file_path: path to output log file
def update_one_log_file(file_path, output_file_path):
    if (not os.path.isfile(file_path)):
        print("File " + file_path + " missing")
        sys.exit(1)

    if (output_file_path == file_path):
        print("Error during generation of cleaned log file")
        sys.exit(1)

    separator = LogsSeparator (os.path.abspath (os.path.join (os.path.dirname (file_path), "..")))

    file_in = open (file_path, 'r')
    file_out = open (output_file_path, 'w')

    for line in file_in:
        file_out.write (LineMessage (line, separator))

    file_in.close()
    file_out.close()

##
# Read the jobs file and find the output directories used
# @param jobs_file : the path to the jobs file
# @return a list of output directories
def findOutputDirFromJob(jobs_file):
    if jobs_file.endswith(".zip"):
        return ['.']  # relative current directory

    # Parse jobs file
    try:
        (jobs_root, ns, prefix) = XMLUtils.ImportXMLFileExtended(jobs_file)
    except:
        print("Fail to import XML file " + jobs_file + os.linesep)
        sys.exit(1)

    output_dirs = []
    # we expect to find job elements and outputs sub-elements with a directory attribute
    for job in XMLUtils.FindAll(jobs_root, prefix, "job", ns):
        for outputs in XMLUtils.FindAll(job, prefix, "outputs", ns):
            if 'directory' in outputs.attrib:
                output_dirs.append(outputs.attrib["directory"])

    # if nothing has been found, it's probably another format of jobs file from a derived project
    # and we return the relative current directory
    return output_dirs or ['.']


##
# conduct a directory diff looking for reference data, and return only the most critical diff status
# @param jobs_file : the path to the jobs file
def DirectoryDiffReferenceDataJob (jobs_file):
    output_dirs = findOutputDirFromJob(jobs_file)
    messages = []
    final_status = IDENTICAL
    for output_dir in output_dirs:
        # caution: output_dir has to be relative !
        reference_data_directory = os.path.join (os.path.dirname(jobs_file), REFERENCE_DATA_DIRECTORY_NAME, output_dir)
        nrt_directory = os.path.join (os.path.dirname(jobs_file),output_dir)
        status_priority = [UNABLE_TO_CHECK, NO_FILES_TO_COMPARE, MISSING_DATA_BOTH_SIDES, MISSING_DATA_LEFT, DIFFERENT, WITHIN_TOLERANCE, LOG_DIFFERENT_WITHIN_TOLERANCE, MISSING_DATA_RIGHT, SAME_LOG_WITH_DIFFERENT_TIMESTAMP, IDENTICAL]

        diff_statuses = None
        diff_messages = None
        if (not os.path.isdir (reference_data_directory)):
            diff_statuses = [NO_FILES_TO_COMPARE]
            diff_messages = ["No files to compare."]
        else:
            (diff_statuses, return_message, file_names, left_paths, right_paths, diff_messages) = DirectoryDiff (nrt_directory, reference_data_directory, True)
        for status in status_priority:
            if status in diff_statuses:
                if status_priority.index(status) < status_priority.index(MISSING_DATA_RIGHT):
                    indices = [i for i, x in enumerate(diff_statuses) if x == status]
                    messages.extend([ diff_messages[index] for index in indices ])
                if status_priority.index(status) < status_priority.index(final_status):
                    final_status = status
    return (final_status, messages)

##
# conduct a directory diff looking for reference data, and return only the most critical diff status in a multithreading environment
# @param case : the case class to analyse
# @param semaphore : the semaphore used for multi-thread
# @param pool : the pool used for multi-thread
def DirectoryDiffReferenceDataJobMultiThread (case, index, nbCases, semaphore, pool):
    ##
    # Following from Python cookbook, #475186
    def has_colours(stream):
        if not hasattr(stream, "isatty"):
            return False
        if not stream.isatty():
            return False # auto color only on TTYs
        try:
            import curses
            curses.setupterm()
            return curses.tigetnum("colors") > 2
        except:
            # guess false in case of error
            return False
    has_colours = has_colours(sys.stdout)
    with semaphore:
#        start_time = time.time()
        name = threading.currentThread().getName()

        toPrint = '[{0:>3}/{1:<3}]'.format(index, nbCases-1)
        toPrint = str(toPrint)
        if has_colours:
            seq = "\x1b[1;%dm" % (31) + toPrint + "\x1b[0m"
            sys.stdout.write(seq)
        else:
            sys.stdout.write(toPrint)
        sys.stdout.write(" " +  case.name_ + "\n")

        pool.makeActive(name)
        (status, messages) = DirectoryDiffReferenceDataJob (case.jobs_file_)
        case.diff_ = status
        case.diff_messages_ = messages
        pool.makeInactive(name)
#        end_time = time.time()
#        sys.stdout.write(case.name_ + " Finished in " + str(end_time-start_time) +"s\n")

##
# Check whether a given directory should be included in the diff
# @param directory : the directory to check ; only the last two (low-level) directory names should be given
def DirectoryIsIncluded (directory):
    first_dir = None
    second_dir = None
    temp = directory.split(os.sep)
    index_temp = 0
    for item in temp:
        if (index_temp == 0):
            first_dir = item
        elif (index_temp == 1):
            second_dir = item
        else:
            break
        index_temp += 1

    for (first_excluded, second_excluded) in settings.directories_excluded:
        if (first_excluded == "*") or (first_dir == first_excluded):
            if (second_excluded == "*") or (second_dir == second_excluded):
                return False

    for (first_included, second_included) in settings.directories_included:
        if (first_included == "*") or (first_dir == first_included):
            if (second_dir is None) or (second_included == "*") or (second_dir == second_included):
                return True

    #neither included nor excluded => rejected
    return False

##
# Check whether a file should be included
# Param file_name : the file name
def FileIsIncluded (file_name):
    for name in files_excluded:
        if (name == "*") or (name[name.rfind('*.')+ 1 :] in file_name):
            return False

    for name in files_included:
        if (name == "*") or (name[name.rfind('*.')+ 1 :] in file_name):
            return True

    #neither included nor excluded => rejected
    return False

##
# Check whether to keep the path for comparison
# @param root_nrt_directory : the root directory of the non-regression test
# @param relative_file_path : the file path relative to root_nrt_directory
# @param is_reference_check : whether the function is called inside a reference check
def keepPathForComparison (root_nrt_directory, relative_file_path, is_reference_check):
    split_path = os.path.normpath(relative_file_path).split(os.sep)

    # Check whether there is reference check reason to skip the path
    if (is_reference_check) and (len(split_path) > 1):
        first_directory = split_path [0]

        # Skip the 'reference' directory when scanning it during a reference data check (it is already included in the reference part)
        if (os.path.basename(root_nrt_directory) != REFERENCE_DATA_DIRECTORY_NAME) and (first_directory == REFERENCE_DATA_DIRECTORY_NAME):
            return False

    # Check whether there is a file_name filter reason to skip the path
    file_name = os.path.basename (relative_file_path)
    if (not FileIsIncluded (file_name)):
        return False
    # Check whether the directory is included
    if not DirectoryIsIncluded(os.path.dirname(relative_file_path)):
        return False
    # No reason to skip the path => keep it
    return True

##
# Check whether all settings have been set
def CheckAllSettings():
    requiredSettings = ["directories_included", "directories_excluded", "max_DTW", "files_included", "files_excluded", "logs_destination", "maximum_threads_nb"]
    optionalSettings = ["logs_file_path"]
    for singleSetting in requiredSettings:
        if (not hasattr(settings, singleSetting)):
            print ("Missing option : " + singleSetting)
            return False

        if (getattr(settings, singleSetting) is None):
            print("Option without value : " + singleSetting)
            return False

    for singleSetting in optionalSettings:
        if (not hasattr(settings, singleSetting)):
            print("Optional option missing : " + singleSetting)

    return True

##
# Write a log message
# @param message : the message as a string
# @param writeEndLine : whether to add a line ending
logFile = None
logLock = threading.Lock()
def WriteLogMessage(message, writeEndLine):
    global logFile, logLock

    if (message is None):
        return False

    if (settings.logs_destination == "console"):
        print(message)
    elif (settings.logs_destination == "text file"):
        if (not hasattr(settings, "logs_file_path")):
            print(" Unable to generate a log file : missing destination repository")
            return False

        if (logFile is None):
            print("Error when writing log file : missing file")
            return False

        message_to_write = message
        endLine = "\n"
        if writeEndLine:
            message_to_write += endLine

        logLock.acquire()
        logFile.write(message_to_write)
        logLock.release()

    return True

##
# Write the log file header
def StartLogWriting():
    global logFile

    if (settings.logs_destination == "text file"):
        #remove a previous log file when needed
        if (os.path.isfile(settings.logs_file_path)):
            os.remove(settings.logs_file_path)

        logFile = open(settings.logs_file_path, "w")
    WriteLogMessage("NRT diff", True)
    WriteLogMessage("Run on " + datetime.datetime.now().strftime("%Y-%m-%d at %Hh%M"), True)
    WriteLogMessage("Left side : " + firstDirectory, True)
    WriteLogMessage("Right side : " + secondDirectory, True)
    WriteLogMessage("------------------------------------------------------", True)

    WriteLogMessage("", True)

    return True

##
# End the log message writing process
def EndLogWriting():
    if (logFile is not None):
        logFile.close()

    return True

##
# Compare two given files
# @param path_left : the absolute path to the left-side file
# @param logs_separator_left : the separator to use as a string
# @param path_right : the absolute path to the right-side file
# @param logs_separator_right : the separator to use as a string
def CompareTwoFiles (path_left, logs_separator_left, path_right, logs_separator_right):
    #ignore log files in debug mode
    file_extension = os.path.splitext(os.path.basename(path_left))[1]
    file_name = os.path.splitext(os.path.basename(path_left))[0]
    build_tests = False
    if os.environ.get('DYNAWO_BUILD_TESTS') != None:
        build_tests = build_tests or (os.environ['DYNAWO_BUILD_TESTS'] == "ON")
    if os.environ.get('DYNAWO_BUILD_TESTS_COVERAGE') != None:
        build_tests =  build_tests or (os.environ['DYNAWO_BUILD_TESTS_COVERAGE'] == "ON")

    if os.environ['DYNAWO_BUILD_TYPE'] == "Debug" and not build_tests:
        return (IDENTICAL, "")

    identical = filecmp.cmp (path_left, path_right, shallow=False)
    message = ""

    return_value = None
    if (identical):
        return_value = IDENTICAL
    else:
        if file_name == "curves" and file_extension == ".xml":
            (nb_points, nb_curves_only_in_left_file, nb_curves_only_in_right_file, nb_differences, nb_err_absolute, nb_err_relative, curves_different) = XMLCloseEnough (path_left, path_right)
            maximum_curves_names_displayed = 5
            dir = os.path.abspath(os.path.join(path_left, os.pardir))
            parent_dir = os.path.abspath(os.path.join(dir, os.pardir))
            message = "<font color=\"red\">" + os.path.basename(parent_dir) + "/" + os.path.basename(dir) + "/" + os.path.basename(path_left) + ":</font> "
            if (nb_err_absolute > 0) or (nb_err_relative > 0):
                return_value = DIFFERENT

                if (nb_err_absolute > 0):
                    message += str(nb_err_absolute) + " absolute errors"

                if (nb_err_relative > 0):
                    if (message != ""):
                        message += " and "
                    message += str(nb_err_relative) + " relative errors"


                if (len (curves_different) <= maximum_curves_names_displayed):
                    for curve in curves_different:
                        message += " , " + curve
                else:
                    message += " coming from more than " + str(maximum_curves_names_displayed) + " curves"

            elif (nb_differences > 0):
                return_value = WITHIN_TOLERANCE
                message = str(nb_points) + " data points compared for each curve"

            else:
                return_value = IDENTICAL

        elif (file_extension == ".log" or "timeline" in file_name):
            dir = os.path.abspath(os.path.join(path_left, os.pardir))
            parent_dir = os.path.abspath(os.path.join(dir, os.pardir))
            message = "<font color=\"red\">" + os.path.basename(parent_dir) + "/" + os.path.basename(dir) + "/" + os.path.basename(path_left) + ":</font>  "
            nb_lines_compared, nb_lines_identical_but_timestamp, nb_lines_different_within_tolerance, nb_lines_different = DynawoLogCloseEnough (path_left, logs_separator_left, path_right, logs_separator_right)
            if (nb_lines_different == 0) and (nb_lines_identical_but_timestamp == 0) and (nb_lines_different_within_tolerance == 0):
                return_value = IDENTICAL
            elif (nb_lines_different == 0) and (nb_lines_identical_but_timestamp > 0) and (nb_lines_different_within_tolerance == 0):
                return_value = SAME_LOG_WITH_DIFFERENT_TIMESTAMP
                message += str (nb_lines_compared) + " lines compared"
            elif (nb_lines_different == 0) and (nb_lines_different_within_tolerance > 0):
                return_value = LOG_DIFFERENT_WITHIN_TOLERANCE
                message += str (nb_lines_different_within_tolerance) + " difference"
                if (nb_lines_different_within_tolerance > 1):
                    message += "s"
                message += " within tolerance"
            elif (nb_lines_different > 0):
                return_value = DIFFERENT
                message += str (nb_lines_different) + " difference"
                if (nb_lines_different > 1):
                    message += "s"

        elif (file_extension == ".csv"):
            (nb_points, nb_curves_only_in_left_file, nb_curves_only_in_right_file, nb_differences, nb_err_absolute, nb_err_relative, curves_different) = CSVCloseEnough (path_left, path_right, True)
            maximum_curves_names_displayed = 5
            dir = os.path.abspath(os.path.join(path_left, os.pardir))
            parent_dir = os.path.abspath(os.path.join(dir, os.pardir))
            message = "<font color=\"red\">" + os.path.basename(parent_dir) + "/" + os.path.basename(dir) + "/" + os.path.basename(path_left) + ":</font> "
            if (nb_err_absolute > 0) or (nb_err_relative > 0):
                return_value = DIFFERENT

                if (nb_err_absolute > 0):
                    message += str(nb_err_absolute) + " absolute errors"

                if (nb_err_relative > 0):
                    if (message != ""):
                        message += " and "
                    message += str(nb_err_relative) + " relative errors"


                if (len (curves_different) <= maximum_curves_names_displayed):
                    for curve in curves_different:
                        message += " , " + curve
                else:
                    message += " coming from more than " + str(maximum_curves_names_displayed) + " curves"

            elif (nb_curves_only_in_left_file + nb_curves_only_in_right_file > 0):
                if (nb_curves_only_in_left_file > 0) and (nb_curves_only_in_right_file > 0):
                    return_value = MISSING_DATA_BOTH_SIDES
                elif (nb_curves_only_in_left_file > 0):
                    return_value = MISSING_DATA_RIGHT
                elif (nb_curves_only_in_right_file > 0):
                    return_value = MISSING_DATA_LEFT

                message = ""

                if (len (curves_different) <= maximum_curves_names_displayed):
                    first_curve = True
                    for curve in sorted(curves_different):
                        if (not first_curve):
                            message += ", "
                        else:
                            first_curve = False
                        message += curve
                else:
                    message = str (nb_curves_only_in_left_file + nb_curves_only_in_right_file) + " curves"
                message += " missing in one file"

            elif (nb_differences > 0):
                return_value = WITHIN_TOLERANCE
                message = str(nb_points) + " data points compared for each curve"

            else:
                return_value = IDENTICAL
        elif file_name.startswith("dumpInitValues-") and file_extension == ".txt":
            (nb_differences) = InitValuesCloseEnough (path_left, path_right)
            dir = os.path.abspath(os.path.join(path_left, os.pardir))
            parent_dir = os.path.abspath(os.path.join(dir, os.pardir))
            message = "<font color=\"red\">" + os.path.basename(parent_dir) + "/" + os.path.basename(dir) + "/" + os.path.basename(path_left) + ":</font> "
            if (nb_differences > 0):
                return_value = DIFFERENT
                message += str(nb_differences) + " different initial values"
            else:
                return_value = IDENTICAL
        elif "outputIIDM" in file_name and file_extension == ".xml":
            (nb_differences, msg) = iidmDiff.OutputIIDMCloseEnough (path_left, path_right)
            dir = os.path.abspath(os.path.join(path_left, os.pardir))
            parent_dir = os.path.abspath(os.path.join(dir, os.pardir))
            message = "<font color=\"red\">" + os.path.basename(parent_dir) + "/" + os.path.basename(dir) + "/" + os.path.basename(path_left) + ":</font> "
            if (nb_differences > 0):
                return_value = DIFFERENT
                message += str(nb_differences) + " different output values\n" + msg
            else:
                return_value = IDENTICAL
        elif "constraints" in file_name:
            (nb_differences, msg) = constraintsDiff.output_constraints_close_enough (path_left, path_right)
            dir = os.path.abspath(os.path.join(path_left, os.pardir))
            parent_dir = os.path.abspath(os.path.join(dir, os.pardir))
            message = "<font color=\"red\">" + os.path.basename(parent_dir) + "/" + os.path.basename(dir) + "/" + os.path.basename(path_left) + ":</font> "
            if (nb_differences > 0):
                return_value = DIFFERENT
                message += str(nb_differences) + " different output values\n" + msg
            else:
                return_value = IDENTICAL
        elif "finalStateValues" in file_name:
            (nb_differences, msg) = finalStateValuesDiff.output_xml_fsv_close_enough (path_left, path_right)
            dir = os.path.abspath(os.path.join(path_left, os.pardir))
            parent_dir = os.path.abspath(os.path.join(dir, os.pardir))
            message = "<font color=\"red\">" + os.path.basename(parent_dir) + "/" + os.path.basename(dir) + "/" + os.path.basename(path_left) + ":</font> "
            if (nb_differences > 0):
                return_value = DIFFERENT
                message += str(nb_differences) + " different output values\n" + msg
            else:
                return_value = IDENTICAL
        else:
            message = "<font color=\"red\">Problem with " + os.path.basename(path_left) + "</font>"
            return_value = DIFFERENT


    return (return_value, message)

TYPE_LOG, TYPE_TIMELINE = range(2)

## Check whether to keep a line for log comparison
# @param line : the line to study as a string
# @param type : type of the file
# @return : a boolean describing whether it is relevant to compare the line
def LineToCompare (line, file_type):
    if file_type == TYPE_LOG:
        lines_to_avoid = settings.logs_pattern_to_avoid

        # if a line should be avoided, then no comparison is needed
        for pattern in lines_to_avoid:
            if pattern in line:
                return False

        if ("number of" in line and "variables" in line and "evaluations" not in line) or "ERROR" in line or ("WARN" in line and "KINSOL" not in line):
            return True
    elif file_type == TYPE_TIMELINE:
        # We filter those lines as they are very unstable
        if ("PMIN : deactivation" not in line and "PMIN : activation" not in line and "PMAX : deactivation" not in line and "PMAX : activation" not in line):
            return True

    # everything went fine => the line should be compared
    return False

## Extract the log message from a given log line
# @param line : the raw line to study as a string
# @param separator : the separator used as a string
# @return : the extracted message as a string
def LineMessage (line, separator):
    maximum_severity_date_length = 31

    # remove everything up to the right-most separator from the sub_line
    sub_line = line [ : maximum_severity_date_length]

    if (separator not in sub_line):
        return line
    else:
        return line [sub_line.rfind (separator) + 1 : ]

## Compare the statistics line ("number of ... = ") with a tolerance
# @param line_left : the raw line to study as a string from left file
# @param line_right : the raw line to study as a string from right file
# @return : IDENTICAL if lines are equals, WITHIN_TOLERANCE if the comparison is within tolerance, DIFFERENT otherwise
def LineCloseEnough (line_left, line_right):
    percentage_tolerance = 3
    if line_left == line_right:
        return IDENTICAL

    xerces_pattern = re.compile(r'.*error while parsing file (?P<path>\/.*?\.[\w:]+) :.*')
    match_left = re.search(xerces_pattern, line_left)
    match_right = re.search(xerces_pattern, line_right)
    if match_left is not None:
        path = match_left.group('path')
        line_left = line_left.replace(path, os.path.basename(path))
    if match_right is not None:
        path = match_right.group('path')
        line_right = line_right.replace(path, os.path.basename(path))

    # Compare statistics lines
    value_pattern = re.compile(r'.*number of [\w ]*= (?P<value>[0-9]+)[ ()\w]*')
    match_left = re.search(value_pattern, line_left)
    match_right = re.search(value_pattern, line_right)
    if match_left is not None and match_right is not None:
        value_left = int(match_left.group("value"))
        value_right = int(match_right.group("value"))
        threshold = min(value_left, value_right)*percentage_tolerance/100
        if abs(value_left - value_right) <= threshold:
            return WITHIN_TOLERANCE

    # Compare warning and error lines
    num_line_pattern = re.compile(r'(?P<value>(\.cpp|\.hpp|\.h):[0-9]+)')
    match_left = re.search(num_line_pattern, line_left)
    match_right = re.search(num_line_pattern, line_right)
    if match_left is not None and match_right is not None:
        line_left = line_left.replace(match_left.group("value"),"")
        line_right = line_right.replace(match_right.group("value"),"")
        if line_left == line_right:
            return IDENTICAL

    return DIFFERENT


##
# Check whether two log files are close enough
# @param path_left : the absolute path to the left-side file
# @param logs_separator_left : the separator to use as a string
# @param path_right : the absolute path to the right-side file
# @param logs_separator_right : the separator to use as a string
def DynawoLogCloseEnough (path_left, logs_separator_left, path_right, logs_separator_right):
    file_left = open (path_left, "rt")
    file_right = open (path_right, "rt")
    lines_to_compare_left = []
    lines_to_compare_right = []
    file_name = os.path.splitext(os.path.basename(path_left))[0]
    file_extension = os.path.splitext(os.path.basename(path_left))[1]
    file_type = TYPE_LOG
    if "timeline" in file_name:
        file_type = TYPE_TIMELINE
    for line_left in file_left:
        # skip some lines when needed
        if (LineToCompare (line_left, file_type)):
            lines_to_compare_left.append(line_left)

    for line_right in file_right:
        # skip some lines when needed
        if (LineToCompare (line_right, file_type)):
            lines_to_compare_right.append(line_right)

    file_left.close()
    file_right.close()

    nb_lines_compared = 0
    nb_lines_identical = 0
    nb_lines_identical_but_timestamp = 0
    nb_lines_different = abs(len(lines_to_compare_left) - len(lines_to_compare_right))
    nb_lines_different_within_tolerance = 0
    for line_left, line_right in zip(lines_to_compare_left, lines_to_compare_right):
        nb_lines_compared += 1
        if (line_left == line_right):
            nb_lines_identical += 1
        else:
            line_left_message = LineMessage (line_left, logs_separator_left)
            line_right_message = LineMessage (line_right, logs_separator_right)
            if (line_left_message == line_right_message):
                nb_lines_identical_but_timestamp += 1
            else:
                diff = LineCloseEnough (line_left_message, line_right_message)
                if diff == DIFFERENT:
                    nb_lines_different += 1
                elif diff == WITHIN_TOLERANCE:
                    nb_lines_different_within_tolerance += 1
                else:
                    nb_lines_identical += 1

    return (nb_lines_compared, nb_lines_identical_but_timestamp, nb_lines_different_within_tolerance, nb_lines_different)

# Check whether two xml curve files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def XMLCloseEnough (path_left, path_right):
    (left_file_content, ns, prefix) = XMLUtils.ImportXMLFileExtended(path_left)
    times_left = []
    left_curve = {}
    ns = left_file_content.nsmap
    for item in XMLUtils.FindAll(left_file_content, prefix, "curve", ns):
        current_curve = item.attrib["model"]+"_"+item.attrib["variable"]
        left_curve[current_curve] = {}
        for pointItem in XMLUtils.FindAll(item, prefix, "point", ns):
            left_curve[current_curve][pointItem.attrib["time"]] = pointItem.attrib["value"]
            if(pointItem.attrib["time"] not in times_left):
                    times_left.append(pointItem.attrib["time"])
    right_curve = {}
    times_right = []
    (right_file_content, ns, prefix) = XMLUtils.ImportXMLFileExtended(path_right)
    for item in XMLUtils.FindAll(right_file_content, prefix, "curve", ns):
        current_curve = item.attrib["model"]+"_"+item.attrib["variable"]
        right_curve[current_curve] = {}
        for pointItem in XMLUtils.FindAll(item, prefix, "point", ns):
            right_curve[current_curve][pointItem.attrib["time"]] = pointItem.attrib["value"]
            if(pointItem.attrib["time"] not in times_right):
                times_right.append(pointItem.attrib["time"])


    times = []
    for t in sorted(times_left):
        if (t in times_right):
            times.append(t)

    curves_different = set([])
    curves = {}
    nb_curves_only_in_left_file = 0
    nb_curves_only_in_right_file = 0

    for curve in sorted (left_curve.keys()):
        if (curve in right_curve.keys()):
            curves [curve] = (left_curve [curve], right_curve [curve])
        else:
            nb_curves_only_in_left_file += 1
            curves_different.add (curve)

    for curve in sorted (right_curve.keys()):
        if (not curve in left_curve.keys()):
            nb_curves_only_in_right_file += 1
            curves_different.add (curve)

    nb_differences = 0
    nb_differences_absolute = 0
    nb_differences_relative = 0
    max_dtw = settings.max_DTW
    for exception in settings.dtw_exceptions:
        if exception in path_left or exception in path_right:
            max_dtw = settings.dtw_exceptions[exception]
            break
    for curve in curves.keys():
        (curve_left, curve_right) = curves [curve]
        left = []
        right = []
        for t in sorted(times_left):
            left.append(float (left_curve[curve][t]))
        for t in sorted(times_right):
            right.append(float (right_curve[curve][t]))
        if max_dtw is not None:
           distance = DTWDistance(left, right)
           if distance > max_dtw:
                nb_differences += 1
                nb_differences_absolute += 1
                curves_different.add (curve)
                if nb_differences > 5: break

    return (len(times), nb_curves_only_in_left_file, nb_curves_only_in_right_file, nb_differences, nb_differences_absolute, nb_differences_relative, curves_different)


# Comparison of 2 curves based on the Dynamic Time Warping distance
# @param left : list of left values
# @param right : list of right values
# @return distance between left and right curves
def DTWDistance(left, right) :
    n = len(left)
    m = len(right)
    if left == right:
        return 0.
    DTW = [[0 if (j == 0 and i == 0) else 999999 for j in range(m+1)] for i in range(n+1)]

    for i in range(1, n+1):
        leftValue = left[i-1]
        previousRow = DTW[i-1]
        thisRow = DTW[i]
        for j in range (1, m+1):
            minValue = [previousRow[j],thisRow[j-1],previousRow[j-1]]
            minValue.sort()
            DTW[i][j] = abs(leftValue - right[j-1]) + minValue[0]

    return DTW[n][m]


# Check whether two initial values files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
def InitValuesCloseEnough (path_left, path_right):
    file_left = open (path_left, "rt")
    file_right = open (path_right, "rt")
    name_2_val_left = {}
    name_2_val_right = {}
    aliases_2_ref_var_left = {}
    aliases_2_ref_var_right = {}
    ptrn_comment = re.compile(r'\s[=]+\s[\w]+[\s=]+')
    ptrn_var_y_yp = re.compile(r'(?P<varName>[\w]+)[\s]+: y =[\s]*(?P<yVal>[-0-9\.]+)[\s]*yp =[\s]*(?P<ypVal>[-0-9\.]+)')
    ptrn_single_val = re.compile(r'(?P<varName>[\w]+)[\s]+: [yz] =[\s]*(?P<val>[-0-9\.]+)[\s]*\n')
    ptrn_single_val_param = re.compile(r'(?P<varName>[\w]+)[\s]+=[\s]*(?P<val>[-0-9\.]+)[\s]*\n')
    ptrn_alias_val = re.compile(r'(?P<varName>[\w]+)[\s]+: alias of (?P<refVar>[\w]+)')
    for line_left in file_left:
        if ptrn_comment.search(line_left) is not None:
            continue
        match = ptrn_var_y_yp.findall(line_left)
        for varName, y, yp in match:
            name_2_val_left[varName] = [float(y), float(yp)]
        if len(match) == 0:
            match = ptrn_single_val.findall(line_left)
            for name, val in match:
                name_2_val_left[name] = [float(val)]
            if len(match) == 0:
                match = ptrn_single_val_param.findall(line_left)
                for name, val in match:
                    name_2_val_left[name] = [float(val)]
        match = ptrn_alias_val.findall(line_left)
        for name, ref_name in match:
            aliases_2_ref_var_left[name] = ref_name
    for line_right in file_right:
        if ptrn_comment.search(line_right) is not None:
            continue
        match = ptrn_var_y_yp.findall(line_right)
        for varName, y, yp in match:
            name_2_val_right[varName] = [float(y), float(yp)]
        if len(match) == 0:
            match = ptrn_single_val.findall(line_right)
            for name, val in match:
                name_2_val_right[name] = [float(val)]
            if len(match) == 0:
                match = ptrn_single_val_param.findall(line_right)
                for name, val in match:
                    name_2_val_right[name] = [float(val)]
        match = ptrn_alias_val.findall(line_right)
        for name, ref_name in match:
            aliases_2_ref_var_right[name] = ref_name

    file_left.close()
    file_right.close()
    if len(name_2_val_left) != len(name_2_val_right) :
        return abs(len(name_2_val_left) != len(name_2_val_right))
    if len(aliases_2_ref_var_left) != len(aliases_2_ref_var_right) :
        return abs(len(aliases_2_ref_var_left) != len(aliases_2_ref_var_right))

    nb_diff = 0
    for name in name_2_val_left:
        left = name_2_val_left[name]
        if name in name_2_val_right:
            right = name_2_val_right[name]
            if len(left) != len(right):
                nb_diff+=1
            else:
                for i in range(len(left)):
                    error = abs(left[i] - right[i])
                    if error > 1e-6:
                        nb_diff+=1
        else:
            nb_diff+=1
    for name in aliases_2_ref_var_left:
        left = aliases_2_ref_var_left[name]
        if name in aliases_2_ref_var_right:
            right = aliases_2_ref_var_right[name]
            if left != right:
                nb_diff+=1
        else:
            nb_diff+=1

    return nb_diff

# Check whether two csv files are close enough
# @param path_left : the absolute path to the left-side file
# @param path_right : the absolute path to the right-side file
# @param dataWrittenAsRows : whether data sets are written as rows (or columns)
def CSVCloseEnough (path_left, path_right, dataWrittenAsRows):

    # when data is written as rows, write a temporary file where data is written as columns
    if dataWrittenAsRows:
        standard_delimiter = ";"

        left_map = transposer.transpose (path_left, None, standard_delimiter)
        # Filter header and last empty row and make it a list of list to comply with data format returned by csv.reader
        reader_left = [[x for x in l.split(";")] for l in left_map if l.split(";")[0] != ""]
        right_map = transposer.transpose (path_right, None, standard_delimiter)
        reader_right = [[x for x in l.split(";")] for l in right_map if l.split(";")[0] != ""]
    else:
        with open (path_left, "rt") as file:
            reader_left = list(csv.reader (file, delimiter = ";"))
        with open (path_right, "rt") as file:
            reader_right = list(csv.reader (file, delimiter = ";"))

    times_left = {}
    curves_left = {}
    row_index = 0
    for row in reader_left:
        if (row_index == 0):
            index = 0
            val = None
            val_previous = None
            for v in row:
                if (index > 0) and (v.strip() != ""):
                    val = float(v)
                    if (val_previous is None) or (val >= val_previous):
                        times_left[val] = index

                if (index == 0):
                    val_previous = None
                else:
                    val_previous = val
                index += 1
        else:
            if (row [0].strip() != ''):
                curves_left [row [0]] = row_index

        row_index += 1


    times_right = {}
    curves_right = {}
    row_index = 0
    for row in reader_right:
        if (row_index == 0):
            index = 0
            val = None
            val_previous = None
            for v in row:
                if (index > 0) and (v.strip() != ""):
                    val = float(v)
                    if (val_previous is None) or (val >= val_previous):
                        times_right[val] = index

                if (index == 0):
                    val_previous = None
                else:
                    val_previous = val
                index += 1
        else:
            if (row [0].strip() != ''):
                curves_right [row [0]] = row_index

        row_index += 1

    times = {}
    for t in sorted(times_left.keys()):
        if (t in times_right.keys()):
            times [t] = (times_left [t], times_right [t])

    curves_different = set([])
    curves = {}
    nb_curves_only_in_left_file = 0
    nb_curves_only_in_right_file = 0

    for curve in sorted (curves_left.keys()):
        if (curve in curves_right.keys()):
            curves [curve] = (curves_left [curve], curves_right [curve])
        else:
            nb_curves_only_in_left_file += 1
            curves_different.add (curve)

    for curve in sorted (curves_right.keys()):
        if (not curve in curves_left.keys()):
            nb_curves_only_in_right_file += 1
            curves_different.add (curve)

    nb_differences = 0
    nb_differences_absolute = 0
    nb_differences_relative = 0
    max_dtw = settings.max_DTW
    for exception in settings.dtw_exceptions:
        if exception in path_left or exception in path_right:
            max_dtw = settings.dtw_exceptions[exception]
            break
    for curve in curves.keys():
        (curve_left, curve_right) = curves [curve]
        data_left = reader_left [curve_left]
        data_right = reader_right [curve_right]
        left = []
        right = []
        for t in sorted(times_left.keys()):
            left.append(float (data_left [times_left[t]] .strip()))
        for t in sorted(times_right.keys()):
            right.append(float (data_right [times_right[t]] .strip()))
        if max_dtw is not None:
            distance = DTWDistance(left, right)
            if distance > max_dtw:
                nb_differences += 1
                nb_differences_absolute += 1
                curves_different.add (curve)
                if nb_differences > 5: break

    return (len(times), nb_curves_only_in_left_file, nb_curves_only_in_right_file, nb_differences, nb_differences_absolute, nb_differences_relative, curves_different)

##
# Make an html report to display diff results
# @param output_dir : output directory
# @param html_output : path of html result file
def exportHTML(output_dir, html_output):
    # delete old html report if exists
    if os.path.isfile(html_output):
        os.remove(html_output)
    # create an output directory for each testcase
    for test_case in listCases:
        os.mkdir(os.path.join(output_dir,test_case.case_))
    # create the html report
    file = open(html_output, "w")
    writeHeader(file)
    writeResume(file)
    writeDetails(file, output_dir, html_output)
    writeFooter(file)
    # open the html report
    webbrowser.get(web_browser).open_new_tab(html_output)

##
# Write Header
# @param file : html file
def writeHeader(file):
    file.write("""<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <link rel="stylesheet" href="resources/report.css" />
        <title>Dynawo NRT Diff</title>
    </head>
    <body>
      <div id="page_bloc">
        <header>
          <h1>Dynawo NRT Diff</h1>
        </header>\n""")

##
# Write Footer of html report
# @param file : html file
def writeFooter(file):
    file.write("""
      </div>
    </body>
</html>""")

##
# Write global summary of NRT diff results
# @param file : html file
def writeResume(file):
    file.write("<section>")
    file.write('<h2 id="resume">Resume</h2>')
    # Analyze for statistics
    diff_ok = diff_ok_statuses (False)
    diff_warn = diff_warn_statuses ()
    diff_error = diff_error_statuses (False)
    no_diff = diff_neutral_statuses ()
    nb_ok = 0
    nb_warn = 0
    nb_nok = 0

    nb_cases =   len(listCases)

    for test_case in listCases:
        if test_case.error_:
            nb_nok += 1
        elif test_case.warning_:
            nb_warn +=1
        elif test_case.ok_:
            nb_ok +=1
    # Write statistics
    nb_diff=0
    statistics = "<aside><h1>Statistics</h1><ul><li>Run on:</li><li>Left Side:</li><li>Right Side:</li><li>Number of OK cases:</li><li>Number of OK cases with warning:</li>" \
                + "<li>Number of NOK cases:</li><li>Total comparison time:</li></ul><ul>"

    addOnBeginNOK = ""
    addOnEndNOK = ""
    if (nb_nok > 0):
        addOnBeginNOK = "<a href = \"#Failed_cases\">"
        addOnEndNOK = "</a>"

    addOnBeginWarn = ""
    addOnEndWarn = ""
    if (nb_warn > 0):
        addOnBeginWarn = "<a href = \"#Warning_cases\">"
        addOnEndWarn = "</a>"

    addOnBeginOK = ""
    addOnEndOK = ""
    if (nb_ok > 0):
        addOnBeginOK = "<a href = \"#OK_cases\">"
        addOnEndOK = "</a>"

    statistics += "<li>" + datetime.datetime.now().strftime("%Y-%m-%d at %Hh%M") +"</li>" \
         + "<li>" + str(os.path.abspath(firstDirectory)) +"</li>"   \
         + "<li>" + str(os.path.abspath(secondDirectory)) + "</li>" \
         + "<li>" + addOnBeginOK + str(nb_ok) + "/" + str(nb_cases) + addOnEndOK + "</li>" \
         + "<li>" + addOnBeginWarn + str(nb_warn) + "/" + str(nb_cases) + addOnEndWarn + "</li>" \
         + "<li>" + addOnBeginNOK + str(nb_nok) + "/" + str(nb_cases) + addOnEndNOK + "</li>" \
         + "<li>" + timeToString(totalTime) + "</li>" \
         + "</ul></aside>\n"
    file.write(statistics)

    # Write OK table
    if nb_ok > 0:
        writeOKTable(file)
    # Write WARN table
    if nb_warn > 0:
        writeWARNTable(file)
    # Write NOK table
    if nb_nok > 0:
        writeNOKTable(file)

    file.write("</section>")

##
# Write table of OK cases
# @param file : html file
def writeOKTable(file):
    file.write('<h3 id="OK_cases">Proper cases</h3>')
    file.write("<table><tr><th>Test case</th><th>Directory</th><th>Name</th><th>Status</th></tr>")

    for test_case in listCases:
        if test_case.ok_:
            line ='<tr><td>'
            line += '<a href="#' + test_case.case_ + '">' + test_case.case_ + "</a><td>" + test_case.directory_
            line += "</td><td>" + test_case.name_ + "</td><td class='ok'>OK</td></tr>"
            file.write(line)
    file.write("</table>")
    file.write('<ul><a href="#resume">Back to resume</a></ul>')

##
# Write table of cases with warnings
# @param file : html file
def writeWARNTable(file):
    file.write('<h3 id="Warning_cases">Cases with warnings</h3>')
    file.write("<table><tr><th>Test case</th><th>Directory</th><th>Name</th><th>Number of compared files</th><th>Status</th><th>Number of files with differences</th></tr>")

    for test_case in listCases:
        if test_case.warning_ and not test_case.error_:
            line ='<tr><td>'
            line += '<a href="#' + test_case.case_ + '">' + test_case.case_ + "</a><td>" + test_case.directory_ + "</td><td>" + test_case.name_
            line += "</td><td class='code'>" + str(test_case.number_of_files_) + "</td><td class='warn'>WARN</td><td class='code'>" + str(test_case.number_of_files_withDiff_) + "</td></tr>"
            file.write(line)
    file.write("</table>")
    file.write('<ul><a href="#resume">Back to resume</a></ul>')

##
# Write table of cases with errors
# @param file : html file
def writeNOKTable(file):
    file.write('<h3 id="Failed_cases">Failed cases</h3>')
    file.write("<table><tr><th>Test case</th><th>Directory</th><th>Name</th><th>Number of compared files</th><th>Status</th><th>Number of files with differences</th></tr>")

    for test_case in listCases:
        if test_case.error_:
            line ='<tr><td>'
            line += '<a href="#' + test_case.case_ + '">' + test_case.case_ + "</a><td>" + test_case.directory_ + "</td><td>" + test_case.name_
            line += "</td><td class='code'>" + str(test_case.number_of_files_) + "</td><td class='nok'>NOK</td><td class='code'>" + str(test_case.number_of_files_withDiff_) + "</td></tr>"
            file.write(line)
    file.write("</table>")
    file.write('<ul><a href="#resume">Back to resume</a></ul>')

##
# Write details of NRT diff results
# @param file : html file
# @param output_dir : output directory
# @param html_output : path of html result file
def writeDetails(file, output_dir, html_output):
    file.write("<section>")
    file.write("<h2>Details by test case</h2>")
    for test_case in listCases:
        writeDetailsCase(file, test_case, output_dir, html_output)
    file.write("</section>")

##
# Write details of NRT test case diff results
# @param file : html file
# @param test_case : NRT test case
# @param output_dir : output directory
# @param html_output : path of html result file
def writeDetailsCase(file, test_case, output_dir, html_output):
    file.write('<h3 id="' + test_case.case_ + '">' + test_case.case_ + "</h3>")
    file.write("<table><tr><th>Properties</th><th>value</th></tr>")
    file.write("<tr><td>Directory</td><td>" + test_case.directory_ + "</td></tr>")
    file.write("<tr><td>Name</td><td>" + test_case.name_ + "</td></tr>")
    file.write("<tr><td>Description</td><td>" + test_case.description_ + "</td></tr>")
    line = "<tr><td>Diff status</td>"
    if( test_case.ok_ ):
        line += "<td class='ok'>OK</td></tr>"
    elif test_case.error_:
        line += "<td class='nok'>NOK</td></tr>"
    elif test_case.warning_:
        line += "<td class='warn'>WARN</td></tr>"
    file.write(line)

    if test_case.diff_message_ != "":
        file.write("<tr><td>Diff message</td><td>" + test_case.diff_message_ + "</td></tr>")
    file.write("</table>")

    diff_ok = diff_ok_statuses (False)
    diff_warn = diff_warn_statuses ()
    diff_error = diff_error_statuses (False)

    if test_case.number_of_files_ != 0 :
        file.write("<table><tr><th>Directory</th><th>Left Side</th><th>Right Side</th><th>Diff Status</th><th>Message</th></tr>")
        for logFile in test_case.compared_files_:
            log_relative_dir = os.path.dirname(logFile.name_)
            file_name, file_extension = os.path.splitext(os.path.basename(logFile.name_))
            temp = log_relative_dir.split(os.sep)
            line = "<tr><td>" + log_relative_dir + "</td>"
            # create left side output
            if os.path.isfile(logFile.left_path_):
                leftSide_log_output_dir = os.path.join(output_dir,test_case.case_,'leftSide')
                if not os.path.isdir(leftSide_log_output_dir):
                    os.mkdir(leftSide_log_output_dir)
                for item in temp:
                    leftSide_log_output_dir = os.path.join(leftSide_log_output_dir,item)
                    if not os.path.isdir(leftSide_log_output_dir):
                        os.mkdir(leftSide_log_output_dir)
                path_left_out = os.path.join(leftSide_log_output_dir,os.path.basename(logFile.left_path_))
                rel_path_left_out = os.path.relpath(path_left_out,os.path.dirname(html_output))
                if file_extension == '.log' and file_name != "timeline" and file_name != "constraints":
                    update_one_log_file (logFile.left_path_, path_left_out)
                else:
                    shutil.copy(logFile.left_path_, leftSide_log_output_dir)
                line +=  '<td><a href="' + rel_path_left_out + '" target="_blank">'+str(os.path.basename(logFile.name_))+"</a></td>"
            else:
                line += '<td></td>'
            # create right side output
            if os.path.isfile(logFile.right_path_):
                rightSide_log_output_dir = os.path.join(output_dir,test_case.case_,'rightSide')
                if not os.path.isdir(rightSide_log_output_dir):
                    os.mkdir(rightSide_log_output_dir)
                for item in temp:
                    rightSide_log_output_dir = os.path.join(rightSide_log_output_dir,item)
                    if not os.path.isdir(rightSide_log_output_dir):
                        os.mkdir(rightSide_log_output_dir)
                path_right_out = os.path.join(rightSide_log_output_dir,os.path.basename(logFile.right_path_))
                rel_path_right_out = os.path.relpath(path_right_out,os.path.dirname(html_output))
                if file_extension == '.log' and file_name != "timeline" and file_name != "constraints":
                    update_one_log_file (logFile.right_path_, path_right_out)
                else:
                    shutil.copy(logFile.right_path_, rightSide_log_output_dir)
                line +=  '<td><a href="' + rel_path_right_out + '" target="_blank">'+str(os.path.basename(logFile.name_))+"</a></td>"
            else:
                line += '<td></td>'

            if (logFile.diff_status_ not in diff_neutral_statuses()):
                line += "<td class='"
                if (logFile.diff_status_ in diff_error):
                    line += "comparisonNOk"
                elif (logFile.diff_status_ in diff_warn):
                    line += "comparisonWarn"
                elif (logFile.diff_status_ in diff_ok):
                    line += "comparisonOk"
                line += "'>"
            else:
                line += '<td>'
            line += toString(logFile.diff_status_,False) + '<td>' + logFile.diff_message_
            if sys.platform.startswith('linux'):
                try:
                    command = ""
                    if (logFile.diff_status_ in diff_error) or (logFile.diff_status_ in diff_warn):
                        if  os.path.isfile(logFile.left_path_) and os.path.isfile(logFile.right_path_):
                            diff_file = os.path.join(leftSide_log_output_dir, file_name + '_Diff.txt')
                            command = "diff " +  path_left_out + " " + path_right_out + " > " + diff_file
                            os.system(command)
                            line += '<a href="' + os.path.relpath(diff_file,os.path.dirname(html_output)) \
                                    + '" target="_blank"> See diff </a>'
                except:
                    pass

            line +='</td></tr>'
            file.write(line)

        file.write("</table>")

    file.write('<ul></ul>')
    file.write('<ul><a href="#resume">Back to resume</a></ul>')


# the main function, usually called for standard diffs
if __name__ == "__main__":
    main()
