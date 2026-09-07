#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.
"""
dynawo_check_params.py
----------------------
Lists all parameters without a default value in a Modelica file,
including parameters inherited via 'extends' and from instantiated
sub-components (both handled recursively).

A parameter is excluded from the report if:
  - it has a default value in its own declaration, OR
  - a value is provided at instantiation:  LoadBase base(P0Pu = 1.0)
  - a value is provided in an extends clause: extends Base(SNom = 100)

Output: XML <mandatoryParameters> with one <parameter> per missing default.

Usage:
    python dynawo_check_params.py MyModel.mo
    python dynawo_check_params.py MyModel.mo --lib-dirs ../Electrical ../NonElectrical
    python dynawo_check_params.py MyModel.mo --output result.xml
"""

from __future__ import print_function

import argparse
import datetime
import io
import os
import re
import sys
try:
    from xml.etree import ElementTree as ET
    from xml.dom import minidom
except ImportError:
    raise SystemExit("Python standard library xml modules are required.")


# ---------------------------------------------------------------------------
# Text preparation helpers
# ---------------------------------------------------------------------------

def _strip_comments(text):
    """Remove // and /* */ comments, without touching content inside string literals."""
    result = []
    i = 0
    n = len(text)
    while i < n:
        if text[i] == '"':
            # String literal: copy verbatim until closing quote (handle \" escapes)
            j = i + 1
            while j < n:
                if text[j] == '\\' and j + 1 < n:
                    j += 2
                elif text[j] == '"':
                    j += 1
                    break
                else:
                    j += 1
            result.append(text[i:j])
            i = j
        elif text[i:i+2] == '/*':
            end = text.find('*/', i + 2)
            if end == -1:
                break
            result.append(' ')
            i = end + 2
        elif text[i:i+2] == '//':
            end = text.find('\n', i + 2)
            if end == -1:
                i = n
            else:
                i = end  # keep the newline
        else:
            result.append(text[i])
            i += 1
    return ''.join(result)


def _strip_strings(text):
    """Replace Modelica string literals with empty placeholder \"\"."""
    return re.sub(r'"[^"\\]*(?:\\.[^"\\]*)*"', '""', text)


def _strip_annotations(text):
    """Remove annotation(...) blocks (including nested parens) from Modelica text."""
    result = []
    i = 0
    pattern = re.compile(r'\bannotation\s*\(')
    while i < len(text):
        m = pattern.search(text, i)
        if not m:
            result.append(text[i:])
            break
        result.append(text[i:m.start()])
        # Find balanced closing paren starting at the '('
        depth = 0
        j = m.end() - 1  # position of '('
        while j < len(text):
            if text[j] == '(':
                depth += 1
            elif text[j] == ')':
                depth -= 1
                if depth == 0:
                    j += 1
                    break
            j += 1
        i = j
    return ''.join(result)


def _prepare(text):
    return _strip_annotations(_strip_strings(_strip_comments(text)))


_RE_WITHIN = re.compile(r'\bwithin\s+((?:[\w]+\.)*[\w]+)\s*;')

def _get_within(text):
    """Return the 'within' package name from a Modelica file, or None."""
    m = _RE_WITHIN.search(text)
    return m.group(1) if m else None


# ---------------------------------------------------------------------------
# Class body extraction
# ---------------------------------------------------------------------------

def _extract_class_body(text, class_name):
    """
    Return the body of 'model/block/record <class_name> ... end <class_name>;'
    Text must already be comment+string stripped.
    """
    pattern = re.compile(
        r'\b(?:model|block|record|class)\s+' + re.escape(class_name) +
        r'\b(.*?)\bend\s+' + re.escape(class_name) + r'\s*;',
        re.DOTALL,
    )
    m = pattern.search(text)
    return m.group(1) if m else None


# ---------------------------------------------------------------------------
# Parameter declaration parser
# ---------------------------------------------------------------------------

# Regex for the start of a parameter declaration: 'parameter <type> <name>'
_RE_PARAM_START = re.compile(
    r'\bparameter\b\s+([\w.\[\], ]+?)\s+(\w+)\s*',
    re.DOTALL,
)

