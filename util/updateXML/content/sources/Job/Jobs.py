import os
import sys
import traceback
import imp
import lxml.etree

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
    __update_modules_list : list[str]
        list of update modules to call to update XML files
    __dynawo_version : tuple[int, int, int]
        dynawo version to update
    __dynawo_origin : tuple[int, int, int]
        dynawo origin version (starting point of the update)
    __outputs_path : str
        path of the folder containing the output XML files
    __does_update_nrt : bool
        if True, generate output files without gathering them in an output folder. The aim of this feature is to
        update Dynawo nrt input files.
    """
    def __init__(self):
        """
        Parse the Job file
        """
        options = get_command_line_options()

        if not options.job or not options.origin or not options.version or not options.outputs_path:
            if not options.job:
                print("No input job file (use --job option)")
            if not options.origin:
                print("No input dynawo origin (use --origin option)")
            if not options.version:
                print("No input dynawo version (use --version option)")
            if not options.outputs_path:
                print("No outputs path (use -o option)")
            sys.exit(1)

        dynawo_origin_str = str(options.origin)
        dynawo_version_str = str(options.version)
        self.__dynawo_origin = tuple(map(int, dynawo_origin_str.split('.')))
        self.__dynawo_version = tuple(map(int, dynawo_version_str.split('.')))

        if len(self.__dynawo_origin) != 3 or len(self.__dynawo_version) != 3:
            if len(self.__dynawo_origin) != 3:
                print("origin should be this format MAJOR.MINOR.PATCH")
            if len(self.__dynawo_version) != 3:
                print("version should be this format MAJOR.MINOR.PATCH")
            sys.exit(1)

        script_folders = None
        if options.scriptfolders:
            script_folders_relative_paths = options.scriptfolders.split(',')
            script_folders = [os.path.abspath(script_filepath) for script_filepath in script_folders_relative_paths]

        self.__get_update_modules_list(script_folders)

        filepath = os.path.abspath(options.job)
        self.__filename = os.path.basename(filepath)
        parent_directory = os.path.dirname(filepath)
        try:
            self.__jobtree = lxml.etree.parse(filepath)
        except OSError:
            print("Error : File " + filepath + " doesn't exist.")
            sys.exit(1)

        self.__outputs_path = os.path.abspath(options.outputs_path)

        if options.update_nrt:
            self.__does_update_nrt = True
        else:
            self.__does_update_nrt = False

        self.__jobs_collection = list()
        self.__par_files_collection = dict()
        self.__curves_collection = dict()
        self.__final_state_values_collection = dict()

        self.dyds = Dyds()

        number_of_jobs = 0
        jobs_element = self.__jobtree.getroot()
        for job_element in jobs_element:
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

        self.__add_dynawo_version()

    # ---------------------------------------------------------------
    #   UPDATE METHOD
    # ---------------------------------------------------------------

    def update(self):
        """
        Call update functions in every patch script of the directory
        """
        if len(self.__update_modules_list) == 0:
            print("Patch files not found")
            sys.exit(1)
        for update_module_path in self.__update_modules_list:
            update_module_filename = os.path.basename(update_module_path)
            update_module_filename_without_extension = update_module_filename.split('.')[0]
            update_module = imp.load_source(update_module_filename_without_extension, update_module_path)
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

    def __get_update_modules_list(self, script_folders=None):
        """
        Populate __update_modules_list with the update modules
        """
        call_stack = traceback.extract_stack()
        main_update_file_path = os.path.abspath(call_stack[-3].filename)
        main_update_filename = os.path.basename(main_update_file_path)
        main_update_filename_without_extension = os.path.splitext(main_update_filename)[0]
        if script_folders is None:
            update_scripts_dir_path = os.path.dirname(main_update_file_path)
            files_in_script_dir = os.listdir(update_scripts_dir_path)
            files_in_all_scripts_dirs = [os.path.join(update_scripts_dir_path, script_filepath) for script_filepath in files_in_script_dir]
        else:
            files_in_all_scripts_dirs = list()
            for script_folder in script_folders:
                if os.path.isfile(script_folder):
                    print("Error : " + script_folder + " is not a directory")
                    sys.exit(1)
                files_in_script_dir = os.listdir(script_folder)
                files_in_all_scripts_dirs.extend([os.path.join(script_folder, script_filepath) for script_filepath in files_in_script_dir])

        unsorted_update_modules_list = list()
        invalid_update_files = list()
        for update_filepath in files_in_all_scripts_dirs:
            update_file = os.path.basename(update_filepath)
            if update_file.startswith(main_update_filename_without_extension) and \
                    update_file.endswith(PYTHON_FILE_EXTENSION) and \
                    update_file != main_update_filename:
                update_module = os.path.splitext(update_file)[0]
                module_version = update_module.split(main_update_filename_without_extension)[1]
                if not re.match(r'^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$', module_version):
                    invalid_update_files.append(update_file)
                    continue
                min_limit_version = (self.__dynawo_origin[0], self.__dynawo_origin[1], self.__dynawo_origin[2]+1)
                max_limit_version = (self.__dynawo_version[0], self.__dynawo_version[1], self.__dynawo_version[2]+1)
                if min_limit_version < tuple(map(int, module_version.split('.'))) < max_limit_version:
                    unsorted_update_modules_list.append(update_filepath)
        self.__update_modules_list = sorted(unsorted_update_modules_list, key=lambda update_filepath: os.path.basename(update_filepath))

        if len(invalid_update_files) != 0:
            for invalid_update_file in invalid_update_files:
                print("Invalid update file error : " + invalid_update_file + "\nVersion should be in this format 'myUpdateFileMAJOR.MINOR.PATCH.NUMMODIF.py'")
            sys.exit(1)

    def __generate_configuration_files(self):
        """
        Generate configuration files
        """
        if self.__does_update_nrt:
            outputs_dir_path = self.__outputs_path
        else:
            outputs_dir_name = "outputs" + '.'.join(map(str, self.__dynawo_version))
            outputs_dir_path = os.path.join(self.__outputs_path, outputs_dir_name)
            if not os.path.exists(outputs_dir_path):
                os.makedirs(outputs_dir_path)

        generated_job_file_path = os.path.join(outputs_dir_path, self.__filename)
        self.__jobtree.write(generated_job_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

        # WARNING : If several Dyd files have the same name, some files won't be generated properly.
        #           This is because when two files have the exact same name, the write method will erase the previous
        #           generated Dyd file to generate the new one with the same name
        for dyd in self.dyds._dyds_collection.values():
            generated_dyd_file_path = os.path.join(outputs_dir_path, dyd._filename)
            format_xml_tree(dyd._dydtree.getroot())
            dyd._dydtree.write(generated_dyd_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

        # WARNING : If several Par files have the same name, some files won't be generated properly.
        #           This is because when two files have the exact same name, the write method will erase the previous
        #           generated Par file to generate the new one with the same name
        for par in self.__par_files_collection.values():
            generated_par_file_path = os.path.join(outputs_dir_path, par._filename)
            format_xml_tree(par._partree.getroot())
            par._partree.write(generated_par_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

        # WARNING : If several curves files have the same name, some files won't be generated properly.
        #           This is because when two files have the exact same name, the write method will erase the previous
        #           generated CRV file to generate the new one with the same name
        for curves_tree in self.__curves_collection.values():
            curves_file_name = os.path.basename(curves_tree.docinfo.URL)
            generated_curves_file_path = os.path.join(outputs_dir_path, curves_file_name)
            format_xml_tree(curves_tree.getroot())
            curves_tree.write(generated_curves_file_path, pretty_print=True, xml_declaration=True, encoding="utf-8")

        # WARNING : If several final state values files have the same name, some files won't be generated properly.
        #           This is because when two files have the exact same name, the write method will erase the previous
        #           generated FSV file to generate the new one with the same name
        for final_state_values_tree in self.__final_state_values_collection.values():
            final_state_values_name = os.path.basename(final_state_values_tree.docinfo.URL)
            generated_final_state_values_file_path = os.path.join(outputs_dir_path, final_state_values_name)
            format_xml_tree(final_state_values_tree.getroot())
            final_state_values_tree.write(generated_final_state_values_file_path,
                                                                    pretty_print=True,
                                                                    xml_declaration=True,
                                                                    encoding="utf-8")

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
