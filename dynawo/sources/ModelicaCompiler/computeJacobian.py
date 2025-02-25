import sys
import os
import clang.cindex
from clang.cindex import CursorKind
import json
import re
import sympy as sp

def parse_cpp_file(file_path, model_type):
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
    options = ["-ferror-limit=200",
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
    if model_type == 'Dyn':
        for diag in tu.diagnostics:
            if 'unknown type' in diag.spelling or 'use of undeclared identifier' in diag.spelling:
                print("Issue with handling parts of the residual.")
                sys.exit(1)
    return tu.cursor

def find_evalFAdept_function(cursor):
    for child in cursor.get_children():
        if child.kind == CursorKind.FUNCTION_DECL and child.spelling == 'evalFAdept':
            return child
    return None

def extract_code_block(node):
    code = []
    for child in node.get_children():
        if child.kind == CursorKind.IF_STMT:
            code.append(process_if_stmt(child))
        elif child.kind == CursorKind.COMPOUND_STMT:
            code.extend(extract_compound_stmt(child))
        else:
            if 'res[' not in get_code_snippet(child):
                code.append(get_code_snippet(child))
    return code

def process_if_stmt(if_node):
    condition = get_code_snippet(list(if_node.get_children())[0])
    then_block = extract_compound_stmt(list(if_node.get_children())[1])
    then_variables = extract_variables(then_block)
    else_block = []
    else_variables = {}
    if len(list(if_node.get_children())) > 2:
        if list(if_node.get_children())[2]:
            else_block = extract_compound_stmt(list(if_node.get_children())[2])
            else_variables = extract_variables(else_block)

    if not else_block:
        if len(then_block) == 1 and 'throwStreamPrintWithEquationIndexes' in then_block[0]:
            line = then_block[0]
            line = line.replace('throwStreamPrintWithEquationIndexes(', 'throwStreamPrintWithEquationIndexes(' + condition + ',')
            return line
        pattern = r'\(\s*\(\s*modelica_integer\s*\)\s*1\s*\)\s*\+\s*\(\s*modelica_integer\s*\)\s*\b(?:integerParameter|integerDoubleVars)\b\[(\d+)\]\s*==\s*(\d+)'
        match = re.search(pattern, condition)
        if match:
            return {
                'type': 'if_statement',
                'condition': condition,
                'then': {"code": then_block, "variables": then_variables}
            }

    return {
        'type': 'if_statement',
        'condition': condition,
        'then': {"code": then_block, "variables": then_variables},
        'else': {"code": else_block, "variables": else_variables}
    }

def extract_compound_stmt(compound_node):
    code_lines = []
    if compound_node.kind == CursorKind.BINARY_OPERATOR:
        code_lines.append(get_code_snippet(compound_node))
        return code_lines
    for child in compound_node.get_children():
        if child.kind == CursorKind.IF_STMT:
            code_lines.append(process_if_stmt(child))
        elif child.kind == CursorKind.BINARY_OPERATOR:
            code = get_code_snippet(child)
            code_lines.append(code)
        elif child.kind == CursorKind.DECL_STMT:
            code_lines.append(get_code_snippet(child))
        elif child.kind == CursorKind.COMPOUND_STMT:
            code_lines.extend(extract_compound_stmt(child))
        elif child.kind == CursorKind.UNEXPOSED_EXPR and 'throwStreamPrintWithEquationIndexes' in get_code_snippet(child):
            code_lines.append(get_code_snippet(child))
        elif child.kind == CursorKind.CALL_EXPR and child.spelling == 'operator=':
            code = get_code_snippet(child)
            if 'omc_Complex_adept' in code or 'omc_ComplexInput_adept' in code:
                for child_child in child.get_children():
                    if child_child.kind == CursorKind.UNEXPOSED_EXPR:
                        for child_child_child in child_child.get_children():
                            if child_child_child.kind == CursorKind.CALL_EXPR and (child_child_child.spelling == 'omc_Complex_adept' or child_child_child.spelling == 'omc_ComplexInput_adept'):
                                args = [get_code_snippet(arg) for arg in child_child_child.get_arguments()]
                                tmpVar = code.split('=')[0].strip()
                                code_lines.append(tmpVar + "._re = " + args[0])
                                code_lines.append(tmpVar + "._im = " + args[1])
            else:
                code_lines.append(code)

    return code_lines

def get_code_snippet(node):
    start = node.extent.start.offset
    end = node.extent.end.offset
    with open(node.translation_unit.spelling, 'r') as f:
        f.seek(start)
        return f.read(end - start).strip()

def extract_residual_index(node):
    code = get_code_snippet(node)
    match = re.search(r'res\[(\d+)\]', code)
    return int(match.group(1)) if match else None

def extract_variables(block):
    variables = {}
    for line in block:
        if isinstance(line, str) and 'throwStreamPrintWithEquationIndexes' not in line:
            var_assign_match = re.match(r'(.*)\s*=\s*(.*)', line)
            if var_assign_match:
                var = var_assign_match.group(1).strip()
                value = var_assign_match.group(2)
                variables[var] = value
        else:
            if isinstance(line, dict):
                if 'else' in line and line['then']['variables'].keys() == line['else']['variables'].keys():
                    for variable in line['then']['variables']:
                        variables[variable] = None

    return variables

def find_closest_value(lst, target):
    # Initialize the closest value to the first element in the list
    closest_value = lst[0]

    # Iterate through the list to find the closest value
    for value in lst:
        if abs(value - target) < abs(closest_value - target):
            closest_value = value

    return closest_value

def extract_residual_blocks(func_cursor):
    residuals = []

    nodes = []
    num_stmt = 0
    for node in func_cursor.walk_preorder():
        if num_stmt > 1:
            nodes.append(node)
        num_stmt += 1
        if node.kind == CursorKind.BINARY_OPERATOR and 'res' in get_code_snippet(node):
            lhs = list(node.get_children())[0]
            if lhs.kind == CursorKind.ARRAY_SUBSCRIPT_EXPR:
                res_index = extract_residual_index(lhs)
                if res_index is not None:
                    residual_equation = get_code_snippet(node)
                    parent_node = None
                    for nodeTest in nodes:
                      if nodeTest.kind == CursorKind.COMPOUND_STMT and parent_node == None:
                          parent_node = nodeTest
                          break
                    if parent_node is not None:
                        block = extract_code_block(parent_node)
                        variables = extract_variables(block)
                    else:
                        block = [get_code_snippet(node)]
                        variables = {}
                    if '._re' in residual_equation or '._im' in residual_equation:
                        tmpVars = []
                        for var in variables:
                            if var in residual_equation:
                                tmpVars.append(var)
                        indices = []
                        for tmpVar in tmpVars:
                            indices.append([i for i, line in enumerate(block) if tmpVar in line and '=' in line][0])
                        indexToKeep = max(indices)
                        numOfIf = 0
                        block = block[:indexToKeep + 1]
                        block_indices = []
                        for i, line in enumerate(block):
                            if isinstance(line, dict):
                                numOfIf += 1
                                block_indices.append(i)
                        if numOfIf > 1:
                            if block_indices:
                                closest_index = find_closest_value(block_indices, indexToKeep)
                                indices_to_remove = [value for value in block_indices if value != closest_index]
                                for index_to_remove in reversed(indices_to_remove):
                                    block.pop(index_to_remove)

                    residuals.append({'index': res_index, 'block': {'code': block, 'variables': variables}, 'residual_equation': residual_equation})
                    if not ('._re' in residual_equation or '._im' in residual_equation):
                        nodes = []

    return residuals

def expand_powers(match):
  base, exponent = match.groups()
  return "(" + "*".join((["(" + base + ")"]) * int(exponent)) + ")"

def is_fraction_with_x(expr, x):
    if expr.is_Mul:
        has_x = False
        has_inverse = False
        for arg in expr.args:
            if arg == x:
                has_x = True
            elif arg.is_Pow and arg.exp.is_negative:
                has_inverse = True
        return has_x and has_inverse
    return False

def get_denominator(expr):
    for arg in expr.args:
        if arg.is_Pow and arg.exp.is_negative:
            return arg.base
    return None

def smart_power_processing(expr, x):
    if expr.is_Pow:
        base, exponent = expr.args

        # Cas spécial pour (x/a)^alpha
        if is_fraction_with_x(base, x):
            if isinstance(exponent, sp.Symbol) and len(exponent.name) > 1:  # alpha, beta, etc.
                denominator = get_denominator(base)
                return exponent * (x / denominator) ** (exponent - 1) * (1 / denominator)

        # Cas des puissances simples avec x
        if base == x and isinstance(exponent, sp.Symbol):
            if len(exponent.name) > 1:
                return exponent * x ** (exponent - 1)
            return sp.diff(expr, x)

    # Traitement récursif des sous-expressions
    if expr.is_Add:
        return sp.Add(*[smart_power_processing(arg, x) for arg in expr.args])
    if expr.is_Mul:
        # Utiliser la règle du produit
        terms = list(expr.args)
        result = 0
        for i in range(len(terms)):
            term = terms[i]
            other_terms = sp.Mul(*terms[:i] + terms[i + 1:])
            processed_term = smart_power_processing(term, x)
            if processed_term != 0:
                result += other_terms * processed_term
        return result

    return sp.diff(expr, x)

def smart_derivative(expr, x):
    return smart_power_processing(expr, x)

def derivExpr(deriv_expr, tmpsOmc, lineIndex):
    deriv_expr_comment = None
    # deriv_expr = sp.powsimp(deriv_expr, force=True)
    if not deriv_expr.has(sp.zoo):
        deriv_expr = sp.ccode(deriv_expr)
        deriv_expr = re.sub(r'x\[(\d+)\]', lambda m: f'x{m.group(1)}', deriv_expr)
        # deriv_expr = re.sub(r"pow\(\s*([^,]*)\s*,\s*([23456789])\)", expand_powers, deriv_expr)
        deriv_expr_comment = deriv_expr
        deriv_expr = re.sub(r'x(\d+)', lambda m: f'data->localData[0]->realVars[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r'xd\[(\d+)\]', lambda m: f'data->localData[0]->derivativesVars[{m.group(1)}]', str(deriv_expr))
        for tmpOmc in tmpsOmc:
            if tmpOmc in deriv_expr:
                deriv_expr = deriv_expr.replace(tmpOmc, tmpsOmc[tmpOmc])
                if "getDerValue" in tmpsOmc[tmpOmc]:
                    deriv_expr = deriv_expr.replace("ModelicaStandardTables_CombiTable1D_getDerValue_adept", "omc_Modelica_Blocks_Tables_Internal_getDerTable1DValue")
                    deriv_expr = re.sub(r"(omc_Modelica_Blocks_Tables_Internal_getDerTable1DValue\(.*, )(x\[\d+\])\)", r"\1" + r"\2, 1)", deriv_expr)

                    deriv_expr = deriv_expr.replace("ModelicaStandardTables_CombiTable2D_getDerValue_adept", "omc_Modelica_Blocks_Tables_Internal_getDerTable2DValue")
                    deriv_expr = re.sub(r"(omc_Modelica_Blocks_Tables_Internal_getDerTable2DValue\(.*, )(x\[\d+\]), (x\[\d+\])\)", r"\1" + r"\2, " + r"\3, 1, 1)", deriv_expr)

                    deriv_expr = deriv_expr.replace("ModelicaStandardTables_CombiTimeTable_getDerValue_adept", "omc_Modelica_Blocks_Tables_Internal_getDerTimeTableValue")
                    deriv_expr = re.sub(r"(omc_Modelica_Blocks_Tables_Internal_getDerTimeTableValue\(.*, )(x\[\d+\]),(.*)\)", r"\1" + r"\2,\3, 1)", deriv_expr)
        deriv_expr = re.sub(r"realParameter(\d+)", lambda m: f'data->simulationInfo->realParameter[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r"constCalcVars(\d+)", lambda m: f'data->constCalcVars[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r"timeValue", 'data->localData[0]->timeValue', deriv_expr)
        deriv_expr = re.sub(r'x\[(\d+)\]', lambda m: f'data->localData[0]->realVars[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r'xValue\[(\d+)\]', lambda m: f'data->localData[0]->realVars[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r'extObjs\[(\d+)\]', lambda m: f'data->simulationInfo->extObjs[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r"discreteVars(\d+)", lambda m: f'data->localData[0]->discreteVars[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r"discreteVarsPre(\d+)", lambda m: f'data->simulationInfo->discreteVarsPre[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r"integerParameter(\d+)", lambda m: f'data->simulationInfo->integerParameter[{m.group(1)}]', deriv_expr)
        deriv_expr = re.sub(r"integerDoubleVars(\d+)", lambda m: f'((modelica_real)((modelica_integer)data->localData[0]->integerDoubleVars[{m.group(1)}]))', deriv_expr)
        deriv_expr = deriv_expr.replace('*', ' * ').replace('/', ' / ')
    else:
        deriv_expr_comment = str(deriv_expr) + " = nan"
        deriv_expr = "nan"

    if deriv_expr != "nan":
        lineAddTerm = f"jt.addTerm({lineIndex} + rowOffset, {str(deriv_expr)});\n\n"
    else:
        lineAddTerm = f"throw DYNError(Error::MODELER, SparseMatrixWithNanInf, modelManager_->modelType(), modelManager_->name());\n\n"

    deriv_expr_comment = re.sub(r'x(\d+)', lambda m: f'x[{m.group(1)}]', deriv_expr_comment)
    deriv_expr_comment = re.sub(r"realParameter(\d+)", r"realParameter[\1]", deriv_expr_comment)
    deriv_expr_comment = deriv_expr_comment.replace('*', ' * ').replace('/', ' / ')

    return lineAddTerm, deriv_expr_comment

def line_replacements(line):
    replacements = [
        (r"discreteVars\[(\d+)\]", lambda m: f'data->localData[0]->discreteVars[{m.group(1)}]'),
        (r"discreteVarsPre\[(\d+)\]", lambda m: f'data->simulationInfo->discreteVarsPre[{m.group(1)}]'),
        (r"integerParameter\[(\d+)\]", lambda m: f'data->simulationInfo->integerParameter[{m.group(1)}]'),
        (r"integerDoubleVars\[(\d+)\]", lambda m: f'data->localData[0]->integerDoubleVars[{m.group(1)}]'),
        (r"realVarsPre\[(\d+)\]", lambda m: f'data->simulationInfo->realVarsPre[{m.group(1)}]'),
        (r"timeValue", 'data->localData[0]->timeValue'),
        (r'xValue\[(\d+)\]', lambda m: f'data->localData[0]->realVars[{m.group(1)}]'),
        (r'x\[(\d+)\]', lambda m: f'data->localData[0]->realVars[{m.group(1)}]'),
        (r'xd\[(\d+)\]', lambda m: f'data->localData[0]->derivativesVars[{m.group(1)}]'),
        (r"realParameter\[(\d+)\]", lambda m: f'data->simulationInfo->realParameter[{m.group(1)}]'),
        (r"constCalcVars\[?(\d+)\]?", lambda m: f'data->constCalcVars[{m.group(1)}]')
    ]

    for pattern, replacement in replacements:
        line = re.sub(pattern, replacement, line)

    line = line.replace('tmpHysteresis = ', '')

    return line

def condition_replacements(condition):
    replacements = [
        (r"realParameter\[(\d+)\]", lambda m: f'data->simulationInfo->realParameter[{m.group(1)}]'),
        (r"integerDoubleVars\[(\d+)\]", lambda m: f'data->localData[0]->integerDoubleVars[{m.group(1)}]'),
        (r"integerParameter\[(\d+)\]", lambda m: f'data->simulationInfo->integerParameter[{m.group(1)}]'),
        (r"discreteVars\[(\d+)\]", lambda m: f'data->localData[0]->discreteVars[{m.group(1)}]'),
        (r"timeValue", 'data->localData[0]->timeValue'),
        (r'x\[(\d+)\]', lambda m: f'data->localData[0]->realVars[{m.group(1)}]'),
        (r'xd\[(\d+)\]', lambda m: f'data->localData[0]->derivativesVars[{m.group(1)}]')
    ]

    for pattern, replacement in replacements:
        condition = re.sub(pattern, replacement, condition)

    return condition

def residual_replacements(res):
    replacements = [
        (r"realParameter\[(\d+)\]", r"realParameter\1"),
        (r"discreteVars\[(\d+)\]", r"discreteVars\1"),
        (r"discreteVarsPre\[(\d+)\]", r"discreteVarsPre\1"),
        (r"integerParameter\[(\d+)\]", r"integerParameter\1"),
        (r"\(\(\s*modelica_real\s*\)\(\(\s*modelica_integer\s*\)\s*integerDoubleVars\[(\d+)\]\s*\)\)", r"integerDoubleVars\1"),
        (r"realVarsPre\[(\d+)\]", r"realVarsPre\1"),
        (r"constCalcVars\[(\d+)\]", r"constCalcVars\1")
    ]

    for pattern, replacement in replacements:
        res = re.sub(pattern, replacement, res)

    return res

def block_variables(block_code, then_else_block_variables):
    removed_variables = set()
    for line in block_code:
        if not isinstance(line, str):
            condition = line['condition']
            then_block_variables = line['then']['variables']
            then_else_block_variables.update(then_block_variables.keys())
            then_removed_variables_internal = block_variables(line['then']['code'], then_else_block_variables)
            to_remove = []
            for remove_variable in then_removed_variables_internal:
                for variable in then_else_block_variables:
                    if then_block_variables[remove_variable] is not None and variable in then_block_variables[remove_variable]:
                        to_remove.append(variable)
            else_block_variables = line['else']['variables']
            then_else_block_variables.update(else_block_variables.keys())
            else_removed_variables_internal = block_variables(line['else']['code'], then_else_block_variables)
            for remove_variable in else_removed_variables_internal:
                for variable in then_else_block_variables:
                    if else_block_variables[remove_variable] is not None and variable in else_block_variables[remove_variable]:
                        to_remove.append(variable)
            if condition in then_else_block_variables:
                then_else_block_variables.remove(condition)
                removed_variables.add(condition)
            for variable in then_else_block_variables:
                if variable in condition:
                    to_remove.append(variable)
                    removed_variables.add(variable)
            for variable in then_else_block_variables:
                for line in block_code:
                    if variable + " = " in line:
                        removed_variables.add(variable)
            for var_remove in to_remove:
                if var_remove in then_else_block_variables:
                    then_else_block_variables.remove(var_remove)
    return removed_variables

def merge_dicos(block_vars, else_block_variables):
    merged_dict = {**block_vars}

    for key, value in else_block_variables.items():
        if value is not None or key not in block_vars:
            merged_dict[key] = value

    return merged_dict

def print_block_code(residual_code, evalF_code, jacobian_code, jacobian_prim_code, block_code, tmp_vars_replaced, block_vars, residual_equation, residual_index, indent, skip_delay_evalF):
    indent_str = "  "
    residual_equation_init = residual_equation
    indent_init = indent
    indent += 1
    with_if = False
    sym_exprs = {}
    x = sp.IndexedBase('x', shape=(50,))
    xd = sp.IndexedBase('xd', shape=(50,))
    cj = sp.symbols('cj')
    with_if_tmp = False
    then_else_block_variables = set()
    for line in block_code:
        if not isinstance(line, str):
            with_if_tmp = True
            condition = line['condition']
            then_block_variables = line['then']['variables']
            then_else_block_variables.update(then_block_variables.keys())
            removed_variables = block_variables(line['then']['code'], then_else_block_variables)
            to_remove = []
            for remove_variable in removed_variables:
                for variable in then_else_block_variables:
                    if then_block_variables[remove_variable] is not None and variable in then_block_variables[remove_variable]:
                        to_remove.append(variable)
            if 'else' in line:
                else_block_variables = line['else']['variables']
                then_else_block_variables.update(else_block_variables.keys())
                removed_variables = block_variables(line['else']['code'], then_else_block_variables)
                for remove_variable in removed_variables:
                    for variable in then_else_block_variables:
                        if else_block_variables[remove_variable] is not None and variable in else_block_variables[remove_variable]:
                            to_remove.append(variable)
            if condition in then_else_block_variables:
                then_else_block_variables.remove(condition)
            for variable in then_else_block_variables:
                if variable in condition:
                    to_remove.append(variable)
                    removed_variables.add(variable)

            for var_remove in to_remove:
                if var_remove in then_else_block_variables:
                    then_else_block_variables.remove(var_remove)
            break
    then_else_block_variables_replaced = set(then_else_block_variables)
    delay_vars_removed = []
    for var in then_else_block_variables_replaced:
        if 'const Delay&' in var or 'const DelayManager&' in var or 'const auto lastRegisteredTime' in var or 'const auto lastRegisteredValue' in var or 'const auto values' in var:
            delay_vars_removed.append(var)
    for delay_var_removed in delay_vars_removed:
        then_else_block_variables_replaced.remove(delay_var_removed)
    for line in block_code:
        if isinstance(line, str):
            if not line.endswith(";"):
                line = line + ";"
            if not any(tmp in line for tmp in tmp_vars_replaced) or "throwStreamPrintWithEquationIndexes" in line:
                if "throwStreamPrintWithEquationIndexes" in line:
                    pattern = r'throwStreamPrintWithEquationIndexes\(\s*([^,]*)\s*,\s*(".*")\s*,\s*([^,]*)\s*\)'
                    match = re.search(pattern, line)
                    condition_throw = match.group(1)
                    for variable in reversed(block_vars):
                        escapedVar = re.escape(variable)
                        patternVariable = rf'{escapedVar}\b'
                        if re.search(patternVariable, condition_throw) and block_vars[variable] is not None:
                            condition_throw = condition_throw.replace(variable, "(" + block_vars[variable] + ")")
                    arg1 = match.group(2)
                    arg2 = match.group(3)
                    for variable in reversed(block_vars):
                        if variable in arg2 and block_vars[variable] is not None:
                            arg2 = arg2.replace(variable, "(" + block_vars[variable] + ")")

                    line = 'throwStreamPrintWithEquationIndexes(equationIndexes, ' + arg1 + ', ' + arg2 + ');'
                    line = "if (" + condition_throw + ") {\n" + indent_str * indent + "  " + line + "\n" + indent_str * indent + "}\n"
                if not with_if_tmp:
                    residual_code.append(indent_str * indent + line + '\n')
                    if 'delayManager' not in line:
                        evalF_line = line_replacements(line)
                        evalF_line = evalF_line.replace('adouble', 'modelica_real')
                        evalF_line = evalF_line.replace('Complex_adept', 'Complex')
                        evalF_code.append(indent_str * indent + evalF_line + '\n')

                    jacobian_line = line_replacements(line)
                    jacobian_line = jacobian_line.replace('adouble', 'modelica_real')
                    jacobian_line = jacobian_line.replace('Complex_adept', 'Complex')

                    jacobian_code.append(indent_str * indent + jacobian_line + '\n')
                    jacobian_prim_code.append(indent_str * indent + jacobian_line + '\n')
                else:
                    if not any(tmp in line for tmp in then_else_block_variables_replaced) or 'tmpHysteresis' in line:
                        residual_code.append(indent_str * indent + line + '\n')

                        evalF_line = line_replacements(line)

                        jacobian_line = line_replacements(line)
                        if 'RELATIONHYSTERESIS' in jacobian_line:
                            evalF_line = evalF_line.replace('<adouble>', '')
                            jacobian_line = jacobian_line.replace('<adouble>', '')
                        else:
                            evalF_line = evalF_line.replace('adouble', 'modelica_real')
                            evalF_line = evalF_line.replace('Complex_adept', 'Complex')
                            jacobian_line = jacobian_line.replace('adouble', 'modelica_real')
                            jacobian_line = jacobian_line.replace('Complex_adept', 'Complex')

                        if 'incorrectDelay' not in jacobian_line:
                            if 'delayManager' not in line and 'lastRegistered' not in line and 'getLastRegisteredPoint' not in line and not skip_delay_evalF:
                                evalF_code.append(indent_str * indent + evalF_line + '\n')
                            jacobian_code.append(indent_str * indent + jacobian_line + '\n')
                            jacobian_prim_code.append(indent_str * indent + jacobian_line + '\n')
                        else:
                            match = re.search(r'incorrectDelay\(\s*realParameter\[(\d+)\]\s*,\s*timeValue\s*,\s*realParameter\[(\d+)\]\s*\)', line)

                            jacobian_code.append(indent_str * indent + f"if (data->simulationInfo->realParameter[{match.group(1)}] > data->simulationInfo->realParameter[{match.group(2)}] || data->simulationInfo->realParameter[{match.group(1)}] < 0.0) " + "{\n")
                            jacobian_code.append(indent_str * indent + "  " + jacobian_line.replace('incorrectDelay(', 'throw DYNError(DYN::Error::SIMULATION, IncorrectDelay, ') + ';\n')
                            jacobian_code.append(indent_str * indent + "}" '\n')

                            jacobian_prim_code.append(indent_str * indent + f"if (data->simulationInfo->realParameter[{match.group(1)}] > data->simulationInfo->realParameter[{match.group(2)}] || data->simulationInfo->realParameter[{match.group(1)}] < 0.0) " + "{\n")
                            jacobian_prim_code.append(indent_str * indent + "  " + jacobian_line.replace('incorrectDelay(', 'throw DYNError(DYN::Error::SIMULATION, IncorrectDelay, ') + '\n')
                            jacobian_prim_code.append(indent_str * indent + "}" '\n')
        else:
            with_if = True
            condition = line['condition']
            residual_code.append(indent_str * indent + "if (" + condition + ') {\n')

            condition = condition_replacements(condition)
            if 'delay' not in condition and 'lastRegistered' not in condition:
                evalF_code.append(indent_str * indent + "if (" + condition + ') {\n')
            else:
                skip_delay_evalF = True

            jacobian_code.append(indent_str * indent + "if (" + condition + ') {\n')
            jacobian_prim_code.append(indent_str * indent + "if (" + condition + ') {\n')

            then_block = line['then']
            then_block_code = then_block['code']
            then_block_variables = then_block['variables']
            tmp_vars_replaced_if = []
            for variable in reversed(then_block_variables):
                escapedVar = re.escape(variable)
                patternVariable = rf'{escapedVar}\b'
                if re.search(patternVariable, residual_equation) and then_block_variables[variable] is not None:
                    tmp_vars_replaced_if.append(variable)
                    if '._re' not in residual_equation and '._im' not in residual_equation:
                        residual_equation = residual_equation.replace(variable, "(" + then_block_variables[variable] + ")")
                    else:
                        residual_equation = residual_equation.replace(variable, then_block_variables[variable])
            for variable in reversed(block_vars):
                escapedVar = re.escape(variable)
                patternVariable = rf'{escapedVar}\b'
                if re.search(patternVariable, residual_equation) and block_vars[variable] is not None:
                    if '._re' not in residual_equation and '._im' not in residual_equation:
                        residual_equation = residual_equation.replace(variable, "(" + block_vars[variable] + ")")
                    else:
                        residual_equation = residual_equation.replace(variable, block_vars[variable])

            print_block_code(residual_code, evalF_code, jacobian_code, jacobian_prim_code, then_block_code, tmp_vars_replaced_if, merge_dicos(block_vars, then_block_variables), residual_equation, residual_index, indent, skip_delay_evalF)

            residual_equation = residual_equation_init
            if 'else' in line:
                else_block = line['else']
                else_block_code = else_block['code']
                if else_block_code:
                    else_block_variables = else_block['variables']
                    tmp_vars_replaced_else = []
                    for variable in reversed(else_block_variables):
                        escapedVar = re.escape(variable)
                        patternVariable = rf'{escapedVar}\b'
                        if re.search(patternVariable, residual_equation) and else_block_variables[variable] is not None:
                            tmp_vars_replaced_else.append(variable)
                            if '._re' not in residual_equation and '._im' not in residual_equation:
                                residual_equation = residual_equation.replace(variable, "(" + else_block_variables[variable] + ")")
                            else:
                                residual_equation = residual_equation.replace(variable, else_block_variables[variable])
                    for variable in reversed(block_vars):
                        escapedVar = re.escape(variable)
                        patternVariable = rf'{escapedVar}\b'
                        if re.search(patternVariable, residual_equation) and block_vars[variable] is not None:
                            if '._re' not in residual_equation and '._im' not in residual_equation:
                                residual_equation = residual_equation.replace(variable, "(" + block_vars[variable] + ")")
                            else:
                                residual_equation = residual_equation.replace(variable, block_vars[variable])

                    residual_code.append(indent_str * indent + "} else {\n")
                    if 'delay' not in condition and 'lastRegistered' not in condition:
                        evalF_code.append(indent_str * indent + "} else {\n")
                    jacobian_code.append(indent_str * indent + "} else {\n")
                    jacobian_prim_code.append(indent_str * indent + "} else {\n")

                    print_block_code(residual_code, evalF_code, jacobian_code, jacobian_prim_code, else_block_code, tmp_vars_replaced_else, merge_dicos(block_vars, else_block_variables), residual_equation, residual_index, indent, skip_delay_evalF)

            residual_code.append(indent_str * indent + "}\n")
            if 'delay' not in condition and 'lastRegistered' not in condition:
                evalF_code.append(indent_str * indent + "}\n")
            jacobian_code.append(indent_str * indent + "}\n")
            jacobian_prim_code.append(indent_str * indent + "}\n")
    if not with_if:
        residual_code.append(indent_str * indent + residual_equation + '\n')

        res_expr = residual_equation
        indices_match = re.findall(r'x[d]*\[(\d+)\]', res_expr)
        indices = sorted([int(index) for index in indices_match])

        res_expr = residual_replacements(res_expr)
        rhs_res_expr = res_expr.split(' = ')[1]
        tmpsOmc = {}
        i_tmpOmc = 0
        if 'omc_Modelica_Blocks_Tables_Internal_getTable1DValue' in rhs_res_expr and 'NoDer' not in rhs_res_expr:
            pattern = r'omc_Modelica_Blocks_Tables_Internal_getTable1DValue\(\s*extObjs\[\d+\],\s*\(\(modelica_integer\).*\),\s*\w*(\[)?\d+(\])?\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc, rhs_res_expr)
            i_tmpOmc += 1
        if 'omc_Modelica_Blocks_Tables_Internal_getTable1DValueNoDer' in rhs_res_expr:
            pattern = r'omc_Modelica_Blocks_Tables_Internal_getTable1DValueNoDer\(\s*extObjs\[\d+\],\s*\(\(modelica_integer\).*\),\s*\w*(\[)?\d+(\])?\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc, rhs_res_expr)
            i_tmpOmc += 1
        if 'omc_Modelica_Blocks_Tables_Internal_getTimeTableValue' in rhs_res_expr and 'NoDer' not in rhs_res_expr:
            pattern = r'omc_Modelica_Blocks_Tables_Internal_getTimeTableValue\(\s*extObjs\[\d+\],\s*\(\(modelica_integer\).*\),\s*\w*(\[)?\d+(\])?\s*,\s*\w*(\[)?\d+(\])?\s*,\s*\w*(\[)?\d+(\])?\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc, rhs_res_expr)
            i_tmpOmc += 1
        if 'omc_Modelica_Blocks_Tables_Internal_getTimeTableValueNoDer' in rhs_res_expr:
            pattern = r'omc_Modelica_Blocks_Tables_Internal_getTimeTableValueNoDer\(\s*extObjs\[\d+\],\s*\(\(modelica_integer\).*\),\s*\w*(\[)?\d+(\])?\s*,\s*\w*(\[)?\d+(\])?\s*,\s*\w*(\[)?\d+(\])?\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc, rhs_res_expr)
            i_tmpOmc += 1
        if 'ModelicaStandardTables_CombiTable1D_getDerValue_adept' in rhs_res_expr:
            pattern = r'ModelicaStandardTables_CombiTable1D_getDerValue_adept\(\s*extObjs\[\d+\],\s*\(\(modelica_integer\).*\),\s*(x\[\d+\])\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc + "*" + match.group(1), rhs_res_expr)
            i_tmpOmc += 1
        if 'ModelicaStandardTables_CombiTable2D_getDerValue_adept' in rhs_res_expr:
            pattern = r'ModelicaStandardTables_CombiTable2D_getDerValue_adept\(\s*extObjs\[\d+\],\s*(x\[\d+\])\s*,\s*(x\[\d+\])\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc + "*" + match.group(1) + " + " + tmpOmc + "*" + match.group(2), rhs_res_expr)
            i_tmpOmc += 1
        if 'ModelicaStandardTables_CombiTimeTable_getDerValue_adept' in rhs_res_expr:
            pattern = r'ModelicaStandardTables_CombiTimeTable_getDerValue_adept\(\s*extObjs\[\d+\],\s*\(\(modelica_integer\).*\),\s*(x\[\d+\])\s*\,\s*\w*(\[)?\d+(\])?\s*,\s*\w*(\[)?\d+(\])?\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc + "*" + match.group(1), rhs_res_expr)
            i_tmpOmc += 1
        if re.search(r'delayManager\d+[.]getDelay', rhs_res_expr):
            pattern = r'delayManager\d+[.]getDelay\(\s*(\d+)\s*,\s*(?:realParameter\[(\d+)\]|(.*?))\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc, rhs_res_expr)
            i_tmpOmc += 1
        if 'min_real_array' in rhs_res_expr or 'max_real_array' in rhs_res_expr:
            pattern = r'(?:min|max)_real_array\(\s*(\w*\d+)\s*\)'
            match = re.search(pattern, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(pattern, tmpOmc, rhs_res_expr)
            i_tmpOmc += 1
            tmpVar = match.group(1)
            for block_line in block_code:
                if tmpVar in block_line:
                    variables_match = re.findall(r'x[d]*\[\d+\]', block_line)
                    if variables_match:
                        print("In " + tmpVar + " a variable is present but not handled in " + block_line)
                        sys.exit(1)
        pattern1 = r'(\(modelica_integer\)integerDoubleVars\[\d+\])'
        pattern2 = r'(\(modelica_integer\)\s*\d+)'
        pattern3 = r'(\(modelica_real\))'
        while re.search(pattern1, rhs_res_expr) or re.search(pattern2, rhs_res_expr) or re.search(pattern3, rhs_res_expr):
            if re.search(pattern1, rhs_res_expr):
                match = re.search(pattern1, rhs_res_expr)
                tmpOmc = "tempOmc" + str(i_tmpOmc)
                tmpsOmc[tmpOmc] = match.group(0)
                rhs_res_expr = re.sub(pattern1, tmpOmc, rhs_res_expr, 1)
                i_tmpOmc += 1
            if re.search(pattern2, rhs_res_expr):
                match = re.search(pattern2, rhs_res_expr)
                tmpOmc = "tempOmc" + str(i_tmpOmc)
                tmpsOmc[tmpOmc] = match.group(0)
                rhs_res_expr = re.sub(pattern2, tmpOmc, rhs_res_expr, 1)
                i_tmpOmc += 1
            if re.search(pattern3, rhs_res_expr):
                match = re.search(pattern3, rhs_res_expr)
                tmpOmc = "tempOmc" + str(i_tmpOmc)
                tmpsOmc[tmpOmc] = match.group(0)
                rhs_res_expr = re.sub(pattern3, tmpOmc, rhs_res_expr, 1)
                i_tmpOmc += 1
        patternComplex = r'realParameter\d+[.]_(?:re|im)'
        if re.search(patternComplex, rhs_res_expr):
            match = re.search(patternComplex, rhs_res_expr)
            tmpOmc = "tempOmc" + str(i_tmpOmc)
            tmpsOmc[tmpOmc] = match.group(0)
            rhs_res_expr = re.sub(patternComplex, tmpOmc, rhs_res_expr)
            i_tmpOmc += 1
        if re.search(r"tmp[0-9]*", rhs_res_expr):
            print("tmp is present in " + rhs_res_expr)
            sys.exit(1)
        sp_res_expr = sp.sympify(rhs_res_expr, locals={'x': x, 'xd': xd, **sym_exprs})
        # derivs_x = [sp.diff(sp_res_expr, x[i]) for i in range(max(indices)+1)]
        # derivs_xd = [sp.diff(sp_res_expr, xd[i]) for i in range(max(indices) + 1)]
        derivs_x = [smart_derivative(sp_res_expr, x[i]) for i in range(max(indices)+1)]
        derivs_xd = [smart_derivative(sp_res_expr, xd[i]) for i in range(max(indices) + 1)]
        derivs = []
        for deriv_x, deriv_xd in zip(derivs_x, derivs_xd):
            derivs.append(deriv_x + cj * deriv_xd)
        rhs_res_expr_comment = rhs_res_expr
        rhs_res_expr_comment = re.sub(r"realParameter(\d+)", r"realParameter[\1]", rhs_res_expr_comment)

        if not skip_delay_evalF:
            evalF_code.append(indent_str * indent + "// res[" + str(residual_index) + "] = " + rhs_res_expr_comment + '\n')
            evalF_line = line_replacements(residual_equation)
            if not evalF_line.endswith(";"):
                evalF_line = evalF_line + ";"
            evalF_line = evalF_line.replace('ModelicaStandardTables_CombiTable1D_getDerValue_adept', 'omc_Modelica_Blocks_Tables_Internal_getTable1DValue')
            evalF_line = evalF_line.replace('ModelicaStandardTables_CombiTable2D_getDerValue_adept', 'omc_Modelica_Blocks_Tables_Internal_getTable2DValue')
            evalF_line = evalF_line.replace('ModelicaStandardTables_CombiTimeTable_getDerValue_adept', 'omc_Modelica_Blocks_Tables_Internal_getTimeTableValue')
            evalF_line = re.sub(r'extObjs\[(\d+)\]', lambda m: f'data->simulationInfo->extObjs[{m.group(1)}]', evalF_line)
            evalF_code.append(indent_str * indent + evalF_line + "\n")
        else:
            if 'getDelay' in residual_equation:
                pattern = r'x\[(\d+)\]\s*-\s*\((.*)delayManager\d+[.]getDelay\((\d+),\s*(?:realParameter\[(\d+)\]|(.*?))\)(.*)\)'
                match = re.search(pattern, residual_equation)
                if match:
                    if match.group(4) is not None:
                        evalF_line = f"res[{residual_index}] = x[{match.group(1)}] - ({match.group(2)} delayImpl(data, {match.group(3)}, x[{match.group(1)}], timeValue, realParameter[{match.group(4)}], realParameter[{match.group(4)}]){match.group(6)});"
                    elif match.group(5) is not None:
                        evalF_line = f"res[{residual_index}] = x[{match.group(1)}] - ({match.group(2)} delayImpl(data, {match.group(3)}, x[{match.group(1)}], timeValue, {match.group(5)}, {match.group(5)}){match.group(6)});"
                    evalF_line = line_replacements(evalF_line)
                    evalF_code.append(indent_str * (indent - 2) + evalF_line + "\n")

        jacobian_code.append(indent_str * indent + "// res[" + str(residual_index) + "] = " + rhs_res_expr_comment + '\n')
        jacobian_code.append(indent_str * indent + "jt.changeCol();" + '\n\n')
        jacobian_prim_code.append(indent_str * indent + "// " + rhs_res_expr_comment + '\n')
        jacobian_prim_code.append(indent_str * indent + "jt.changeCol();" + '\n\n')
        for i, deriv_expr in enumerate(derivs):
            if deriv_expr != 0:
                lineAddTerm, deriv_expr_comment = derivExpr(deriv_expr, tmpsOmc, i)
                jacobian_code.append(indent_str * indent + "// dres[" + str(residual_index) + "]/dx[" + str(i) + "] = " + deriv_expr_comment + '\n')
                jacobian_code.append(indent_str * indent + lineAddTerm)
        for i, deriv_expr in enumerate(derivs_xd):
            if deriv_expr != 0:
                lineAddTerm, deriv_expr_comment = derivExpr(deriv_expr, tmpsOmc, i)
                jacobian_prim_code.append(indent_str * indent + "// dres[" + str(residual_index) + "]/dx[" + str(i) + "] = " + deriv_expr_comment + '\n')
                jacobian_prim_code.append(indent_str * indent + lineAddTerm)

    indent = indent_init

def jacobian(residuals, input_path, input_filename, model_name, model_type):

    residual_code = []
    residual_code.append("void " + model_name + "_" + model_type + "::evalF()\n")
    residual_code.append("{\n")

    evalF_code = []
    evalF_code.append("void " + model_name + "_" + model_type + "::evalF(double* res, propertyF_t type)\n")
    evalF_code.append("{\n")

    jacobian_code = []
    jacobian_code.append("void " + model_name + "_" + model_type + "::evalJt(double cj, SparseMatrix& jt, int rowOffset)\n")
    jacobian_code.append("{\n")

    jacobian_prim_code = []
    jacobian_prim_code.append("void " + model_name + "_" + model_type + "::evalJtPrim(double cj, SparseMatrix& jt, int rowOffset)\n")
    jacobian_prim_code.append("{\n")

    indent_str = "  "

    for residual in residuals:
        indent = 1
        residual_equation = residual['residual_equation']
        residual_code.append(indent_str * indent + "{\n")

        evalF_code.append(indent_str * indent + "{\n")

        jacobian_code.append(indent_str * indent + f"// {residual_equation.split(' = ')[0]}\n")
        jacobian_code.append(indent_str * indent + "{\n")

        jacobian_prim_code.append(indent_str * indent + f"// {residual_equation.split(' = ')[0]}\n")
        jacobian_prim_code.append(indent_str * indent + "{\n")

        residual_index = residual['index']
        block = residual['block']
        block_code = block['code']
        block_variables = block['variables']
        tmp_vars_replaced = []
        for variable in reversed(block_variables):
            escapedVar = re.escape(variable)
            patternVariable = rf'{escapedVar}\b'
            if re.search(patternVariable, residual_equation) and block_variables[variable] is not None:
                tmp_vars_replaced.append(variable)
                if '._re' not in residual_equation and '._im' not in residual_equation:
                    residual_equation = residual_equation.replace(variable, "(" + block_variables[variable] + ")")
                else:
                    residual_equation = residual_equation.replace(variable, block_variables[variable])
        print_block_code(residual_code, evalF_code, jacobian_code, jacobian_prim_code, block_code, tmp_vars_replaced, block_variables, residual_equation, residual_index, indent, False)

        residual_code.append(indent_str * indent + "}\n")
        evalF_code.append(indent_str * indent + "}\n")
        jacobian_code.append(indent_str * indent + "}\n")
        jacobian_prim_code.append(indent_str * indent + "}\n")

        residual_code.append("\n")
        evalF_code.append("\n")
        jacobian_code.append("\n")
        jacobian_prim_code.append("\n")

    residual_code.append("}\n")
    evalF_code.append("}\n")
    jacobian_code.append("}\n")
    jacobian_prim_code.append("}\n")

    with open(input_path + '/' + input_filename.replace('.nocomment.in.cpp', '') + '_evalF.cpp', 'w') as f:
        f.writelines(residual_code)

    with open(input_path + '/' + input_filename.replace('.nocomment.in.cpp', '') + '_evalJ.cpp', 'w') as f:
        f.write('#include "DYNSparseMatrix.h"\n')
        f.write('#include "DYNDelayManager.h"\n')
        f.write('#include "DYNModelManager.h"\n')
        f.write('#pragma GCC diagnostic ignored "-Wunused-parameter"\n')
        f.write('#include "' + input_filename.replace('_' + model_type + '.nocomment.in.cpp', '') + '_' + model_type + '.h"\n')
        f.write('#include "' + input_filename.replace('_' + model_type + '.nocomment.in.cpp', '') + '_' + model_type + '_definition.h"\n')
        f.write('#include "' + input_filename.replace('_' + model_type + '.nocomment.in.cpp', '') + '_' + model_type + '_literal.h"\n')
        f.write("\n")
        f.write("namespace DYN {\n")
        f.write("\n")
        f.writelines(jacobian_code)
        f.write("\n")
        f.writelines(jacobian_prim_code)
        f.write("\n")
        f.write("void " + model_name + "_" + model_type + "::evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const\n")
        f.write("{\n")
        # f.write(f'std::cout << "{model_name}_{model_type} evalJCalculatedVarI" << std::endl;\n')
        f.write("}\n")
        f.write("\n")
        f.writelines(evalF_code)
        f.write("\n")
        f.write("}\n")

    return residual_code

def countIf(block_code, block_variables):
    if_blocks = [(index, code) for index, code in enumerate(block_code) if isinstance(code, dict)]
    pattern = r'\(\s*\(\s*modelica_integer\s*\)\s*1\s*\)\s*\+\s*\(\s*modelica_integer\s*\)\s*\b(?:integerParameter|integerDoubleVars)\b\[(\d+)\]\s*==\s*(\d+)'

    if not any('else' in if_block[1] for if_block in if_blocks) and all(re.match(pattern, if_block[1]['condition']) for if_block in if_blocks):
        parameter_indices = []
        parameter_values = []
        for if_block in if_blocks:
            match = re.search(pattern, if_block[1]['condition'])
            parameter_indices.append(match.group(1))
            parameter_values.append(match.group(2))
        parameter_index = set(parameter_indices)
        if len(parameter_index) == 1 and len(parameter_values) == len(set(parameter_values)):
            return

    if len(if_blocks) == 1:
        then_block = if_blocks[0][1]['then']
        then_block_code = then_block['code']
        then_block_variables = then_block['variables']
        countIf(then_block_code, then_block_variables)
        else_block = if_blocks[0][1]['else']
        else_block_code = else_block['code']
        else_block_variables = else_block['variables']
        countIf(else_block_code, else_block_variables)

    if len(if_blocks) >= 2:
        while len(if_blocks) > 1:
            previous_block = if_blocks[-2]
            previous_block_index = previous_block[0]

            last_block = if_blocks[-1]
            last_block_index = last_block[0]

            previous_block[1]['then']['code'].extend(block_code[previous_block_index + 1:last_block_index])
            previous_block[1]['then']['code'].append(last_block[1])
            previous_block[1]['then']['code'].extend(block_code[last_block_index + 1:])
            previous_block[1]['then']['variables'] = {**block_variables, **previous_block[1]['then']['variables']}

            previous_block[1]['else']['code'].extend(block_code[previous_block_index + 1:last_block_index])
            previous_block[1]['else']['code'].append(last_block[1])
            previous_block[1]['else']['code'].extend(block_code[last_block_index + 1:])
            previous_block[1]['else']['variables'] = {**block_variables, **previous_block[1]['else']['variables']}

            for code in block_code[previous_block_index + 1:last_block_index]:
                block_code.remove(code)
            block_code.remove(last_block[1])
            for code in block_code[previous_block_index + 1:]:
                block_code.remove(code)
            if_blocks.remove(last_block)

            previous_block_then_block = previous_block[1]['then']
            previous_block_then_block_code = previous_block_then_block['code']
            previous_block_then_block_variables = previous_block_then_block['variables']
            countIf(previous_block_then_block_code, previous_block_then_block_variables)
            previous_block_else_block = previous_block[1]['else']
            previous_block_else_block_code = previous_block_else_block['code']
            previous_block_else_block_variables = previous_block_else_block['variables']
            countIf(previous_block_else_block_code, previous_block_else_block_variables)

def write_structure(input_file, input_path, model_type):
    cursor = parse_cpp_file(input_file, model_type)
    func_cursor = find_evalFAdept_function(cursor)

    if not func_cursor:
        print("Fonction evalFAdept non trouvée.")
        return

    residuals = []
    if model_type == 'Dyn':
        residuals = extract_residual_blocks(func_cursor)
        output = {
            'residuals': sorted(residuals, key=lambda x: x['index'])
        }

        with open(input_path + '/evalF' + '_' + model_type + '_structure_before.json', 'w') as f:
            json.dump(output, f, indent=2, ensure_ascii=False)

        for residual in residuals:
            block = residual['block']
            block_code = block['code']
            block_variables = block['variables']
            residual_index = residual['index']
            if not any(isinstance(code, str) and 'Complex_adept' in code for code in block_code):
                countIf(block_code, block_variables)

        with open(input_path + '/evalF' + '_' + model_type + '_structure.json', 'w') as f:
            json.dump(output, f, indent=2, ensure_ascii=False)

    return residuals

def write_jacobian(input_file, model_name, model_type):
    input_path = os.path.dirname(os.path.abspath(input_file))
    input_filename = os.path.basename(os.path.abspath(input_file))

    residuals = write_structure(input_file, input_path, model_type)

    jacobian(residuals, input_path, input_filename, model_name, model_type)

if __name__ == '__main__':
    print("start evalJ gen")
    file = sys.argv[1]
    model_name = sys.argv[2]
    model_type = sys.argv[3]
    if not os.path.isfile(file):
        print(file + " does not exist.")
        sys.exit(1)
    write_jacobian(file, model_name, model_type)
