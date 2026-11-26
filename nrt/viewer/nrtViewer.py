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

##
# Local web viewer for non-regression test results and simulation outputs.
#
# Two modes:
# - NRT results: reads the results.json file written by nrt.py
# - jobs files (--jobs): reads the outputs of one or several jobs files, compared with their reference directory if any
# It relies on the python standard library (h5py being only needed for HDF5 curves) and on the nrt_diff scripts,
# so that it can be deployed with Dynawo and used for any project running its NRT with nrt.py.

import argparse
import bisect
import collections
import difflib
import errno
import importlib
import json
import math
import mimetypes
import os
import re
import shutil
import signal
import socketserver
import subprocess
import sys
import threading
import time
import webbrowser
import xml.etree.ElementTree as ElementTree
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs

##
# Import a module of the nrt_diff scripts, so that the viewer applies exactly the NRT comparison rules
# (loaded on first use: it requires lxml and the nrt_diff scripts, next to the viewer once deployed)
# @param module_name : "nrtDiff" or "iidmDiff"
# @param required_attribute : attribute the module must provide (older nrt_diff scripts may lack it)
_nrt_diff_modules = {}
_nrt_diff_lock = threading.Lock()
def nrtDiffModule(module_name, required_attribute):
    with _nrt_diff_lock:
        if module_name not in _nrt_diff_modules:
            _nrt_diff_modules[module_name] = importNrtDiffModule(module_name)
        module = _nrt_diff_modules[module_name]
    if isinstance(module, ViewerError):
        raise module
    if not hasattr(module, required_attribute):
        raise ViewerError(501, "The nrt_diff scripts in " + os.path.dirname(module.__file__) + " are too old for the viewer (no " +
                          required_attribute + ")")
    return module

##
# @return the module, or the ViewerError explaining why it cannot be imported (kept to avoid retrying at each request)
def importNrtDiffModule(module_name):
    candidates = [os.getenv("DYNAWO_NRT_DIFF_DIR"),
                  os.path.join(VIEWER_DIR, os.pardir, "nrt_diff"), # deployed: sbin/nrt/{viewer,nrt_diff}
                  os.path.join(VIEWER_DIR, os.pardir, os.pardir, "util", "nrt_diff")] # sources: nrt/viewer, util/nrt_diff
    for candidate in candidates:
        if candidate and os.path.isfile(os.path.join(candidate, module_name + ".py")):
            nrt_diff_dir = os.path.realpath(candidate)
            break
    else:
        return ViewerError(501, "nrt_diff scripts not found: set DYNAWO_NRT_DIFF_DIR to the directory containing " + module_name + ".py")
    if nrt_diff_dir not in sys.path:
        sys.path.append(nrt_diff_dir)
    try:
        return importlib.import_module(module_name)
    except (Exception, SystemExit) as exc: # nrt_diff scripts call sys.exit when a dependency is missing
        return ViewerError(501, "nrt_diff comparison unavailable (" + module_name + ": " + str(exc) + "), install lxml then restart the viewer")

VIEWER_DIR = os.path.dirname(os.path.realpath(__file__))
STATIC_DIR = os.path.join(VIEWER_DIR, "static")
RESULTS_FILE_NAME = "results.json"
SUPPORTED_JSON_VERSION = 1
REFERENCE_DIRECTORY_NAME = "reference"
# directories that are never displayed in the file tree (generated, huge and never compared)
SKIPPED_DIRECTORIES = set(["compilation", "curvesOutput"])
# text diffs (difflib) become very slow on big files with many differences
MAX_DIFF_FILE_SIZE = 5 * 1024 * 1024
MAX_DIFF_FILE_LINES = 50000
MAX_DIFF_ROWS = 20000
# raw files are sent by chunks of lines
DEFAULT_RAW_LINES = 5000
MAX_RAW_LINES = 50000
MAX_IIDM_ROWS = 500
# maximum number of curves sent at once when several curves are plotted together (exploration without reference)
MAX_SERIES = 50
# the full DTW costs n x m operations in pure python: when the cheap bounds do not conclude, it is only computed
# within these budgets while listing the curves (each remaining curve is computed on demand)
DTW_BUDGET_PER_CURVE = 4 * 1000 * 1000
DTW_BUDGET_PER_FILE = 20 * 1000 * 1000
DIFF_CONTEXT_LINES = 3
CSRF_HEADER = "X-NRT-Viewer"
# --exit-on-close: the pages send a heartbeat, and a last message when they are closed. The server stops when no page is open:
# - CLOSE_GRACE_DELAY after the last page was closed (a page reload also sends the closing message, then reconnects)
# - HEARTBEAT_TIMEOUT without heartbeat (closing message lost, browser killed). The heartbeat is sent by a web worker,
#   whose timers are not slowed down in background tabs (contrary to the page ones, down to once per minute in Chrome)
HEARTBEAT_PERIOD = 5
HEARTBEAT_TIMEOUT = 20
CLOSE_GRACE_DELAY = 10
# timestamp at the beginning of a log line, e.g. "2026-11-16 09:34:26,123 | INFO | ..."
LOG_TIMESTAMP_REGEX = re.compile(r"^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}(?:[.,]\d+)?\s*")
# tokens for the highlighting of the changes inside a modified line: numbers as a whole, words, spaces, single symbols
INLINE_TOKEN_REGEX = re.compile(r"[-+]?\d+(?:\.\d*)?(?:[eE][-+]?\d+)?|\w+|\s+|.")
MAX_INLINE_DIFF_LENGTH = 2000  # longer lines are not highlighted
MIN_INLINE_DIFF_RATIO = 0.3  # lines sharing less than that are shown as entirely different
HDF5_EXTENSIONS = (".h5", ".hdf5")
# simulations run again from the viewer: last console lines kept, sent by chunks to the page
RUN_MAX_LINES = 5000
# nrtDiff messages may contain html markup (e.g. <font color="red">)
HTML_TAG_REGEX = re.compile(r"<[^>]+>")


class ViewerError(Exception):
    def __init__(self, code, message):
        Exception.__init__(self, message)
        self.code = code
        self.message = message


