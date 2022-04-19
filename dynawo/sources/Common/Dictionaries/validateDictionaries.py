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
# Small python utility to check if dictionaries have the same entries and message description.
# It optionally creates header, CPP and Modelica files associated to each dictionary.
#

import filecmp
import glob
import os
import shutil

from optparse import OptionParser


##
# Class containing all dictionaries found by the utility.
class DictionariesPool:
    ##
    # Default constructor.
    #
    # @param  self: the object pointer
    def __init__(self):
        ## dictionaries found
        self._dictionaries = {}

    ##
    # Add a new dictionary to the container.
    #
    # @param  self: the object pointer
    # @param  dictionary: the dictionary to add
    # @return
    def add_dictionary(self, dictionary):
        name = dictionary.name
        locale = dictionary.locale
        if name not in self._dictionaries:
            self._dictionaries[name] = {}
        if locale in self._dictionaries[name]:
            self._dictionaries[name][locale].extend(dictionary)
        else:
            self._dictionaries[name][locale] = dictionary

    ##
    # Check integrity of all dictionaries in the container.
    #
    # @param  self: the object pointer
    # @return True if integrity is right, False otherwise
    def check_integrity(self):
        return self._check_locales() and self._check_timeline_priority()

    ##
    # Check locales variations integrity.
    # Compare all dictionaries in the container to check if they have the same keys and same kind of message.
    #
    # @param  self: the object pointer
    # @return True if integrity is right, False otherwise
    def _check_locales(self):
        for dictionaries in self._dictionaries.values():
            ref_dictionary = None
            for _, other_dictionary in sorted(dictionaries.items()):
                if ref_dictionary is None:
                    ref_dictionary = other_dictionary
                    continue

                if (not DictionariesPool._compare_keys(ref_dictionary, other_dictionary)
                        or not DictionariesPool._compare_messages(ref_dictionary, other_dictionary)):
                    return False
        return True

    ##
    # Compare two dictionaries and return @b False if they have not the same keys.
    #
    # @param  dictionary1: first dictionary to compare
    # @param  dictionary2: second dictionary to compare
    # @return True if comparison is right, False otherwise
    @staticmethod
    def _compare_keys(dictionary1, dictionary2):
        if set(dictionary1.messages) != set(dictionary2.messages):
            print("Error: " + str(dictionary1.paths) + " and "
                  + str(dictionary2.paths) + " have not the same entries.")
            return False

        return True

    ##
    # Compare each messages from two dictionaries and return @b False if one has not the same number of arguments.
    #
    # @param  dictionary1: first dictionary to compare
    # @param  dictionary2: second dictionary to compare
    # @return True if is right, False otherwise
    @staticmethod
    def _compare_messages(dictionary1, dictionary2):
        for key in dictionary1.messages:
            if dictionary2.get_args_count(key) != dictionary1.get_args_count(key):
                print("Error: Messages of key '" + str(key) + "' for dictionary " + str(dictionary1.paths) + " and " +
                      str(dictionary2.paths) + " have not the same number of arguments.")
                return False

        return True

    ##
    # Check Timeline/TimelinePriority integrity.
    # Compare Timeline and TimelinePriority dictionaries to check if they have the same keys.
    #
    # @param  self: the object pointer
    # @return True if integrity is right, False otherwise
    def _check_timeline_priority(self):
        for name, dictionaries in self._dictionaries.items():
            if not name.endswith('TimelinePriority'):
                continue

            locale, timeline_priority_dictionary = next(iter(dictionaries.items()))
            if len(dictionaries) > 1 or locale:
                print("Error: " + name
                      + " dictionary should be present only once and without a locale.")
                return False

            timeline_name = name[:-len('Priority')]
            timeline_dictionaries = self._dictionaries.get(timeline_name)
            if not timeline_dictionaries:
                print("Error: " + timeline_name + " dictionary not present in input directories while "
                      + str(timeline_priority_dictionary.paths) + " is.")
                return False

            for timeline_dictionary in timeline_dictionaries.values():
                if not DictionariesPool._compare_keys(timeline_dictionary, timeline_priority_dictionary):
                    return False

        return True

    ##
    # Generate files with respect to keys found in dictionaries.
    #
    # @param  self: the object pointer
    # @param  namespace: the cpp namespace to use for keys declarations
    # @param  output_dir: the directory where files should be created
    # @param  modelica_dir: the directory where modelica files should be created
    # @param  modelica_package: the parent package of modelica keys files
    # @param  include_dirs: the directories where dynawo header files already exist
    # @return
    def generate_files(self, output_dir, namespace, modelica_dir, modelica_package, include_dirs):
        if not output_dir:
            return

        for name, dictionaries in self._dictionaries.items():
            if name.endswith('TimelinePriority'):  # No need to generate keys as we use those of Timeline
                continue

            if any(os.path.isfile(os.path.join(include_dir, name + '_keys.h')) for include_dir in include_dirs):
                continue
            # take english dic as reference if possible else the first available
            dictionary = dictionaries.get('en_GB', next(iter(dictionaries.values())))
            dictionary.generate_header_files(namespace, output_dir)
            dictionary.generate_cpp_files(namespace, output_dir)
            dictionary.generate_modelica_files(modelica_package, modelica_dir)
            dictionary.copy_delete_cpp_header_files(output_dir)
            dictionary.copy_delete_modelica_files(modelica_dir)


