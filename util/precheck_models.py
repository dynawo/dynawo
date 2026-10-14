#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

"""Fast consistency checks of the Dynawo Modelica library, without any compilation.

Catches the usual causes of build-all failures before pushing:
  1. package.order  <-> .mo files and sub-packages actually present
  2. CMakeLists.txt <-> model files (.mo, .extvar, .mandatoryParam, package.order) and add_subdirectory
  3. PreassembledModels: file name == modelicaModel id, file listed in the CMakeLists.txt,
     unitDynamicModel classes exist

By default, only the issues that are not already present on the reference branch are reported.

Usage: python3 util/precheck_models.py [--root <dynawo repository>] [--ref master] [--no-baseline]
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET

MODELICA_DIR = os.path.join("dynawo", "sources", "Models", "Modelica")
DYN_NS = "{http://www.rte-france.com/dynawo}"


def cmake_entries(path):
    txt = re.sub(r"#.*", "", open(path).read())
    files = set()
    for block in re.findall(r"set\s*\(\s*\w+(.*?)\)", txt, re.S | re.I):
        files |= set(block.split())
    subdirs = set(re.findall(r"add_subdirectory\s*\(\s*([^\s)]+)", txt, re.I))
    return files, subdirs


def structural_checks(root):
    lib = os.path.join(root, MODELICA_DIR, "Dynawo")
    pre = os.path.join(root, MODELICA_DIR, "PreassembledModels")
    found = []

    def rel(path):
        return os.path.relpath(path, root)

    # 1 + 2: library directories
    for directory, dirs, files in os.walk(lib):
        if "package.mo" not in files:
            continue
        subpkgs = {s for s in dirs if os.path.isfile(os.path.join(directory, s, "package.mo"))}
        mos = {f[:-3] for f in files if f.endswith(".mo") and f != "package.mo"}

        order_path = os.path.join(directory, "package.order")
        if os.path.isfile(order_path):
            order = [line.strip() for line in open(order_path) if line.strip()]
            present = mos | subpkgs
            for name in order:
                if name not in present:
                    found.append("%s: '%s' listed but no %s.mo nor %s/package.mo" % (rel(order_path), name, name, name))
            for name in sorted(present - set(order)):
                found.append("%s: '%s' exists but is not listed" % (rel(order_path), name))
            if len(order) != len(set(order)):
                found.append("%s: duplicate entries" % rel(order_path))

        cmake = os.path.join(directory, "CMakeLists.txt")
        if not os.path.isfile(cmake):
            found.append("%s: missing CMakeLists.txt" % rel(directory))
            continue
        listed, subdirs = cmake_entries(cmake)
        model_files = {f for f in files if f.endswith((".mo", ".extvar", ".mandatoryParam")) or f == "package.order"}
        for f in sorted(model_files - listed):
            found.append("%s: '%s' not installed (missing in MODEL_FILES)" % (rel(cmake), f))
        for f in sorted(x for x in listed if "." in x and not x.startswith("$") and x not in files):
            found.append("%s: '%s' listed but the file does not exist" % (rel(cmake), f))
        for s in sorted(subpkgs - subdirs):
            found.append("%s: sub-package '%s' has no add_subdirectory" % (rel(cmake), s))
        for s in sorted(subdirs - set(dirs)):
            found.append("%s: add_subdirectory(%s) but the directory does not exist" % (rel(cmake), s))
        for f in files:
            base, ext = os.path.splitext(f)
            if ext in (".extvar", ".mandatoryParam") and base not in mos:
                found.append("%s: %s has no matching %s.mo" % (rel(directory), f, base))

    # 3: preassembled models
    pre_listed, _ = cmake_entries(os.path.join(pre, "CMakeLists.txt"))
    for f in sorted(os.listdir(pre)):
        if not f.endswith(".xml"):
            continue
        path = os.path.join(pre, f)
        if " " in f:
            found.append("%s: file name contains a space" % rel(path))
        if f not in pre_listed:
            found.append("%s: not listed in PreassembledModels/CMakeLists.txt" % rel(path))
        try:
            tree = ET.parse(path)
        except ET.ParseError as error:
            found.append("%s: invalid XML (%s)" % (rel(path), error))
            continue
        for model in tree.getroot().iter(DYN_NS + "modelicaModel"):
            if model.get("id") != f[:-4]:
                found.append("%s: modelicaModel id '%s' differs from the file name '%s'" % (rel(path), model.get("id"), f[:-4]))
            for unit in model.iter(DYN_NS + "unitDynamicModel"):
                name = unit.get("name", "")
                if name.startswith("Dynawo."):
                    cls = os.path.join(lib, *name.split(".")[1:]) + ".mo"
                    if not os.path.isfile(cls):
                        found.append("%s: unitDynamicModel class %s not found (%s)" % (rel(path), name, rel(cls)))
    for f in sorted(x for x in pre_listed if x.endswith(".xml") and not os.path.isfile(os.path.join(pre, x))):
        found.append("PreassembledModels/CMakeLists.txt: '%s' listed but the file does not exist" % f)

    return found


def main():
    parser = argparse.ArgumentParser(description="Fast consistency checks of the Dynawo Modelica library (no compilation)")
    parser.add_argument("--root", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), os.pardir),
                        help="root of the Dynawo repository (default: parent of the util directory)")
    parser.add_argument("--ref", default="master", help="git reference whose already existing issues are ignored (default: master)")
    parser.add_argument("--no-baseline", action="store_true", help="report all issues, including those already present on --ref")
    options = parser.parse_args()
    root = os.path.abspath(options.root)

    errors = structural_checks(root)
    if not options.no_baseline:
        base = tempfile.mkdtemp(prefix="precheck_models_")
        try:
            archive = subprocess.Popen(["git", "-C", root, "archive", options.ref, MODELICA_DIR], stdout=subprocess.PIPE)
            subprocess.check_call(["tar", "-x", "-C", base], stdin=archive.stdout)
            archive.stdout.close()
            if archive.wait() != 0:
                sys.exit("git archive of '%s' failed" % options.ref)
            known = set(structural_checks(base))
        finally:
            shutil.rmtree(base)
        print("%d issue(s) already present on %s ignored" % (len(set(errors) & known), options.ref))
        errors = [e for e in errors if e not in known]

    if errors:
        print("\n".join("  - " + e for e in errors))
        sys.exit(1)
    print("OK: no problem found")


if __name__ == "__main__":
    main()
