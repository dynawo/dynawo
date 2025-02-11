
import argparse
import logging
import math
from pathlib import Path
import time

from player import Player
from utils import WORKSPACE_ROOT
from logging_config import setup_logging


def main():
    setup_logging()
    logger = logging.getLogger(__name__)

    parser = argparse.ArgumentParser()
    parser.add_argument("base_dir", help="Base directory where data is located (jobs, dyd, etc.)")
    parser.add_argument("--curves", "-c", action="store_true", help="display curves")
    parser.add_argument("--timeline", "-t", action="store_true", help="display timeline")
    parser.add_argument("--diff", "-d", action="store_true", help="display difference between init state values (k+1) and final state values (k)")
    parser.add_argument("--rte", "-r", action="store_true", help="use with dynawoRTE version")
    parser.add_argument("--events_file", "-e", help="events PAR file")
    args = parser.parse_args()
    testcase_dir = Path(args.base_dir).resolve()
    display_curves_opt = args.curves
    display_timeline_opt = args.timeline
    display_diff_opt = args.diff
    dynawo_rte = args.rte

    if not testcase_dir.exists():
        raise NotADirectoryError("Invalid base directory {base_dir}")

    workspace_dir = (WORKSPACE_ROOT / (testcase_dir.name + "_" + str(math.floor(time.time())))).resolve()
    workspace_dir.mkdir( parents=True, exist_ok=True )
    logger.info(f"New workspace: {workspace_dir}")

    player = Player(workspace_dir, Path(testcase_dir), dynawo_rte)
    player.run()
    if display_curves_opt: player.display_curves()
    if display_timeline_opt: player.display_timeline()
    if display_diff_opt: player.display_final_vs_init_cmp()

if __name__ == "__main__":
    main()
