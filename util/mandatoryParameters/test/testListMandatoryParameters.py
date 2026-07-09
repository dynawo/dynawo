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

import os
import shutil
import sys
import tempfile
import unittest

try:
    mandatory_param_dir = os.environ["DYNAWO_MANDATORY_PARAM_DIR"]
    sys.path.append(mandatory_param_dir)
    from listMandatoryParameters import ModelicaParamChecker, _build_xml
except Exception:
    print("Failed to import listMandatoryParameters")
    sys.exit(1)


def _run(mo_content, filename='Model.mo', extra_files=None):
    """Write mo_content to a temp file, run the checker, return (results, known_enums)."""
    tmpdir = tempfile.mkdtemp()
    try:
        mo_file = os.path.join(tmpdir, filename)
        with open(mo_file, 'w') as fh:
            fh.write(mo_content)
        if extra_files:
            for name, content in extra_files.items():
                with open(os.path.join(tmpdir, name), 'w') as fh:
                    fh.write(content)
        checker = ModelicaParamChecker(search_dirs=[tmpdir])
        results = checker.check_file(mo_file)
        return results, checker.known_enums
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)


def _names(results):
    return {r['param'] for r in results}


def _xml_names(results, known_enums=None):
    root = _build_xml(results, known_enums)
    return {p.get('name') for p in root}


class TestDirectParameters(unittest.TestCase):
    def test_parameter_without_default_is_detected(self):
        mo = "model M\n  parameter Real P1;\nend M;\n"
        results, _ = _run(mo)
        self.assertIn('P1', _names(results))

    def test_parameter_with_default_is_excluded(self):
        mo = "model M\n  parameter Real P1 = 1.0;\nend M;\n"
        results, _ = _run(mo)
        self.assertNotIn('P1', _names(results))

    def test_boolean_type(self):
        mo = "model M\n  parameter Boolean Flag;\nend M;\n"
        results, enums = _run(mo)
        xml_root = _build_xml(results, enums)
        types = {p.get('name'): p.get('type') for p in xml_root}
        self.assertEqual(types.get('Flag'), 'BOOL')

    def test_integer_type(self):
        mo = "model M\n  parameter Integer N;\nend M;\n"
        results, enums = _run(mo)
        xml_root = _build_xml(results, enums)
        types = {p.get('name'): p.get('type') for p in xml_root}
        self.assertEqual(types.get('N'), 'INT')

    def test_real_type(self):
        mo = "model M\n  parameter Real X;\nend M;\n"
        results, enums = _run(mo)
        xml_root = _build_xml(results, enums)
        types = {p.get('name'): p.get('type') for p in xml_root}
        self.assertEqual(types.get('X'), 'DOUBLE')

    def test_complex_parameter_split_into_re_im(self):
        mo = "model M\n  parameter Complex Z;\nend M;\n"
        results, enums = _run(mo)
        names = _xml_names(results, enums)
        self.assertIn('Z.re', names)
        self.assertIn('Z.im', names)
        self.assertNotIn('Z', names)

    def test_array_parameter_expanded_literal_dim(self):
        mo = "model M\n  parameter Real X[3];\nend M;\n"
        results, enums = _run(mo)
        names = _xml_names(results, enums)
        self.assertIn('X[1]', names)
        self.assertIn('X[2]', names)
        self.assertIn('X[3]', names)
        self.assertNotIn('X', names)

    def test_multiple_parameters_mixed(self):
        mo = ("model M\n"
              "  parameter Real P1;\n"
              "  parameter Real P2 = 0.0;\n"
              "  parameter Boolean Flag;\n"
              "end M;\n")
        results, _ = _run(mo)
        names = _names(results)
        self.assertIn('P1', names)
        self.assertIn('Flag', names)
        self.assertNotIn('P2', names)


class TestInheritedParameters(unittest.TestCase):
    def test_extends_mandatory_param_propagated(self):
        base = "model Base\n  parameter Real BasePar;\nend Base;\n"
        child = ("within Test;\nmodel Child\n  extends Base;\nend Child;\n")
        results, _ = _run(child, filename='Child.mo',
                          extra_files={'Base.mo': base})
        self.assertIn('BasePar', _names(results))

    def test_extends_param_provided_in_clause_excluded(self):
        base = "model Base\n  parameter Real BasePar;\nend Base;\n"
        child = ("within Test;\nmodel Child\n"
                 "  extends Base(BasePar = 5.0);\nend Child;\n")
        results, _ = _run(child, filename='Child.mo',
                          extra_files={'Base.mo': base})
        self.assertNotIn('BasePar', _names(results))

    def test_extends_param_with_default_excluded(self):
        base = "model Base\n  parameter Real BasePar = 1.0;\nend Base;\n"
        child = "within Test;\nmodel Child\n  extends Base;\nend Child;\n"
        results, _ = _run(child, filename='Child.mo',
                          extra_files={'Base.mo': base})
        self.assertNotIn('BasePar', _names(results))


class TestSubComponentParameters(unittest.TestCase):
    def test_subcomponent_mandatory_param_detected(self):
        sub = "model Sub\n  parameter Real SubPar;\nend Sub;\n"
        parent = ("within Test;\nmodel Parent\n"
                  "  Sub s;\nend Parent;\n")
        results, enums = _run(parent, filename='Parent.mo',
                              extra_files={'Sub.mo': sub})
        self.assertIn('s.SubPar', _xml_names(results, enums))

    def test_subcomponent_param_provided_at_instantiation_excluded(self):
        sub = "model Sub\n  parameter Real SubPar;\nend Sub;\n"
        parent = ("within Test;\nmodel Parent\n"
                  "  Sub s(SubPar = 2.0);\nend Parent;\n")
        results, enums = _run(parent, filename='Parent.mo',
                              extra_files={'Sub.mo': sub})
        self.assertNotIn('s.SubPar', _xml_names(results, enums))

    def test_subcomponent_param_with_default_excluded(self):
        sub = "model Sub\n  parameter Real SubPar = 1.0;\nend Sub;\n"
        parent = ("within Test;\nmodel Parent\n"
                  "  Sub s;\nend Parent;\n")
        results, enums = _run(parent, filename='Parent.mo',
                              extra_files={'Sub.mo': sub})
        self.assertNotIn('s.SubPar', _xml_names(results, enums))


if __name__ == '__main__':
    unittest.main()
