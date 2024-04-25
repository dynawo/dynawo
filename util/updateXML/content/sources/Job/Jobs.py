# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.


import os
import sys
import traceback
import imp
import lxml.etree
from optparse import OptionParser
from collections import Counter

from ..utils.Common import *
from .JobData import JobData
from ..Dyd.Dyds import Dyds
from ..utils.UpdateXMLExceptions import *


class Jobs:
    """
    Represents a Job file

    Attributes
    ----------
    __jobs_collection : list[JobData]
        absolute filepath of the job parent directory
    __filename : str
        name of the Job file
    __jobtree : lxml.etree._ElementTree
        lxml ElementTree of job XML file
    dyds : Dyds
        attribute used to interact with Dyd files related to contained jobs
    __par_files_collection : dict[str, Par]
        collection of parsed Par files
    __curves_collection : dict[str, lxml.etree._ElementTree]
        collection of curves trees
    __final_state_values_collection : dict[str, lxml.etree._ElementTree]
        collection of final state values trees
    __update_modules_filepath_list : list[str]
        list of update modules to call to update XML files
    __dynawo_origin : tuple[int, int, int]
        dynawo origin version (starting point of the update)
    __dynawo_version : tuple[int, int, int]
        dynawo version to update
    __main_update_file_path : str
        path of the script launching all update scripts
    __outputs_path : str
        path of the folder containing the output XML files
    __script_folders : list[str]
        contains --scriptfolders option value : folders containing update scripts
    __selected_tickets_to_update : list[str]
        contains --tickets option value : selected tickets to update
    __does_print_logs : bool
        contains --log option value. If true, print applied tickets numbers in a log file.
    __does_update_nrt : bool
        if True, generate output files without gathering them in an output folder. The aim of this feature is to
        update Dynawo nrt input files.
    __does_add_dynawo_version : bool
        if True, add dynawo version as a comment at the top of XML files
    """
    def __init__(self):
        """
        Parse the Job file
        """
        parser = OptionParser()
        parser.add_option('--job', dest="job", type="string", help=u"job to update")
        parser.add_option('--origin', dest="origin", type="string", help=u"dynawo origin version")
        parser.add_option('--version', dest="version", type="string", help=u"dynawo version")
        parser.add_option('--tickets', dest="tickets_to_update", type="string", help=u"selected tickets to update")
        parser.add_option('-o', dest="outputs_path", type="string", help=u"outputs path")
        parser.add_option('--scriptfolders', dest="scriptfolders", type="string", help=u"folders containing update scripts")
        parser.add_option('--log', action="store_true", dest="log", help=u"generate an applied_tickets.log file to list the numbers of applied tickets")
        parser.add_option('--add-dynawo-version', action="store_true", dest="add_dynawo_version", help=u"add dynawo version as a comment at the top of XML files")
        parser.add_option('--update-nrt', action="store_true", dest="update_nrt", help=u"generate output files without gathering them in an output folder to replace")
        options, _ = parser.parse_args()

        if not options.job or \
                not options.origin or \
                not options.version or \
                (not options.outputs_path and not options.update_nrt) or \
                (options.outputs_path and options.update_nrt) or \
                (options.log and options.update_nrt):
            if not options.job:
                print("Error : No input job file (use --job option)")
            if not options.origin:
                print("Error : No input dynawo origin (use --origin option)")
            if not options.version:
                print("Error : No input dynawo version (use --version option)")
            if not options.outputs_path and not options.update_nrt:
                print("Error : No outputs path (use -o option)")
            if options.outputs_path and options.update_nrt:
                print("Error : You can't use both -o and --update-nrt options at the same time")
            if options.log and options.update_nrt:
                print("Error : You can't use both --log and --update-nrt options at the same time")
            sys.exit(1)

        self.__dynawo_origin = tuple(map(int, options.origin.split('.')))
        self.__dynawo_version = tuple(map(int, options.version.split('.')))

        if len(self.__dynawo_origin) != 3 or len(self.__dynawo_version) != 3:
            if len(self.__dynawo_origin) != 3:
                print("Error : origin should be this format MAJOR.MINOR.PATCH")
            if len(self.__dynawo_version) != 3:
                print("Error : version should be this format MAJOR.MINOR.PATCH")
            sys.exit(1)

        self.__script_folders = None
        if options.scriptfolders:
            script_folders_relative_paths = options.scriptfolders.split(',')
            self.__script_folders = [os.path.abspath(script_filepath) for script_filepath in script_folders_relative_paths]

        self.__selected_tickets_to_update = None
        if options.tickets_to_update:
            self.__selected_tickets_to_update = options.tickets_to_update.split(',')
            duplicate_tickets = [k for k, v in Counter(self.__selected_tickets_to_update).items() if v > 1]
            if len(duplicate_tickets) != 0:
                print("Error : input tickets contain duplicates :")
                for duplicate_ticket in duplicate_tickets:
                    print("ticket number " + duplicate_ticket)
                sys.exit(1)

        self.__get_update_modules_to_execute()

        filepath = os.path.abspath(options.job)
        if not os.path.isfile(filepath):
            print("Error : " + filepath + " is not a file.")
            sys.exit(1)
        self.__filename = os.path.basename(filepath)
        parent_directory = os.path.dirname(filepath)
        try:
            self.__jobtree = lxml.etree.parse(filepath)
        except OSError:
            print("Error : File " + filepath + " doesn't exist.")
            sys.exit(1)

        if options.outputs_path:
            self.__outputs_path = os.path.abspath(options.outputs_path)
        else:
            self.__outputs_path = None

        self.__does_print_logs = options.log
        self.__does_update_nrt = options.update_nrt
        self.__does_add_dynawo_version = options.add_dynawo_version

        self.__jobs_collection = list()
        self.__par_files_collection = dict()
        self.__curves_collection = dict()
        self.__final_state_values_collection = dict()

        self.dyds = Dyds()

        number_of_jobs = 0
        jobs_element = self.__jobtree.getroot()
        if jobs_element.tag != xmlns('jobs'):
            print("Error : File " + filepath + " is not a jobs file.")
            sys.exit(1)
        for job_element in jobs_element:
            if isinstance(job_element, lxml.etree._Comment):
                continue
            if job_element.tag == xmlns('job'):
                number_of_jobs += 1
                job = JobData(job_element.attrib['name'],
                                job_element,
                                parent_directory,
                                self.dyds._dyds_collection,
                                self.__par_files_collection,
                                self.__curves_collection,
                                self.__final_state_values_collection)
                self.__jobs_collection.append(job)
            else:
                raise UnknownJobElementError(job_element.tag)

        if number_of_jobs == 0:
            raise NoJobError(self.__jobtree.docinfo.URL)

    # ---------------------------------------------------------------
    #   UPDATE METHOD
    # ---------------------------------------------------------------

    def update(self):
        """
        Call update functions in every patch script of the directory
        """
        if self.__does_add_dynawo_version:
            self.__add_dynawo_version()

        for update_module_path in self.__update_modules_filepath_list:
            update_module_filename = os.path.basename(update_module_path)
            update_module_filename_without_extension = update_module_filename.split('.')[0]
            update_module = imp.load_source(update_module_filename_without_extension, update_module_path)
            if not self.__does_update_nrt and hasattr(update_module.update, 'ticket_number'):
                print("Apply ticket " + str(update_module.update.ticket_number))
            if self.__does_print_logs:
                pid = os.getpid()
                log_filename = "applied_tickets.log." + str(pid)
                outputs_dir_path = self.__create_output_dir()
                log_filepath = os.path.join(outputs_dir_path, log_filename)
                with open(log_filepath, 'a') as logfile:
                    print(update_module.update.ticket_number, file=logfile)
            update_module.update(self)
        self.__generate_configuration_files()

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def get_networks(self):
        networks = list()
        for job in self.__jobs_collection:
            networks.append(job.network)
        return networks

    def get_solvers(self):
        solvers = list()
        for job in self.__jobs_collection:
            solvers.append(job.solver)
        return solvers

    # ---------------------------------------------------------------
    #   UTILITY METHODS
    # ---------------------------------------------------------------

    def __get_update_modules_to_execute(self):
        """
        Populate __update_modules_filepath_list with the update modules file paths and check
        """
        call_stack = traceback.extract_stack()
        self.__main_update_file_path = os.path.abspath(call_stack[-3].filename)
        all_files_in_all_scripts_dirs = self.__get_all_files_in_all_scripts_dirs()
        sorted_update_modules_filepath_list = self.__get_update_modules_filepath_list(all_files_in_all_scripts_dirs)
        if self.__selected_tickets_to_update:
            self.__update_modules_filepath_list = self.__filter_update_modules(sorted_update_modules_filepath_list)
        else:
            self.__update_modules_filepath_list = sorted_update_modules_filepath_list

    def __get_all_files_in_all_scripts_dirs(self):
        """
        Get in a list all files in selected directories without checking if files are update scripts or not

        Returns:
            all_files_in_all_scripts_dirs (list[str]) : list of all files in selected directories
        """
        if self.__script_folders is None:
            update_scripts_dir_path = os.path.dirname(self.__main_update_file_path)
            files_in_script_dir = os.listdir(update_scripts_dir_path)
            all_files_in_all_scripts_dirs = [os.path.join(update_scripts_dir_path, script_filepath) for script_filepath in files_in_script_dir]
        else:
            all_files_in_all_scripts_dirs = list()
            for script_folder in self.__script_folders:
                if os.path.isfile(script_folder):
                    print("Error : " + script_folder + " is not a directory")
                    sys.exit(1)
                files_in_script_dir = os.listdir(script_folder)
                all_files_in_all_scripts_dirs.extend([os.path.join(script_folder, script_filepath) for script_filepath in files_in_script_dir])
        return all_files_in_all_scripts_dirs

    def __get_update_modules_filepath_list(self, all_files_in_all_scripts_dirs):
        """
        Get in a list all update scripts and order them according to the sequence they will be called

        Parameter:
            all_files_in_all_scripts_dirs (list[str]): list of all files in selected directories without checking if
                                                        they are update scripts or not

        Returns:
            sorted_update_modules_list (list[str]) : list of all update scripts in the order of call
        """
        unsorted_update_modules_list = list()
        all_update_filenames_in_all_scripts_dirs = set()
        duplicate_update_file_names = set()
        invalid_update_files = list()
        main_update_filename = os.path.basename(self.__main_update_file_path)
        main_update_filename_without_extension = os.path.splitext(main_update_filename)[0]
        for update_filepath in all_files_in_all_scripts_dirs:
            update_file = os.path.basename(update_filepath)
            if update_file.startswith(main_update_filename_without_extension) and \
                    update_file.endswith(PYTHON_FILE_EXTENSION) and \
                    update_file != main_update_filename:
                if (update_file in all_update_filenames_in_all_scripts_dirs):
                    duplicate_update_file_names.add(update_file)
                all_update_filenames_in_all_scripts_dirs.add(update_file)
                update_module = os.path.splitext(update_file)[0]
                module_version = update_module.split(main_update_filename_without_extension)[1]
                if not re.match(r'^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$', module_version):
                    invalid_update_files.append(update_file)
                    continue
                min_limit_version = (self.__dynawo_origin[0], self.__dynawo_origin[1], self.__dynawo_origin[2]+1)
                max_limit_version = (self.__dynawo_version[0], self.__dynawo_version[1], self.__dynawo_version[2]+1)
                if min_limit_version < tuple(map(int, module_version.split('.'))) < max_limit_version:
                    unsorted_update_modules_list.append(update_filepath)

        if len(duplicate_update_file_names) != 0:
            for duplicate_update_file_name in duplicate_update_file_names:
                print("Error : " + duplicate_update_file_name + " is a duplicate")
            sys.exit(1)
        if len(invalid_update_files) != 0:
            for invalid_update_file in invalid_update_files:
                print("Error : Invalid update file : " + invalid_update_file + "\nVersion should be in this format 'myUpdateFileMAJOR.MINOR.PATCH.NUMMODIF.py'")
            sys.exit(1)
        if len(unsorted_update_modules_list) == 0:
            print("Error : Patch files between version " + '.'.join(map(str, self.__dynawo_origin)) + "+ and " + '.'.join(map(str, self.__dynawo_version)) + " not found")
            sys.exit(1)

        sorted_update_modules_list = sorted(unsorted_update_modules_list, key=lambda update_filepath: os.path.basename(update_filepath))
        return sorted_update_modules_list

    def __filter_update_modules(self, sorted_update_modules_filepath_list):
        """
        Check if tickets given with --tickets option exist.

        Parameter:
            sorted_update_modules_filepath_list (list[str]): list of all update scripts in the order of call

        Returns:
            filtered_update_modules_filepath_list (list[str]): filtered list of update scripts
        """
        filtered_update_modules_filepath_list = list()
        all_tickets_list = list()

        for update_module_path in sorted_update_modules_filepath_list:
            update_module_filename = os.path.basename(update_module_path)
            update_module_filename_without_extension = update_module_filename.split('.')[0]
            update_module = imp.load_source(update_module_filename_without_extension, update_module_path)
            if hasattr(update_module.update, 'ticket_number'):
                all_tickets_list.append(update_module.update.ticket_number)
            if not hasattr(update_module.update, 'ticket_number'):
                continue
            if update_module.update.ticket_number not in self.__selected_tickets_to_update:
                continue
            filtered_update_modules_filepath_list.append(update_module_path)

        invalid_tickets = set()
        for selected_ticket_to_update in self.__selected_tickets_to_update:
            if selected_ticket_to_update not in all_tickets_list:
                invalid_tickets.add(selected_ticket_to_update)
        if len(invalid_tickets) != 0:
            print("Error : following tickets do not exist :")
            for invalid_ticket in invalid_tickets:
                print("ticket number " + invalid_ticket)
            sys.exit(1)

        return filtered_update_modules_filepath_list

    def __generate_configuration_files(self):
        """
        Generate configuration files
        """
        if self.__outputs_path:

            self.__check_duplicate_xml_filenames()
            outputs_dir_path = self.__create_output_dir()

            # Update Jobs file
            generated_job_file_path = os.path.join(outputs_dir_path, self.__filename)
            self.__jobtree.write(generated_job_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update Dyd files
            for dyd in self.dyds._dyds_collection.values():
                generated_dyd_file_path = os.path.join(outputs_dir_path, dyd._filename)
                format_xml_tree(dyd._dydtree.getroot())
                dyd._dydtree.write(generated_dyd_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update Par files
            for par in self.__par_files_collection.values():
                generated_par_file_path = os.path.join(outputs_dir_path, par._filename)
                format_xml_tree(par._partree.getroot())
                par._partree.write(generated_par_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update curves files
            for curves_tree in self.__curves_collection.values():
                curves_file_name = os.path.basename(curves_tree.docinfo.URL)
                generated_curves_file_path = os.path.join(outputs_dir_path, curves_file_name)
                format_xml_tree(curves_tree.getroot())
                curves_tree.write(generated_curves_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update final state values files
            for final_state_values_tree in self.__final_state_values_collection.values():
                final_state_values_name = os.path.basename(final_state_values_tree.docinfo.URL)
                generated_final_state_values_file_path = os.path.join(outputs_dir_path, final_state_values_name)
                format_xml_tree(final_state_values_tree.getroot())
                final_state_values_tree.write(generated_final_state_values_file_path,
                                                                        pretty_print=True,
                                                                        xml_declaration=True,
                                                                        encoding="utf-8")
        elif self.__does_update_nrt:
            # Update Jobs file
            self.__jobtree.write(self.__jobtree.docinfo.URL, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update Dyd files
            for dyd in self.dyds._dyds_collection.values():
                format_xml_tree(dyd._dydtree.getroot())
                dyd._dydtree.write(dyd._dydtree.docinfo.URL, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update Par files
            for par in self.__par_files_collection.values():
                format_xml_tree(par._partree.getroot())
                par._partree.write(par._partree.docinfo.URL, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update curves files
            for curves_tree in self.__curves_collection.values():
                format_xml_tree(curves_tree.getroot())
                curves_tree.write(curves_tree.docinfo.URL, pretty_print=True, xml_declaration=True, encoding="utf-8")

            # Update final state values files
            for final_state_values_tree in self.__final_state_values_collection.values():
                format_xml_tree(final_state_values_tree.getroot())
                final_state_values_tree.write(final_state_values_tree.docinfo.URL,
                                                                        pretty_print=True,
                                                                        xml_declaration=True,
                                                                        encoding="utf-8")
        else:
            print("Error : No outputs path (-o option) and no --update-nrt option")
            print("This should not happen.")
            sys.exit(1)

    def __check_duplicate_xml_filenames(self):
        """
        Check no file will have the same name in the output directory
        """
        duplicate_file_names = set()
        xml_filenames = set()

        xml_filenames.add(self.__filename)

        for dyd in self.dyds._dyds_collection.values():
            if dyd._filename in xml_filenames:
                duplicate_file_names.add(dyd._filename)
            xml_filenames.add(dyd._filename)

        for par in self.__par_files_collection.values():
            if par._filename in xml_filenames:
                duplicate_file_names.add(par._filename)
            xml_filenames.add(par._filename)

        for curves_tree in self.__curves_collection.values():
            curves_file_name = os.path.basename(curves_tree.docinfo.URL)
            if curves_file_name in xml_filenames:
                duplicate_file_names.add(curves_file_name)
            xml_filenames.add(curves_file_name)

        for final_state_values_tree in self.__final_state_values_collection.values():
            final_state_values_name = os.path.basename(final_state_values_tree.docinfo.URL)
            if final_state_values_name in xml_filenames:
                duplicate_file_names.add(final_state_values_name)
            xml_filenames.add(final_state_values_name)

        if len(duplicate_file_names) != 0:
            print("Error while generating output XML files. You can't generate output files with the same name in the same output directory :")
            for duplicate_file_name in duplicate_file_names:
                print("    '" + duplicate_file_name + "' file name is a duplicate")
            sys.exit(1)

    def __create_output_dir(self):
        """
        Create the output directory

        Returns:
            outputs_dir_path (str): output directory path
        """
        dynawo_version_str = '.'.join(map(str, self.__dynawo_version))
        outputs_dir_name = "outputs" + dynawo_version_str
        outputs_dir_path = os.path.join(self.__outputs_path, outputs_dir_name)
        if not os.path.exists(outputs_dir_path):
            os.makedirs(outputs_dir_path)
        return outputs_dir_path

    def __add_dynawo_version(self):
        """
        Add a comment containing the dynawo version above Job, Dyd and Par files
        """
        dynawo_version_message = "Dynawo version " + '.'.join(map(str, self.__dynawo_version))

        job_dynawo_version = lxml.etree.Comment(dynawo_version_message)
        self.__jobtree.getroot().addprevious(job_dynawo_version)

        for dyd in self.dyds._dyds_collection.values():
            dyd_dynawo_version = lxml.etree.Comment(dynawo_version_message)
            dyd._dydtree.getroot().addprevious(dyd_dynawo_version)

        for par in self.__par_files_collection.values():
            par_dynawo_version = lxml.etree.Comment(dynawo_version_message)
            par._partree.getroot().addprevious(par_dynawo_version)

        for curves_tree in self.__curves_collection.values():
            curves_dynawo_version = lxml.etree.Comment(dynawo_version_message)
            curves_tree.getroot().addprevious(curves_dynawo_version)

        for final_state_values_tree in self.__final_state_values_collection.values():
            final_state_values_dynawo_version = lxml.etree.Comment(dynawo_version_message)
            final_state_values_tree.getroot().addprevious(final_state_values_dynawo_version)


def format_xml_tree(root_element):
    container_xml_elements = [xmlns(XML_BLACKBOXMODEL),
                                xmlns(XML_MODELICAMODEL),
                                xmlns(XML_MODELTEMPLATE),
                                xmlns(XML_MODELTEMPLATEEXPANSION),
                                xmlns(XML_MACROCONNECTOR),
                                xmlns(XML_MACROSTATICREFERENCE),
                                xmlns(XML_SET)]
    root_element.text = XML_SIMPLE_INDENTATION
    for idx1 in range(len(root_element)-1):
        first_level_elem = root_element[idx1]
        if len(first_level_elem) != 0:
            first_level_elem.text = XML_DOUBLE_INDENTATION
        first_level_elem.tail = XML_SIMPLE_INDENTATION
        if first_level_elem.tag in container_xml_elements:
            first_level_elem.tail = XML_SIMPLE_INDENTATION
            for idx2 in range(len(first_level_elem)-1):
                first_level_elem[idx2].tail = XML_DOUBLE_INDENTATION
            if len(first_level_elem) == 0:
                first_level_elem.tail = XML_SIMPLE_INDENTATION
                if first_level_elem.text is not None:
                    first_level_elem.text = XML_SIMPLE_INDENTATION
            else:
                first_level_elem[-1].tail = XML_SIMPLE_INDENTATION
    if len(root_element) != 0:
        last_first_level_elem = root_element[-1]
        if last_first_level_elem.tag in container_xml_elements:
            for idx3 in range(len(last_first_level_elem)-1):
                last_first_level_elem[idx3].tail = XML_DOUBLE_INDENTATION
            if len(last_first_level_elem) != 0:
                last_first_level_elem.text = XML_DOUBLE_INDENTATION
                last_first_level_elem[-1].tail = XML_SIMPLE_INDENTATION
            else:
                if last_first_level_elem.text is not None:
                    last_first_level_elem.text = XML_SIMPLE_INDENTATION
        last_first_level_elem.tail = XML_ESCAPE_SEQUENCE
