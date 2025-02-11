import os
from pathlib import Path

DYNAWO_HOME = Path("/home/vermeulenthi/Projects/dynawo")
WORKSPACE_ROOT = Path(os.path.dirname(__file__)) / "../../workspace"

DYNAWO_MYENVDYNAWO = "/home/vermeulenthi/Projects/dynawo/dynawo/myEnvDynawo.sh"
DYNAWO_MYENVDYNAWORTE = "/home/vermeulenthi/Projects/dynawo/dynawo-rte/myEnvDynawoRTE.sh"

JOBS_XSD_PATH = DYNAWO_HOME / "dynawo/dynawo/sources/API/JOB/xsd/jobs.xsd"
PAR_XSD_PATH = DYNAWO_HOME / "dynawo/dynawo/sources/API/PAR/xsd/parameters.xsd"
DYD_XSD_PATH = DYNAWO_HOME / "dynawo/dynawo/sources/API/DYD/xsd/dyd.xsd"
TL_XSD_PATH = DYNAWO_HOME / "dynawo/dynawo/sources/API/TL/xsd/timeline.xsd"
