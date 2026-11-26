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
# Reading of the Dynawo curves files shared by nrtDiff and the NRT viewer.
# h5py is an optional dependency: it is only imported when an HDF5 curves file is read.

HDF5_EXTENSIONS = (".h5", ".hdf5")
# datasets written by the HDF5 curves exporter (see CRVHdf5Exporter)
HDF5_TIME_DATASET = "time"
HDF5_DATA_DATASET = "data"
HDF5_NAMES_DATASET = "curve_names"

##
# @return the h5py module, or None when it is not installed
def importH5py():
    try:
        import h5py
        return h5py
    except ImportError:
        return None

##
# Whether HDF5 curves files can be read (h5py installed)
def isHdf5Available():
    return importH5py() is not None

##
# Whether a path is an HDF5 curves file, from its extension
def isHdf5File(path):
    return path.lower().endswith(HDF5_EXTENSIONS)

##
# Read a Dynawo HDF5 curves file: datasets "time" (n), "data" (n x m) and "curve_names" (m)
# @param path : the HDF5 file to read
# @return (times, names, values) with times a list of n floats, names the list of the m curve names in file order,
#         and values a dict curve name -> list of n floats
# @throw ImportError if h5py is not installed, ValueError if the file is not a Dynawo HDF5 curves file
def readHdf5Curves(path):
    h5py = importH5py()
    if h5py is None:
        raise ImportError("the h5py python module is required to read HDF5 curves files")
    with h5py.File(path, "r") as h5_file:
        for dataset in (HDF5_TIME_DATASET, HDF5_DATA_DATASET, HDF5_NAMES_DATASET):
            if dataset not in h5_file:
                raise ValueError("unexpected HDF5 curves file, dataset '" + dataset + "' missing: " + path)
        times = [float(t) for t in h5_file[HDF5_TIME_DATASET][()]]
        names = [name.decode("utf-8") if isinstance(name, bytes) else str(name) for name in h5_file[HDF5_NAMES_DATASET][()]]
        data = h5_file[HDF5_DATA_DATASET][()]
    if len(names) == 0 or len(times) == 0:
        return (times, names, dict((name, []) for name in names))
    if data.shape != (len(times), len(names)):
        raise ValueError("unexpected HDF5 curves file, dataset '" + HDF5_DATA_DATASET + "' has shape " + str(data.shape) +
                         " instead of " + str((len(times), len(names))) + ": " + path)
    # the transposition is done in python so that numpy (installed with h5py) stays an implementation detail
    rows = data.tolist()
    values = dict((name, [float(row[index]) for row in rows]) for index, name in enumerate(names))
    return (times, names, values)