##
#  Class defining one dictionary found by the utility.
#  A dictionary associates a key with a message.
class Dictionary:
    ##
    # Default constructor.
    #
    # @param  self: the object pointer
    # @param  full_path: the full path of dictionary file to parse
    def __init__(self, full_path=""):
        # dictionary filename is like: name_en_GB.dic
        name_and_locale = os.path.basename(full_path).rsplit('.', 1)[0].split('_', 1)
        ## name of the dictionary
        self.name = name_and_locale[0]
        ## locale of the dictionary
        self.locale = name_and_locale[1] if len(name_and_locale) > 1 else ''
        ## Python dictionary to store messages
        self.messages = dict()
        ## path to sparse files
        self.paths = [str(full_path)] if full_path else []

    ##
    # Extend the dictionary with another dictionary.
    #
    # @param  self: the object pointer
    # @param  dictionary: the other dictionary
    # @return
    def extend(self, dictionary):
        self.messages.update(dictionary.messages)
        self.paths.extend(dictionary.paths)

    ##
    # Count the number of arguments expected to format a message.
    # Pattern of an argument is like %n%
    #
    # @param  self: the object pointer
    # @param  key: the key of the message to analyze
    # @return the number of arguments expected to format this message
    def get_args_count(self, key):
        return len([word for word in self.messages[key].split() if '%' in word])

    ##
    # Generate a header file associated to the dictionary.
    #
    # @param  self: the object pointer
    # @param  namespace: the cpp namespace to use for keys declarations
    # @param  header_dir:  the path where to create header files
    # @return
    def generate_header_files(self, namespace, header_dir=None):
        if not header_dir:
            return

        name = self.name[3:]  # remove DYN prefix
        tag = self.name.upper() + '_KEYS_H'
        file_name = os.path.join(str(header_dir), self.name + '_keys.h-tmp')

        with open(file_name, 'w') as header_file:
            header_file.write('''//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//
''')
            header_file.write("#ifndef " + tag + "\n")
            header_file.write("#define " + tag + "\n")
            header_file.write("namespace " + namespace + " {\n\n")
            header_file.write("  ///< struct of Key" + name
                              + " to declare enum values and names associated to the enum to be used in dynawo\n")
            header_file.write("  struct Key" + name + "_t\n")
            header_file.write("  {\n")
            header_file.write("    ///< enum of possible key for " + name + "\n")
            header_file.write("    enum value\n")
            header_file.write("    {\n")
            nb_keys = len(self.messages)
            comma = ","
            for key in sorted(self.messages):
                nb_keys -= 1
                if nb_keys == 0:
                    comma = ""
                try:
                    header_file.write("      " + (key + comma).ljust(70) + "  ///< " + self.messages[key] + "\n")
                except UnicodeEncodeError:
                    header_file.write("      " + (key.encode('utf-8') + comma).ljust(70) + "  ///< " + self.messages[key].encode('utf-8') + "\n")
            header_file.write("    };\n\n")
            header_file.write("    /**\n")
            header_file.write("    * @brief Return the name associated to the enum.\n")
            header_file.write("    *\n")
            header_file.write("    * @return The name associated to the enum.\n")
            header_file.write("    */\n")
            header_file.write("    static const char* names(const value&); ///< names associated to the enum\n")
            header_file.write("  };\n")
            header_file.write("} //namespace " + namespace + "\n")
            header_file.write("#endif\n")

    ##
    # Generate a cpp file associated to the dictionary.
    #
    # @param  self: the object pointer
    # @param  namespace: the cpp namespace to use for keys declarations
    # @param  cpp_dir: the path where to create cpp files
    # @return
    def generate_cpp_files(self, namespace, cpp_dir=None):
        if not cpp_dir:
            return

        name = self.name[3:]  # remove DYN prefix
        file_name = os.path.join(str(cpp_dir), self.name + '_keys.cpp-tmp')

        with open(file_name, 'w') as cpp_file:
            cpp_file.write('''//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//
''')
            cpp_file.write('#include "' + self.name + '_keys.h"\n')
            cpp_file.write("namespace " + namespace + " {\n\n")
            cpp_file.write("const char* Key" + name + "_t::names(const value& v) {\n")
            cpp_file.write("  static const char* names[] = {\n")
            for key in sorted(self.messages):
                cpp_file.write('    "' + key + '",\n')
            cpp_file.write("  };\n")
            cpp_file.write("  return names[v];\n")
            cpp_file.write("}\n")
            cpp_file.write("} //namespace " + namespace + "\n")

    ##
    # Generate a modelica file to declare the enum of the dictionary.
    #
    # @param  self: the object pointer
    # @param  modelica_package: the parent package of modelica keys files
    # @param  modelica_dir: the path where to create modelica files
    # @return
    def generate_modelica_files(self, modelica_package, modelica_dir=None):
        if not modelica_dir:
            return

        name = self.name[3:]  # remove DYN prefix
        file_name = os.path.join(str(modelica_dir), name + 'Keys.mo-tmp')

        with open(file_name, 'w') as mo_file:
            mo_file.write('''/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
* for power systems.
*/
''')
            mo_file.write("within " + modelica_package + ";\n\n")
            mo_file.write('encapsulated package ' + name + 'Keys\n\n')
            for i, key in enumerate(sorted(self.messages)):
                mo_file.write("final constant Integer " + key + " = " + str(i) + ";\n")
            mo_file.write("\nend " + name + "Keys;\n")
            mo_file.close()

    ##
    # To avoid regeneration of sources, tmp files are created.
    # If files exist and are equal to tmp files, tmp files are deleted,
    # else tmp files are copied.
    #
    # @param  self: the object pointer
    # @param  modelica_dir: the path where modelica files was created
    # @return
    def copy_delete_modelica_files(self, modelica_dir=None):
        if not modelica_dir:
            return

        name = self.name[3:]  # remove prefix DYN
        mo_file = os.path.join(str(modelica_dir), name + 'Keys.mo')
        tmp_mo_file = mo_file + '-tmp'

        # check if modelica file doesn't exist or is different
        if not os.path.exists(mo_file) or not filecmp.cmp(tmp_mo_file, mo_file):
            if os.path.exists(mo_file):
                os.chmod(mo_file, 0o777)
            shutil.copyfile(tmp_mo_file, mo_file)
            os.chmod(mo_file, 0o444)

        # suppression fichier tmp
        os.remove(tmp_mo_file)

    ##
    # To avoid regeneration of sources, tmp files are created.
    # If files exist and are equal to tmp files, tmp files are deleted,
    # else tmp files are copied.
    #
    # @param  self: the object pointer
    # @param  cpp_dir: the path where cpp/header files was created
    # @return
    def copy_delete_cpp_header_files(self, cpp_dir=None):
        if not cpp_dir:
            return

        h_file = os.path.join(str(cpp_dir), self.name + '_keys.h')
        tmp_h_file = h_file + '-tmp'
        cpp_file = os.path.join(str(cpp_dir), self.name + '_keys.cpp')
        tmp_cpp_file = cpp_file + '-tmp'

        # check if one file doesn't exist or is different
        if (not os.path.exists(h_file)
                or not filecmp.cmp(tmp_h_file, h_file)
                or not os.path.exists(cpp_file)
                or not filecmp.cmp(tmp_cpp_file, cpp_file)):
            if os.path.exists(h_file):
                os.chmod(h_file, 0o777)  # change before copy
            if os.path.exists(cpp_file):
                os.chmod(cpp_file, 0o777)
            shutil.copyfile(tmp_h_file, h_file)
            shutil.copyfile(tmp_cpp_file, cpp_file)
            os.chmod(h_file, 0o444)  # file only readable
            os.chmod(cpp_file, 0o444)  # file only readable
        # remove tmp files
        os.remove(tmp_h_file)
        os.remove(tmp_cpp_file)

    ##
    # Parse the dictionary file.
    #
    # @param  self: the object pointer
    # @param  check_capital_letters: whether we should check if the first letter of the first word is capitalized or not
    # @return
    # @throw  Raise ValueError is the file is not well formatted
    def parse_file(self, check_capital_letters):
        if not self.paths:
            return

        from io import open
        try:
            with open(self.paths[0]) as dic_file:
                lines = dic_file.readlines()
        except UnicodeDecodeError:
            with open(self.paths[0], encoding='iso8859-1') as dic_file:
                lines = dic_file.readlines()

        for line in lines:
            line = line.rstrip('\n\r')  # remove endline characters
            self._parse_line(line, check_capital_letters)

    ##
    # Parse a line and add a key/value to the dictionary.
    #
    # @param  self: the object pointer
    # @param  line: the line to read and analyze
    # @param  check_capital_letters: whether we should check if the first letter of the first word is capitalized or not
    # @return
    # @throw  Raise ValueError is the line is not well formatted
    def _parse_line(self, line, check_capital_letters):
        if '//' in line:
            line, _ = line.split('//', 1)  # erase any comment
        line = line.strip()
        if not line:  # it was only a comment
            return

        if '=' not in line:  # no separator => error
            raise ValueError("Error: File: " + self.paths[0] + " line: '" + line
                             + "' is not well defined, no separator '=' between the key and the value.")

        key, value = line.split('=', 1)
        key, value = key.strip(), value.strip()

        # analyze first word of the value
        list_words = value.split()
        first_word = list_words[0]
        if (check_capital_letters
                and first_word[0].isupper()
                and not first_word.isupper()):  # first letter is a capitalized one, and the other letters are not
            raise ValueError("Error: File: " + self.paths[0] + " line: '" + line
                             + "', the value definition should not begin with a capital letter.")

        self.messages[key] = value

