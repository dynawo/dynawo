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


import unittest


from TestDyd.TestDyd.TestDyd import TestDyd
from TestDyd.TestBBM.TestBBM import TestBBM
from TestDyd.TestModelicaModel.TestModelicaModel import TestModelicaModel
from TestDyd.TestModelTemplate.TestModelTemplate import TestModelTemplate
from TestDyd.TestModelTemplateExpansion.TestModelTemplateExpansion import TestModelTemplateExpansion
from TestJob.TestJob.TestJob import TestJob
from TestJob.TestSolver.TestSolver import TestSolver
from TestJob.TestNetwork.TestNetwork import TestNetwork
from TestJob.TestCurves.TestCurves import TestCurves
from TestJob.TestFinalStateValues.TestFinalStateValues import TestFinalStateValues
from TestPar.TestPar import TestPar


if __name__ == '__main__':
    test_suite = unittest.TestSuite()

    test_suite.addTest(TestDyd())
    test_suite.addTest(TestBBM())
    test_suite.addTest(TestModelicaModel())
    test_suite.addTest(TestModelTemplate())
    test_suite.addTest(TestModelTemplateExpansion())
    test_suite.addTest(TestJob())
    test_suite.addTest(TestSolver())
    test_suite.addTest(TestNetwork())
    test_suite.addTest(TestCurves())
    test_suite.addTest(TestFinalStateValues())
    test_suite.addTest(TestPar())

    runner = unittest.TextTestRunner()
    result = runner.run(test_suite)
