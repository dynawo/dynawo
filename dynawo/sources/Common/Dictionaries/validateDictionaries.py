#!/usr/bin/python

# -*- coding: utf-8;

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

##
# Small python utility to create header and CPP files associated to a dictionary
#

import glob
import formatter
import string
import filecmp
import shutil
import os
from optparse import OptionParser

##
# Class containing all dictionaries found by the utility
class Dictionaries:
    ##
    # Default constructor
    def __init__( self ):
        ## dictionaries found
        self.dicts_ = []
        ## name of each dictionary
        self.names_ = []

    ##
    # Add a new dictionary to the container
    # @param self: object pointer
    # @param dictionary : new dictionary to add
    # @return
    def addDict(self , dictionary):
        index = [x for x in self.names_ if x == dictionary.name()]
        if index:
            self.dicts_[self.names_.index(dictionary.name())].dict_.update(dictionary.dict_)
        else:
            self.dicts_.append(dictionary)
            self.names_.append(dictionary.name_)

    ##
    #  Generate files with respect to keys found in dictionary
    # @param self: object pointer
    # @param outputDir : directory where files should be created
    # @param modelicaDir : directory where modelica files should be created
    # @param modelicaPackage : Parent package of modelica keys files
    # @return
    def generateFiles(self,outputDir, modelicaDir, modelicaPackage):
        for name in self.names_:
            dictionary = Dictionary()
            for d in self.dicts_:
                if (d.name() == name):
                    dictionary = d
            dictionary.setOutputDir(outputDir)
            dictionary.setModelicaDir(modelicaDir)
            dictionary.generateHeader()
            dictionary.generateCPP()
            dictionary.generateModelica(modelicaPackage)
            dictionary.copyDeleteFiles()