##
# Create a dictionary thanks to information found in a file.
#
# @param  full_path: the file where the information are stored
# @return the dictionary created by the function
# @throw  Raise ValueError is the file is not well formatted
def create_dictionary(full_path):
    dictionary = Dictionary(full_path)
    dictionary.parse_file('Log' in dictionary.name or 'Error' in dictionary.name)
    return dictionary


##
#   Main function of the utility.
def main():
    usage = u"""%prog --inputDir=<directories> [--outputDir=<directory> [--namespace=<namespace>] [--existingKeysDir=<directories>]] [--modelicaDir=<directory> --modelicaPackage=<packageName>]

    Script checks integrity of all dictionaries in inputDir.
    If check is ok, it generates keys.h and keys.cpp files in outputDir and keys.mo files in modelicaDir."""

    parser = OptionParser(usage)
    parser.add_option('--inputDir', dest='inputDir',
                      help=u"Input directories where dictionaries files should be read (commas separated)")
    parser.add_option('--outputDir', dest='outputDir',
                      help=u"Optional output directory where keys (.h and .cpp) files should be created")
    parser.add_option('--namespace', dest='namespace', default='DYN',
                      help=u"Optional namespace to use in keys (.h and .cpp) files (default to DYN)")
    parser.add_option('--existingKeysDir', dest='existingKeysDir',
                      help=u"Optional directories with already existing key files (commas separated)")
    parser.add_option('--modelicaDir', dest='modelicaDir',
                      help=u"Optional output directory where modelica keys files should be created")
    parser.add_option('--modelicaPackage', dest='modelicaPackage',
                      help=u"Parent package of modelica keys files (required if --modelicaDir is used)")

    (options, args) = parser.parse_args()

    if options.inputDir is None:
        parser.error("Input directories should be informed.")

    if options.outputDir is not None and not os.path.exists(options.outputDir):
        parser.error("Output directory: " + str(options.outputDir) + " does not exist.")

    if options.modelicaDir is not None:
        if not os.path.exists(options.modelicaDir):
            parser.error("Modelica directory: " + str(options.modelicaDir) + " does not exist.")

        if options.modelicaPackage is None:
            parser.error("Parent package of modelica keys files should be informed.")

    # retrieve dictionaries paths
    dic_mapping_name = os.environ.get('DYNAWO_DICTIONARIES', 'dictionaries_mapping') + '.dic'
    dic_paths = []
    input_dirs = str(options.inputDir).split(',')
    for input_dir in input_dirs:
        if input_dir:
            for path in glob.glob(os.path.join(input_dir, '*.dic')):
                if os.path.basename(path) not in ('dictionaries_mapping.dic', dic_mapping_name):
                    if not path.endswith("_oppositeEvents.dic"):
                        dic_paths.append(path)

    # read all dictionary files
    dictionaries = DictionariesPool()
    try:
        for path in sorted(dic_paths):
            dictionaries.add_dictionary(create_dictionary(path))

    except ValueError as ve:
        exit(ve)

    if not dictionaries.check_integrity():
        exit(1)

    # generate cpp and modelica files
    existing_dir = str(options.existingKeysDir).split(',')
    dictionaries.generate_files(options.outputDir, options.namespace, options.modelicaDir, options.modelicaPackage,
                                existing_dir)


if __name__ == '__main__':
    main()
