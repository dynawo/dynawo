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

import datetime
import sys
import multiprocessing as mp
from optparse import OptionParser
import os
import re
import shutil
import time
import threading

nrtDiff_dir = os.environ["DYNAWO_NRT_DIFF_DIR"]
sys.path.append(nrtDiff_dir)
import nrtDiff
import nrtUtils

import psutil

##
# Get the process id of the last child of a given process
# @param pid : the id of the parent process
def get_last_child_pid(pid):
    p = psutil.Process(pid)
    child_pid = pid
    for process in p.children (recursive=True):
        print(" process :" + str(process) + " pid =" + str(process.pid))
        child_pid = process.pid
    return child_pid

##
# Kill all subprocesses of a given process
# @param proc_pid : the id of the parent process
def kill_subprocess(proc_pid):
    process = psutil.Process(proc_pid)
    for proc in process.children(recursive=True):
        proc.kill()
    process.kill()

if os.getenv("DYNAWO_NRT_DIR") is None:
    print("environment variable DYNAWO_NRT_DIR needs to be defined")
    sys.exit(1)

if os.getenv("DYNAWO_BRANCH_NAME") is None:
    print("environment variable DYNAWO_BRANCH_NAME needs to be defined")
    sys.exit(1)

if os.getenv("DYNAWO_CURVES_TO_HTML_DIR") is None:
    print("environment variable DYNAWO_CURVES_TO_HTML_DIR needs to be defined")
    sys.exit(1)

# Non-regression tests configuration
resources_dir = os.path.join(os.environ["DYNAWO_NRT_DIR"], "resources")
data_dir = os.path.join(os.environ["DYNAWO_NRT_DIR"], "data")
branch_name = os.environ["DYNAWO_BRANCH_NAME"]
output_dir_all_nrt = os.path.join(os.environ["DYNAWO_NRT_DIR"], "output")
output_dir = os.path.join(os.environ["DYNAWO_NRT_DIR"], "output",branch_name)

# No branch in jenkins mode until now
jenkins_mode = os.getenv("DYNAWO_JENKINS_MODE","NO")
if jenkins_mode == "YES" :
    output_dir = output_dir_all_nrt
html_output = os.path.join(output_dir, "report.html")

# Load custom python modules
csvToHtml_dir = os.path.join(os.environ["DYNAWO_CURVES_TO_HTML_DIR"], "csvToHtml")
sys.path.append(csvToHtml_dir)
from csvToHtml import *

xmlToHtml_dir = os.path.join(os.environ["DYNAWO_CURVES_TO_HTML_DIR"], "xmlToHtml")
sys.path.append(xmlToHtml_dir)
from xmlToHtml import *

###Code to print logs in colour
BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = range(8)

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


def printout(text, colour=WHITE):
        if has_colours:
            seq = "\x1b[1;%dm" % (30+colour) + text + "\x1b[0m"
            sys.stdout.write(seq)
        else:
            sys.stdout.write(text)

#### Code to handle xml parsing
DYN_NAMESPACE = "http://www.rte-france.com/dynawo"

def namespaceDYN(tag):
    return "{" + DYN_NAMESPACE + "}" + tag

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

def boolToString(boolean):
    if boolean:
        return "True"
    else:
        return "False"

class KeyboardInterruptError(Exception): pass

##
# Run a given non-regression test
# @param index : the test-case index (order when it will be run among all test cases)
# @param nbCases : the total number of test cases to be run
# @param case : the test-case object
# @param timeout : the run timeout, in seconds
def launchOneCase(index, nbCases, case, timeout):
    try:
        toPrint = '[{0:>3}/{1:<3}]'.format(index, nbCases-1)
        printout(str(toPrint), RED)
        case.launch(timeout)
        return case
    except KeyboardInterrupt:
        raise KeyboardInterruptError()

