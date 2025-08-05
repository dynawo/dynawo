import os, sys

def find_mo_files(directory):
    mo_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.mo'):
                if 'package' not in file and 'Examples' not in root and 'VariableImpedantFault' not in file:
                    mo_files.append(os.path.join(root, file))
    return mo_files

def is_line_empty(line):
    return not line.strip()

def findAllBlocks(directory):
    mo_files = find_mo_files(directory)

    excluded_keys = []
    with open('excluded_lines.txt', 'r') as exclude_lines_file:
        lines = exclude_lines_file.readlines()
        for line in lines:
            excluded_keys.append(line.strip())

    for mo_file in mo_files:
        with open(mo_file, 'r') as file:
            lines = file.readlines()
            inside_model_section = False
            start_equation = False

            for line in lines:
                line = line.strip()
                if 'model' in line and not start_equation:
                    inside_model_section = True
                if 'equation' in line:
                    inside_model_section = False
                    start_equation = True

                if inside_model_section:
                    if not any(excluded_key in line for excluded_key in excluded_keys) and not is_line_empty(line):
                        if line != 'annotation(':
                            print(line)

if __name__ == "__main__":
    directory = sys.argv[1]
    findAllBlocks(directory)
