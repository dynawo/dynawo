import clang.cindex
from clang.cindex import CursorKind, AccessSpecifier, Config
import json
import re
import sys
import os

def parse_cpp_file(file_path):
    index = clang.cindex.Index.create()
    omc_includes = os.environ['DYNAWO_INSTALL_OPENMODELICA'] + "/include/omc/c"
    adept_includes = os.environ['DYNAWO_ADEPT_INSTALL_DIR'] + "/include"
    xerces_includes = os.environ['DYNAWO_XERCESC_INSTALL_DIR'] + "/include"
    libxml_includes = os.environ['DYNAWO_LIBXML_HOME'] + "/include"
    boost_includes = os.environ['DYNAWO_BOOST_HOME'] + "/include"
    dynawo_includes = os.environ['DYNAWO_INSTALL_DIR'] + "/include"
    additional_includes = []
    if 'ADDITIONAL_INCLUDE_FOLDER' in os.environ:
        folders = os.environ['ADDITIONAL_INCLUDE_FOLDER'].split(";")
        for folder in folders:
            additional_includes.append(folder)
    options = ["-D_ADEPT_=1", "-E", "-P",
         "-I" + omc_includes,
         "-I" + adept_includes,
         "-I" + xerces_includes,
         "-I" + libxml_includes,
         "-I" + boost_includes,
         "-I" + dynawo_includes]
    if additional_includes:
        for additional_include in additional_includes:
            options.append("-I" + additional_include)
    if 'DYNAWO_ADDITIONAL_INCLUDE_FOR_PREASSEMBLED' in os.environ:
        dynawo_additional_includes = os.environ['DYNAWO_ADDITIONAL_INCLUDE_FOR_PREASSEMBLED']
        options.append("-I" + dynawo_additional_includes)
    tu = index.parse(file_path, options)
    for diag in tu.diagnostics:
      print(diag)
    return tu.cursor

def find_evalFAdept_function(cursor):
    for child in cursor.get_children():
        if child.kind == CursorKind.NAMESPACE:
            if child.spelling == 'DYN':
                for child_child in child.get_children():
                    if child_child.kind == CursorKind.CXX_METHOD and child_child.spelling == 'evalFAdept':
                        return child_child
    return None

def get_code_snippet(node):
    start = node.extent.start.offset
    end = node.extent.end.offset
    with open(node.translation_unit.spelling, 'r') as f:
        f.seek(start)
        return f.read(end - start).strip()