class NonRegressionTest:
    def __init__(self,timeout):
        self.test_cases_ = []
        self.total_time_ = 0
        self.number_of_cases_ = 0
        self.number_of_nok_cases_= 0
        self.number_of_tooLong_cases_= 0
        self.real_time_ = 0
        self.nb_processors_used_ = int(os.getenv("DYNAWO_NB_PROCESSORS_USED"))
        self.timeout = timeout

    def clear(self,html_output):
        if os.path.isfile(html_output):
            os.remove(html_output)

    def setRealTime(self,time):
        self.real_time_ = time

    def addTestCase(self, test_case):
        self.test_cases_.append(test_case)


    def launchCases(self):
        nbCases = len(self.test_cases_)
        pool = mp.Pool(processes=self.nb_processors_used_)
        # sort test cases according to decreasing computation time
        #(to decrease overall computation time when running NRT in parallel)
        sorted_test_cases = sorted(self.test_cases_, key=lambda x: x.estimated_computation_time_, reverse=True)
        # change num case according to the new order
        index = 0
        for test_case in sorted_test_cases:
            test_case.case_ = 'case_' + str(index)
            index = index + 1

        # launch cases
        try:
            results = [pool.apply_async(launchOneCase, args=(index + 1, nbCases + 1, sorted_test_cases[index], self.timeout)) for index in range(nbCases)]
            index = 0
            for r in results:
                self.test_cases_[index] = r.get()
                index = index + 1
            pool.close()
            # sort the test cases according to case_name in order to restore the initial cases order
            self.test_cases_.sort(key=lambda x: x.name_.lower())
        except  KeyboardInterrupt:
            pool.terminate()
            raise KeyboardInterruptError()


    def exportHTML(self, html_output):
        # Write html file
        file = open(html_output, 'w')
        self.writeHeader(file)
        #Statistics analysis
        for test_case in self.test_cases_:
            self.total_time_ = self.total_time_+test_case.time_
            self.number_of_cases_ += 1
            if test_case.tooLong_:
                self.number_of_tooLong_cases_ +=1
            else:
                if not test_case.gives_satisfactory_results():
                    self.number_of_nok_cases_ +=1
        #Create a repository for each testcase resources
        for test_case in self.test_cases_:
            os.mkdir(os.path.join(output_dir,test_case.case_))
        self.writeResume(file)
        self.writeDetails(file)
        self.writeFooter(file)

    def writeResume(self, file):
        file.write("<section>")
        file.write('<h2 id="resume">Resume</h2>')
        self.writeInformation(file)
        self.writeStatistics(file)
        if (self.number_of_cases_ -  self.number_of_nok_cases_ - self.number_of_tooLong_cases_) > 0:
            self.writeOKTable(file)
        if self.number_of_nok_cases_ > 0 :
            self.writeNOKTable(file)
        if self.number_of_tooLong_cases_ > 0:
            self.writeTooLongTable(file)
        file.write("</section>")

    def writeDetails(self, file):
        file.write("<section>")
        file.write("<h2>Details by test case</h2>")
        for test_case in self.test_cases_:
            self.writeDetailsCase(file, test_case)
        file.write("</section>")


    def writeCaseSummaryLine (self, test_case, file):
        diff_ok = nrtDiff.diff_ok_statuses (True)
        diff_warn = nrtDiff.diff_warn_statuses ()
        diff_error = nrtDiff.diff_error_statuses (True)

        status_cell = ""
        if test_case.gives_satisfactory_results():
            status_cell = "<td class='ok'>OK</td>"
        elif test_case.code_ == -150:
            status_cell = "<td class='tooLong'>TOO LONG</td>"
        else:
            status_cell = "<td class='nok'>NOK</td>"

        line ='<tr><td>'
        line += '<a href="#' + test_case.case_ + '">' + test_case.case_ + "</a><td>" + test_case.name_
        line += "</td><td class='simuTime'>%s</td>" % timeToString(test_case.time_) + status_cell + "<td class='code'>" + str(test_case.code_) + "</td>"

        #reference data
        line += "<td class='"

        if (test_case.diff_ in diff_error):
            line += "comparisonNOk"
        elif (test_case.diff_ in diff_warn):
            line += "comparisonWarn"
        elif (test_case.diff_ in diff_ok):
            line += "comparisonOk"
        else:
            line += "noComparison"

        line += "'>"
        line += nrtDiff.toString(test_case.diff_, True)
        line += "</td></tr>"
        file.write(line)

    def writeOKTable(self, file):
        file.write('<h3 id="Proper_cases">Proper cases</h3>')
        file.write("<table><tr><th>Test case</th><th>Name</th><th>Simulation time</th><th>Status</th><th>Return Code</th><th>Results</th></tr>")

        for test_case in self.test_cases_:
            if test_case.gives_satisfactory_results():
                self.writeCaseSummaryLine (test_case, file)
        file.write("</table>")

    def writeNOKTable(self,file):
        file.write('<h3 id="Failed_cases">Failed cases</h3>')
        file.write("<table><tr><th>Test case</th><th>Name</th><th>Simulation time</th><th>Status</th><th>Return Code</th><th>Results</th></tr>")

        for test_case in self.test_cases_:
            if (not test_case.gives_satisfactory_results()) and (test_case.code_ != -150):
                self.writeCaseSummaryLine (test_case, file)
        file.write("</table>")

    def writeTooLongTable(self,file):
        file.write('<h3 id="TooLong_cases">Too Long cases</h3>')
        file.write("<table><tr><th>Test case</th><th>Name</th><th>Simulation time</th><th>Status</th><th>Return Code</th></tr>")

        for test_case in self.test_cases_:
            if (not test_case.ok_) and (test_case.code_ == -150):
                self.writeCaseSummaryLine (test_case, file)
        file.write("</table>")

    def writeDetailsCase(self, file, test_case):
        file.write('<h3 id="' + test_case.case_ + '">' + test_case.case_ + "</h3>")
        file.write("<table><tr><th>Properties</th><th>value</th></tr>")
        file.write("<tr><td>Name</td><td>"+test_case.name_+"</td></tr>")
        file.write("<tr><td>Description</td><td>"+test_case.description_+"</td></tr>")
        file.write("<tr><td>simulation time</td><td>"+timeToString(test_case.time_)+"</td></tr>")
        file.write("<tr><td>return code</td><td>"+str(test_case.code_)+"</td></tr>")
        line = "<tr><td>return status</td>"
        testcase_status = "OK"
        if( test_case.ok_ ):
            line += "<td class='ok'>OK</td></tr>"
        elif test_case.code_ == -150:
            line += "<td class='tooLong'>TOO LONG</td></tr>"
            testcase_status = "tooLong"
        else:
            line += "<td class='nok'>NOK<br />Dynawo simulation failed.</td></tr>"
            testcase_status = "KO"
        file.write(line)

        diff_status = "NoReference"
        if (test_case.diff_ not in nrtDiff.diff_neutral_statuses()):
            diff_ok = nrtDiff.diff_ok_statuses (True)
            diff_warn = nrtDiff.diff_warn_statuses ()
            diff_error = nrtDiff.diff_error_statuses (True)
            line = "<tr><td>diff status</td><td class='"
            if (test_case.diff_ in diff_error):
                line += "comparisonNOk"
                diff_status = "KO"
            elif (test_case.diff_ in diff_warn):
                line += "comparisonWarn"
                diff_status = "Warn"
            elif (test_case.diff_ in diff_ok):
                line += "comparisonOk"
                diff_status = "OK"
            line += "'>" + nrtDiff.toString(test_case.diff_, True)
            if not (test_case.diff_ in diff_ok):
                if len(test_case.diff_messages_) > 0: line += "<br/><br/>"
                for message in test_case.diff_messages_:
                    line += message + "<br/>"
            line += "</td></tr>"
            file.write(line)

        file.write("</table>")

        for job in test_case.jobs_:
            job_relative_dir = test_case.case_ + "/" + job.job_
            job_output_dir = os.path.join(output_dir,job_relative_dir)
            file.write("<table><tr><th>Properties</th><th>value</th></tr>")
            file.write("<tr><td>Name</td><td>"+job.name_+"</td></tr>")
            file.write("<tr><td>Description</td><td>"+job.description_+"</td></tr>")
            file.write("<tr><td>Solver Used</td><td>"+job.solver_+"</td></tr>")
            # copy all tree of outputs
            if os.path.isdir(job.output_dir_):
                shutil.copytree(job.output_dir_, job_output_dir)
            else:
                os.mkdir(job_output_dir)
            if job.timeline_ != None:
                basename = os.path.basename(job.timeline_)
                if os.path.isfile(job.timeline_):
                    if os.path.getsize(job.timeline_) > 0:
                        file.write('<tr><td>timeline</td><td><a href="'+job_relative_dir+"/timeLine/"+basename+'" target="_blank">'+basename+"</a></td></tr>")
                    else:
                        file.write('<tr><td>timeline</td><td>no event</td></tr>')
            if job.constraints_ != None:
                basename = os.path.basename(job.constraints_)
                if os.path.isfile(job.constraints_):
                    if os.path.getsize(job.constraints_) > 0:
                        file.write('<tr><td>constraints</td><td><a href="'+job_relative_dir+"/constraints/"+basename+'" target="_blank">'+basename+"</a></td></tr>")
                    else:
                        file.write('<tr><td>constraints</td><td>'+basename+" (zero constraints)</a></td></tr>")

            for app in job.appenders_:
                basename = os.path.basename(app)
                if os.path.isfile(app):
                    file.write('<tr><td>log file</td><td><a href="'+job_relative_dir+"/logs/"+basename+'" target="_blank">'+basename+"</a></td></tr>")

            if job.hasCurves_:
                curvesOutput = os.path.join(os.path.dirname(job.curves_),"curvesOutput")
                curvesOutputCopyDir = os.path.join(job_output_dir,"curvesOutput")
                if os.path.isdir(curvesOutput):
                    file.write('<tr><td>curves output</td><td><a href="'+job_relative_dir+"/curves/curvesOutput/curves.html"+'" target="_blank">'+"curves.html"+'</a></td></tr>')
            file.write("</table>")
            # write job identification info into a text file
            info_file_path = os.path.join(job_output_dir,'info.txt')
            if (os.path.isfile(info_file_path)):
                os.remove(info_file_path)
            info_file = open(info_file_path, "w")
            case_dir = os.path.relpath (os.path.dirname (job.file_), data_dir)
            path_list = case_dir.split(os.sep)
            if len(path_list) > 1:
                case_first_dir= case_dir.split(os.sep)[0]
                case_second_dir = case_dir.split(os.sep)[1]
            else:
                case_first_dir = ""
                case_second_dir = case_dir.split(os.sep)[0]
            # first line: job identification infos
            info_file.write(case_first_dir + '|' + case_second_dir + '|' + job.name_ + '|' + job.description_ + \
                            '|' + testcase_status + '|' + diff_status +'\n')
            # second line : path to jobs file
            info_file.write(job.file_)
            info_file.close()
        file.write('<ul></ul>')
        file.write("<aside><h1>case command:</h1><ul>"+test_case.command_+"</ul></aside>\n")
        file.write('<ul><a href="#resume">Back to resume</a></ul>')
    def writeFooter(self,file):
        file.write("""
      </div>
    </body>
</html>""")

    def writeHeader(self,file):
        file.write("""<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <link rel="stylesheet" href="resources/report.css" />
        <title>Dynawo non-regression tests</title>
    </head>
    <body>
      <div id="page_bloc">
        <header>
          <h1>Dynawo non-regression tests</h1>
        </header>\n""")

    def writeInformation(self, file):
        file.write("<aside style=\"margin-bottom:5px;margin-top:0px;\"><h1 style=\"margin-bottom:0px;margin-top:5px;\">Information</h1><ul style=\"margin-bottom:5px;margin-top:2px;\"><li>Left: normal output folder</li><li>Right: reference folder</li></ul></aside>\n")

    def writeStatistics(self, file):
        diff_error = nrtDiff.diff_error_statuses (True)
        nb_diff_failed = 0
        nb_diff = 0
        no_diff = nrtDiff.diff_neutral_statuses ()
        for test_case in self.test_cases_:
            if (test_case.diff_ in diff_error):
                nb_diff_failed += 1

            if (test_case.diff_ not in no_diff):
                nb_diff += 1

        statistics = "<aside><h1>Statistics</h1><ul><li>Number of failed cases:</li><li>Number of too long cases:</li>"
        if (nb_diff > 0):
            statistics += "<li>Number of failed results comparisons:</li>"
        statistics += "<li>Complete simulation time(sum of time of each case):</li><li>Non Regression Tests time:</li><li>Number of processors used:</li></ul><ul>"

        addOnBeginFailed = ""
        addOnEndFailed = ""
        if (self.number_of_nok_cases_ > 0):
            addOnBeginFailed = "<a href = \"#Failed_cases\">"
            addOnEndFailed = "</a>"

        addOnBeginTooLong = ""
        addOnEndTooLong = ""
        if (self.number_of_tooLong_cases_ > 0):
            addOnBeginTooLong = "<a href = \"#TooLong_cases\">"
            addOnEndTooLong = "</a>"

        statistics += "<li>" + addOnBeginFailed + str(self.number_of_nok_cases_) + "/" + str(self.number_of_cases_) + addOnEndFailed+"</li>"  \
            + "<li>" + addOnBeginTooLong + str(self.number_of_tooLong_cases_) + "/" + str(self.number_of_cases_) + addOnEndTooLong+"</li>"  \

        if (nb_diff > 0):
            statistics += "<li>" + str(nb_diff_failed) + "/" + str(nb_diff) +"</li>"

        statistics += "<li>" + timeToString(self.total_time_) +"</li>" \
            + "<li>" + timeToString(self.real_time_) + "</li>" \
            + "<li>" + str(self.nb_processors_used_) + "</li>" \
            + "</ul></aside>\n"
        file.write(statistics)

