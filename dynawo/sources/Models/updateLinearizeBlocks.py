import os, sys
from findAllBlocks import find_mo_files

def updateLinearizeBlocks(path):
    directory = path
    mo_files = find_mo_files(directory)

    linearizeBlocks = {
        'Modelica.Blocks.Nonlinear.Limiter': 'Dynawo.NonElectrical.Blocks.Linear.Limiter'
    }

    for mo_file in mo_files:
        modelica_name = mo_file.split('/')[-1].split('.')[0]
        with open(mo_file, 'r') as file:
            lines = file.readlines()
            inside_model_section = False
            start_equation = False
            modified_lines = []
            file_modified = False

            for line in lines:
                if 'model' in line and not start_equation:
                    inside_model_section = True
                if 'equation' in line:
                    inside_model_section = False
                    start_equation = True

                if inside_model_section:
                    modified_line = line
                    for block, linearizeBlock in linearizeBlocks.items():
                        if block in modified_line:
                            modified_line = modified_line.replace(block, linearizeBlock)
                            file_modified = True
                    modified_lines.append(modified_line)
                else:
                    modified_lines.append(line)

        if file_modified:
            print(modelica_name + " modified")
            with open(mo_file, 'w') as file:
                file.writelines(modified_lines)

if __name__ == "__main__":
    path = sys.argv[1]
    updateLinearizeBlocks(path)
