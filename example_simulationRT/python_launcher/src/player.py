import csv
import logging
import time
from enum import Enum
from pathlib import Path
import shutil
import subprocess
import webbrowser

from handlers.dumped_values_handler import DumpedValuesHandler
from handlers.jobs_handler import JobsHandler
from handlers.sequence_handler import SequenceHandler
from handlers.par_handler import ParHandler
from handlers.tl_handler import TimelineHandler
from utils import DYNAWO_MYENVDYNAWO, DYNAWO_MYENVDYNAWORTE

logger = logging.getLogger(__name__)


class FileTypeE(Enum):
    JOBS = 1
    DYD = 2
    PAR = 3
    CRV = 4
    IIDM = 5

class Player:
    FILE_TYPE_MAP = {
        FileTypeE.JOBS: ("*.jobs", "fic_JOB.xml"),
        FileTypeE.DYD: ("*.dyd", "fic_DYD.xml"),
        FileTypeE.PAR: ("*.par", "fic_PAR.xml"),
        FileTypeE.CRV: ("*.crv", "fic_CRV.xml"),
        FileTypeE.IIDM: ("*.iidm", "*.xiidm", "*IIDM.xml")
    }

    def __init__(self, workspace_dir, testcase_dir, dynawo_rte=False) -> None:
        self._workspace_dir = workspace_dir
        self._testcase: Path = testcase_dir
        self._current_step = None
        self._working_dir = None
        self._sequence = None
        self._final_jobs_file_for_curves = None
        self._final_timeline = None
        self._final_logs = None
        self._final_vs_init_cmp_dir = None
        self._dynawo_rte = dynawo_rte
        for f in [p.resolve() for p in self._testcase.glob("*") if p.suffix == ".dsq"]:
            shutil.copyfile(f, self._workspace_dir / f.name)
            self._sequence = SequenceHandler(self._workspace_dir / f.name).get_sequence()
            continue  # Only 1 seq autorized
        self._new_step()
        self._copy_files()

    def _find_files(self, path: Path, file_type:FileTypeE):
        return [f for exp in self.FILE_TYPE_MAP[file_type] for f in path.glob(exp)]


    def _copy_files(self, incremental_jobs = False, incremental_par = False):
        filetypes_to_cp = [FileTypeE.JOBS, FileTypeE.DYD, FileTypeE.PAR, FileTypeE.CRV, FileTypeE.IIDM]

        if (incremental_jobs or incremental_par) and self._current_step > 0:
            prev_step_dir =  self._working_dir.parent / str(self._current_step - 1)
            if incremental_jobs:
                filetypes_to_cp.remove(FileTypeE.JOBS)
                for f in [p.resolve() for p in self._find_files(prev_step_dir, FileTypeE.JOBS)]:
                    shutil.copyfile(f, self._working_dir / f.name)
            if incremental_par:
                filetypes_to_cp.remove(FileTypeE.PAR)
                for f in [p.resolve() for p in self._find_files(prev_step_dir, FileTypeE.PAR)]:
                    shutil.copyfile(f, self._working_dir / f.name)

        for f in [p.resolve() for ft in filetypes_to_cp for p in self._find_files(self._testcase, ft)]:
            shutil.copyfile(f, self._working_dir / f.name)

        jobs_files = self._find_files(self._working_dir, FileTypeE.JOBS)
        if len(jobs_files) != 1:
            msg = f"Error: {len(jobs_files)} jobs file located in dir {self._working_dir}, 1 expected"
            logger.error(msg)
            raise RuntimeError(msg)
        self._current_jobs_file = self._working_dir / jobs_files[0].name

    def _new_step(self):
        self._current_step = 0 if self._current_step is None else self._current_step + 1
        self._working_dir = self._workspace_dir / str(self._current_step)
        self._working_dir.mkdir()

    def _run_jobs(self):
        jobs_file = str(self._current_jobs_file)
        args = [DYNAWO_MYENVDYNAWORTE if self._dynawo_rte else DYNAWO_MYENVDYNAWO, 'jobs', '-i', jobs_file]
        logger.info(f"======================== ---> New jobs subprocess ({self._current_step}): {' '.join(args)}\n\n")
        subprocess.run(args, stderr=subprocess.STDOUT)
        logger.info("======================== <--- Jobs suprocess completed")

    def _run_sequence(self):
        if self._sequence is None:
            msg = "Sequence is not defined"
            logger.error(msg)
            raise RuntimeError(msg)

        last_end_time = 0
        for step in self._sequence:
            t_init_step = time.time()
            # Prepare jobs and par
            jobs_handler = JobsHandler(self._current_jobs_file)
            jobs_handler.set_simulation_time(last_end_time, step.stop_time)
            last_end_time = step.stop_time
            if self._current_step > 0:
                jobs_handler.set_initial_state(f"../{self._current_step-1}/outputs/finalState/outputState.dmp")
                jobs_handler.set_iidm(f"../{self._current_step-1}/outputs/finalState/outputIIDM.xml")
            jobs_handler.flush_to_file()

            par_handlers = {}

            for mod in step.mods:
                if mod.par_file not in par_handlers:
                    par_handlers[mod.par_file] = ParHandler(self._working_dir / mod.par_file)
                par_handler = par_handlers[mod.par_file]
                par_handler.modify_par(mod.set_id, mod.par_name, mod.par_value)

            for par_handler in par_handlers.values():
                par_handler.flush_to_file()

            # run dynawo
            t_run_jobs = time.time()
            self._run_jobs()
            t_end_jobs = time.time()

            # prepare next step
            if self._current_step < len(self._sequence) - 1:
                self._new_step()
                self._copy_files(incremental_par=True)
            t_end_step = time.time()
            logger.info(f"...t_init: {(t_run_jobs - t_init_step):.3f} s")
            logger.info(f"...t_jobs: {(t_end_jobs - t_run_jobs):.3f} s")
            logger.info(f"...t_cpfiles: {(t_end_step - t_end_jobs):.3f} s")

    def run(self):
        if self._sequence is None:
            logger.info("---------- Run single jobs (no sequence) ----------")
            self._run_jobs()
        else:
            logger.info("---------- Run sequence ----------")
            self._run_sequence()
        self.merge_curves()
        self.merge_timelines()
        self.merge_logs()

    def merge_curves(self):
        logger.info("  .. Merge curves")

        if self._current_step == 0:
            self._final_jobs_file_for_curves = self._current_jobs_file
        else:
            crv_dir = self._workspace_dir / "merged"
            crv_curves_dir = self._workspace_dir / "merged/outputs/curves"
            crv_curves_dir.mkdir(parents=True, exist_ok=True)

            for f in [p.resolve() for p in self._find_files(self._testcase, FileTypeE.JOBS)]:
                shutil.copyfile(f, crv_dir / f.name)
            self._final_jobs_file_for_curves = crv_dir / self._current_jobs_file.name

            shutil.copyfile(self._workspace_dir / "0/outputs/curves/curves.csv", crv_curves_dir / "curves.csv")
            with open(crv_curves_dir/"curves.csv", "a") as merged_crv_f:
                for step in range(1, self._current_step+1):
                    with open(self._workspace_dir / str(step) / "outputs/curves/curves.csv", "r") as crv_f:
                        merged_crv_f.writelines(crv_f.readlines()[1:])

    def display_curves(self):
        logger.info("  .. Display curves")
        if self._final_jobs_file_for_curves is None:
            self.merge_curves()
        subprocess.run([str(DYNAWO_MYENVDYNAWO), "curves", f"{self._final_jobs_file_for_curves}"], stderr=subprocess.STDOUT)

    def merge_timelines(self):
        logger.info("  .. Merge timelines")

        if self._current_step == 0:
            self._final_timeline = self._workspace_dir / "0/outputs/timeLine/timeline.xml"
        else:
            tl_dir = self._workspace_dir / "merged/outputs/timeLine"
            tl_dir.mkdir(parents=True, exist_ok=True)
            self._final_timeline = (tl_dir / "timeline.xml").resolve()
            shutil.copyfile(self._workspace_dir / "0/outputs/timeLine/timeline.xml", self._final_timeline)
            merged_tl = TimelineHandler(tl_dir / "timeline.xml")
            for step in range(1, self._current_step+1):
                merged_tl.absorb(self._workspace_dir / str(step) / "outputs/timeLine/timeline.xml")
            merged_tl.flush_to_file()

    def merge_logs(self):
        logger.info("  .. Merge logs")

        if self._current_step == 0:
            self._final_logs = self._workspace_dir / "0/outputs/logs/dynawaltz.log"
        else:
            logs_dir = self._workspace_dir / "merged/outputs/logs"
            logs_dir.mkdir(parents=True, exist_ok=True)

            shutil.copyfile(self._workspace_dir / "0/outputs/logs/dynawaltz.log", logs_dir / "dynawaltz.log")
            with open(logs_dir / "dynawaltz.log", "a") as merged_log_f:
                for step in range(1, self._current_step + 1):
                    with open(self._workspace_dir / str(step) / "outputs/logs/dynawaltz.log", "r") as log_f:
                        merged_log_f.writelines(">>>>>>>>>>>>>>>> DUMP/LOAD <<<<<<<<<<<<<<<<<<\n")
                        merged_log_f.writelines(log_f.readlines())

    def display_timeline(self):
        logger.info("  .. Display timelines")

        if self._final_timeline is None:
            self.merge_timelines()
        webbrowser.open(f'file://{str(self._final_timeline)}')

    def cmp_init_vs_final_values(self):
        logger.info("  .. Compare final values (run k) with init values (run k+1)")
        if self._current_step == 0:
            logger.info("    __ single run sequence, nothing to compare...")
            return
        final_suffix = "outputs/finalValues"
        init_local_suffix = "outputs/initValues/localInit"
        init_global_suffix = "outputs/initValues/globalInit"
        if not (self._working_dir / final_suffix).exists():
            logger.error(f"missing {final_suffix} file (in jobs ?)")
            return
        if not (self._working_dir / init_local_suffix).exists():
            logger.error(f"missing {init_local_suffix} file (in jobs ?)")
            return
        if not (self._working_dir / init_global_suffix).exists():
            logger.error(f"missing {init_global_suffix} file (in jobs ?)")
            return

        files_suffix_list = [f.name.replace("dumpFinalValues-","") for f in (self._working_dir / final_suffix).glob("*")]
        self._final_vs_init_cmp_dir = self._workspace_dir / "merged/outputs/finalVsInit"
        self._final_vs_init_cmp_dir.mkdir()
        results = {}
        if self._current_step > 0:
            for step in range(self._current_step):
                final_dir = self._workspace_dir / str(step) / final_suffix
                init_local_dir = self._workspace_dir / str(step+1) / init_local_suffix
                init_global_dir = self._workspace_dir / str(step+1) / init_global_suffix

                for f in files_suffix_list:
                    final_h = DumpedValuesHandler(final_dir / ("dumpFinalValues-" + f))
                    init_local_h = DumpedValuesHandler(init_local_dir / ("dumpInitValues-" + f))
                    init_global_h = DumpedValuesHandler(init_global_dir / ("dumpInitValues-" + f))
                    for d in final_h.data:
                        if f"{f}_{d.name}" not in results:
                            results[f"{f}_{d.name}"] = {"name": d.name}
                            results[f"{f}_{d.name}"]["type"] = d.type
                            results[f"{f}_{d.name}"]["file"] = f
                        results[f"{f}_{d.name}"][f"finalV_{step}"] = str(d.values)
                    for d in init_local_h.data:
                        if f"{f}_{d.name}" not in results:
                            results[f"{f}_{d.name}"] = {"name": d.name}
                            results[f"{f}_{d.name}"]["type"] = d.type
                            results[f"{f}_{d.name}"]["file"] = f
                        results[f"{f}_{d.name}"][f"initLocalV_{step+1}"] = str(d.values)
                    for d in init_global_h.data:
                        if f"{f}_{d.name}" not in results:
                            results[f"{f}_{d.name}"] = {"name": d.name}
                            results[f"{f}_{d.name}"]["type"] = d.type
                            results[f"{f}_{d.name}"]["file"] = f
                        results[f"{f}_{d.name}"][f"initGlobalV_{step+1}"] = str(d.values)

            fieldnames = ['file', 'name', 'type']
            for step in range(self._current_step):
                fieldnames += [f'finalV_{step}', f'initLocalV_{step+1}', f'initGlobalV_{step+1}', f'finalEqInitLoc{step}_{step+1}', f'finalEqInitGlob{step}_{step+1}']
                for e in results.values():

                    if f'finalV_{step}' in e and f'initLocalV_{step + 1}' in e:
                        e[f'finalEqInitLoc{step}_{step+1}'] = "x" if e[f'finalV_{step}'] != e[f'initLocalV_{step + 1}'] else "_"

                    if f'finalV_{step}' in e and f'initGlobalV_{step + 1}' in e:
                        e[f'finalEqInitGlob{step}_{step+1}'] = "x" if e[f'finalV_{step}'] != e[f'initGlobalV_{step + 1}'] else "_"

            with (open(self._final_vs_init_cmp_dir / f"finalVsInit.csv", 'w') as csv_file):
                writer = csv.DictWriter(csv_file, fieldnames=fieldnames, delimiter=',')
                writer.writeheader()
                for e in [v for v in sorted(results.values(), key=lambda v: v["file"])]:
                    writer.writerow(e)

    def display_final_vs_init_cmp(self):
        logger.info("  .. Display finalvsinit")
        if self._final_vs_init_cmp_dir is None:
            self.cmp_init_vs_final_values()
        if self._final_vs_init_cmp_dir:
            for f in self._final_vs_init_cmp_dir.glob("*"):
                webbrowser.open(f'file://{str(f.resolve())}')
