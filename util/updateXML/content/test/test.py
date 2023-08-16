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
