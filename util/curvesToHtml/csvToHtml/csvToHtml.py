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
import csv
import shutil
from optparse import OptionParser

csvToHtml_resources_dir = os.path.join(os.path.dirname(__file__),"../resources")
jsFileIn=csvToHtml_resources_dir+"/curves.js.in"
jsRefFileIn=csvToHtml_resources_dir+"/curves_ref.js.in"
htmlFileIn=csvToHtml_resources_dir+"/curves.html.in"

def cleanIdForJS(id):
    return id.replace(".","_").replace(" ","_").replace("-","_").replace('#',"_")

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

def readCsvToHtml(csv_file, ref_csv_file, output_dir, withoutOffset, showpoints):
    full_path = os.path.expanduser(output_dir)
    # Copy resources in output directory
    output_resources_dir = os.path.join(full_path,"curvesResources")

    # Delete resources directory and then create it again
    if os.path.isdir(output_resources_dir) == True:
        shutil.rmtree(output_resources_dir)
    shutil.copytree(csvToHtml_resources_dir,output_resources_dir)

    full_path = os.path.expanduser(csv_file)
    ## read csv and create data structures
    cr = csv.reader(open(full_path,"r"),delimiter=";")
    datas=[]
    timeIndex = 0
    index =  -1
    for row in cr:
      #first line
      if( row[0] == "time" ):
        index  = 0
        for value in row:
          if(value != ""):
            data = Data(value)
            datas.append(data)
      else:
        index = 0
        for value in row:
          if(value != ""):
            datas[index].add(value)
            index = index + 1

    ref_datas = []
    if (ref_csv_file is not None):
        ref_full_path = os.path.expanduser(ref_csv_file)
        ref_cr = csv.reader(open(ref_full_path,"r"),delimiter=";")
        for row in ref_cr:
          #first line
          if( row[0] == "time" ):
            index  = 0
            for value in row:
              if(value != ""):
                data = Data("REF_" + value)
                ref_datas.append(data)
          else:
            index = 0
            for value in row:
              if(value != ""):
                ref_datas[index].add(value)
                index = index + 1


    # ## dump dataStructures in javascript data
    full_path =  os.path.expanduser(output_dir)
    jsDst=os.path.join(full_path,"curves.js")
    htmlDst=os.path.join(full_path,"curves.html")

    dataToPrint=[]
    dataToPrintBody=[]
    titleToPrint=""
    timeSerie=datas[timeIndex].serie()

    del datas[0] # remove time from datas to print
    if (len(ref_datas) > 0):
        refTimeSerie=ref_datas[timeIndex].serie()
        del ref_datas[0]

    if withoutOffset:
        minTime = timeSerie[0]
        for i in range(0,len(timeSerie)):
            timeSerie[i] = str(float(timeSerie[i]) - float(minTime))
        if (len(ref_datas) > 0):
            minTime = refTimeSerie[0]
            for i in range(0,len(refTimeSerie)):
                refTimeSerie[i] = str(float(refTimeSerie[i]) - float(minTime))

    index = 0
    for data in datas:
        dataToPrint.append("")
        text = "\n"
        name = cleanIdForJS(data.name())
        text += "\tvar "+name+"=[];\n"
        serie = data.serie()
        for i in range(0,len(serie)):
            text += "\t"+name+".push(["+timeSerie[i]+","+serie[i]+"]);\n"
        dataToPrint[index] = text

        dataToPrintBody.append("")
        textBody ="\t{\n"
        textBody +='\t\tlabel:"'+data.name()+'",\n'
        textBody +="\t\tdata:"+name+"\n"
        if(index < len(datas)-1 or len(ref_datas) > 0):
            textBody +="\t},\n"
        else:
            textBody +="\t}\n"
        dataToPrintBody[index] = textBody

        index +=1

    if (len(ref_datas) > 0):
        for data in ref_datas:
            dataToPrint.append("")
            text = "\n"
            name = cleanIdForJS(data.name())
            text += "\tvar "+name+"=[];\n"
            serie = data.serie()
            for i in range(0,len(serie)):
                text += "\t"+name+".push(["+refTimeSerie[i]+","+serie[i]+"]);\n"
            dataToPrint[index] = text

            dataToPrintBody.append("")
            textBody ="\t{\n"
            textBody +='\t\tlabel:"'+data.name()+'",\n'
            textBody +="\t\tdata:"+name+"\n"
            if(index < len(datas) + len(ref_datas)-1):
                textBody +="\t},\n"
            else:
                textBody +="\t}\n"
            dataToPrintBody[index] = textBody

            index +=1

    titleToPrint = os.path.basename(csv_file)
    ## javascript file
    if (len(ref_datas) > 0) :
        fileSrc = open(jsRefFileIn,'r')
        lines = fileSrc.readlines()
        fileSrc.close()
    else:
        fileSrc = open(jsFileIn,'r')
        lines = fileSrc.readlines()
        fileSrc.close()
    fileDst = open(jsDst,'w')

    for line in lines:
        if (line.find("@DATA_TO_PRINT@")!=-1):
            for data in dataToPrint:
                fileDst.write(data)
            fileDst.write("\n\tdatasRead=[\n")
            for data in dataToPrintBody:
                fileDst.write(data)
            fileDst.write("\t];\n")
            continue
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
        elif(line.find("@DYNAWO_RESOURCES_DIR@")!=-1):
            line=line.replace("@DYNAWO_RESOURCES_DIR@","curvesResources")

        fileDst.write(line)

    fileDst.close()
#### end

def main():
    usage=u""" Usage: %prog --csvFile=<csv-file> --outputDir=<output-dir>

    Script intended to build a HTML interface for curves visualization
    from a CSV curves file <csv-file>

    Options :
      --withoutOffset : remove time offset
      --showpoints : <True|False> show simulation points
    """
    parser = OptionParser(usage)
    parser.add_option( '--csvFile', dest="csvFile",
                       help=u'File to read')
    parser.add_option( '--refCsvFile', dest="refCsvFile",
                       help=u'Reference file to read')
    parser.add_option( '--outputDir', dest="outputdir",
                       help=u"Output directory for html files created")
    parser.add_option("--withoutOffset", action="store_true", dest="withoutOffset",
                      help=u"Remove time offset", default=False)
    parser.add_option("--showpoints", action="store_true", dest="showpoints",
                      help=u"Show simulation points", default=True)
    (options, args) = parser.parse_args()

    if options.csvFile == None:
        parser.error("CSV file to read should be informed")

    if options.outputdir == None:
        parser.error("Output directory should be informed")

    readCsvToHtml(options.csvFile, options.refCsvFile, options.outputdir, options.withoutOffset, options.showpoints)

if __name__ == "__main__":
    main()