# Modelica built-in attribute names used in modification maps — these are NOT
# field bindings and do not constitute a default value for the parameter.
_MODELICA_ATTRIBUTES = frozenset([
    'min', 'max', 'start', 'fixed', 'nominal',
    'displayUnit', 'quantity', 'unit', 'each', 'final', 'stateSelect',
])


def _has_field_binding(map_text):
    """Return True if a modification map contains non-attribute name=value pairs.

    Detects e.g. ZPu(re = RPu, im = XPu) where 're' and 'im' are field names,
    meaning the parameter is initialised through its components.
    """
    for m in re.finditer(r'\b(\w+)\s*=', map_text):
        if m.group(1) not in _MODELICA_ATTRIBUTES:
            return True
    return False


def _find_param_default(body, pos):
    """Scan from pos (just after 'parameter <type> <name>') to ';'.

    Returns (has_default, end_pos).  A parameter is considered to have a
    default when:
      - an '=' appears at depth 0 (explicit default value), or
      - the first parenthesised group contains non-attribute field bindings
        such as ZPu(re = RPu, im = XPu), which initialise the parameter's
        components.
    """
    depth = 0
    has_default = False
    mod_start = -1
    i = pos
    while i < len(body):
        c = body[i]
        if c == '(':
            if depth == 0 and mod_start < 0:
                mod_start = i + 1
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0 and mod_start >= 0 and not has_default:
                if _has_field_binding(body[mod_start:i]):
                    has_default = True
                mod_start = -1
        elif c == ';' and depth == 0:
            return has_default, i + 1
        elif c == '=' and depth == 0:
            if i + 1 < len(body) and body[i + 1] != '=':
                has_default = True
        i += 1
    return has_default, len(body)


def _parse_param_declarations(body):
    """Return {param_name: has_default} for all 'parameter' declarations in body."""
    params = {}
    for m in _RE_PARAM_START.finditer(body):
        name = m.group(2).strip()
        has_default, _ = _find_param_default(body, m.end())
        params[name] = has_default
    return params


# ---------------------------------------------------------------------------
# Instantiation parser  (captures the parameter map passed at instantiation)
# ---------------------------------------------------------------------------

# Matches:  TypeName instanceName (k1 = v1, k2 = v2) ;
# or:       TypeName instanceName ;
# After _prepare(), strings in the map are "" and the optional Modelica
# description string (e.g. "doc string") becomes "" sitting between the
# closing ')' and the ';' — so we allow for zero or more such placeholders.
_RE_INSTANCE = re.compile(
    r"""
    \b((?:[\w]+\.)*[\w]+)\b   # group 1: component type
    \s+
    (\w+)                     # group 2: instance name
    \s*
    (?:\(([^)]*)\))?          # group 3: optional parameter map content
    (?:\s*"")*                # optional stripped description string(s)
    \s*;
    """,
    re.VERBOSE | re.DOTALL,
)

def _parse_provided_params(map_text):
    """
    Given the content inside parentheses of an instantiation,
    return a set of parameter names that are explicitly provided.
    e.g. "P0Pu = 1.0, SNom = 100" → {'P0Pu', 'SNom'}
    """
    if not map_text:
        return set()
    provided = set()
    for m in re.finditer(r'(\w+)\s*=', map_text):
        provided.add(m.group(1).strip())
    return provided


# ---------------------------------------------------------------------------
# Extends clause parser
# ---------------------------------------------------------------------------

# Matches:  extends SomeType ;
#           extends SomeType (k1 = v1, k2 = v2) ;
# Note: modification map may contain nested parentheses (e.g. start values),
# so we only match the type name here and extract the map with a balanced-paren scan.
_RE_EXTENDS_TYPE = re.compile(
    r'\bextends\b\s+((?:[\w]+\.)*[\w]+)',
    re.DOTALL,
)


def _extract_balanced_parens(text, start):
    """Return content inside balanced parentheses starting at index start (the '(')."""
    depth = 0
    for i in range(start, len(text)):
        if text[i] == '(':
            depth += 1
        elif text[i] == ')':
            depth -= 1
            if depth == 0:
                return text[start + 1:i]
    return ''


