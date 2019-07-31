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
    def add_dict(self , dictionary):
        index = [x for x in self.names_ if x == dictionary.name()]
        if index:
            self.dicts_[self.names_.index(dictionary.name())].dict_.update(dictionary.dict_)
        else:
            self.dicts_.append(dictionary)
            self.names_.append(dictionary.name_)

    ##
    #  Generate files with respect to keys found in dictionary
    # @param self: object pointer
    # @param output_dir : directory where files should be created
    # @param modelica_dir : directory where modelica files should be created
    # @param modelica_package : Parent package of modelica keys files
    # @return
    def generate_files(self,output_dir, modelica_dir, modelica_package):
        for name in self.names_:
            dictionary = Dictionary()
            for d in self.dicts_:
                if (d.name() == name):
                    dictionary = d
            dictionary.set_output_dir(output_dir)
            dictionary.set_modelica_dir(modelica_dir)
            dictionary.generate_header()
            dictionary.generate_cpp()
            dictionary.generate_modelica(modelica_package)
            dictionary.copy_delete_files()
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
        self.full_name_ = ""
        ## dictionary to store information
        self.dict_ = dict()
        ## path to create files
        self.directory_ = ""
        ## path to create modelica files
        self.modelica_dir_ = ""

    ##
    # Set the name of the dictionary
    # @param self : object pointer
    # @param name : name of the dictionary
    # @return
    def set_name(self,name):
        self.name_ = name

    ##
    # Set the path to use to create files
    # @param self : object pointer
    # @param directory : path to use
    # @return
    def set_output_dir(self, directory):
        self.directory_ = directory

    ##
    # Set the path to use to create modelica files
    # @param self : object pointer
    # @param directory : path to use
    # @return
    def set_modelica_dir(self, directory):
        self.modelica_dir_ = directory

    ##
    # Set the full name of the dictionary
    # @param self : object pointer
    # @param name : full name of the dictionary
    # @return
    def set_full_name(self,name):
        self.full_name_ = name

    ##
    # Add a new pair of value in the dictionary
    # @param self : object pointer
    # @param key : key to add in the dictionary
    # @param value: value associated to the key
    # @return
    def add_pair(self,key,value):
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
    def full_name(self):
        return self.full_name_

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
    def get_message(self,key):
        return self.dict_[key]


    ##
    # Generate a header file associated to the dictionary
    # @param self : object pointer
    # @return
    def generate_header(self):
        file_name = str(self.directory_)+'/'+str(self.name_)+'_keys.h-tmp'
        tag = str(self.name_).upper()  + '_KEYS_H'
        header_file = open(file_name,'w')
        name = self.name_[ 3:]
        header_file.write('''//
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
        header_file.write("#ifndef "+str(tag)+"\n")
        header_file.write("#define "+str(tag)+"\n")
        header_file.write("#include <string>\n")
        header_file.write("namespace DYN {\n\n")
        header_file.write("  ///< struct of Key"+str(name)+" to declare enum values and names associated to the enum to be used in dynawo\n")
        header_file.write("  struct Key"+name+"_t\n")
        header_file.write("  {\n")
        header_file.write("    ///< enum of possible key for "+str(name)+"\n")
        header_file.write("    enum value\n")
        header_file.write("    {\n")
        list_keys = self.keys()
        for key in list_keys:
            key1 = key+","
            key_to_print = key1.ljust(70)
            header_file.write('      '+str(key_to_print)+'\t///< '+self.get_message(key)+'\n')
        header_file.write("    };\n\n")
        header_file.write("    static const char* const names[]; ///< names associated to the enum \n")
        header_file.write("  };\n")
        header_file.write("} //namespace DYN\n")
        header_file.write("#endif\n")
        header_file.close()

    ##
    # Generate a cpp file associated to the dictionary
    # @param self : object pointer
    # @return
    def generate_cpp(self):
        file_name = str(self.directory_)+'/'+str(self.name_)+'_keys.cpp-tmp'
        cpp_file = open(file_name,'w')
        name = self.name_[ 3:]
        cpp_file.write('''//
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
        cpp_file.write('#include "'+ str(self.name_)+'_keys.h"\n')
        cpp_file.write("namespace DYN {\n\n")
        cpp_file.write("const char* const Key"+name+"_t::names[] = {\n")
        list_keys = self.keys()
        for key in list_keys:
            cpp_file.write('  "'+str(key)+'",\n')
        cpp_file.write("};\n")
        cpp_file.write("} //namespace DYN\n")
        cpp_file.close()

    ##
    # Generate a modelica file to declare the enum of the dictionary
    # @param self : object pointer
    # @param modelica_package : Parent package of modelica keys files
    # @return
    def generate_modelica(self, modelica_package):
        if not os.path.exists(self.modelica_dir_):
            print ("Modelica directory :"+str(self.modelica_dir_)+" does not exist")
            exit(1)
        name = self.name_[3:]
        file_name = str(self.modelica_dir_)+'/'+str(name)+'Keys.mo-tmp'
        mo_file = open(file_name,'w')
        mo_file.write('''/*
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
        mo_file.write("within " + modelica_package + ";\n\n")
        mo_file.write('encapsulated package '+name+'Keys\n\n')
        i = 0
        for key in self.keys():
            mo_file.write("final constant Integer "+str(key)+" = "+str(i)+";\n")
            i = i+1
        mo_file.write("\nend "+name+"Keys;\n")
        mo_file.close()

    ##
    # to avoid regeneration of sources, tmp files are created
    # if files exists and equals to tmp files, tmp files are deleted
    # else tmp files are copied
    # @param self : object pointer
    # @return
    def copy_delete_files(self):
        self.copy_delete_cpp_h_files()

        name = self.name_[3:]
        mo_file = str(self.modelica_dir_)+'/'+str(name)+'Keys.mo'
        tmp_mo_file = mo_file+'-tmp'

        diff = False
        if not os.path.exists(mo_file):
            diff = True
        else :
            # file is different
            if not filecmp.cmp(tmp_mo_file, mo_file):
                diff = True

        if diff:
            if os.path.exists(mo_file):
                os.chmod(mo_file, 0o777)
            shutil.copyfile(tmp_mo_file, mo_file)
            os.chmod(mo_file, 0o444)

        # suppression fichier tmp
        os.remove(tmp_mo_file)

    ##
    # to avoid regeneration of sources, tmp files are created
    # if files exists and equals to tmp files, tmp files are deleted
    # else tmp files are copied
    # @param self : object pointer
    # @return
    def copy_delete_cpp_h_files(self):
        h_file = str(self.directory_)+'/'+str(self.name_)+'_keys.h'
        tmp_h_file = h_file+'-tmp'
        cpp_file = str(self.directory_)+'/'+str(self.name_)+'_keys.cpp'
        tmp_cpp_file = cpp_file+'-tmp'

        diff_cpp_h = False
        # file exists
        if not os.path.exists(h_file):
            diff_cpp_h = True
        else :
            # file is different
            if not filecmp.cmp(tmp_h_file, h_file):
                diff_cpp_h = True

        # file exists
        if not os.path.exists(cpp_file):
            diff_cpp_h = True
        else:
            # file is different
            if not filecmp.cmp(tmp_cpp_file, cpp_file):
                diff_cpp_h = True

        if diff_cpp_h :
            if os.path.exists(h_file):
                os.chmod(h_file,0o777) # change before copy
            if os.path.exists(cpp_file):
                os.chmod(cpp_file,0o777)
            shutil.copyfile(tmp_h_file, h_file)
            shutil.copyfile(tmp_cpp_file, cpp_file)
            os.chmod(h_file,0o444) # file only readable
            os.chmod(cpp_file,0o444) # file only readable

        # suppression fichier tmp
        os.remove(tmp_h_file)
        os.remove(tmp_cpp_file)

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
# @param check_capital_letters : whether we should check if the first letter of the first word is capitalized or not
# @return  True is the line is correctly added to the dictionary
def read_line(line,dictionary,check_capital_letters):
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
    list_words = value.split()
    first_word = list_words[0]
    if (check_capital_letters and first_word[0].isupper() and not first_word.isupper()): # first letter is a capitalized one, and the other letters are not
      return Status.BEGIN_WITH_CAPITAL_LETTER
    dictionary.add_pair(key,value)
    return Status.OK

##
# Create a dictionary thanks to information found in a file
# @param file_2_read: file where the information are stored
# @return the dictionary created by the function
# @throw Raise an error is the file is not well formatted
def create_dictionary(file_2_read):
    # create a dictionary
    dictionary = Dictionary()
    names = file_2_read.split("/")
    dictionary_name = names.pop()
    dictionary_name = (dictionary_name.split(".")[0]).split("_")[0] # dictionary name is like : name_en_GB.dic
    dictionary.set_name(dictionary_name)
    dictionary.set_full_name(file_2_read)
    check_capital_letters = False
    if(dictionary_name.find("Log") != -1 or dictionary_name.find("Error") != -1):
      check_capital_letters = True
    file_read = open(file_2_read,'r')
    lines = file_read.readlines()
    file_read.close()
    for line in lines:
        line = line.rstrip('\n\r') # erase the endline characters
        status = read_line(line,dictionary,check_capital_letters)
        if( status == Status.NO_SEPARATOR ) :
            print ("File :"+str(file_2_read)+" line : '"+str(line)+"' is not well defined, no separator '=' between the key and the value")
            exit(1)
        if( status == Status.BEGIN_WITH_CAPITAL_LETTER):
            print ("File :"+str(file_2_read)+" line : '"+str(line)+"' , the value definition should not begin with a capital letter")
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
        dictionary=create_dictionary(f)
        dicts.add_dict(dictionary)

    # generate files
    dicts.generate_files(options.outputDir, options.modelicaDir, options.modelicaPackage)

if __name__ == "__main__":
    main()
