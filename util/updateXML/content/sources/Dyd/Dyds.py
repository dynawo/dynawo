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


class Dyds:
    """
    Collection of Dyd files

    Attribute
    ----------
    _dyds_collection : list[DydData]
        collection of Dyd files
    """
    def __init__(self):
        self._dyds_collection = dict()

    def get_bbms(self, func):
        selected_bbms = list()
        for dyd in self._dyds_collection.values():
            bbms = dyd._get_bbms(func)
            selected_bbms.extend(bbms)
        return selected_bbms

    def get_modelica_models(self, func):
        selected_modelica_models = list()
        for dyd in self._dyds_collection.values():
            modelica_models = dyd._get_modelica_models(func)
            selected_modelica_models.extend(modelica_models)
        return selected_modelica_models

    def get_model_templates(self, func):
        selected_model_templates = list()
        for dyd in self._dyds_collection.values():
            model_templates = dyd._get_model_templates(func)
            selected_model_templates.extend(model_templates)
        return selected_model_templates

    def get_model_template_expansions(self, func):
        selected_model_template_expansions = list()
        for dyd in self._dyds_collection.values():
            model_template_expansions = dyd._get_model_template_expansions(func)
            selected_model_template_expansions.extend(model_template_expansions)
        return selected_model_template_expansions

    def remove_macro_connector(self, id):
        for dyd in self._dyds_collection.values():
            dyd._remove_macro_connector(id)

    def remove_macro_static_reference(self, id):
        for dyd in self._dyds_collection.values():
            dyd._remove_macro_static_reference(id)
