# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import getopt
import os
import subprocess
import sys

def filterGitStatus(status):
    return status[1] not in ['!', 'D', '?'] and status[0] not in ['!', 'D', '?']

def filterGitName(filename, status):
    if status[0] in ['R', 'C']:
        return filename.split(' -> ')[1]
    else:
        return filename

def filterFilename(filename):
    source_file = filename.endswith(b".cpp")
    header_file = (filename.endswith(b".h") or filename.endswith(b".hpp") or filename.endswith(b".hxx"))

    return source_file or header_file

def getAllFiles(root_directory):
    files = []

    process = subprocess.Popen(["git", "ls-tree", "-r", "--name-only", "HEAD"], stdout=subprocess.PIPE, cwd=root_directory)
    for line in process.stdout:
        filename = line[:-1]
        if filterFilename(line[:-1]):
            files.append(filename)

    return files

def getModifiedFiles(root_directory):
    files = []

    process = subprocess.Popen(["git", "status", "--porcelain"], stdout=subprocess.PIPE, cwd=root_directory)
    for line in process.stdout:
        status = line[0:2]
        filename = line[3:-1]
        if filterGitStatus(status) and filterFilename(filename):
            filename=filterGitName(filename, status)
            files.append(filename)

    return files

def cpplint(root_directory, filename, filter):
    # Prepare cpplint command line
    cpplint_path = os.path.abspath(os.path.join(os.path.split(__file__)[0], "cpplint.py"))
    cmd = "python"
    if os.environ.get('DYNAWO_PYTHON_COMMAND') is not None:
        cmd = os.environ.get('DYNAWO_PYTHON_COMMAND')
    options = [cmd, cpplint_path, "--quiet", filename]
    if filter != None:
        options = [cmd, cpplint_path, "--quiet", "--filter", filter, filename]
    process = subprocess.Popen(options, stdout=subprocess.PIPE, cwd=root_directory)
    process.wait()

    return process.returncode

def usage(exitStatus):
    print >> sys.stderr, "Usage: %s [--modified | --all] --filter=<comma separated filters> <git-root-folder>" %(os.path.basename(sys.argv[0]))
    print >> sys.stderr, "--modified       Check only modified (track and untracked files)"
    print >> sys.stderr, "--all:           Check all files"
    print >> sys.stderr, "--filter:        category-filters to apply"

    sys.exit(exitStatus)

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h", ["modified", "all", "filter=", "help"])
    except getopt.GetoptError as err:
        print >> sys.stderr, str(err)
        usage(1)

    process_modified_files = False
    process_all_files = False
    filter = None
    for option,value in opts:
        if option == '--modified':
            process_modified_files = True
        elif option == '--all':
            process_all_files = True
        elif option == '--filter':
            filter = value
        elif option in ('-h', '--help'):
            usage(0)
        else:
            print >> sys.stderr, "Invalid option: %s" %(option)
            usage(1)

    if not (process_modified_files ^ process_all_files):
        print >> sys.stderr, "Required option not specified: all or modified"
        usage(1)

    if len(args) != 1:
        usage(1)
    root_directory = args[0]

    exitStatus = 0
    files = getAllFiles(root_directory) if process_all_files else getModifiedFiles(root_directory)
    for file in files:
        exitStatus += cpplint(root_directory, file, filter)
    sys.exit(exitStatus)

if __name__ == '__main__':
    main()