##
# Holds the NRT results and every file-system access done by the viewer
class NrtResults:
    ##
    # @param compare_default : whether the viewer starts comparing the outputs with the references (can be switched in the page)
    def __init__(self, results_path, read_only, compare_default=True):
        self.results_path_ = results_path
        self.read_only_ = read_only
        self.compare_default_ = compare_default
        self.lock_ = threading.Lock()
        self.mtime_ = None
        self.data_ = None
        self.cases_ = {}
        self.accepted_ = {} # jobs_dir -> list of relative paths whose reference was updated
        self.curves_cache_ = {} # path -> (mtime, curves)
        self.iidm_cache_ = {} # (output path, reference path) -> (mtimes, differences)
        self.dtw_cache_ = {} # (output path, reference path, mtimes, curve name, max dtw) -> verdict
        self.runs_ = {} # case id -> Run, simulations run again from the viewer

    ##
    # (Re)load the json file if it changed since last load (e.g. a new NRT run)
    def load(self):
        with self.lock_:
            try:
                mtime = os.path.getmtime(self.results_path_)
            except OSError:
                raise ViewerError(404, "Results file not found: " + self.results_path_)
            if mtime == self.mtime_:
                return
            with open(self.results_path_, encoding="utf-8") as results_file:
                data = json.load(results_file)
            if data.get("version", 0) > SUPPORTED_JSON_VERSION:
                print("Warning: results file version " + str(data.get("version")) + " is newer than the viewer one")
            self.relocateSnapshots(data)
            self.data_ = data
            self.cases_ = dict((case["case"], case) for case in data.get("cases", []))
            if self.mtime_ is not None:
                # new NRT run: previous reference updates are not relevant anymore
                self.accepted_ = {}
                print("Results reloaded from " + self.results_path_)
            self.mtime_ = mtime

    ##
    # Snapshot directories are stored as absolute paths: if the results directory was moved
    # (e.g. downloaded from a CI), find them again relatively to the json file location
    def relocateSnapshots(self, data):
        recorded_output_dir = data.get("output_dir", "")
        actual_output_dir = os.path.dirname(os.path.realpath(self.results_path_))
        if not recorded_output_dir or recorded_output_dir == actual_output_dir:
            return
        for case in data.get("cases", []):
            for job in case.get("jobs", []):
                snapshot_dir = job.get("snapshot_dir") or ""
                if snapshot_dir and not os.path.isdir(snapshot_dir) and snapshot_dir.startswith(recorded_output_dir):
                    job["snapshot_dir"] = actual_output_dir + snapshot_dir[len(recorded_output_dir):]

    def getCase(self, case_id):
        self.load()
        if case_id not in self.cases_:
            raise ViewerError(404, "Unknown test case " + str(case_id))
        return self.cases_[case_id]

    @staticmethod
    def jobsDir(case):
        return case.get("jobs_dir") or os.path.dirname(case["jobs_file"])

    def summary(self):
        self.load()
        summary = dict(self.data_)
        summary.setdefault("mode", "nrt")
        summary.setdefault("results_file", os.path.realpath(self.results_path_) if self.results_path_ else "")
        summary["read_only"] = self.read_only_
        summary["compare_default"] = self.compare_default_
        summary["run_unavailable"] = self.runUnavailable()
        cases = []
        for case in self.data_.get("cases", []):
            case = dict(case)
            case["reference_updated"] = list(self.accepted_.get(self.jobsDir(case), []))
            # outputs run again from the viewer: the comparison statuses are not up to date anymore
            case["rerun"] = case["case"] in self.runs_
            cases.append(case)
        summary["cases"] = cases
        return summary

    ##
    # Return the output directories of the jobs of a case as tuples
    # (relative path to the jobs directory, directory where the outputs are read, job id)
    # The snapshot copied by nrt.py is preferred as it is the state that was compared to the reference
    def outputRoots(self, case):
        jobs_dir = self.jobsDir(case)
        roots = []
        for job in case.get("jobs", []):
            output_dir = job.get("output_dir") or ""
            if not output_dir:
                continue
            relative_output_dir = os.path.relpath(output_dir, jobs_dir)
            if relative_output_dir.startswith(os.pardir):
                continue
            snapshot_dir = job.get("snapshot_dir") or ""
            # once run again from the viewer, the fresh outputs are read instead of the NRT snapshot
            use_snapshot = os.path.isdir(snapshot_dir) and case.get("case") not in self.runs_
            read_dir = snapshot_dir if use_snapshot else output_dir
            roots.append((os.path.normpath(relative_output_dir), read_dir, job.get("job")))
        # longest relative path first so that nested output directories are matched first
        roots.sort(key=lambda root: len(root[0]), reverse=True)
        return roots

    ##
    # Resolve a path relative to the jobs directory on a given side
    # @param side : "out" (simulation outputs) or "ref" (reference data)
    def resolve(self, case, side, relative_path):
        relative_path = os.path.normpath(relative_path or "")
        if relative_path.startswith(os.pardir) or os.path.isabs(relative_path):
            raise ViewerError(400, "Invalid path " + relative_path)
        jobs_dir = self.jobsDir(case)
        if side == "ref":
            root = os.path.join(jobs_dir, REFERENCE_DIRECTORY_NAME)
            path = os.path.join(root, relative_path)
        elif side == "out":
            root = None
            for relative_output_dir, read_dir, _ in self.outputRoots(case):
                if relative_output_dir == os.curdir:
                    root = read_dir
                    path = os.path.join(read_dir, relative_path)
                    break
                if relative_path == relative_output_dir or relative_path.startswith(relative_output_dir + os.sep):
                    root = read_dir
                    path = os.path.join(read_dir, os.path.relpath(relative_path, relative_output_dir))
                    break
            if root is None:
                root = jobs_dir
                path = os.path.join(jobs_dir, relative_path)
        else:
            raise ViewerError(400, "Invalid side " + str(side))
        real_root = os.path.realpath(root)
        real_path = os.path.realpath(path)
        if real_path != real_root and not real_path.startswith(real_root + os.sep):
            raise ViewerError(403, "Path outside of the test case directories")
        return real_path

    ##
    # Build the file tree of a case: union of output and reference files, with comparison status
    # and the job owning each file (None when the file is outside every job output directory)
    def fileTree(self, case):
        jobs_dir = self.jobsDir(case)
        roots = self.outputRoots(case)
        entries = {}

        def jobOf(relative_path):
            for relative_output_dir, _, job_id in roots:
                if relative_output_dir == os.curdir or relative_path == relative_output_dir \
                        or relative_path.startswith(relative_output_dir + os.sep):
                    return job_id
            return None

        def newEntry(relative_path):
            return {"path": relative_path, "job": jobOf(relative_path), "out": False, "ref": False, "status": None, "message": ""}

        def addEntry(relative_path, side):
            entry = entries.setdefault(relative_path, newEntry(relative_path))
            entry[side] = True

        def walk(directory, relative_prefix, side):
            if not os.path.isdir(directory):
                return
            for root, directories, file_names in os.walk(directory):
                directories[:] = sorted(d for d in directories if d not in SKIPPED_DIRECTORIES)
                for file_name in file_names:
                    if file_name == "info.txt" and side == "out":
                        continue # written by nrt.py in the snapshot directory
                    relative_path = os.path.normpath(os.path.join(relative_prefix, os.path.relpath(os.path.join(root, file_name), directory)))
                    addEntry(relative_path, side)

        for relative_output_dir, read_dir, _ in roots:
            walk(read_dir, relative_output_dir, "out")
            walk(os.path.join(jobs_dir, REFERENCE_DIRECTORY_NAME, relative_output_dir), relative_output_dir, "ref")

        for compared_file in case.get("compared_files", []):
            relative_path = os.path.normpath(compared_file["path"])
            entry = entries.setdefault(relative_path, newEntry(relative_path))
            entry["status"] = compared_file.get("status")
            entry["message"] = HTML_TAG_REGEX.sub("", compared_file.get("message", ""))

        jobs = []
        for job in case.get("jobs", []):
            relative_output_dir = ""
            for root_relative_dir, _, job_id in roots:
                if job_id == job.get("job"):
                    relative_output_dir = root_relative_dir
            jobs.append({"job": job.get("job"), "name": job.get("name", ""), "solver": job.get("solver", ""),
                         "output_dir": relative_output_dir})
        return {"files": sorted(entries.values(), key=lambda entry: entry["path"]), "jobs": jobs}

    def textPath(self, case, side, relative_path):
        path = self.resolve(case, side, relative_path)
        if not os.path.isfile(path):
            raise ViewerError(404, "File not found on " + side + " side: " + relative_path)
        with open(path, "rb") as text_file:
            if b"\0" in text_file.read(8192):
                raise ViewerError(415, "Binary file, it cannot be displayed as text: " + relative_path)
        return path

    ##
    # Read a chunk of lines of a text file (big files are displayed progressively)
    def readLines(self, case, side, relative_path, offset, limit):
        path = self.textPath(case, side, relative_path)
        offset = max(0, offset)
        limit = max(1, min(limit, MAX_RAW_LINES))
        lines = []
        total = 0
        with open(path, "rb") as text_file:
            for line in text_file:
                if offset <= total < offset + limit:
                    lines.append(line.decode("utf-8", errors="replace").rstrip("\r\n"))
                total += 1
        return {"lines": lines, "offset": offset, "total_lines": total}

    def readText(self, case, side, relative_path):
        path = self.textPath(case, side, relative_path)
        with open(path, "rb") as text_file:
            return text_file.read().decode("utf-8", errors="replace")

    ##
    # Side by side diff of a text file between outputs and reference
    def diff(self, case, relative_path, ignore_timestamps):
        for side in ("out", "ref"):
            path = self.textPath(case, side, relative_path)
            if os.path.getsize(path) > MAX_DIFF_FILE_SIZE:
                raise ViewerError(413, "File too large for a text diff (" + str(os.path.getsize(path) // (1024 * 1024)) + " MB on " +
                                  side + " side, limit " + str(MAX_DIFF_FILE_SIZE // (1024 * 1024)) + " MB)")
        left = self.readText(case, "out", relative_path).splitlines()
        right = self.readText(case, "ref", relative_path).splitlines()
        if max(len(left), len(right)) > MAX_DIFF_FILE_LINES:
            raise ViewerError(413, "File too large for a text diff (" + str(max(len(left), len(right))) + " lines, limit " +
                              str(MAX_DIFF_FILE_LINES) + ")")
        if ignore_timestamps:
            left_cmp = [LOG_TIMESTAMP_REGEX.sub("", line) for line in left]
            right_cmp = [LOG_TIMESTAMP_REGEX.sub("", line) for line in right]
        else:
            left_cmp = left
            right_cmp = right
        matcher = difflib.SequenceMatcher(None, left_cmp, right_cmp, autojunk=False)
        rows = []
        nb_changes = 0
        truncated = False
        for tag, i1, i2, j1, j2 in matcher.get_opcodes():
            if tag == "equal":
                length = i2 - i1
                if length > 2 * DIFF_CONTEXT_LINES + 1:
                    for k in range(DIFF_CONTEXT_LINES):
                        rows.append(["equal", i1 + k + 1, left[i1 + k], j1 + k + 1, right[j1 + k]])
                    rows.append(["skip", length - 2 * DIFF_CONTEXT_LINES])
                    for k in range(length - DIFF_CONTEXT_LINES, length):
                        rows.append(["equal", i1 + k + 1, left[i1 + k], j1 + k + 1, right[j1 + k]])
                else:
                    for k in range(length):
                        rows.append(["equal", i1 + k + 1, left[i1 + k], j1 + k + 1, right[j1 + k]])
            else:
                nb_changes += 1
                for k in range(max(i2 - i1, j2 - j1)):
                    left_index = i1 + k
                    right_index = j1 + k
                    row = [tag,
                           left_index + 1 if left_index < i2 else None, left[left_index] if left_index < i2 else None,
                           right_index + 1 if right_index < j2 else None, right[right_index] if right_index < j2 else None]
                    if left_index < i2 and right_index < j2:
                        # the ignored timestamp prefix is not part of the compared text: shift the spans by its length
                        changes = inlineChanges(left_cmp[left_index], right_cmp[right_index],
                                                len(left[left_index]) - len(left_cmp[left_index]),
                                                len(right[right_index]) - len(right_cmp[right_index]))
                        if changes is not None:
                            row.append(changes)
                    rows.append(row)
            if len(rows) > MAX_DIFF_ROWS:
                truncated = True
                break
        return {"rows": rows, "nb_changes": nb_changes, "truncated": truncated,
                "nb_lines_out": len(left), "nb_lines_ref": len(right)}

    ##
    # Object by object comparison of an output IIDM file with its reference, using nrtDiff's iidmDiff
    # @param filters : dict with optional keys within (bool), type, attribute, search, offset, limit
    def iidmComparison(self, case, relative_path, filters):
        iidm_diff = nrtDiffModule("iidmDiff", "compareOutputIIDM")
        out_path = self.resolve(case, "out", relative_path)
        ref_path = self.resolve(case, "ref", relative_path)
        for side, path in (("output", out_path), ("reference", ref_path)):
            if not os.path.isfile(path):
                raise ViewerError(404, "No " + side + " file: " + relative_path)
        key = (out_path, ref_path)
        mtimes = (os.path.getmtime(out_path), os.path.getmtime(ref_path))
        with self.lock_:
            cached = self.iidm_cache_.get(key)
        if cached is not None and cached[0] == mtimes:
            differences = cached[1]
        else:
            differences = iidm_diff.compareOutputIIDM(out_path, ref_path, True)
            for difference in differences:
                difference.pop("message", None)
                if difference["delta"] is not None:
                    try:
                        scale = max(abs(float(difference["left"])), abs(float(difference["right"])))
                    except (TypeError, ValueError):
                        scale = 0.
                    difference["rel_delta"] = difference["delta"] / scale if scale > 0 else None
                else:
                    difference["rel_delta"] = None
            with self.lock_:
                if len(self.iidm_cache_) > 8:
                    self.iidm_cache_.clear()
                self.iidm_cache_[key] = (mtimes, differences)

        within = filters.get("within", False)
        nb_beyond = sum(1 for d in differences if not d["within_tolerance"])
        nb_within = len(differences) - nb_beyond
        shown = [d for d in differences if within or not d["within_tolerance"]]

        groups = {}
        for difference in shown:
            group_key = (difference["type"], difference["attribute"] or "", difference["category"] if difference["category"].startswith("missing") else "")
            group = groups.setdefault(group_key, {"type": difference["type"], "attribute": difference["attribute"],
                                                  "category": group_key[2] or None, "count": 0, "max_delta": None})
            group["count"] += 1
            if difference["delta"] is not None and (group["max_delta"] is None or difference["delta"] > group["max_delta"]):
                group["max_delta"] = difference["delta"]
        summary = sorted(groups.values(), key=lambda g: (-g["count"], g["type"], g["attribute"] or ""))

        type_filter = filters.get("type")
        attribute_filter = filters.get("attribute")
        search = (filters.get("search") or "").lower()
        if type_filter:
            shown = [d for d in shown if d["type"] == type_filter]
        if attribute_filter:
            shown = [d for d in shown if (d["attribute"] or "") == attribute_filter]
        if search:
            shown = [d for d in shown if search in d["id"].lower()]
        # largest absolute (or relative) delta first; differences without delta (missing objects, discrete values) last
        sort_key = "rel_delta" if filters.get("sort") == "rel_delta" else "delta"
        shown = sorted(shown, key=lambda d: (d[sort_key] is None, -(d[sort_key] or 0.), d["type"], d["id"], d["attribute"] or ""))
        offset = max(0, filters.get("offset", 0))
        limit = max(1, min(filters.get("limit", 100), MAX_IIDM_ROWS))
        return {"nb_beyond_tolerance": nb_beyond, "nb_within_tolerance": nb_within,
                "tolerance": getattr(getattr(iidm_diff, "settings", None), "max_iidm_cmp_tol", None),
                "summary": summary, "filtered": len(shown), "offset": offset, "rows": shown[offset:offset + limit]}

    ##
    # Read a curves file (csv or xml) and return (times, {name: values}), cached on modification time
    def readCurves(self, path):
        mtime = os.path.getmtime(path)
        with self.lock_:
            cached = self.curves_cache_.get(path)
            if cached is not None and cached[0] == mtime:
                return cached[1]
        if path.endswith(".xml"):
            curves = readXmlCurves(path)
        elif path.endswith(HDF5_EXTENSIONS):
            curves = readHdf5Curves(path)
        else:
            curves = readCsvCurves(path)
        with self.lock_:
            if len(self.curves_cache_) > 16:
                self.curves_cache_.clear()
            self.curves_cache_[path] = (mtime, curves)
        return curves

    ##
    # @param compare : False to only read the outputs (exploration without reference)
    def curvesSides(self, case, relative_path, compare=True):
        sides = {}
        for side in ("out", "ref"):
            path = self.resolve(case, side, relative_path)
            sides[side] = self.readCurves(path) if os.path.isfile(path) and (compare or side == "out") else None
        return sides

    ##
    # List the variables of a curves file sorted by decreasing discrepancy with the reference
    # @param compare : False to only list the output curves in file order (exploration without reference)
    def curvesSummary(self, case, relative_path, compare=True):
        sides = self.curvesSides(case, relative_path, compare)
        out = sides["out"]
        ref = sides["ref"]
        if not compare:
            if out is None:
                raise ViewerError(404, "No output file: " + relative_path)
            return {"variables": [{"name": name} for name in out["order"]], "out_points": len(out["time"]),
                    "out_range": [out["time"][0], out["time"][-1]] if out["time"] else None, "max_series": MAX_SERIES}
        criteria_context = None
        criterion_error = None
        if out is not None and ref is not None:
            try:
                criteria_context = self.criteriaContext(case, relative_path)
            except ViewerError as exc:
                criterion_error = exc.message
        budget = [DTW_BUDGET_PER_FILE]
        names = []
        for side in (out, ref):
            if side is not None:
                for name in side["order"]:
                    if name not in names:
                        names.append(name)
        variables = []
        for name in names:
            variable = {"name": name, "only": None, "max_abs": None, "max_rel": None, "t_max": None}
            in_out = out is not None and name in out["values"]
            in_ref = ref is not None and name in ref["values"]
            if in_out and in_ref:
                (max_abs, max_rel, t_max) = curveDiscrepancy(out["time"], out["values"][name], ref["time"], ref["values"][name])
                variable["max_abs"] = max_abs
                variable["max_rel"] = max_rel
                variable["t_max"] = t_max
                if criteria_context is not None:
                    variable.update(self.curveVerdict(criteria_context, name, out, ref, budget))
            elif in_out:
                variable["only"] = "out"
            else:
                variable["only"] = "ref"
            variables.append(variable)
        # missing curves first, then failing the nrtDiff criterion, undetermined, passing, and by decreasing relative discrepancy
        verdict_rank = {"KO": 0, "?": 1, "OK": 2}
        variables.sort(key=lambda v: (v["only"] is None, verdict_rank.get(v.get("verdict"), 3),
                                      -(v["max_rel"] if v["max_rel"] is not None else 0)))

        def timeRange(side):
            if side is None or len(side["time"]) == 0:
                return None
            return [side["time"][0], side["time"][-1]]
        return {"variables": variables,
                "max_dtw": criteria_context["max_dtw"] if criteria_context is not None else None,
                "max_time_error": criteria_context["max_time_error"] if criteria_context is not None else None,
                "criterion_error": criterion_error,
                "out_points": len(out["time"]) if out is not None else 0,
                "ref_points": len(ref["time"]) if ref is not None else 0,
                "out_range": timeRange(out), "ref_range": timeRange(ref)}

    ##
    # Everything needed to apply the nrtDiff curve criteria to the curves of a file:
    # the DTW distance and, with recent nrt_diff scripts, the time-aligned error (a curve is KO when one of them is)
    def criteriaContext(self, case, relative_path):
        nrt_diff = nrtDiffModule("nrtDiff", "DTWDistance")
        settings = nrt_diff.settings
        # nrtDiff matches its exceptions on the paths of the files it compares, in the test case directory
        jobs_dir = self.jobsDir(case)
        path_left = os.path.join(jobs_dir, relative_path)
        path_right = os.path.join(jobs_dir, REFERENCE_DIRECTORY_NAME, relative_path)

        def tolerance(default_name, exceptions_name):
            default = getattr(settings, default_name, None)
            exceptions = getattr(settings, exceptions_name, {})
            if hasattr(nrt_diff, "GetTolerance"):
                return nrt_diff.GetTolerance(default, exceptions, path_left, path_right)
            for exception in exceptions:
                if exception in path_left or exception in path_right:
                    return exceptions[exception]
            return default

        max_dtw = tolerance("max_DTW", "dtw_exceptions")
        has_time_aligned = hasattr(nrt_diff, "TimeAlignedError")
        max_time_error = tolerance("max_time_aligned_error", "time_aligned_error_exceptions") if has_time_aligned else None
        if max_dtw is None and max_time_error is None:
            raise ViewerError(501, "No curve criterion is enabled in the nrt_diff settings")
        out_path = self.resolve(case, "out", relative_path)
        ref_path = self.resolve(case, "ref", relative_path)
        return {"module": nrt_diff, "max_dtw": max_dtw, "max_time_error": max_time_error,
                "key": (out_path, ref_path, os.path.getmtime(out_path), os.path.getmtime(ref_path), max_dtw, max_time_error)}

    ##
    # Apply the nrtDiff criteria to one curve (see nrtDiff.CompareCurves)
    # - time-aligned error (cheap, always computed exactly) : KO when greater than max_time_error
    # - DTW distance: KO when greater than max_dtw. The full DTW costs n x m operations, so cheap bounds are tried first:
    #   . the diagonal path cost is an upper bound of the DTW (already used by nrtDiff)
    #   . every point is paired with at least one point of the other curve: the sum of the distances
    #     to the closest values of the other curve is a lower bound of the DTW
    # @param budget : list holding the remaining number of operations allowed for full DTW computations (None: no limit)
    # @return dict with verdict ("OK", "KO" or "?" when undetermined within the budget), and per criterion:
    #         dtw_verdict, dtw (value or bound), dtw_kind ("exact", "at_most", "at_least"), time_verdict, time_error
    def curveVerdict(self, context, name, out, ref, budget):
        key = context["key"] + (name,)
        with self.lock_:
            cached = self.dtw_cache_.get(key)
        if cached is not None and (cached["verdict"] != "?" or budget is not None):
            return cached
        nrt_diff = context["module"]
        result = {"dtw_verdict": None, "dtw": None, "dtw_kind": None, "time_verdict": None, "time_error": None}

        max_time_error = context["max_time_error"]
        if max_time_error is not None:
            (times_left, values_left) = nrtDiffPoints(out["time"], out["values"][name])
            (times_right, values_right) = nrtDiffPoints(ref["time"], ref["values"][name])
            time_error = nrt_diff.TimeAlignedError(times_left, values_left, times_right, values_right)
            result["time_error"] = time_error
            result["time_verdict"] = "KO" if time_error > max_time_error else "OK"

        max_dtw = context["max_dtw"]
        if max_dtw is not None:
            left = nrtDiffSeries(out["time"], out["values"][name])
            right = nrtDiffSeries(ref["time"], ref["values"][name])
            dtw = None
            if left == right:
                dtw = ("OK", 0., "exact")
            if dtw is None and len(left) == len(right):
                diagonal = sum(abs(l - r) for l, r in zip(left, right))
                if diagonal <= max_dtw:
                    dtw = ("OK", diagonal, "at_most")
            if dtw is None:
                lower_bound = max(closestValuesDistance(left, right), closestValuesDistance(right, left))
                if lower_bound > max_dtw:
                    dtw = ("KO", lower_bound, "at_least")
            if dtw is None:
                cost = len(left) * len(right)
                if budget is None or (cost <= DTW_BUDGET_PER_CURVE and cost <= budget[0]):
                    if budget is not None:
                        budget[0] -= cost
                    distance = nrt_diff.DTWDistance(left, right, max_dtw)
                    dtw = ("KO" if distance > max_dtw else "OK", distance, "exact")
                else:
                    dtw = ("?", None, None)
            (result["dtw_verdict"], result["dtw"], result["dtw_kind"]) = dtw

        verdicts = [v for v in (result["time_verdict"], result["dtw_verdict"]) if v is not None]
        result["verdict"] = "KO" if "KO" in verdicts else "?" if "?" in verdicts else "OK"
        with self.lock_:
            if len(self.dtw_cache_) > 50000:
                self.dtw_cache_.clear()
            self.dtw_cache_[key] = result
        return result

    ##
    # Verdict of one curve without computation budget (used when the curve is displayed)
    def curveDtw(self, case, relative_path, name):
        context = self.criteriaContext(case, relative_path)
        sides = self.curvesSides(case, relative_path)
        if sides["out"] is None or sides["ref"] is None or name not in sides["out"]["values"] or name not in sides["ref"]["values"]:
            raise ViewerError(404, "Curve " + str(name) + " is not on both sides")
        return dict(self.curveVerdict(context, name, sides["out"], sides["ref"], None))

    def curve(self, case, relative_path, name):
        sides = self.curvesSides(case, relative_path)
        result = {"name": name}
        for side_name, side in sides.items():
            if side is not None and name in side["values"]:
                result[side_name] = {"t": side["time"], "v": side["values"][name]}
            else:
                result[side_name] = None
        return result

    ##
    # Several output curves of a file, to plot them together (exploration without reference)
    # @return {"t": times, "series": [{"name", "v"}]} for the names found in the file (at most MAX_SERIES)
    def series(self, case, relative_path, names):
        out = self.curvesSides(case, relative_path, False)["out"]
        if out is None:
            raise ViewerError(404, "No output file: " + relative_path)
        if len(names) > MAX_SERIES:
            raise ViewerError(400, "At most " + str(MAX_SERIES) + " curves can be plotted together")
        return {"t": out["time"], "series": [{"name": name, "v": out["values"][name]} for name in names if name in out["values"]]}

    ##
    # Copy outputs onto the reference for the given files of a case
    # @param relative_paths : files to update; if empty, every file failing the comparison (KO or within tolerance)
    def acceptReference(self, case, relative_paths):
        if self.read_only_:
            raise ViewerError(403, "The viewer was started in read-only mode")
        compared = dict((os.path.normpath(f["path"]), f) for f in case.get("compared_files", []))
        if not relative_paths:
            relative_paths = [path for path, f in compared.items() if f.get("status") in ("KO", "Warn")]
        if not relative_paths:
            raise ViewerError(400, "No file to update for this test case")
        copies = []
        for relative_path in relative_paths:
            relative_path = os.path.normpath(relative_path)
            source = self.resolve(case, "out", relative_path)
            destination = self.resolve(case, "ref", relative_path)
            if not os.path.isfile(source):
                raise ViewerError(404, "Output file not found: " + relative_path)
            copies.append((relative_path, source, destination))
        jobs_dir = self.jobsDir(case)
        copied = []
        for relative_path, source, destination in copies:
            destination_dir = os.path.dirname(destination)
            if not os.path.isdir(destination_dir):
                os.makedirs(destination_dir)
            shutil.copyfile(source, destination)
            print("Reference updated: " + destination)
            copied.append(relative_path)
        with self.lock_:
            accepted = self.accepted_.setdefault(jobs_dir, [])
            for relative_path in copied:
                if relative_path not in accepted:
                    accepted.append(relative_path)
        return {"copied": copied}

    ##
    # Why the simulations cannot be run again from the viewer, None when they can
    def runUnavailable(self):
        if self.read_only_:
            return "the viewer was started in read-only mode"
        if not os.getenv("DYNAWO_ENV_DYNAWO"):
            return "DYNAWO_ENV_DYNAWO is not defined (start the viewer with envDynawo.sh nrt-viewer)"
        return None

    ##
    # Run the jobs file of a case again, with the same command as nrt.py: $DYNAWO_ENV_DYNAWO jobs <jobs file>
    # The command is built here from the case: the page only gives the case id
    def startRun(self, case):
        reason = self.runUnavailable()
        if reason is not None:
            raise ViewerError(403, "Simulations cannot be run from the viewer: " + reason)
        with self.lock_:
            run = self.runs_.get(case["case"])
            if run is not None and run.isRunning():
                raise ViewerError(409, "The simulation of this case is already running")
            self.runs_[case["case"]] = Run([os.environ["DYNAWO_ENV_DYNAWO"], "jobs", case["jobs_file"]], self.jobsDir(case))
        return self.runStatus(case, 0)

    ##
    # @param since : number of console lines already received by the page
    def runStatus(self, case, since):
        run = self.runs_.get(case["case"])
        if run is None:
            return {"status": None}
        return run.status(since)

    def stopRun(self, case):
        run = self.runs_.get(case["case"])
        if run is None or not run.isRunning():
            raise ViewerError(409, "No simulation running for this case")
        run.stop()
        return run.status(0)


##
# A simulation run in the background, its console output being kept for the page
class Run:
    def __init__(self, command, directory):
        self.command_ = command
        self.lock_ = threading.Lock()
        self.lines_ = collections.deque(maxlen=RUN_MAX_LINES)
        self.nb_lines_ = 0 # lines received since the start (the oldest ones are dropped from lines_)
        self.start_ = time.time()
        self.end_ = None
        self.stopped_ = False
        print("Running " + " ".join(command))
        # own process group: the stop button stops the launcher and the simulation it started
        self.process_ = subprocess.Popen(command, cwd=directory, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                         stdin=subprocess.DEVNULL, start_new_session=True)
        reader = threading.Thread(target=self.read, name="run-output")
        reader.daemon = True
        reader.start()

    def read(self):
        for line in self.process_.stdout:
            with self.lock_:
                self.lines_.append(line.decode("utf-8", errors="replace").rstrip("\r\n"))
                self.nb_lines_ += 1
        self.process_.wait()
        with self.lock_:
            self.end_ = time.time()
        print("End of " + " ".join(self.command_) + " (return code " + str(self.process_.returncode) + ")")

    def isRunning(self):
        with self.lock_:
            return self.end_ is None

    def stop(self):
        with self.lock_:
            self.stopped_ = True
        try:
            if hasattr(os, "killpg"):
                os.killpg(self.process_.pid, signal.SIGTERM)
            else:
                self.process_.terminate()
        except OSError:
            pass # already finished

    def status(self, since):
        with self.lock_:
            first = self.nb_lines_ - len(self.lines_) # index of the oldest line kept
            start = max(since, first)
            lines = list(self.lines_)[start - first:]
            if self.end_ is None:
                status = "running"
            elif self.stopped_:
                status = "stopped"
            else:
                status = "OK" if self.process_.returncode == 0 else "KO"
            return {"status": status, "return_code": self.process_.returncode if self.end_ is not None else None,
                    "command": " ".join(self.command_), "elapsed": (self.end_ or time.time()) - self.start_,
                    "lines": lines, "next": self.nb_lines_, "skipped": start > since}


##
# Outputs of jobs files run outside of the NRT (e.g. envDynawo.sh jobs-with-curves): one case per jobs file,
# compared with the reference directory next to the jobs file when there is one
class JobsResults(NrtResults):
    def __init__(self, jobs_files, read_only, compare_default=True):
        NrtResults.__init__(self, None, read_only, compare_default)
        self.jobs_files_ = [os.path.realpath(jobs_file) for jobs_file in jobs_files]

    ##
    # Built on first use: the comparison with the references is run once, when the viewer starts
    def load(self):
        with self.lock_:
            if self.data_ is not None:
                return
            cases = []
            for index, jobs_file in enumerate(self.jobs_files_):
                cases.append(self.jobsCase("case_" + str(index), jobs_file))
            self.data_ = {"version": SUPPORTED_JSON_VERSION, "mode": "jobs", "results_file": ", ".join(self.jobs_files_),
                          "cases": cases}
            self.cases_ = dict((case["case"], case) for case in cases)

    def jobsCase(self, case_id, jobs_file):
        jobs_dir = os.path.dirname(jobs_file)
        jobs = parseJobsFile(jobs_file)
        case = {"case": case_id, "name": os.path.basename(jobs_dir) + "/" + os.path.basename(jobs_file), "description": "",
                "directory": jobs_dir, "family": os.path.basename(os.path.dirname(jobs_dir)), "jobs_dir": jobs_dir,
                "jobs_file": jobs_file, "command": "", "time": None, "return_code": None, "simulation_status": None,
                "diff_status": "NoReference", "diff_label": "no reference data", "satisfactory": True,
                "diff_messages": [], "console_errors": "", "compared_files": [], "jobs": jobs}
        if not os.path.isdir(os.path.join(jobs_dir, REFERENCE_DIRECTORY_NAME)):
            return case
        print("Comparing the outputs of " + jobs_file + " with the references...")
        try:
            nrt_diff = nrtDiffModule("nrtDiff", "DirectoryDiffReferenceDataJobDetailed")
            # nrtDiff reads the build type from the environment (set by envDynawo.sh)
            os.environ.setdefault("DYNAWO_BUILD_TYPE", "Release")
            (status, messages, compared_files) = nrt_diff.DirectoryDiffReferenceDataJobDetailed(jobs_file)
        except Exception as exc:
            case["diff_status"] = "Unable"
            case["diff_label"] = "unable to check"
            case["diff_messages"] = [exc.message if isinstance(exc, ViewerError) else str(exc)]
            return case
        case["diff_status"] = nrt_diff.statusCategory(status, True)
        case["diff_label"] = nrt_diff.toString(status, True)
        case["satisfactory"] = status not in nrt_diff.diff_error_statuses(True)
        case["diff_messages"] = [HTML_TAG_REGEX.sub("", message) for message in messages]
        for compared_file in compared_files:
            compared_file["message"] = HTML_TAG_REGEX.sub("", compared_file.get("message", ""))
        case["compared_files"] = compared_files
        return case


##
# Read the jobs of a jobs file without modifying anything (nrtUtils.TestCase.parseJobsFile removes the previous outputs)
# @return list of dict {job, name, description, solver, output_dir, snapshot_dir} as written by nrt.py in results.json
def parseJobsFile(jobs_file):
    def localName(element):
        return element.tag.split("}")[-1]

    def child(element, name):
        for item in element:
            if localName(item) == name:
                return item
        return None

    try:
        root = ElementTree.parse(jobs_file).getroot()
    except (ElementTree.ParseError, OSError) as exc:
        raise ViewerError(422, "Unable to read the jobs file " + jobs_file + ": " + str(exc))
    jobs = []
    for element in root:
        if localName(element) != "job":
            continue
        solver = child(element, "solver")
        outputs = child(element, "outputs")
        output_dir = None
        if outputs is not None and outputs.get("directory"):
            output_dir = os.path.realpath(os.path.join(os.path.dirname(jobs_file), outputs.get("directory")))
        jobs.append({"job": "job_" + str(len(jobs)), "name": element.get("name", ""), "description": "",
                     "solver": solver.get("lib", "") if solver is not None else "", "output_dir": output_dir, "snapshot_dir": None})
    return jobs


##
# Changed parts of a modified line, compared token by token
# @param left_offset, right_offset : added to the spans (length of a prefix excluded from the comparison)
# @return [left_spans, right_spans] with spans as [start, end[ character ranges, or None when highlighting is not relevant
def inlineChanges(left, right, left_offset=0, right_offset=0):
    if len(left) > MAX_INLINE_DIFF_LENGTH or len(right) > MAX_INLINE_DIFF_LENGTH:
        return None
    left_tokens = INLINE_TOKEN_REGEX.findall(left)
    right_tokens = INLINE_TOKEN_REGEX.findall(right)
    matcher = difflib.SequenceMatcher(None, left_tokens, right_tokens, autojunk=False)
    if matcher.ratio() < MIN_INLINE_DIFF_RATIO:
        return None

    def spans(tokens, ranges, offset):
        starts = [0]
        for token in tokens:
            starts.append(starts[-1] + len(token))
        result = []
        for (begin, end) in ranges:
            if begin == end:
                continue
            (start, stop) = (starts[begin] + offset, starts[end] + offset)
            if result and result[-1][1] == start:
                result[-1][1] = stop
            else:
                result.append([start, stop])
        return result

    opcodes = [op for op in matcher.get_opcodes() if op[0] != "equal"]
    return [spans(left_tokens, [(i1, i2) for _, i1, i2, _, _ in opcodes], left_offset),
            spans(right_tokens, [(j1, j2) for _, _, _, j1, j2 in opcodes], right_offset)]


def toInt(text, default):
    try:
        return int(text)
    except (TypeError, ValueError):
        return default

def toFloat(text):
    try:
        return float(text)
    except ValueError:
        return float("nan")

def readCsvCurves(path):
    times = []
    columns = []
    order = []
    with open(path, encoding="utf-8", errors="replace") as csv_file:
        header = csv_file.readline().rstrip("\r\n").split(";")
        while header and header[-1] == "":
            header.pop()
        if not header:
            return {"time": [], "values": {}, "order": []}
        order = header[1:]
        columns = [[] for _ in order]
        for line in csv_file:
            fields = line.rstrip("\r\n").split(";")
            if len(fields) < len(header) or fields[0] == "":
                continue
            times.append(toFloat(fields[0]))
            for index in range(len(order)):
                columns[index].append(toFloat(fields[index + 1]))
    return {"time": times, "values": dict(zip(order, columns)), "order": order}

##
# Read a Dynawo xml curves file: <curvesOutput><curve model=".." variable=".."><point time=".." value=".."/>
# Every curve is resampled on the time grid of the first one when grids differ
def readXmlCurves(path):
    values = {}
    curve_times = {}
    order = []
    for _, element in ElementTree.iterparse(path):
        if element.tag.split("}")[-1] != "curve":
            continue
        name = element.get("model", "") + "_" + element.get("variable", "")
        times = []
        points = []
        for point in element:
            if point.tag.split("}")[-1] == "point":
                times.append(toFloat(point.get("time", "nan")))
                points.append(toFloat(point.get("value", "nan")))
        order.append(name)
        values[name] = points
        curve_times[name] = times
        element.clear()
    if not order:
        return {"time": [], "values": {}, "order": []}
    times = curve_times[order[0]]
    for name in order[1:]:
        if curve_times[name] != times:
            values[name] = [interpolate(curve_times[name], values[name], t) for t in times]
    return {"time": times, "values": values, "order": order}

##
# Read a Dynawo HDF5 curves file with the reader shared with nrtDiff (h5py is only needed here)
def readHdf5Curves(path):
    curves_utils = nrtDiffModule("curvesUtils", "readHdf5Curves")
    try:
        (times, names, values) = curves_utils.readHdf5Curves(path)
    except ImportError:
        raise ViewerError(501, "Displaying HDF5 curves requires the h5py python module (" +
                          sys.executable + " -m pip install h5py), then restart the viewer")
    except ValueError as exc:
        raise ViewerError(422, str(exc))
    return {"time": times, "values": values, "order": names}

##
# Values of a curve as nrtDiff gives them to the DTW (see CSVCloseEnough): one value per time instant
# (the last one at a discontinuity), points going back in time are ignored, sorted by increasing time
def nrtDiffSeries(times, values):
    index_by_time = {}
    previous = None
    for index, t in enumerate(times):
        if previous is None or t >= previous:
            index_by_time[t] = index
        previous = t
    return [values[index_by_time[t]] for t in sorted(index_by_time)]

##
# Points of a curve as nrtDiff gives them to the time-aligned error (see ExtractCurvePoints): every point is kept,
# including a time appearing twice at a discontinuity, except points going back in time
def nrtDiffPoints(times, values):
    kept_times = []
    kept_values = []
    for t, value in zip(times, values):
        if kept_times and t < kept_times[-1]:
            continue
        kept_times.append(t)
        kept_values.append(value)
    return (kept_times, kept_values)

##
# Sum over the values of a curve of the distance to the closest value of another curve.
# In a DTW path every point is paired with at least one point of the other curve, so this is a lower bound of the DTW.
def closestValuesDistance(values, other_values):
    others = sorted(v for v in other_values if not math.isnan(v))
    if not others:
        return 0.
    total = 0.
    for value in values:
        if math.isnan(value):
            continue
        index = bisect.bisect_left(others, value)
        closest = min(abs(value - others[i]) for i in (index - 1, index) if 0 <= i < len(others))
        total += closest
    return total

##
# Linear interpolation of (times, values) at t; values outside the time range are not extrapolated
def interpolate(times, values, t):
    if not times or t < times[0] or t > times[-1]:
        return float("nan")
    index = bisect.bisect_right(times, t)
    if index >= len(times):
        return values[-1]
    if index == 0:
        return values[0]
    t0 = times[index - 1]
    t1 = times[index]
    if t1 == t0:
        return values[index]
    return values[index - 1] + (values[index] - values[index - 1]) * (t - t0) / (t1 - t0)

##
# Maximum discrepancy between an output curve and its reference, over their common time range
# The reference is interpolated on the output time grid.
# @return (max absolute error, max absolute error divided by the reference amplitude, time of the max)
def curveDiscrepancy(out_times, out_values, ref_times, ref_values):
    max_abs = 0.
    t_max = None
    for t, value in zip(out_times, out_values):
        reference = interpolate(ref_times, ref_values, t)
        if math.isnan(reference) or math.isnan(value):
            continue
        error = abs(value - reference)
        if error > max_abs:
            max_abs = error
            t_max = t
    finite_ref = [abs(v) for v in ref_values if not math.isnan(v)]
    scale = max(finite_ref) if finite_ref else 0.
    max_rel = max_abs / scale if scale > 1e-9 else max_abs
    return (max_abs, max_rel, t_max)


##
# Pages currently open, to stop the server once they are all closed (--exit-on-close)
class OpenPages:
    def __init__(self):
        self.lock_ = threading.Lock()
        self.expiry_ = {} # page id -> time after which the page is considered closed
        self.seen_ = False # no stop before a first page was opened (the browser may be slow to start)

    def heartbeat(self, page):
        with self.lock_:
            self.expiry_[str(page)] = time.time() + HEARTBEAT_TIMEOUT
            self.seen_ = True

    ##
    # @return whether the page is known (page ids are random: another web site cannot guess one)
    def closed(self, page):
        with self.lock_:
            if str(page) not in self.expiry_:
                return False
            self.expiry_[str(page)] = time.time() + CLOSE_GRACE_DELAY
        print("Viewer page closed: the server stops in " + str(CLOSE_GRACE_DELAY) + " s if no page is opened again")
        return True

    def allClosed(self):
        now = time.time()
        with self.lock_:
            self.expiry_ = dict((page, expiry) for page, expiry in self.expiry_.items() if expiry > now)
            return self.seen_ and not self.expiry_

    ##
    # Stop the server once every page is closed (to be run in its own thread: shutdown waits for serve_forever)
    def watch(self, server):
        while not self.allClosed():
            time.sleep(1)
        print("Every viewer page was closed: stopping the server")
        server.shutdown()


class ViewerHandler(BaseHTTPRequestHandler):
    results = None # NrtResults, set before starting the server
    open_pages = None # OpenPages when the server stops once its pages are closed (--exit-on-close)

    def log_message(self, format, *args):
        pass # keep the console readable: only errors and reference updates are printed

    def sendJson(self, payload, code=200):
        body = json.dumps(payload, allow_nan=False, default=str).encode("utf-8") if payload is not None else b"null"
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def sendError(self, code, message):
        self.sendJson({"error": message}, code)

    def sendStatic(self, relative_path):
        path = os.path.realpath(os.path.join(STATIC_DIR, relative_path))
        if not path.startswith(STATIC_DIR + os.sep) or not os.path.isfile(path):
            self.sendError(404, "Not found")
            return
        with open(path, "rb") as static_file:
            body = static_file.read()
        content_type = mimetypes.guess_type(path)[0] or "application/octet-stream"
        if content_type.startswith("text/") or content_type == "application/javascript":
            content_type += "; charset=utf-8"
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-cache")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        url = urlparse(self.path)
        query = dict((key, values[0]) for key, values in parse_qs(url.query).items())
        try:
            if url.path in ("/", "/index.html"):
                self.sendStatic("index.html")
            elif url.path.startswith("/static/"):
                self.sendStatic(url.path[len("/static/"):])
            elif url.path == "/api/results":
                summary = self.results.summary()
                summary["heartbeat_period"] = HEARTBEAT_PERIOD if self.open_pages is not None else None
                self.sendJson(summary)
            elif url.path == "/api/tree":
                case = self.results.getCase(query.get("case"))
                self.sendJson(self.results.fileTree(case))
            elif url.path == "/api/file":
                case = self.results.getCase(query.get("case"))
                self.sendJson(self.results.readLines(case, query.get("side"), query.get("path"),
                                                     toInt(query.get("offset"), 0), toInt(query.get("limit"), DEFAULT_RAW_LINES)))
            elif url.path == "/api/iidm":
                case = self.results.getCase(query.get("case"))
                filters = {"within": query.get("within") == "1", "type": query.get("type"), "attribute": query.get("attribute"),
                           "search": query.get("search"), "offset": toInt(query.get("offset"), 0), "limit": toInt(query.get("limit"), 100),
                           "sort": query.get("sort")}
                self.sendJson(sanitize(self.results.iidmComparison(case, query.get("path"), filters)))
            elif url.path == "/api/diff":
                case = self.results.getCase(query.get("case"))
                self.sendJson(self.results.diff(case, query.get("path"), query.get("ignore_timestamps") == "1"))
            elif url.path == "/api/curves":
                case = self.results.getCase(query.get("case"))
                self.sendJson(sanitize(self.results.curvesSummary(case, query.get("path"), query.get("compare") != "0")))
            elif url.path == "/api/dtw":
                case = self.results.getCase(query.get("case"))
                self.sendJson(sanitize(self.results.curveDtw(case, query.get("path"), query.get("name"))))
            elif url.path == "/api/run":
                case = self.results.getCase(query.get("case"))
                self.sendJson(sanitize(self.results.runStatus(case, toInt(query.get("since"), 0))))
            elif url.path == "/api/curve":
                case = self.results.getCase(query.get("case"))
                self.sendJson(sanitize(self.results.curve(case, query.get("path"), query.get("name"))))
            else:
                self.sendError(404, "Not found")
        except ViewerError as exc:
            self.sendError(exc.code, exc.message)
        except Exception as exc:
            print("Error while serving " + self.path + ": " + repr(exc))
            self.sendError(500, str(exc))

    def do_POST(self):
        url = urlparse(self.path)
        try:
            length = int(self.headers.get("Content-Length", "0"))
            body = json.loads(self.rfile.read(length).decode("utf-8") or "{}")
            # closing message sent by navigator.sendBeacon, which cannot add a header: it only acts on a page id
            # given to the server by a heartbeat, that another web page cannot know
            if url.path == "/api/closed":
                known = self.open_pages is not None and self.open_pages.closed(body.get("page"))
                self.sendJson({"closed": known})
                return
            # a custom header cannot be sent cross-origin without a preflight that this server never accepts:
            # it prevents another web page from triggering a reference update or a simulation
            if self.headers.get(CSRF_HEADER) != "1":
                raise ViewerError(403, "Missing " + CSRF_HEADER + " header")
            if url.path == "/api/accept":
                case = self.results.getCase(body.get("case"))
                self.sendJson(self.results.acceptReference(case, body.get("paths") or []))
            elif url.path == "/api/run":
                case = self.results.getCase(body.get("case"))
                self.sendJson(sanitize(self.results.startRun(case)))
            elif url.path == "/api/run/stop":
                case = self.results.getCase(body.get("case"))
                self.sendJson(sanitize(self.results.stopRun(case)))
            elif url.path == "/api/heartbeat":
                if self.open_pages is not None:
                    self.open_pages.heartbeat(body.get("page"))
                self.sendJson({"exit_on_close": self.open_pages is not None})
            elif url.path == "/api/series":
                # POST as the list of curve names may be too long for a URL (nothing is modified)
                case = self.results.getCase(body.get("case"))
                self.sendJson(sanitize(self.results.series(case, body.get("path"), body.get("names") or [])))
            else:
                self.sendError(404, "Not found")
        except ViewerError as exc:
            self.sendError(exc.code, exc.message)
        except Exception as exc:
            print("Error while serving " + self.path + ": " + repr(exc))
            self.sendError(500, str(exc))


##
# Replace NaN values (not valid in json) by None
def sanitize(payload):
    if isinstance(payload, float):
        return None if math.isnan(payload) or math.isinf(payload) else payload
    if isinstance(payload, dict):
        return dict((key, sanitize(value)) for key, value in payload.items())
    if isinstance(payload, (list, tuple)):
        return [sanitize(value) for value in payload]
    return payload


class ThreadingServer(socketserver.ThreadingMixIn, HTTPServer):
    daemon_threads = True
    allow_reuse_address = True


def defaultResultsPath():
    nrt_dir = os.getenv("DYNAWO_NRT_DIR")
    branch_name = os.getenv("DYNAWO_BRANCH_NAME")
    if nrt_dir is None:
        return None
    if os.getenv("DYNAWO_JENKINS_MODE", "NO") == "YES" or branch_name is None:
        return os.path.join(nrt_dir, "output", RESULTS_FILE_NAME)
    return os.path.join(nrt_dir, "output", branch_name, RESULTS_FILE_NAME)


def main():
    parser = argparse.ArgumentParser(description="Local web viewer for non-regression test results (results.json written by nrt.py) "
                                     "or for the outputs of jobs files")
    parser.add_argument("results", nargs="?", help="results.json file or directory containing it "
                        "(default: $DYNAWO_NRT_DIR/output/$DYNAWO_BRANCH_NAME/results.json)")
    parser.add_argument("--jobs", nargs="+", metavar="JOBS_FILE", help="display the outputs of these jobs files instead of NRT results "
                        "(compared with the reference directory next to each jobs file, if any)")
    parser.add_argument("--no-reference", action="store_true", help="start without comparing with the references "
                        "(only the outputs are displayed, several curves can be plotted together; can be switched in the page)")
    parser.add_argument("--port", type=int, default=8000, help="first port to try (default: 8000)")
    parser.add_argument("--host", default="127.0.0.1", help="interface to listen on (default: 127.0.0.1, local access only)")
    parser.add_argument("--read-only", action="store_true", help="disable reference update")
    parser.add_argument("--browser", help="browser command used to open the viewer (default: no browser opened)")
    parser.add_argument("--exit-on-close", action="store_true", help="stop the server once every viewer page is closed "
                        "(about " + str(CLOSE_GRACE_DELAY) + " s after, or " + str(HEARTBEAT_TIMEOUT) + " s if the browser was killed)")
    options = parser.parse_args()

    read_only = options.read_only
    if options.host not in ("127.0.0.1", "localhost", "::1") and not read_only:
        print("Warning: the viewer is reachable from other machines, reference update is disabled (read-only mode)")
        read_only = True

    if options.jobs:
        if options.results:
            parser.error("give either a results file or --jobs, not both")
        for jobs_file in options.jobs:
            if not os.path.isfile(jobs_file):
                print("Jobs file not found: " + jobs_file)
                sys.exit(1)
        results_path = ", ".join(options.jobs)
        ViewerHandler.results = JobsResults(options.jobs, read_only, not options.no_reference)
    else:
        results_path = options.results or defaultResultsPath()
        if results_path is None:
            parser.error("no results file given and DYNAWO_NRT_DIR is not defined")
        if os.path.isdir(results_path):
            results_path = os.path.join(results_path, RESULTS_FILE_NAME)
        if not os.path.isfile(results_path):
            print("Results file not found: " + results_path)
            print("Run the non-regression tests first (a recent nrt.py writes it next to report.html)")
            sys.exit(1)
        ViewerHandler.results = NrtResults(results_path, read_only, not options.no_reference)
    try:
        ViewerHandler.results.load()
    except ViewerError as exc:
        print(exc.message)
        sys.exit(1)

    server = None
    for port in range(options.port, options.port + 20):
        try:
            server = ThreadingServer((options.host, port), ViewerHandler)
            break
        except OSError as exc:
            if exc.errno != errno.EADDRINUSE:
                raise
    if server is None:
        print("No free port found between " + str(options.port) + " and " + str(options.port + 19))
        sys.exit(1)

    url = "http://" + ("localhost" if options.host in ("127.0.0.1", "::1") else options.host) + ":" + str(server.server_address[1]) + "/"
    print("NRT viewer: " + url + "  (results: " + results_path + ")" + ("  [read-only]" if read_only else ""))
    if options.exit_on_close:
        print("The server stops once the viewer page is closed (or press Ctrl+C)")
        ViewerHandler.open_pages = OpenPages()
        watcher = threading.Thread(target=ViewerHandler.open_pages.watch, args=(server,), name="exit-on-close")
        watcher.daemon = True
        watcher.start()
    else:
        print("Press Ctrl+C to stop")
    if options.browser:
        try:
            webbrowser.get(options.browser + " %s &").open(url)
        except webbrowser.Error:
            webbrowser.open(url)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