##
# The main function usually called for non-regression tests
def main():
    usage=u""" Usage: %prog

    Script to launch non-regression test
    """

    options = {}
    options[('-t', '--timeout')] = {'dest': 'timeout',
                                    'help': 'Timeout of a NRT (in minutes)'}

    options[('-n', '--name')] = {'dest': 'directory_names', 'action':'append',
                                    'help': 'name filter to only run some non-regression tests'}

    options[('-p', '--pattern')] = {'dest': 'directory_patterns', 'action' : 'append',
                                    'help': 'regular expression filter to only run some non-regression tests'}

    options[('-f', '--failed')] = { 'action' : 'store_true', 'dest': 'failed', 'default':'False',
                                    'help': 'Only run failed non-regression tests'}

    parser = OptionParser(usage)
    for param, option in options.items():
        parser.add_option(*param, **option)
    (options, args) = parser.parse_args()

    global NRT

    log_message = "Running non-regression tests"

    timeout = 0
    if options.timeout is not None and options.timeout > 0:
        timeout = options.timeout
        log_message += " with " + timeout + "s timeout"

    with_directory_name = False
    directory_names = []
    if (options.directory_names is not None) and (len(options.directory_names) > 0):
        with_directory_name = True
        directory_names = options.directory_names
        if (options.timeout is not None and options.timeout > 0):
            log_message += " and"
        else:
            log_message += " with"

        for dir_name in directory_names:
            log_message += " '" + dir_name + "'"

        log_message += " name filter"

    directory_patterns = []
    if (options.directory_patterns is not None) and  (len(options.directory_patterns) > 0):
        directory_patterns = options.directory_patterns
        if (options.timeout is not None and options.timeout > 0) or with_directory_name:
            log_message += " and"
        else:
            log_message += " with"

        for pattern in directory_patterns:
            log_message += " '" + pattern + "'"

        log_message += " pattern filter"

    directory_failed = []
    if (options.failed == True):
        for root, dirs, files in os.walk(output_dir):
            for file in files:
                if "info.txt" == file:
                    test_case = nrtDiff.TestCase("dummy")
                    test_case.get_case_info(os.path.join(root, file))
                    if test_case.status_ == "KO" or test_case.cmp_status_ == "KO":
                        directory_failed.append(test_case.jobs_file_)

        if (len(directory_failed) > 0):
            if (options.timeout is not None and options.timeout > 0) or with_directory_name or ((options.directory_patterns is not None) and  (len(options.directory_patterns) > 0)):
                log_message += " and failed tests filter"
            else:
                log_message += " with failed tests filter"
        else :
            log_message += " No failed tests"

    print (log_message)

    # Create NRT structure
    NRT = NonRegressionTest(timeout)

    # Test whether output repository exists, otherwise create it
    if os.path.isdir(output_dir_all_nrt) == False:
        os.mkdir(output_dir_all_nrt)

    # Outputs repository is deleted and then created
    if os.path.isdir(output_dir) == True:
        shutil.rmtree(output_dir)

    os.makedirs(output_dir)

    # Copy resources in outputs repository
    shutil.copytree(resources_dir, os.path.join(output_dir,"resources"))

    # Delete former results if they exists
    NRT.clear(html_output)

    # Loop on testcases
    numCase = 0
    for case_dir in os.listdir(data_dir):
        case_path = os.path.join(data_dir, case_dir)
        if os.path.isdir(case_path) == True and \
            case_dir != ".svn" : # In order to check that we are dealing with a repository and not a file, .svn repository is filtered

            # Get needed info to build object TestCase
            sys.path.append(case_path)
            try:
                import cases
                sys.path.remove(case_path) # Remove from path because all files share the same name

                for case_name, case_description, job_file, estimated_computation_time, return_code_type, expected_return_codes in cases.test_cases:

                    relative_job_dir = os.path.relpath (os.path.dirname (job_file), data_dir)
                    keep_job = True

                    if (len (directory_names) > 0):
                        for dir_name in directory_names:
                            if (dir_name not in relative_job_dir):
                                keep_job = False
                                break

                    if keep_job and (len (directory_patterns) > 0):
                        for pattern in directory_patterns:
                            if  (re.search(pattern, relative_job_dir) is None):
                                keep_job = False
                                break

                    if keep_job and (len(directory_failed) > 0):
                        if job_file not in directory_failed:
                            keep_job = False

                    if keep_job :
                        case = "case_" + str(numCase)
                        numCase += 1
                        current_test = nrtUtils.TestCase(case, case_name, case_description, job_file, estimated_computation_time, return_code_type, expected_return_codes)
                        NRT.addTestCase(current_test)

                del sys.modules['cases'] # Delete load module in order to load another module with the same name
            except:
                print("Error during loading case path " + case_path)
                pass

    if len (NRT.test_cases_) == 0:
        print('No non-regression tests to run')
        sys.exit()

    try:
        # remove the diff notification file
        NRT_RESULT_FILE = os.path.join(output_dir, "nrt_nok.txt")
        if (os.path.isfile(NRT_RESULT_FILE)):
            try:
                os.remove (NRT_RESULT_FILE)
            except:
                print("Failed to remove notification file. Unable to conduct nrt")
                sys.exit(1)

        start_time = time.time()
        NRT.launchCases()
        end_time = time.time()
        NRT.setRealTime(end_time - start_time)

        maximumNumberOfThreads = int(os.getenv ('DYNAWO_NB_PROCESSORS_USED'))
        threads_list = []
        dir_list = []
        sys.stdout.write("Running references comparison\n")
        semaphore = threading.Semaphore (maximumNumberOfThreads)
        pool = nrtDiff.ActivePool()
        index = 1
        for case in NRT.test_cases_:
            if (not case.ok_):
                case.diff_ = nrtDiff.UNABLE_TO_CHECK
            else:
                case_dir = os.path.dirname (case.jobs_file_)
                if case_dir in dir_list: continue
                dir_list.append(case_dir)
                thread = threading.Thread (target = nrtDiff.DirectoryDiffReferenceDataJobMultiThread, name = case_dir, args = (case, index, len(NRT.test_cases_)+1, semaphore, pool))
                thread.setDaemon(True)
                threads_list.append(thread)
                thread.start()
                index+=1
        #Keep the main thread alive while threads are running and catch interruptions
        try:
            while True in [t.is_alive() for t in threads_list]:
                time.sleep(2)
        except KeyboardInterrupt:
            os._exit()

        for thread in threads_list:
            thread.join()
        results_per_dir = {}
        for case in NRT.test_cases_:
            case_dir = os.path.dirname (case.jobs_file_)
            if case_dir in dir_list and case.diff_messages_ != None :
                results_per_dir[case_dir]=[case.diff_, case.diff_messages_]
        for case in NRT.test_cases_:
            case_dir = os.path.dirname (case.jobs_file_)
            if case.diff_messages_ == None and case_dir in results_per_dir:
                case.diff_ = results_per_dir[case_dir][0]
                case.diff_messages_ = results_per_dir[case_dir][1]

        # Export results as html
        NRT.exportHTML(html_output)
        if( NRT.number_of_nok_cases_ > 0):
            logFile = open(NRT_RESULT_FILE, "w")
            logFile.write("NRT NOK\n")
            logFile.write("Run on " + datetime.datetime.now().strftime("%Y-%m-%d at %Hh%M") + "\n")
            logFile.write(" Nb nok case : " + str(NRT.number_of_nok_cases_) + "\n")
            logFile.close()

        sys.exit(NRT.number_of_nok_cases_)
    except KeyboardInterrupt:
        exit()

if __name__ == "__main__":
    main()
