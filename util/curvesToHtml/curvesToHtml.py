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
import sys
import csv
import shutil
try:
    from lxml import etree
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
                    sys.exit(1)
from optparse import OptionParser
import platform

# Load custom python modules
csvToHtml_dir = os.path.join(os.path.dirname(__file__), "csvToHtml")
sys.path.append(csvToHtml_dir)
from csvToHtml import *

xmlToHtml_dir = os.path.join(os.path.dirname(__file__), "xmlToHtml")
sys.path.append(xmlToHtml_dir)
from xmlToHtml import *

CURVES_TYPE_XML=1
CURVES_TYPE_CSV=2

# XML parsing namespace
DYN_NAMESPACE = "http://www.rte-france.com/dynawo"

def namespaceDYN(tag):
    return "{" + DYN_NAMESPACE + "}" + tag


class JobCurves:
    def __init__(self):
        self.file_ =""
        self.jobName_ = ""
        self.hasCurves_ = False
        self.curvesType_ = None
        self.curves_ = None
        self.referenceCurves_ = None
        self.curvesOutput_ = None

##
# Parse the jobs file and create an HTML interface to visualize curves output for each job
# @param jobs_file : the jobs file
# @param withoutOffset: if true, remove time offset
# @param showpoints: if true show simulation points instead of drawing only line
# @param htmlBrowser : HTML browser to display curves
# @return
def readCurvesToHtml(jobs_file, withoutOffset, showpoints, htmlBrowser, plotRef):
    # parsing the job file
    try:
        jobs_root = etree.parse(jobs_file).getroot()
    except:
        print("Fail to  import XML file: " + jobs_file)
        sys.exit(1)

    #-------------------------------------------------#
    # get the needed informations to dispaly curves   #
    # ------------------------------------------------#

    # parse all jobs in the input file
    htmlFileList=[]
    for job in jobs_root.iter(namespaceDYN("job")):

        current_job = JobCurves()
        current_job.file_ = jobs_file

        # job name
        if (not "name" in job.attrib):
            printout("Fail to display curves : job without name")
            sys.exit(1)
        current_job.jobName_ = job.get("name")

        #job outputs
        for outputs in job.iter(namespaceDYN("outputs")):
            if (not "directory" in outputs.attrib):
                print("Fail to display curves for job < " + current_job.jobName_ + "> : missing outputs directory")
                sys.exit(1)

            # job curves
            for curves in job.iter(namespaceDYN("curves")):

                if (not "exportMode" in curves.attrib):
                    print("Fail to display curves for job <" + current_job.jobName_ + "> : a curves element doesn't have an export mode")
                    sys.exit(1)

                try:
                    print("Generating curves visualization page for job <" + current_job.jobName_ + "> ...")

                    # Conversion from csv to html
                    if(curves.get("exportMode") == "CSV"):
                        fileCurves = os.path.join(os.path.dirname(jobs_file), outputs.get("directory"), "curves", "curves.csv" )
                        refFileCurves = os.path.join(os.path.dirname(jobs_file), "reference", outputs.get("directory"), "curves", "curves.csv" )
                        if os.path.isfile(fileCurves) and (len(open(fileCurves).readlines()) > 1):
                            current_job.curves_ = fileCurves
                            if (plotRef and os.path.isfile(refFileCurves)):
                                current_job.referenceCurves_ = refFileCurves
                            current_job.curvesOutput_ = os.path.join(os.path.dirname(fileCurves),"curvesOutput")
                            current_job.hasCurves_ = True
                            current_job.curvesType_ = CURVES_TYPE_CSV
                            readCsvToHtml(current_job.curves_, current_job.referenceCurves_, current_job.curvesOutput_, withoutOffset, showpoints)
                        else:
                            print("No curves output file found for job " + current_job.jobName_)
                            continue

                    # Conversion from xml to html
                    elif(curves.get("exportMode") == "XML"):
                        fileCurves = os.path.join(os.path.dirname(jobs_file), outputs.get("directory"), "curves", "curves.xml" )
                        refFileCurves = os.path.join(os.path.dirname(jobs_file), "reference", outputs.get("directory"), "curves", "curves.xml" )
                        if os.path.isfile(fileCurves) and (len(open(fileCurves).readlines()) > 1):
                            current_job.curves_ = fileCurves
                            if (plotRef and os.path.isfile(refFileCurves)):
                                current_job.referenceCurves_ = refFileCurves
                            current_job.curvesOutput_ = os.path.join(os.path.dirname(fileCurves),"curvesOutput")
                            current_job.hasCurves_ = True
                            current_job.curvesType_ = CURVES_TYPE_XML
                            readXmlToHtml(current_job.curves_, current_job.referenceCurves_, current_job.curvesOutput_, withoutOffset, showpoints)
                        else:
                            print("No curves output file found for job " + current_job.jobName_)
                            continue

                    # output html file
                    htmlFilePath = os.path.join(current_job.curvesOutput_,"curves.html")
                    if not os.path.isfile(htmlFilePath):
                        print("No HTML output file was generated by curves visualization script for job: " + current_job.jobName_)
                        continue
                    htmlFileList.append(htmlFilePath)

                    print("... End of generating curves visualization page for job <" + current_job.jobName_ + ">")

                except Exception as exc:
                    print("Fail to generate curves visualization : " + str(exc))
                    sys.exit(1)

    allCurves = ""
    for ht in htmlFileList:
        allCurves+=""+ht+" "
    if(platform.system()== 'Windows'):
        os.system(htmlBrowser + " " + allCurves +" 2> null &")
    else:
        os.system(htmlBrowser + " " + allCurves +" 2> /dev/null &")


def main():
    usage=u""" Usage: %prog --jobsFile=<job-file> [--withoutOffset] [--showpoints] [--htmlBrowser=<html-browser>]

    Script to create an HTML interface for curves output visualization

    Options :
      --withoutOffset : remove time offset
      --showpoints    : show simulation points
      --htmlBrowser   : HTML Browser to visualize curves
    """
    parser = OptionParser(usage)
    parser.add_option( '--jobsFile', dest="jobsFile",
                       help=u'jobs file')
    parser.add_option( "--withoutOffset", action="store_true", dest="withoutOffset",
                       help=u"Remove time offset", default=False)
    parser.add_option( "--showpoints", action="store_true", dest="showpoints",
                       help=u"Show simulation points", default=False)
    parser.add_option( "--htmlBrowser", action="store", dest="htmlBrowser",
                       help=u"HTML Browser to visualize curves", default='firefox')
    parser.add_option( "--plotRef", action="store_true", dest="plotRef",
                       help=u"Plot the reference curves", default=False)
    (options, args) = parser.parse_args()

    if options.jobsFile == None:
        parser.error("Jobs file should be informed")

    readCurvesToHtml(options.jobsFile,options.withoutOffset,options.showpoints,options.htmlBrowser, options.plotRef)
if __name__ == "__main__":
    main()