def _parse_comp_mods(map_text):
    """Extract component-level modifications from an extends modification map.

    Handles two Modelica syntaxes:
      - Nested:  CompName(Param = val, ...)
      - Dot:     CompName.Param = val

    Returns {component_name: set_of_param_names}.
    """
    comp_mods = {}
    # Nested syntax: CompName(inner params)
    for m in re.finditer(r'\b(\w+)\s*\(([^()]*)\)', map_text):
        inner_params = {
            pm.group(1) for pm in re.finditer(r'\b(\w+)\s*=', m.group(2))
        }
        if inner_params:
            comp_mods.setdefault(m.group(1), set()).update(inner_params)
    # Dot syntax: CompName.Param = val
    for m in re.finditer(r'\b(\w+)\.(\w+)\s*=', map_text):
        comp_mods.setdefault(m.group(1), set()).add(m.group(2))
    return comp_mods


def _parse_extends(body):
    """
    Return list of (parent_type_str, provided_params_set, comp_mods_dict, int_vals_dict)
    for every 'extends' clause found in body.
    comp_mods_dict maps sub-component names to sets of provided param names.
    int_vals_dict maps integer param names to their literal values (e.g. nbEventVariables=1).
    """
    result = []
    for m in _RE_EXTENDS_TYPE.finditer(body):
        parent_type = m.group(1).strip()
        pos = m.end()
        while pos < len(body) and body[pos] in ' \t\n\r':
            pos += 1
        provided = set()
        comp_mods = {}
        int_vals = {}
        if pos < len(body) and body[pos] == '(':
            map_text = _extract_balanced_parens(body, pos)
            provided = _parse_provided_params(map_text)
            comp_mods = _parse_comp_mods(map_text)
            for pm in re.finditer(r'\b(\w+)\s*=\s*(-?\d+)\b', map_text):
                int_vals[pm.group(1)] = int(pm.group(2))
        result.append((parent_type, provided, comp_mods, int_vals))
    return result


def _get_param_if_condition(body, param_name):
    """Return the condition string from 'parameter T name if (condition)' or None."""
    pattern = re.compile(
        r'\bparameter\b\s+[\w.\[\], ]+?\s+' + re.escape(param_name) +
        r'\s+if\s*\(([^)]*)\)'
    )
    m = pattern.search(body)
    return m.group(1).strip() if m else None


def _eval_if_condition(expr, int_params):
    """Evaluate a simple 'var op N' Modelica condition. Returns True/False/None."""
    m = re.match(r'\s*(\w+)\s*(>=|<=|==|!=|>|<)\s*(-?\d+)\s*$', expr)
    if not m:
        return None
    var, op, val = m.group(1), m.group(2), int(m.group(3))
    if var not in int_params:
        return None
    lhs = int_params[var]
    return {'>=': lhs >= val, '<=': lhs <= val, '==': lhs == val,
            '!=': lhs != val, '>': lhs > val, '<': lhs < val}[op]


# ---------------------------------------------------------------------------
# Model alias and array parameter helpers
# ---------------------------------------------------------------------------

_RE_MODEL_ALIAS = re.compile(
    r'\bmodel\s+(\w+)\s*=\s*((?:[\w]+\.)*[\w]+)'
    r'(?:\s*\(([^)]*)\))?\s*;',
    re.DOTALL,
)


def _parse_model_alias(text, class_name):
    """
    Detect: model class_name = BaseType(param=val, ...);
    Returns (base_type_str, provided_set, int_params_dict) or (None, None, None).
    """
    for m in _RE_MODEL_ALIAS.finditer(text):
        if m.group(1) == class_name:
            base_type = m.group(2)
            map_text = m.group(3) or ''
            provided = _parse_provided_params(map_text)
            int_params = {}
            for pm in re.finditer(r'(\w+)\s*=\s*(-?\d+)', map_text):
                int_params[pm.group(1)] = int(pm.group(2))
            return base_type, provided, int_params
    return None, None, None


def _parse_redeclare_params(body):
    """
    Extract 'redeclare parameter' entries (e.g. redeclare parameter Integer NbMotors = 1).
    Returns (provided_set, int_params_dict).
    """
    provided = set()
    int_params = {}
    pattern = re.compile(
        r'\bredeclare\s+parameter\s+[\w.\[\]]+\s+(\w+)\s*(?:=\s*(-?\d+))?'
    )
    for m in pattern.finditer(body):
        provided.add(m.group(1))
        if m.group(2) is not None:
            int_params[m.group(1)] = int(m.group(2))
    return provided, int_params