##
#  Class defining one dictionary found by the utility
#  A dictionary associates a key with a message
class Dictionary:
    ##
    # Default constructor
    def __init__(self):
        ## name of the dictionary
        self.name_ = ""
        ## full name of the dictionary
        self.fullName_ = ""
        ## dictionary to store information
        self.dict_ = dict()
        ## path to create files
        self.directory_ = ""
        ## path to create modelica files
        self.modelicaDir_ = ""

    ##
    # Set the name of the dictionary
    # @param self : object pointer
    # @param name : name of the dictionary
    # @return
    def setName(self,name):
        self.name_ = name

    ##
    # Set the path to use to create files
    # @param self : object pointer
    # @param directory : path to use
    # @return
    def setOutputDir(self, directory):
        self.directory_ = directory

    ##
    # Set the path to use to create modelica files
    # @param self : object pointer
    # @param directory : path to use
    # @return
    def setModelicaDir(self, directory):
        self.modelicaDir_ = directory

    ##
    # Set the full name of the dictionary
    # @param self : object pointer
    # @param name : full name of the dictionary
    # @return
    def setFullName(self,name):
        self.fullName_ = name

    ##
    # Add a new pair of value in the dictionary
    # @param self : object pointer
    # @param key : key to add in the dictionary
    # @param value: value associated to the key
    # @return
    def addPair(self,key,value):
        self.dict_[key]=value

    ##
    # Getter of the dictionary's name
    # @param self: object pointer
    # @return : name of the dictionary
    def name(self):
        return self.name_

    ##
    # Getter of the dictionary's full name
    # @param self: object pointer
    # @return :  full name of the dictionary
    def fullName(self):
        return self.fullName_

    ##
    # Getter of the keys found in dictionary
    # @param  self: object pointer
    # @return All the keys found in the dictionary
    def keys(self):
        return self.dict_.keys()

    ##
    #  Get the message associated to a key
    # @param self: object pointer
    # @param key: key of the message to find
    # @return  the message associated to the key
    def getMessage(self,key):
        return self.dict_[key]


    ##
    # Generate a header file associated to the dictionary
    # @param self : object pointer
    # @return
    def generateHeader(self):
        fileName = str(self.directory_)+'/'+str(self.name_)+'_keys.h-tmp'
        tag = str(self.name_).upper()  + '_KEYS_H'
        headerFile = open(fileName,'w')
        name = self.name_[ 3:]
        headerFile.write('''//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
//
''')
        headerFile.write("#ifndef "+str(tag)+"\n")
        headerFile.write("#define "+str(tag)+"\n")
        headerFile.write("#include <string>\n")
        headerFile.write("namespace DYN {\n\n")
        headerFile.write("  ///< struct of Key"+str(name)+" to declare enum values and names associated to the enum to be used in dynawo\n")
        headerFile.write("  struct Key"+name+"_t\n")
        headerFile.write("  {\n")
        headerFile.write("    ///< enum of possible key for "+str(name)+"\n")
        headerFile.write("    enum value\n")
        headerFile.write("    {\n")
        listKeys = self.keys()
        for key in listKeys:
            key1 = key+","
            keyToPrint = key1.ljust(70)
            headerFile.write('      '+str(keyToPrint)+'\t///< '+self.getMessage(key)+'\n')
        headerFile.write("    };\n\n")
        headerFile.write("    static std::string names[]; ///< names associated to the enum \n")
        headerFile.write("  };\n")
        headerFile.write("} //namespace DYN\n")
        headerFile.write("#endif\n")
        headerFile.close()

    ##
    # Generate a cpp file associated to the dictionary
    # @param self : object pointer
    # @return
    def generateCPP(self):
        fileName = str(self.directory_)+'/'+str(self.name_)+'_keys.cpp-tmp'
        cppFile = open(fileName,'w')
        name = self.name_[ 3:]
        cppFile.write('''//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
//
''')
        cppFile.write('#include "'+ str(self.name_)+'_keys.h"\n')
        cppFile.write("namespace DYN {\n\n")
        cppFile.write("std::string Key"+name+"_t::names[] = {\n")
        listKeys = self.keys()
        for key in listKeys:
            cppFile.write('  "'+str(key)+'",\n')
        cppFile.write("};\n")
        cppFile.write("} //namespace DYN\n")
        cppFile.close()

    ##
    # Generate a modelica file to declare the enum of the dictionary
    # @param self : object pointer
    # @param modelicaPackage : Parent package of modelica keys files
    # @return
    def generateModelica(self, modelicaPackage):
        if not os.path.exists(self.modelicaDir_):
            print ("Modelica directory :"+str(self.modelicaDir_)+" does not exist")
            exit(1)
        name = self.name_[3:]
        fileName = str(self.modelicaDir_)+'/'+str(name)+'Keys.mo-tmp'
        moFile = open(fileName,'w')
        moFile.write('''/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/
''')
        moFile.write("within " + modelicaPackage + ";\n\n")
        moFile.write('encapsulated package '+name+'Keys\n\n')
        i = 0
        for key in self.keys():
            moFile.write("final constant Integer "+str(key)+" = "+str(i)+";\n")
            i = i+1
        moFile.write("\nend "+name+"Keys;\n")
        moFile.close()

    ##
    # to avoid regeneration of sources, tmp files are created
    # if files exists and equals to tmp files, tmp files are deleted
    # else tmp files are copied
    # @param self : object pointer
    # @return
    def copyDeleteFiles(self):
        HFile = str(self.directory_)+'/'+str(self.name_)+'_keys.h'
        tmpHFile = HFile+'-tmp'
        CPPFile = str(self.directory_)+'/'+str(self.name_)+'_keys.cpp'
        tmpCPPFile = CPPFile+'-tmp'

        diffCPP_H = False
        # file exists
        if not os.path.exists(HFile):
            diffCPP_H = True
        else :
            # file is different
            if not filecmp.cmp(tmpHFile, HFile):
                diffCPP_H = True

        # file exists
        if not os.path.exists(CPPFile):
            diffCPP_H = True
        else:
            # file is different
            if not filecmp.cmp(tmpCPPFile, CPPFile):
                diffCPP_H = True

        if diffCPP_H :
            if os.path.exists(HFile):
                os.chmod(HFile,0777) # change before copy
            if os.path.exists(CPPFile):
                os.chmod(CPPFile,0777)
            shutil.copyfile(tmpHFile, HFile)
            shutil.copyfile(tmpCPPFile, CPPFile)
            os.chmod(HFile,0444) # file only readable
            os.chmod(CPPFile,0444) # file only readable

        name = self.name_[3:]
        MOFile = str(self.modelicaDir_)+'/'+str(name)+'Keys.mo'
        tmpMOFile = MOFile+'-tmp'

        diff = False
        if not os.path.exists(MOFile):
            diff = True
        else :
            # file is different
            if not filecmp.cmp(tmpMOFile, MOFile):
                diff = True

        if diff:
            if os.path.exists(MOFile):
                os.chmod(MOFile, 0777)
            shutil.copyfile(tmpMOFile, MOFile)
            os.chmod(MOFile, 0444)

        # suppression fichier tmp
        os.remove(tmpHFile)
        os.remove(tmpCPPFile)
        os.remove(tmpMOFile)

##
# Class defining status when parsing a dictionary file
class Status():
  OK = 0  # no error
  NO_SEPARATOR = 1 # no separator found in the line
  BEGIN_WITH_CAPITAL_LETTER = 2 # first word of the line begins with a capital letter (and is not a capitalized word such as KINSOL)

