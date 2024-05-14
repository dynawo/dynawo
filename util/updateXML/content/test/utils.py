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


import os
import filecmp
import subprocess


def launch_test(test_job, test_dir_path, update_XML_script, outputs_path, test_crv=False, test_fsv=False):
    input_job_file_path = os.path.join(test_dir_path, "inputs/fic_JOB.xml")

    output_job_file_path = os.path.join(test_dir_path, "outputs1.4.0/fic_JOB.xml")
    output_dyd_file_path = os.path.join(test_dir_path, "outputs1.4.0/fic_DYD.xml")
    output_par_file_path = os.path.join(test_dir_path, "outputs1.4.0/fic_PAR.xml")
    output_solver_file_path = os.path.join(test_dir_path, "outputs1.4.0/solvers.par")
    ref_job_file_path = os.path.join(test_dir_path, "reference/fic_JOB.xml")
    ref_dyd_file_path = os.path.join(test_dir_path, "reference/fic_DYD.xml")
    ref_par_file_path = os.path.join(test_dir_path, "reference/fic_PAR.xml")
    ref_solver_file_path = os.path.join(test_dir_path, "reference/solvers.par")

    project_env = dict(os.environ)
    project_env['PYTHONPATH'] = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    subprocess.run(["python", update_XML_script,
                    "--job", input_job_file_path,
                    "--origin", "1.3.0",
                    "--version", "1.4.0",
                    "-o", outputs_path,
                    "--add-dynawo-version"], check=True, env=project_env)

    test_job.assertTrue(filecmp.cmp(output_job_file_path, ref_job_file_path))
    test_job.assertTrue(filecmp.cmp(output_dyd_file_path, ref_dyd_file_path))
    test_job.assertTrue(filecmp.cmp(output_par_file_path, ref_par_file_path))
    test_job.assertTrue(filecmp.cmp(output_solver_file_path, ref_solver_file_path))

    if test_crv:
        output_crv_file_path = os.path.join(test_dir_path, "outputs1.4.0/fic_CRV.xml")
        ref_crv_file_path = os.path.join(test_dir_path, "reference/fic_CRV.xml")
        test_job.assertTrue(filecmp.cmp(output_crv_file_path, ref_crv_file_path))

    if test_fsv:
        output_fsv_file_path = os.path.join(test_dir_path, "outputs1.4.0/fic_FSV.xml")
        ref_fsv_file_path = os.path.join(test_dir_path, "reference/fic_FSV.xml")
        test_job.assertTrue(filecmp.cmp(output_fsv_file_path, ref_fsv_file_path))
