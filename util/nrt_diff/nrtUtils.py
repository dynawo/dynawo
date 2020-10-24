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
import time
import subprocess
import signal
from xml.dom import minidom
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
            doc = minidom.parse(self.jobs_file_)
            jobs_root = doc.documentElement
        except:
            printout("Fail to import XML file " + self.jobs_file_ + os.linesep, BLACK)
            sys.exit(1)

        #----------------------------------------------#
        #        Get needed info to generate           #
        #            the output report.                #
        # ---------------------------------------------#

        # Go through every jobs file
        job_num = 0
        for job in jobs_root.getElementsByTagNameNS(jobs_root.namespaceURI, 'job'):

            current_job = Job()
            # Create ID
            current_job.job_ = "job_" + str(job_num)
            current_job.file_ = self.jobs_file_

            # Get names
            if (not job.hasAttribute('name')):
                printout("Fail to generate NRT : jobs without name " + os.linesep, BLACK)
                sys.exit(1)
            current_job.name_ = job.getAttribute("name")

            # Get solver
            for solver in job.getElementsByTagNameNS(jobs_root.namespaceURI, "solver"):
                libSolver = solver.getAttribute("lib")
                if libSolver == "dynawo_SolverSIM":
                    current_job.solver_="Solver SIM"
                else:
                    current_job.solver_="Solver IDA"
                if solver.hasAttribute("parFile") and not os.path.join(os.path.dirname(self.jobs_file_), solver.getAttribute("parFile")) in current_job.par_files_:
                    current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), solver.getAttribute("parFile")))
                for iidm in job.getElementsByTagNameNS(jobs_root.namespaceURI, "network"):
                    if iidm.hasAttribute("parFile") and not os.path.join(os.path.dirname(self.jobs_file_), iidm.getAttribute("parFile")) in current_job.par_files_:
                        current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), iidm.getAttribute("parFile")))

            # Get dyd files
            for modeler in job.getElementsByTagNameNS(jobs_root.namespaceURI, "modeler"):
                if (modeler.hasAttribute('compileDir')):
                    current_job.compilation_dir_ = os.path.join(os.path.dirname(self.jobs_file_), modeler.getAttribute("compileDir"))
                for dynModels in modeler.getElementsByTagNameNS(jobs_root.namespaceURI, "dynModels"):
                    current_job.dyd_files_.append(os.path.join(os.path.dirname(self.jobs_file_), dynModels.getAttribute("dydFile")))

            # Get their outputs
            for outputs in job.getElementsByTagNameNS(jobs_root.namespaceURI, "outputs"):
                if (not outputs.hasAttribute('directory')):
                    printout("Fail to generate NRT : outputs directory is missing in jobs file " + current_job.name_ + os.linesep, BLACK)
                    sys.exit(1)
                outputsDir = outputs.getAttribute("directory")
                current_job.output_dir_ = os.path.join(os.path.dirname(self.jobs_file_), outputsDir)

                # constraints
                for constraints in outputs.getElementsByTagNameNS(jobs_root.namespaceURI, "constraints"):

                    if (not constraints.hasAttribute('exportMode')):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : a constraints element does not have an export mode " + os.linesep, BLACK)
                        sys.exit(1)

                    if(constraints.getAttribute("exportMode") == "XML"):
                        fileConstraints = os.path.join(current_job.output_dir_, "constraints", "constraints.xml" )
                        if os.path.isfile(fileConstraints):
                            os.remove(fileConstraints)
                        current_job.constraints_ = fileConstraints
                    elif(constraints.getAttribute("exportMode") == "TXT"):
                        fileConstraints = os.path.join(current_job.output_dir_, "constraints", "constraints.log" )
                        if os.path.isfile(fileConstraints):
                            os.remove(fileConstraints)
                        current_job.constraints_ = fileConstraints


                # timeline
                for timeline in outputs.getElementsByTagNameNS(jobs_root.namespaceURI, "timeline"):

                    if (not timeline.hasAttribute('exportMode')):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : a timeline element does not have an export mode " + os.linesep, BLACK)
                        sys.exit(1)

                    if(timeline.getAttribute("exportMode") == "CSV"):
                        fileTimeline = os.path.join(current_job.output_dir_, "timeLine", "timeline.csv" )
                        if os.path.isfile(fileTimeline):
                            os.remove(fileTimeline)
                        current_job.timeline_ = fileTimeline
                    elif(timeline.getAttribute("exportMode") == "XML"):
                        fileTimeline = os.path.join(current_job.output_dir_, "timeLine", "timeline.xml" )
                        if os.path.isfile(fileTimeline):
                            os.remove(fileTimeline)
                        current_job.timeline_ = fileTimeline
                    elif(timeline.getAttribute("exportMode") == "TXT"):
                        fileTimeline = os.path.join(current_job.output_dir_, "timeLine", "timeline.log" )
                        if os.path.isfile(fileTimeline):
                            os.remove(fileTimeline)
                        current_job.timeline_ = fileTimeline


                # curves
                for curves in outputs.getElementsByTagNameNS(jobs_root.namespaceURI, "curves"):

                    if (not curves.hasAttribute('exportMode')):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : a curve element does not have an export mode " + os.linesep, BLACK)
                        sys.exit(1)

                    current_job.curves_files_.append(os.path.join(os.path.dirname(self.jobs_file_), curves.getAttribute("inputFile")))
                    if(curves.getAttribute("exportMode") == "CSV"):
                        fileCurves = os.path.join(current_job.output_dir_, "curves", "curves.csv" )
                        if os.path.isfile(fileCurves):
                            os.remove(fileCurves)
                        current_job.curves_ = fileCurves
                        current_job.curvesType_ = CURVES_TYPE_CSV
                    elif(curves.getAttribute("exportMode") == "XML"):
                        fileCurves = os.path.join(current_job.output_dir_, "curves", "curves.xml" )
                        if os.path.isfile(fileCurves):
                            os.remove(fileCurves)
                        current_job.curves_ = fileCurves
                        current_job.curvesType_ = CURVES_TYPE_XML

                # logs
                for appender in outputs.getElementsByTagNameNS(jobs_root.namespaceURI, "appender"):
                    if (not appender.hasAttribute('file')):
                        printout("Fail to generate NRT for " + current_job.name_ + "(file = "+current_job.file_+") : an appender of output is not an attribut in file " + os.linesep, BLACK)
                        sys.exit(1)
                    fileAppender = os.path.join(current_job.output_dir_, "logs", appender.getAttribute("file"))
                    if os.path.isfile(fileAppender):
                        os.remove(fileAppender)
                    current_job.appenders_.append(fileAppender)

            # Parse dyd files file
            for dyd_file in current_job.dyd_files_:
                try:
                    doc = minidom.parse(dyd_file)
                    dyd_root = doc.documentElement
                except:
                    printout("Fail to import XML file " + dyd_file + os.linesep, BLACK)
                    sys.exit(1)
                for item in dyd_root.getElementsByTagNameNS(dyd_root.namespaceURI, "blackBoxModel"):
                    if item.hasAttribute("parFile") and os.path.join(os.path.dirname(self.jobs_file_), item.getAttribute("parFile")) not in current_job.par_files_:
                        current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), item.getAttribute("parFile")))
                for item in dyd_root.getElementsByTagNameNS(dyd_root.namespaceURI, "modelTemplateExpansion"):
                    if item.hasAttribute("parFile") and os.path.join(os.path.dirname(self.jobs_file_), item.getAttribute("parFile")) not in current_job.par_files_:
                        current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), item.getAttribute("parFile")))
                for item in dyd_root.getElementsByTagNameNS(dyd_root.namespaceURI, "unitDynamicModel"):
                    if item.hasAttribute("parFile") and os.path.join(os.path.dirname(self.jobs_file_), item.getAttribute("parFile")) not in current_job.par_files_:
                        current_job.par_files_.append(os.path.join(os.path.dirname(self.jobs_file_), item.getAttribute("parFile")))

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
