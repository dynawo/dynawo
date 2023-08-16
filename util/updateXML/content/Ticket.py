import os
import sys

parent_dir = os.path.abspath(os.path.dirname(__file__))
sys.path.append(parent_dir)
from sources.utils.Common import *


def ticket(num_ticket):
    print("Apply ticket " + str(num_ticket))
    options = get_command_line_options()
    if options.log:
        dynawo_version_str = str(options.version)
        outputs_path = os.path.abspath(options.outputs_path)
        if options.update_nrt:
            outputs_dir_path = outputs_path
        else:
            outputs_dir_name = "outputs" + dynawo_version_str
            outputs_dir_path = os.path.join(outputs_path, outputs_dir_name)
        pid = os.getpid()
        log_filename = "applied_tickets.log." + str(pid)
        log_filepath = os.path.join(outputs_dir_path, log_filename)
        if not os.path.exists(outputs_dir_path):
            os.makedirs(outputs_dir_path)
        with open(log_filepath, 'a') as fichier:
            print(str(num_ticket), file=fichier)
    def new_function(func):
        return func
    return new_function