def _parse_array_dim(type_str):
    """Return dimension expression from 'Type[dim]', or None if not an array type."""
    m = re.search(r'\[(\w+)\]', type_str)
    return m.group(1) if m else None


def _resolve_dim(dim_expr, known_int_params):
    """Resolve a dimension expression to int using known integer params, or None."""
    try:
        return int(dim_expr)
    except ValueError:
        return (known_int_params or {}).get(dim_expr)


# ---------------------------------------------------------------------------
# Modelica keywords / built-in types to skip as instances
# ---------------------------------------------------------------------------

_SKIP_TYPES = frozenset([
    "algorithm", "and", "annotation", "assert", "block", "break",
    "class", "connect", "connector", "constant", "constrainedby",
    "der", "discrete", "each", "else", "elseif", "elsewhen",
    "encapsulated", "end", "enumeration", "equation", "expandable",
    "extends", "external", "false", "final", "flow", "for",
    "function", "if", "import", "impure", "in", "initial", "inner",
    "input", "loop", "model", "not", "operator", "or", "outer",
    "output", "package", "parameter", "partial", "protected", "public",
    "pure", "record", "redeclare", "replaceable", "return", "stream",
    "then", "true", "type", "when", "while", "within",
    "Real", "Integer", "Boolean", "String", "Complex",
    "Types", "Connectors", "AdditionalIcons", "Interfaces",
])


# ---------------------------------------------------------------------------
# .mo file resolver
# ---------------------------------------------------------------------------

def find_mo_file(type_name, search_dirs, within_package=None):
    """
    Find the .mo file for a Modelica type name (possibly qualified).

    When within_package is provided, relative names are resolved by trying
    progressively shorter prefixes of within_package prepended to type_name,
    mirroring Modelica's own name-resolution rule.

    Example: type_name='BaseClasses.TransformerParameters',
             within_package='Dynawo.Electrical.Transformers.TransformersFixedTap'
    tries (in order):
      Dynawo/Electrical/Transformers/TransformersFixedTap/BaseClasses/TransformerParameters.mo
      Dynawo/Electrical/Transformers/BaseClasses/TransformerParameters.mo  ← found
      Dynawo/Electrical/BaseClasses/TransformerParameters.mo
      ...
      BaseClasses/TransformerParameters.mo  (last resort, may be ambiguous)
    """
    parts = type_name.split('.')
    filename = parts[-1] + '.mo'

    sub_paths = []
    if within_package:
        within_parts = within_package.split('.')
        for i in range(len(within_parts), 0, -1):
            qualified = within_parts[:i] + parts
            sub_paths.append('/'.join(qualified) + '.mo')
    # Append the type's own suffixes (most to least specific)
    sub_paths.extend('/'.join(parts[i:]) + '.mo' for i in range(len(parts) - 1))

    candidates = []
    for search_dir in search_dirs:
        for root, _, files in os.walk(search_dir):
            if filename in files:
                candidates.append(os.path.abspath(os.path.join(root, filename)))

    for sub in sub_paths:
        for c in candidates:
            if sub in c.replace(os.sep, '/'):
                return c

    # Fallback: class may be defined inside its parent package .mo file.
    # This is common in the Modelica standard library (e.g. CombiTimeTable is
    # declared inside Sources.mo, not in CombiTimeTable.mo).
    if len(parts) >= 2:
        parent_parts = parts[:-1]
        parent_filename = parent_parts[-1] + '.mo'
        parent_sub_paths = []
        if within_package:
            within_parts = within_package.split('.')
            for i in range(len(within_parts), 0, -1):
                qualified = within_parts[:i] + parent_parts
                parent_sub_paths.append('/'.join(qualified) + '.mo')
        parent_sub_paths.extend(
            '/'.join(parent_parts[i:]) + '.mo' for i in range(len(parent_parts))
        )
        for search_dir in search_dirs:
            for root, _, files in os.walk(search_dir):
                if parent_filename in files:
                    c = os.path.abspath(os.path.join(root, parent_filename))
                    for sub in parent_sub_paths:
                        if sub in c.replace(os.sep, '/'):
                            return c

    return candidates[0] if candidates else None


