#!/usr/bin/python

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
import shutil
import lxml.etree
from optparse import OptionParser

xmlToHtml_resources_dir = os.path.join(os.path.dirname(__file__),"../resources")
jsFileIn=xmlToHtml_resources_dir+"/curves.js.in"
htmlFileIn=xmlToHtml_resources_dir+"/curves.html.in"

DYN_NAMESPACE = "http://www.rte-france.com/dynawo"

def namespaceDYN(tag):
    return "{" + DYN_NAMESPACE + "}" + tag

def cleanIdForJS(id):
    return id.replace(".","_").replace(" ","_").replace("-","_")


### CSV READER and DUMP into jsFile
class Data:
    def __init__ (self,name):
        self.name_ = name
        self.serie_=[]

    def add(self,value):
        self.serie_.append(value)

    def name(self):
        return self.name_

    def serie(self):
        return self.serie_

def readXmlToHtml(xml_file, output_dir, withoutOffset, showpoints):
    full_path = os.path.expanduser(output_dir)
    # Copy resources in output directory
    output_resources_dir = os.path.join(full_path,"curvesResources")

    # Delete resources directory and then create it again
    if os.path.isdir(output_resources_dir) == True:
        shutil.rmtree(output_resources_dir)
    shutil.copytree(xmlToHtml_resources_dir,output_resources_dir)

    ## read xml and create data structures
    datas=[]
    timeSerie = []
    full_path = os.path.expanduser(xml_file)
    xml_curves = lxml.etree.parse(full_path).getroot()
    index = 0
    for curve in xml_curves.iter(namespaceDYN("curve")):
        model = curve.get("model")
        variable = curve.get("variable")
        data= Data(model+"_"+variable)
        datas.append(data)
        for point in curve.iter(namespaceDYN("point")):
            timeValue = point.get("time")
            value = point.get("value")
            datas[index].add(value)
            if index == 0:
                timeSerie.append(timeValue)
        index = index + 1


    # ## dump dataStructures in javascript data
    full_path =  os.path.expanduser(output_dir)
    jsDst=os.path.join(full_path,"curves.js")
    htmlDst=os.path.join(full_path,"curves.html")

    dataToPrint=""
    titleToPrint=""
    if withoutOffset:
        minTime = timeSerie[0]
        for i in range(0,len(timeSerie)):
            timeSerie[i] = str(float(timeSerie[i]) - float(minTime))

    for data in datas:
        dataToPrint = dataToPrint + "\n"
        dataToPrint = dataToPrint +"\tvar "+cleanIdForJS(data.name())+"=[];\n"
        serie = data.serie()
        for i in range(0,len(serie)):
            dataToPrint = dataToPrint + "\t"+cleanIdForJS(data.name())+".push(["+timeSerie[i]+","+serie[i]+"]);\n"

    dataToPrint += "\n\tdatasRead=[\n"
    index = 0
    for data in datas:
        dataToPrint +="\t{\n"
        dataToPrint +='\t\tlabel:"'+data.name()+'",\n'
        dataToPrint +="\t\tdata:"+cleanIdForJS(data.name())+"\n"
        if(index < len(datas)-1):
            dataToPrint +="\t},\n"
        else:
            dataToPrint +="\t}\n"
        index += 1
    dataToPrint += "\t];\n"

    titleToPrint = os.path.basename(xml_file)
    ## javascript file
    fileSrc = open(jsFileIn,'r')
    lines = fileSrc.readlines()
    fileSrc.close()
    fileDst = open(jsDst,'w')

    for line in lines:
        if (line.find("@DATA_TO_PRINT@")!=-1):
            line=line.replace("@DATA_TO_PRINT@",dataToPrint)
        elif(line.find("@TITLE_TO_READ@")!=-1):
            line=line.replace("@TITLE_TO_READ@",titleToPrint)
        elif(line.find("@SHOW_POINTS@")!=-1):
            if (showpoints):
                line=line.replace("@SHOW_POINTS@","true")
            else :
                line=line.replace("@SHOW_POINTS@","false")
        fileDst.write(line)

    fileDst.close()
    ## html file
    fileSrc = open(htmlFileIn,'r')
    lines = fileSrc.readlines()
    fileSrc.close()
    fileDst = open(htmlDst,'w')

    for line in lines:
        if (line.find("@FILE_JS@")!=-1):
            line=line.replace("@FILE_JS@",os.path.basename(jsDst))
        elif(line.find("@TITLE_TO_READ@")!=-1):
            line=line.replace("@TITLE_TO_READ@",titleToPrint)
        elif(line.find("@RESOURCES_DIR@")!=-1):
            line=line.replace("@RESOURCES_DIR@","curvesResources")

        fileDst.write(line)

    fileDst.close()
#### end

def main():
    usage=u""" Usage: %prog --xmlFile=<xml-file> --outputDir=<output-dir>

    Script intended to build a HTML interface for curves visualization
    from a XML curves file <xml-file>

    Options :
      --withoutOffset : remove time offset
      --showpoints : show simulation points
    """
    parser = OptionParser(usage)
    parser.add_option( '--xmlFile', dest="xmlFile",
                       help=u'File to read')
    parser.add_option( '--outputDir', dest="outputdir",
                       help=u"Output directory for html files created")
    parser.add_option("--withoutOffset", action="store_true", dest="withoutOffset",
                      help=u"Remove time offset", default=False)
    parser.add_option("--showpoints", action="store_true", dest="showpoints",
                      help=u"Show simulation points", default=False)
    (options, args) = parser.parse_args()

    if options.xmlFile == None:
        parser.error("XML file to read should be informed")

    if options.outputdir == None:
        parser.error("Output directory should be informed")

    readXmlToHtml(options.xmlFile, options.outputdir, options.withoutOffset, options.showpoints)

if __name__ == "__main__":
    main()
