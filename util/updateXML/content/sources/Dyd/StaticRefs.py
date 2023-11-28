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


from ..utils.Common import *


class StaticRefs:
    """
    Class to interact with staticRef elements related to a model

    Attributes
    ----------
    __model_xml_tree : lxml.etree._Element
        model element tree containing the staticRef element
    __model_id : str
        model id of the model element containing staticRef elements
    __dyd_root_tree : lxml.etree._ElementTree
        element tree of the Dyd file
    """
    def __init__(self, model_xml_tree):
        self.__model_xml_tree = model_xml_tree
        self.__model_id = self.__model_xml_tree.attrib['id']
        self.__dyd_root_tree = self.__model_xml_tree.getroottree()

    # ---------------------------------------------------------------
    #   USER METHODS
    # ---------------------------------------------------------------

    def change_var_name(self, current_var, new_var):
        """
        Modify var attribute

        Parameters:
            current_var (str): current var name to change
            new_var (str): new var name to change
        """
        static_ref_to_modify = list()

        model_static_ref_subelem_xpath = './dyn:staticRef[@var="' + current_var + '"]'
        static_refs = self.__model_xml_tree.xpath(model_static_ref_subelem_xpath, namespaces=NAMESPACE_URI)
        static_ref_to_modify.extend(static_refs)

        model_macro_static_ref_subelem_xpath = './dyn:macroStaticRef'
        model_macro_static_ref_subelems = self.__model_xml_tree.xpath(model_macro_static_ref_subelem_xpath,
                                                                        namespaces=NAMESPACE_URI)
        for model_macro_static_ref_subelem in model_macro_static_ref_subelems:
            static_refs_in_macro_static_ref_xpath = '/dyn:dynamicModelsArchitecture/dyn:macroStaticReference[@id="' + \
                                                        model_macro_static_ref_subelem.attrib['id'] + \
                                                        '"]/dyn:staticRef[@var="' + current_var + '"]'
            static_refs_in_macro_static_ref = self.__dyd_root_tree.xpath(static_refs_in_macro_static_ref_xpath,
                                                                            namespaces=NAMESPACE_URI)
            static_ref_to_modify.extend(static_refs_in_macro_static_ref)

        if len(static_ref_to_modify) == 0:
            pass  # nothing to do
        elif len(static_ref_to_modify) == 1:
            static_ref_to_modify[0].attrib['var'] = new_var
        else:
            raise DuplicateStaticRefsError(current_var, self.__model_id, self.__model_xml_tree.base)

    def remove_static_ref(self, var):
        static_ref_to_remove = list()

        static_ref_xpath = './dyn:staticRef[@var="' + var + '"]'
        static_ref = self.__model_xml_tree.xpath(static_ref_xpath, namespaces=NAMESPACE_URI)
        static_ref_to_remove.extend(static_ref)

        macro_static_refs_xpath = './dyn:macroStaticRef'
        macro_static_refs = self.__model_xml_tree.xpath(macro_static_refs_xpath, namespaces=NAMESPACE_URI)
        for macro_static_ref in macro_static_refs:
            macro_static_reference_static_ref_xpath = '/dyn:dynamicModelsArchitecture/dyn:macroStaticReference[@id="' + \
                                                        macro_static_ref.attrib['id'] + '"]/dyn:staticRef[@var="' + \
                                                        var + '"]'
            macro_static_reference_static_ref = self.__dyd_root_tree.xpath(macro_static_reference_static_ref_xpath,
                                                                            namespaces=NAMESPACE_URI)
            static_ref_to_remove.extend(macro_static_reference_static_ref)

        if len(static_ref_to_remove) == 0:
            pass  # nothing to do
        elif len(static_ref_to_remove) == 1:
            static_ref_to_remove[0].getparent().remove(static_ref_to_remove[0])
            static_ref_to_remove.clear()
        else:
            raise DuplicateStaticRefsError(var, self.__model_id, self.__model_xml_tree.base)