# ---------------------------------------------------------------------------
# Core analyser
# ---------------------------------------------------------------------------

_RE_ENUM_DEF = re.compile(r'\btype\s+(\w+)\s*=\s*enumeration\s*\(', re.DOTALL)


class ModelicaParamChecker(object):

    def __init__(self, search_dirs=None):
        self.search_dirs = search_dirs or []
        self._file_cache = {}   # filepath -> prepared text
        self._visited = set()   # (filepath, class_name) to avoid cycles
        self.known_enums = set()  # enumeration type names collected across all visited files

    def _load(self, filepath):
        if filepath not in self._file_cache:
            with io.open(filepath, 'r', encoding='utf-8', errors='replace') as f:
                raw = f.read()
            self._file_cache[filepath] = _prepare(raw)
            self.known_enums.update(m.group(1) for m in _RE_ENUM_DEF.finditer(raw))
        return self._file_cache[filepath]

    def check_file(self, filepath):
        """
        Main entry point.
        Returns list of dicts:
          { param, type, origin, class, file }
        'origin' is 'direct' for top-level params, or the dotted instance path
        for params coming from sub-components.
        """
        text = self._load(filepath)
        top_classes = re.findall(
            r'\b(?:model|block|record|class)\s+(\w+)', text
        )
        if not top_classes:
            print("[warn] No model/block/record found in {}".format(filepath),
                  file=sys.stderr)
            return []

        results = []
        for cls in top_classes:
            results.extend(
                self._analyse_class(
                    filepath, cls,
                    origin_prefix='',
                    provided_from_parent=set(),
                )
            )
        return results

    def _analyse_class(self, filepath, class_name,
                       origin_prefix, provided_from_parent,
                       known_int_params=None, comp_mods_from_parent=None):
        """
        Recursively analyse one class.

        provided_from_parent:   set of param names given at instantiation —
                                excluded even if declared without default.
        known_int_params:       dict of integer param name → value, used to
                                resolve array dimensions (e.g. NbZones=4).
        comp_mods_from_parent:  dict mapping sub-component names to sets of
                                param names provided via the child class's
                                extends clause (nested or dot notation).
        """
        known_int_params = known_int_params or {}
        comp_mods_from_parent = comp_mods_from_parent or {}
        key = (filepath, class_name, frozenset(provided_from_parent),
               frozenset(known_int_params.items()),
               frozenset((k, frozenset(v)) for k, v in comp_mods_from_parent.items()))
        if key in self._visited:
            return []
        self._visited.add(key)

        text = self._load(filepath)
        body = _extract_class_body(text, class_name)

        # Handle model alias syntax:  model X = BaseType(param=val, ...);
        if body is None:
            base_type_str, alias_provided, alias_int = \
                _parse_model_alias(text, class_name)
            if base_type_str is not None:
                within = _get_within(text)
                all_dirs = ([os.path.dirname(os.path.abspath(filepath))]
                            + self.search_dirs)
                base_name = base_type_str.split('.')[-1]
                base_file = find_mo_file(base_type_str, all_dirs,
                                         within_package=within)
                if base_file:
                    merged_provided = provided_from_parent | alias_provided
                    merged_int = dict(known_int_params)
                    merged_int.update(alias_int)
                    return self._analyse_class(
                        base_file, base_name,
                        origin_prefix, merged_provided, merged_int,
                    )
            return []

        within = _get_within(text)
        all_dirs = [os.path.dirname(os.path.abspath(filepath))] + self.search_dirs

        # Collect redeclare params (e.g. redeclare parameter Integer NbMotors = 1)
        redeclare_provided, redeclare_int = _parse_redeclare_params(body)
        eff_int_params = dict(known_int_params)
        eff_int_params.update(redeclare_int)

        results = []

        # ---- 1. Direct parameters ----
        declared = _parse_param_declarations(body)
        for pname, has_default in declared.items():
            if has_default:
                continue
            if pname in provided_from_parent:
                continue   # value supplied at instantiation → skip
            # Conditional parameter: 'parameter T name if (condition)'
            cond_expr = _get_param_if_condition(body, pname)
            if cond_expr is not None:
                cond_val = _eval_if_condition(cond_expr, eff_int_params)
                if cond_val is False:
                    continue  # param absent in this configuration
            origin = origin_prefix if origin_prefix else 'direct'
            ptype = _get_param_type(body, pname)

            dim_expr = _parse_array_dim(ptype)
            if dim_expr is not None:
                dim = _resolve_dim(dim_expr, eff_int_params)
                if dim is not None:
                    base_t = re.sub(r'\s*\[[^\]]*\]', '', ptype).strip()
                    for i in range(1, dim + 1):
                        results.append({
                            'param':  '{}[{}]'.format(pname, i),
                            'type':   base_t,
                            'origin': origin,
                            'class':  class_name,
                            'file':   os.path.abspath(filepath),
                        })
                    continue
            results.append({
                'param':  pname,
                'type':   ptype,
                'origin': origin,
                'class':  class_name,
                'file':   os.path.abspath(filepath),
            })

        # ---- 2. Recurse into instantiated sub-components ----
        for m in _RE_INSTANCE.finditer(body):
            comp_type  = m.group(1).strip()
            inst_name  = m.group(2).strip()
            map_text   = m.group(3) or ''

            if comp_type in _SKIP_TYPES:
                continue
            base_type = comp_type.split('.')[-1]
            if not base_type or not base_type[0].isupper():
                continue

            # Merge any modifications passed from the enclosing class's
            # extends clause (e.g. extends Base(CompName(Param=val)) or
            # extends Base(CompName.Param=val))
            provided = (_parse_provided_params(map_text)
                        | comp_mods_from_parent.get(inst_name, set()))
            child_origin = (
                (origin_prefix + '.' if origin_prefix else '') + inst_name
            )
            child_file = find_mo_file(comp_type, all_dirs, within_package=within)
            if child_file:
                results.extend(
                    self._analyse_class(
                        child_file, base_type,
                        child_origin, provided,
                        eff_int_params,
                    )
                )

        # ---- 3. Recurse into parent classes via extends ----
        for parent_type, provided_in_extends, comp_mods, int_vals in _parse_extends(body):
            base_type = parent_type.split('.')[-1]
            if not base_type or not base_type[0].isupper():
                continue
            if parent_type in _SKIP_TYPES or base_type in _SKIP_TYPES:
                continue

            parent_file = find_mo_file(parent_type, all_dirs, within_package=within)
            if parent_file:
                # merge: params from extends clause + redeclare + provided to this class
                merged_provided = (provided_in_extends | redeclare_provided
                                   | provided_from_parent)
                # propagate integer values (e.g. nbEventVariables=1) to parent
                merged_int = dict(eff_int_params)
                merged_int.update(int_vals)
                # merge comp_mods from this extends clause with those received from
                # our own parent so they propagate through multi-level inheritance
                merged_comp_mods = {}
                for d in (comp_mods, comp_mods_from_parent):
                    for k, v in d.items():
                        merged_comp_mods.setdefault(k, set()).update(v)
                results.extend(
                    self._analyse_class(
                        parent_file, base_type,
                        origin_prefix,
                        merged_provided,
                        merged_int,
                        comp_mods_from_parent=merged_comp_mods,
                    )
                )

        return results


