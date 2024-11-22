# -*- coding: utf-8 -*-

# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
import sys
import time
import subprocess
import signal
from XMLUtils import FindAll, ImportXMLFileExtended
import nrtDiff

CURVES_TYPE_XML = 1
CURVES_TYPE_CSV = 2


class Alarm(Exception):
    pass

##
# Raise an alarm
def alarm_handler(signum, frame):
    raise Alarm

class Job:
    def __init__(self):
        self.name_ = ""
        self.description_ = ""
        self.appenders_ = []
        self.curves_ = None
        self.curvesType_ = None
        self.timeline_ = None
        self.constraints_ = None
        self.solver_ = ""
        self.hasCurves_ = False
        self.job_ = ""
        self.file_ =""
        self.output_dir_ =""
        self.compilation_dir_ =""
        self.dyd_files_ =[]
        self.curves_files_ =[]
        self.par_files_ =[]

class TestCase:
    def __init__(self, case, case_name, case_description, jobs_file, estimated_computation_time, return_code_type, expected_return_codes):
        self.case_ = case
        self.jobs_file_ = jobs_file
        self.estimated_computation_time_ = estimated_computation_time # rough computation time estimate (in s) in order to sort test cases
        self.time_ = 0
        self.code_ = 0
        self.ok_ = True
        self.outputs = ''
        self.errors = ''
        self.tooLong_ = False
        self.command_ = ""
        self.name_ = case_name
        self.description_ = case_description
        self.jobs_ = []
        self.return_code_type_ = return_code_type # ALLOWED or FORBIDDEN
        self.process_return_codes_ = expected_return_codes
        self.diff_ = None
        self.diff_messages_ = None
        if (os.path.isfile (self.jobs_file_)):
            self.parseJobsFile()

    def parseJobsFile(self):
        # Parse jobs file
        try:
            (jobs_root, ns, prefix) = ImportXMLFileExtended(self.jobs_file_)
        except:
            printout("Fail to import XML file " + self.jobs_file_ + os.linesep, BLACK)
            sys.exit(1)

        #----------------------------------------------#
        #        Get needed info to generate           #
        #            the output report.                #
        # ---------------------------------------------#

        # Go through every jobs file
        job_num = 0
        for job in FindAll(jobs_root, prefix, "job", ns):

            current_job = Job()
            # Create ID
            current_job.job_ = "job_" + str(job_num)
            current_job.file_ = self.jobs_file_

            # Get names
            if ('name' not in job.attrib):
                printout("Fail to generate NRT : jobs without name " + os.linesep, BLACK)
                sys.exit(1)
            current_job.name_ = job.attrib["name"]

            # Get solver
            for solver in FindAll(job, prefix, "solver", ns):
                libSolver = solver.attrib["lib"]
                if libSolver == "dynawo_SolverSIM":
                    current_job.solver_="Solver SIM"
                elif libSolver == "dynawo_SolverTRAP":
                    current_job.solver_="Solver TRAP"
                elif libSolver == "dynawo_SolverIDA":
                    current_job.solver_="Solver IDA"
                else:
                    print(libSolver + " not supported")
                    sys.exit(1)
                if "parFile" in solver.attrib and not os.path.join(os.path.dirname(self.jobs_file_), solver.attrib["parFile"]) in current_job.par_files_:
                    current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), solver.attrib["parFile"]))

            for iidm in FindAll(job, prefix, "network", ns):
                if "parFile" in iidm.attrib and not os.path.join(os.path.dirname(self.jobs_file_), iidm.attrib["parFile"]) in current_job.par_files_:
                    current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), iidm.attrib["parFile"]))

            # Get dyd files
            for modeler in FindAll(job, prefix, "modeler", ns):
                if ('compileDir' in modeler.attrib):
                    current_job.compilation_dir_ = os.path.join(os.path.dirname(self.jobs_file_), modeler.attrib["compileDir"])
                for dynModels in FindAll(modeler, prefix, "dynModels", ns):
                    current_job.dyd_files_.append(os.path.join(os.path.dirname(self.jobs_file_), dynModels.attrib["dydFile"]))

            # Get their outputs
            for outputs in FindAll(job, prefix, "outputs", ns):
                if ('directory' not in outputs.attrib):
                    printout("Fail to generate NRT : outputs directory is missing in jobs file " + current_job.name_ + os.linesep, BLACK)
                    sys.exit(1)
                outputsDir = outputs.attrib["directory"]
                current_job.output_dir_ = os.path.join(os.path.dirname(self.jobs_file_), outputsDir)

                # constraints
                for constraints in FindAll(outputs, prefix, "constraints", ns):

                    if ('exportMode' not in constraints.attrib):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : a constraints element does not have an export mode " + os.linesep, BLACK)
                        sys.exit(1)

                    if(constraints.attrib["exportMode"] == "XML"):
                        fileConstraints = os.path.join(current_job.output_dir_, "constraints", "constraints.xml" )
                        if os.path.isfile(fileConstraints):
                            os.remove(fileConstraints)
                        current_job.constraints_ = fileConstraints
                    elif(constraints.attrib["exportMode"] == "TXT"):
                        fileConstraints = os.path.join(current_job.output_dir_, "constraints", "constraints.log" )
                        if os.path.isfile(fileConstraints):
                            os.remove(fileConstraints)
                        current_job.constraints_ = fileConstraints


                # timeline
                for timeline in FindAll(outputs, prefix, "timeline", ns):

                    if ('exportMode' not in timeline.attrib):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : a timeline element does not have an export mode " + os.linesep, BLACK)
                        sys.exit(1)

                    if(timeline.attrib["exportMode"] == "CSV"):
                        fileTimeline = os.path.join(current_job.output_dir_, "timeLine", "timeline.csv" )
                        if os.path.isfile(fileTimeline):
                            os.remove(fileTimeline)
                        current_job.timeline_ = fileTimeline
                    elif(timeline.attrib["exportMode"] == "XML"):
                        fileTimeline = os.path.join(current_job.output_dir_, "timeLine", "timeline.xml" )
                        if os.path.isfile(fileTimeline):
                            os.remove(fileTimeline)
                        current_job.timeline_ = fileTimeline
                    elif(timeline.attrib["exportMode"] == "TXT"):
                        fileTimeline = os.path.join(current_job.output_dir_, "timeLine", "timeline.log" )
                        if os.path.isfile(fileTimeline):
                            os.remove(fileTimeline)
                        current_job.timeline_ = fileTimeline


                # curves
                for curves in FindAll(outputs, prefix, "curves", ns):

                    if ('exportMode' not in curves.attrib):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : a curve element does not have an export mode " + os.linesep, BLACK)
                        sys.exit(1)

                    current_job.curves_files_.append(os.path.join(os.path.dirname(self.jobs_file_), curves.attrib["inputFile"]))
                    if(curves.attrib["exportMode"] == "CSV"):
                        fileCurves = os.path.join(current_job.output_dir_, "curves", "curves.csv" )
                        if os.path.isfile(fileCurves):
                            os.remove(fileCurves)
                        current_job.curves_ = fileCurves
                        current_job.curvesType_ = CURVES_TYPE_CSV
                    elif(curves.attrib["exportMode"] == "XML"):
                        fileCurves = os.path.join(current_job.output_dir_, "curves", "curves.xml" )
                        if os.path.isfile(fileCurves):
                            os.remove(fileCurves)
                        current_job.curves_ = fileCurves
                        current_job.curvesType_ = CURVES_TYPE_XML

                # logs
                for appender in FindAll(outputs, prefix, "appender", ns):
                    if ('file' not in appender.attrib):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : an appender of output is not an attribut in file " + os.linesep, BLACK)
                        sys.exit(1)
                    fileAppender = os.path.join(current_job.output_dir_, "logs", appender.attrib["file"])
                    if os.path.isfile(fileAppender):
                        os.remove(fileAppender)
                    current_job.appenders_.append(fileAppender)

            # Parse dyd files file
            for dyd_file in current_job.dyd_files_:
                try:
                    (dyd_root, ns_dyd, prefix) = ImportXMLFileExtended(dyd_file)
                except:
                    printout("Fail to import XML file " + dyd_file + os.linesep, BLACK)
                    sys.exit(1)
                for item in FindAll(dyd_root, prefix, "blackBoxModel", ns_dyd):
                    if "parFile" in item.attrib and os.path.join(os.path.dirname(self.jobs_file_), item.attrib["parFile"]) not in current_job.par_files_:
                        current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), item.attrib["parFile"]))
                for item in FindAll(dyd_root, prefix, "modelTemplateExpansion", ns_dyd):
                    if "parFile" in item.attrib and os.path.join(os.path.dirname(self.jobs_file_), item.attrib["parFile"]) not in current_job.par_files_:
                        current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), item.attrib["parFile"]))
                for item in FindAll(dyd_root, prefix, "unitDynamicModel", ns_dyd):
                    if "parFile" in item.attrib and os.path.join(os.path.dirname(self.jobs_file_), item.attrib["parFile"]) not in current_job.par_files_:
                        current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), item.attrib["parFile"]))

            self.jobs_.append(current_job)
            job_num += 1

    def launch(self, timeout):
        start_time = time.time()
        command = []

        if os.getenv("DYNAWO_ENV_DYNAWO") is None:
            print("environment variable DYNAWO_ENV_DYNAWO needs to be defined")
            sys.exit(1)
        env_dynawo = os.environ["DYNAWO_ENV_DYNAWO"]
        command = [env_dynawo, "jobs", self.jobs_file_]

        commandStr = " ".join(command) # for traces
        self.command_= commandStr
        print (self.name_)

        if(timeout > 0):
            signal.signal(signal.SIGALRM, alarm_handler)
            signal.alarm(int(timeout)*60) # in seconds

        code = 0
        output = ''
        errors = ''
        errorTooLong = -150
        p = subprocess.Popen(commandStr, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        try:
            output, errors = p.communicate()
            signal.alarm(0)
            code = p.wait()
        except Alarm:
            kill_subprocess(p.pid)
            code = errorTooLong

        self.code_ = code
        self.outputs_ = output
        self.errors_ = errors
        if code == errorTooLong:
            self.tooLong_ = True
            self.ok_ = False
        else:
            self.tooLong_ = False
            self.ok_ = True
            if (self.return_code_type_ == "FORBIDDEN") and (self.code_ in self.process_return_codes_):
                self.ok_ = False

            if (self.return_code_type_ == "ALLOWED") and (not self.code_ in self.process_return_codes_):
                self.ok_ = False

        end_time = time.time()
        self.time_ = end_time - start_time

        # Conversion from csv to html if curves file csv/xml
        for job in self.jobs_:
            try:
                curvesOutput = os.path.join(os.path.dirname(job.curves_), "curvesOutput")
                if job.curvesType_ == CURVES_TYPE_CSV:
                    readCsvToHtml(job.curves_,curvesOutput,True, False)
                elif job.curvesType_ == CURVES_TYPE_XML:
                    readXmlToHtml(job.curves_,curvesOutput,True, False)
                job.hasCurves_ = True
            except:
                job.hasCurves_ = False
                pass

    ##
    # Check whether a test case led to satisfactory results
    def gives_satisfactory_results(self):
        if not self.ok_:
            return False

        if self.diff_ in nrtDiff.diff_error_statuses (True):
            return False

        return True