def main(input_file, model_name, model_type):
    cursor = parse_cpp_file(input_file)
    func_cursor = find_evalFAdept_function(cursor)

    if not func_cursor:
        print("Fonction evalFAdept non trouvée.")
        return

    initial_code = get_code_snippet(func_cursor)
    output_code = []

    initial_code_lines = initial_code.splitlines()
    numBracket = 0
    for line in initial_code_lines:
        line = line.replace(model_name + "_" + model_type + "::", "")
        line = line.replace("const std::vector<adept::adouble> & x,", "")
        line = line.replace("const std::vector<adept::adouble> & xd,", "")
        line = line.replace("std::vector<adept::adouble> & res", "")
        line = line.replace("adept::adouble", "adouble")
        line = line.replace("data->localData[0]->", "")
        line = line.replace("data->simulationInfo->", "")
        line = line.replace("data->constCalcVars", "constCalcVars")
        line = line.replace("RELATIONHYSTERESIS", "tmpHysteresis = RELATIONHYSTERESIS")
        line = line.replace("derDelayImpl(data,", "derDelayImpl(")
        line = line.replace("throwStreamPrintWithEquationIndexes( equationIndexes,", "throwStreamPrintWithEquationIndexes(")
        pattern = r'x\[(\d+)\]\.value\(\)'
        line = re.sub(pattern, r'xValue[\1]', line)
        if '}if' in line:
            indent_pattern = r'(\s*).*'
            match_indent = re.search(indent_pattern, line)
            line = line.replace('}if', "}\n" + match_indent.group(1) + "if")

        if 'derDelayImpl' in line:
            pattern = r'derDelayImpl\(\s*(\d+)\s*,\s*x\[(\d+)],\s*timeValue\s*,\s*(?:realParameter\[(\d+)\]|(.*?))\s*,\s*(?:realParameter\[(\d+)\]|(.*?))\s*\)'
            match = re.search(pattern, line)
            indent_pattern = r'(\s*).*'
            match_indent = re.search(indent_pattern, line)
            tmpDelay = line.split(' = ')[0].strip()
            output_code.append(match_indent.group(1) + f"const DelayManager& delayManager{match.group(1)} = getModelManager()->getDelayManager();")
            output_code.append(match_indent.group(1) + f"const Delay& delay{match.group(1)} = delayManager{match.group(1)}.getDelayById({match.group(1)});")
            if match.group(3) is not None and match.group(5) is not None:
                output_code.append(match_indent.group(1) + f"incorrectDelay(realParameter[{match.group(3)}], timeValue, realParameter[{match.group(5)}]);")
            elif match.group(4) is not None and match.group(6) is not None:
                output_code.append(match_indent.group(1) + f"incorrectDelay({match.group(4)}, timeValue, {match.group(6)});")
            output_code.append(match_indent.group(1) + f"if (doubleIsZero(timeValue) || !delay{match.group(1)}.isTriggered()) " + "{")
            output_code.append(match_indent.group(1) + f"  {tmpDelay} = 0.;")
            output_code.append(match_indent.group(1) + "} else {")
            output_code.append(match_indent.group(1) + f"  const auto values{match.group(1)} = delay{match.group(1)}.getLastRegisteredPoint();")
            output_code.append(match_indent.group(1) + f"  const auto lastRegisteredTime{match.group(1)} = values{match.group(1)}.first;")
            output_code.append(match_indent.group(1) + f"  const auto lastRegisteredValue{match.group(1)} = values{match.group(1)}.second;")
            if match.group(3) is not None:
                output_code.append(match_indent.group(1) + f"  if (timeValue - realParameter[{match.group(3)}] < lastRegisteredTime{match.group(1)} || doubleEquals(timeValue - realParameter[{match.group(3)}], lastRegisteredTime{match.group(1)})) " + "{")
                output_code.append(match_indent.group(1) + f"    {tmpDelay} = delayManager{match.group(1)}.getDelay({match.group(1)}, realParameter[{match.group(3)}]);")
                output_code.append(match_indent.group(1) + "  } else {")
                output_code.append(match_indent.group(1) + f"    {tmpDelay} = lastRegisteredValue{match.group(1)} + (x[{match.group(2)}] - lastRegisteredValue{match.group(1)}) * (timeValue - realParameter[{match.group(3)}] - lastRegisteredTime{match.group(1)}) / (timeValue - lastRegisteredTime{match.group(1)});")
            elif match.group(4) is not None:
                output_code.append(match_indent.group(1) + f"  if (timeValue - {match.group(4)} < lastRegisteredTime{match.group(1)} || doubleEquals(timeValue - {match.group(4)}, lastRegisteredTime{match.group(1)})) " + "{")
                output_code.append(match_indent.group(1) + f"    {tmpDelay} = delayManager{match.group(1)}.getDelay({match.group(1)}, {match.group(4)});")
                output_code.append(match_indent.group(1) + "  } else {")
                output_code.append(match_indent.group(1) + f"    {tmpDelay} = lastRegisteredValue{match.group(1)} + (x[{match.group(2)}] - lastRegisteredValue{match.group(1)}) * (timeValue - {match.group(4)} - lastRegisteredTime{match.group(1)}) / (timeValue - lastRegisteredTime{match.group(1)});")
            output_code.append(match_indent.group(1) + "  }")
            output_code.append(match_indent.group(1) + "}")

        if 'derDelayImpl' not in line:
            output_code.append(line)
        if numBracket == 0 and '{' in line:
            declarations = """  double tmpHysteresis;
  double x[10000];
  double xd[10000];
  double xValue[10000];
  double res[10000];
  double discreteVars[10000];
  double realParameter[10000];
  double timeValue;
  double extObjs[10000];
  double constCalcVars[10000];
  double integerDoubleVars[10000];
  double realVarsPre[10000];
  double discreteVarsPre[10000];
  int integerParameter[10000];"""
            output_code.append(declarations)
            numBracket += 1
    if 'DYNAWO_INSTALL_DIR' not in os.environ:
        print('DYNAWO_INSTALL_DIR environment variable should be defined.')
        sys.exit(1)
    dynawo_install_dir = os.environ['DYNAWO_INSTALL_DIR']
    with open(dynawo_install_dir + '/sbin/methodsEvalFAdept.cpp', 'r') as fMethods:
        methodsCode = fMethods.read()

    with open(input_file.replace('.cpp', '.in.cpp'), 'w') as f:
        f.write(methodsCode)
        f.write("\n")
        f.write("\n")
        f.write("\n".join(output_code))

if __name__ == '__main__':
    print("start extract")
    file = sys.argv[1]
    model_name = sys.argv[2]
    model_type = sys.argv[3]
    main(file, model_name, model_type)