def _get_param_type(body, param_name):
    """Re-scan body to retrieve the type of a parameter, normalising both array syntaxes:
      Style 1:  parameter Type[N] name  →  returns 'Type[N]'
      Style 2:  parameter Type name[N]  →  returns 'Type[N]' (dim folded into type)
    """
    pattern = re.compile(
        r'\bparameter\b\s+([\w.\[\], ]+?)\s+' + re.escape(param_name) + r'\b'
    )
    m = pattern.search(body)
    if not m:
        return 'unknown'
    ptype = m.group(1).strip()
    # Style 2: dim comes after the name — fold it into the type string
    if '[' not in ptype:
        dm = re.compile(
            r'\bparameter\b\s+[\w.\[\], ]+?\s+' + re.escape(param_name) +
            r'\s*\[(\w+)\]'
        ).search(body)
        if dm:
            ptype = ptype + '[' + dm.group(1) + ']'
    return ptype


def _is_complex_type(modelica_type):
    """Return True if the type is a Modelica complex type."""
    t = modelica_type.strip().lower()
    return 'complex' in t


def _map_type(modelica_type, known_enums=None):
    """
    Map a Modelica/Dynawo type to one of: DOUBLE, STRING, BOOL, INT.
    Complex types are handled separately via _is_complex_type().
    Default is DOUBLE (most parameters in Dynawo are real-valued).
    """
    t = modelica_type.strip()
    tl = t.lower()
    if tl == 'boolean':
        return 'BOOL'
    if tl == 'integer':
        return 'INT'
    if tl == 'string':
        return 'STRING'
    if known_enums and t in known_enums:
        return 'INT'
    return 'DOUBLE'