##
# Read a line and add a key/value to a dictionary
# @param line : line to read and analyse
# @param dictionary : dictionary where the message should be added
# @param checkCapitalLetters : whether we should check if the first letter of the first word is capitalized or not
# @return  True is the line is correctly added to the dictionary
def readLine(line,dictionary,checkCapitalLetters):
    if( line.find("//") != -1):
        line = line[ :line.find("//")] # erase any comment

    line=line.strip()
    if( len(line) == 0): # it was only a comment
        return Status.OK
    if( line.find("=") == -1): # no separator => error
        return Status.NO_SEPARATOR

    key = line[ : line.find("=")].strip()
    value = line[ line.find("=")+1:].strip()
    # analyze first word of the value
    listWords = value.split()
    firstWord = listWords[0]
    if (checkCapitalLetters and firstWord[0].isupper() and not firstWord.isupper()): # first letter is a capitalized one, and the other letters are not
      return Status.BEGIN_WITH_CAPITAL_LETTER
    dictionary.addPair(key,value)
    return Status.OK

##
# Create a dictionary thanks to information found in a file
# @param file2Read: file where the information are stored
# @return the dictionary created by the function
# @throw Raise an error is the file is not well formatted
def createDictionary(file2Read):
    # create a dictionary
    dictionary = Dictionary()
    names = file2Read.split("/")
    dictionaryName = names.pop()
    dictionaryName = (dictionaryName.split(".")[0]).split("_")[0] # dictionary name is like : name_en_GB.dic
    dictionary.setName(dictionaryName)
    dictionary.setFullName(file2Read)
    checkCapitalLetters = False
    if(dictionaryName.find("Log") != -1 or dictionaryName.find("Error") != -1):
      checkCapitalLetters = True
    fileRead = open(file2Read,'r')
    lines = fileRead.readlines()
    fileRead.close()
    for line in lines:
        line = line.rstrip('\n\r') # erase the endline characters
        status = readLine(line,dictionary,checkCapitalLetters)
        if( status == Status.NO_SEPARATOR ) :
            print ("File :"+str(file2Read)+" line : '"+str(line)+"' is not well defined, no separator '=' between the key and the value")
            exit(1)
        if( status == Status.BEGIN_WITH_CAPITAL_LETTER):
            print ("File :"+str(file2Read)+" line : '"+str(line)+"' , the value definition should not begin with a capital letter")
            exit(1)
    return dictionary

##
#   Main function of the utility
def main():
    usage =u""" usage: %prog --inputDir=<directories> --outputDir=<directory> --modelicaDir=<directory> --modelicaPackage=<packageName>

    Script generates keys.h and keys.cpp of inputDir files in outputDir
    Generates keys.mo files in modelicaDir
    If everything is ok, generates header associated with all kind of dictionary
    """

    parser = OptionParser(usage)
    parser.add_option( '--inputDir', dest="inputDir",
                       help=u"input directories where dictionaries files should be read (commas separated)")
    parser.add_option( '--outputDir', dest="outputDir",
                       help=u"Output directory where keys (.h and .cpp) files should be created")
    parser.add_option( '--modelicaDir', dest="modelicaDir",
                       help=u"Output directory where modelica keys files should be created")
    parser.add_option( '--modelicaPackage', dest="modelicaPackage",
                       help=u"Parent package of modelica keys files")

    (options, args) = parser.parse_args()

    if options.inputDir == None:
        parser.error("Input directory should be informed")

    if options.outputDir == None:
        parser.error("Output directory should be informed")

    if options.modelicaDir == None:
        parser.error("Output directory for modelica files should be informed")

    if options.modelicaPackage == None:
        parser.error("Parent package of modelica keys files should be informed")

    # create dictionaries structure
    dicts = Dictionaries()

    files = []
    input_dir_list = str(options.inputDir).split(",")
    for input_dir in input_dir_list:
        if len(input_dir) == 0:
            continue
        dic_mapping_name = os.environ.get('DYNAWO_DICTIONARIES',"")+".dic"
        for path in glob.glob(str(input_dir)+'/*.dic'):
            if os.path.basename(path) != "dictionaries_mapping.dic" and  os.path.basename(path) !=  dic_mapping_name:
                files.append(path)

    # read all files
    for f in files:
        dictionary=createDictionary(f)
        dicts.addDict(dictionary)

    # generate files
    dicts.generateFiles(options.outputDir, options.modelicaDir, options.modelicaPackage)

if __name__ == "__main__":
    main()
