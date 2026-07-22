#!/usr/bin/env python3
# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite of
# simulation tools for power systems.

"""Streamlit viewer for Dynawo HDF5 curves files.

Launch via envDynawo.sh (jobs-with-curves) or directly:
    streamlit run app.py -- --jobsFile path/to/sim.jobs
    streamlit run app.py -- --h5File  path/to/curves.h5
"""

import os
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

import h5py
import numpy as np
import plotly.graph_objects as go
import streamlit as st

_NS = {"dyn": "http://www.rte-france.com/dynawo"}


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _get_cli_arg(flag: str) -> str | None:
    """Return the value of --flag or --flag=value from sys.argv, or None."""
    for i, arg in enumerate(sys.argv):
        if arg == flag and i + 1 < len(sys.argv):
            return sys.argv[i + 1]
        if arg.startswith(f"{flag}="):
            return arg.split("=", 1)[1]
    return None


def find_h5_files(jobs_path: str) -> list[tuple[str, str]]:
    """Return [(job_name, h5_path), ...] for every HDF5 curves entry in a .jobs file."""
    jobs_path = Path(jobs_path).resolve()
    base = jobs_path.parent
    try:
        root = ET.parse(jobs_path).getroot()
    except ET.ParseError as exc:
        st.error(f"Cannot parse jobs file: {exc}")
        return []

    results = []
    for job in root.findall("dyn:job", _NS):
        name = job.get("name", "unnamed")
        outputs = job.find("dyn:outputs", _NS)
        if outputs is None:
            continue
        curves = outputs.find("dyn:curves", _NS)
        if curves is None or curves.get("exportMode") != "HDF5":
            continue
        out_dir = outputs.get("directory", "outputs")
        h5 = base / out_dir / "curves" / "curves.h5"
        results.append((name, str(h5)))
    return results


def load_h5(h5_path: str) -> tuple[np.ndarray, np.ndarray, list[str]]:
    """Return (time, data, curve_names) from a Dynawo HDF5 curves file."""
    with h5py.File(h5_path, "r") as f:
        time = f["time"][:]
        data = f["data"][:]
        raw = f["curve_names"][:]
    names = [n.decode() if isinstance(n, bytes) else str(n) for n in raw]
    return time, data, names


# ---------------------------------------------------------------------------
# Main UI
# ---------------------------------------------------------------------------

def main() -> None:
    st.set_page_config(page_title="Dynawo Curves", layout="wide")
    st.title("Dynawo Curves Viewer")

    # --- resolve the HDF5 file to open ---
    jobs_arg = _get_cli_arg("--jobsFile")
    h5_arg   = _get_cli_arg("--h5File")

    h5_path: str | None = None

    if h5_arg and os.path.isfile(h5_arg):
        h5_path = h5_arg
        st.caption(f"`{h5_path}`")

    elif jobs_arg and os.path.isfile(jobs_arg):
        entries = find_h5_files(jobs_arg)
        if not entries:
            st.warning("No HDF5 curves found in the jobs file.")
            return
        if len(entries) == 1:
            h5_path = entries[0][1]
            st.caption(f"Job: **{entries[0][0]}** — `{h5_path}`")
        else:
            label_map = {f"{n}  ({p})": p for n, p in entries}
            sel = st.selectbox("Select job", list(label_map))
            h5_path = label_map[sel]

    else:
        raw = st.text_input(
            "Path to .jobs file or curves.h5",
            placeholder="/path/to/sim.jobs  or  /path/to/curves.h5",
        )
        if not raw:
            st.info("Provide a `.jobs` or `.h5` file path above, or launch with `--jobsFile` / `--h5File`.")
            return
        raw = raw.strip()
        if raw.endswith(".jobs"):
            entries = find_h5_files(raw)
            if not entries:
                st.error("No HDF5 curves found in that jobs file.")
                return
            label_map = {f"{n}": p for n, p in entries}
            sel = st.selectbox("Select job", list(label_map))
            h5_path = label_map[sel]
        else:
            h5_path = raw

    if not h5_path or not os.path.isfile(h5_path):
        st.error(f"HDF5 file not found: {h5_path}")
        return

    # --- load data ---
    try:
        time, data, curve_names = load_h5(h5_path)
    except Exception as exc:
        st.error(f"Failed to read HDF5 file: {exc}")
        return

    n_steps, n_curves = data.shape
    st.caption(f"{n_curves} curves · {n_steps} time steps · t ∈ [{time[0]:.3g}, {time[-1]:.3g}] s")

    # --- curve selection ---
    col_sel, col_all = st.columns([6, 1])
    with col_all:
        select_all = st.checkbox("All", value=False)
    with col_sel:
        default = curve_names if select_all else []
        selected = st.multiselect("Curves", options=curve_names, default=default)

    if not selected:
        st.info("Select at least one curve.")
        return

    # --- plot ---
    fig = go.Figure()
    name_to_idx = {n: i for i, n in enumerate(curve_names)}
    for name in selected:
        fig.add_trace(go.Scatter(
            x=time,
            y=data[:, name_to_idx[name]],
            mode="lines",
            name=name,
        ))

    fig.update_layout(
        xaxis_title="Time (s)",
        yaxis_title="Value",
        hovermode="x unified",
        legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1),
        margin=dict(t=60),
    )
    st.plotly_chart(fig, use_container_width=True)


if __name__ == "__main__":
    main()