# ---------------------------------------------------------------------------
# XML output
# ---------------------------------------------------------------------------

def _build_xml(results, known_enums=None):
    """
    Build a flat XML:

      <mandatoryParameters source="..." count="N">
        <parameter name="..." type="..." origin="..." class="..." file="..."/>
        ...
      </mandatoryParameters>
    """
    root = ET.Element('mandatoryParameters')

    for r in results:
        origin = r['origin']
        base_name = r['param']
        full_name = (origin + '.' + base_name
                     if origin and origin != 'direct' else base_name)
        if _is_complex_type(r['type']):
            for suffix in ('.re', '.im'):
                p = ET.SubElement(root, 'mandatoryParameter')
                p.set('name', full_name + suffix)
                p.set('type', 'DOUBLE')
        else:
            p = ET.SubElement(root, 'mandatoryParameter')
            p.set('name', full_name)
            p.set('type', _map_type(r['type'], known_enums))

    return root


_LICENSE_COMMENT = """\

    Copyright (c) {year}, RTE (http://www.rte-france.com)
    See AUTHORS.txt
    All rights reserved.
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, you can obtain one at http://mozilla.org/MPL/2.0/.
    SPDX-License-Identifier: MPL-2.0

    This file is part of Dynawo, a hybrid C++/Modelica open source time domain
    simulation tool for power systems.
"""


def _pretty_xml(element):
    """Return a nicely indented XML string with license header."""
    raw = ET.tostring(element, encoding='utf-8')
    if isinstance(raw, bytes):
        raw = raw.decode('utf-8')
    parsed = minidom.parseString(raw)
    license_node = parsed.createComment(
        _LICENSE_COMMENT.format(year=datetime.date.today().year)
    )
    parsed.insertBefore(license_node, parsed.documentElement)
    return parsed.toprettyxml(indent='  ', encoding=None)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description=(
            "List Modelica parameters without default values, "
            "including those from instantiated sub-components (recursive). "
            "Parameters explicitly provided at instantiation are excluded."
        )
    )
    parser.add_argument('mo_file',
                        help='Path to the .mo file to analyse')
    parser.add_argument(
        '--lib-dirs', nargs='*', default=[], metavar='DIR',
        help='Directories to search for referenced .mo files '
             '(e.g. the Dynawo Modelica library root)',
    )
    parser.add_argument(
        '--output', metavar='FILE',
        help='Write XML to this file instead of stdout',
    )
    args = parser.parse_args()

    if not os.path.isfile(args.mo_file):
        print("Error: file not found: {}".format(args.mo_file), file=sys.stderr)
        sys.exit(1)

    checker = ModelicaParamChecker(
        search_dirs=args.lib_dirs,
    )
    results = checker.check_file(args.mo_file)

    xml_root = _build_xml(results, checker.known_enums)
    param_count = len(list(xml_root))
    print("{} mandatory parameter(s) without default value found".format(param_count))

    if not list(xml_root):
        return  # no mandatory parameters — nothing to write

    xml_str = _pretty_xml(xml_root)

    if args.output:
        out_path = args.output
    else:
        base = os.path.splitext(os.path.abspath(args.mo_file))[0]
        out_path = base + '.mandatoryParam'

    with io.open(out_path, 'w', encoding='utf-8') as f:
        f.write(xml_str)
    print("Written to {}".format(out_path))


if __name__ == '__main__':
    main()
