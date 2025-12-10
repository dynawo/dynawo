# -*- coding: utf-8 -*-

# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.

import os
import platform

from utils import *
from headerPatternDefine import HeaderPatternDefine
from subprocess import Popen, PIPE
########################################################
#
#                  Writer Base
#
########################################################

##
# Writer Base
#
class ModelWriterBase:
    ##
    # default constructor
    # @param self : object pointer
    # @param mod_name : model name to use when creating file
    def __init__(self,mod_name):
        ##  model name to use when creating file
        self.mod_name = mod_name
        ## data to print in cpp file
        self.file_content = []
        ## data to print in header file
        self.file_content_h = []
        ## data to print in header definition file
        self.file_content_definitions_h = []
        ## data to print header literals file
        self.file_content_literals_h = []

    ##
    # write cpp file
    # @param self : object pointer
    # @return
    def write_file(self):
        write_file (self.file_content, self.fileName)

    ##
    # write header file
    # @param self : object pointer
    # @return
    def write_header_file(self):
        write_file (self.file_content_h, self.fileName_h)


##
# Writer Manager
#
class ModelWriterManager(ModelWriterBase):
    ##
    # default constructor
    # @param self : object pointer
    # @param mod_name : name of the model
    # @param output_dir : directory where files should be written
    # @param package_name: name of the Modelica package containing the model
    # @param init_pb : @b True if the model has an init model
    def __init__(self,mod_name,output_dir, package_name, init_pb):
        ModelWriterBase.__init__(self,mod_name.replace(package_name, ''))
        ## name of the model to use in files
        self.className = self.mod_name
        ## canonical name of the cpp file
        self.fileName = os.path.join (output_dir, self.className + ".cpp")
        ## canonical name of the header file
        self.fileName_h = os.path.join (output_dir, self.className + ".h")
        ## indicates if the model has an init model
        self.hasInitPb = init_pb
        ## body of the cpp file
        self.body ="""
#include "__fill_model_name__.h"
#include "DYNSubModel.h"
__fill_model_include_header__

extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::Model__fill_model_name__Factory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::Model__fill_model_name__Factory::create() const
{
  DYN::SubModel* model (new DYN::Model__fill_model_name__() );
  return model;
}

extern "C" void DYN::Model__fill_model_name__Factory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

Model__fill_model_name__::Model__fill_model_name__() {
__fill_model_constructor__
}

Model__fill_model_name__::~Model__fill_model_name__() {
__fill_model_destructor__
}

}

"""
        ## body of the header file
        self.bodyHeader="""
#ifndef __fill_model_name___h
#define __fill_model_name___h
#include "DYNModelManager.h"
#include "DYNSubModelFactory.h"

namespace DYN {

  class Model__fill_model_name__Factory : public SubModelFactory
  {
    public:
    Model__fill_model_name__Factory() {}
    ~Model__fill_model_name__Factory() {}

    SubModel* create() const;
    void destroy(SubModel*) const;
  };

  class Model__fill_model_name__ : public ModelManager
  {
    public:
    Model__fill_model_name__();
    ~Model__fill_model_name__();

    bool hasInit() const { return __fill_has_init_model__; }
  };
}

#endif
"""
    ##
    # Defines the body of the cpp file (add new lines)
    # @param self : object pointer
    # @return
    def set_body(self):
        lines = self.body.split('\n')
        body = []
        for line in lines:
            body.append(line+'\n')

        for line in body:
            if "__fill_model_name__" in line:
                line_tmp = line.replace("__fill_model_name__",self.mod_name)
                self.file_content.append(line_tmp)
            elif "__fill_model_include_header__" in line:
                self.file_content.append(HASHTAG_INCLUDE+ self.mod_name+"_Dyn.h\"\n")
                if self.hasInitPb:
                    self.file_content.append(HASHTAG_INCLUDE+ self.mod_name+"_Init.h\"\n")
            elif "__fill_model_constructor__" in line:
                self.file_content.append("  modelType_ = std::string(\"" +self.mod_name +"\");\n")
                self.file_content.append("  modelDyn_ = NULL;\n")
                self.file_content.append("  modelInit_ = NULL;\n")
                self.file_content.append("  modelDyn_ = new Model"+ self.mod_name+"_Dyn();\n")
                self.file_content.append("  modelDyn_->setModelManager(this);\n")
                self.file_content.append("  modelDyn_->setModelType(this->modelType());\n")
                if self.hasInitPb:
                    self.file_content.append("  modelInit_ = new Model"+ self.mod_name+"_Init();\n")
                    self.file_content.append("  modelInit_->setModelManager(this);\n")
                    self.file_content.append("  modelInit_->setModelType(this->modelType());\n")
            elif "__fill_model_destructor__" in line:
                self.file_content.append("  delete modelDyn_;\n")
                if self.hasInitPb:
                    self.file_content.append("  delete modelInit_;\n")
            else:
                self.file_content.append(line)

    ##
    # Defines the body of the header file (add new lines)
    # @param self : object pointer
    # @return
    def setBodyHeader(self):
        lines = self.bodyHeader.split('\n')
        body = []
        for line in lines:
            body.append(line+'\n')

        for line in body:
            if "__fill_model_name__" in line:
                line_tmp = line.replace("__fill_model_name__",self.mod_name)
                self.file_content_h.append(line_tmp)
            elif "__fill_has_init_model__" in line:
                fill_string = "false"
                if self.hasInitPb:
                    fill_string = "true"
                line_tmp = line.replace("__fill_has_init_model__",fill_string)
                self.file_content_h.append(line_tmp)
            else:
                self.file_content_h.append(line)


##
# Writer
#
class ModelWriter(ModelWriterBase):
    ##
    # default constructor
    # @param obj_factory : builder associated to the writer
    # @param mod_name : name of the model
    # @param output_dir : output directory where files should be written
    # @param package_name: name of the Modelica package containing the model
    # @param init_pb : indicates if the model is an init model
    def __init__(self, obj_factory, mod_name, output_dir, package_name, init_pb = False):
        ModelWriterBase.__init__(self,mod_name.replace(package_name, ''))
        ## builder associated to the writer
        self.builder = obj_factory
        ## indicates if the model is an init model
        self.init_pb_ = init_pb
        ## define the name of the class to use in cpp/h files
        self.className =""
        if init_pb:
            self.className = self.mod_name + "_Init"
        else:
            self.className = self.mod_name + "_Dyn"

        ## Cpp file to generate
        self.fileName = os.path.join(output_dir, self.className + ".cpp")

        ## header file to generate
        self.fileName_h = os.path.join(output_dir, self.className + ".h")

        ## header file to generate
        self.fileNameLiterals_h = os.path.join(output_dir, self.className + "_literal.h")

        ## header file to generate
        self.fileNameDefinitions_h = os.path.join(output_dir, self.className + "_definition.h")

        ## filename for external functions
        self.fileName_external   = os.path.join(output_dir, self.className + "_external.cpp")

        ## List of external functions
        self.file_content_external=[]
        ## data to print header literals file
        self.file_content_literals_h = []

        ## constant used for void method declaration
        self.void_function_prefix = "void Model"

    ##
    # Add an empty line in external file
    # @param self : object pointer
    # @return
    def addEmptyLine_external(self):
        self.file_content_external.append("\n")

    ##
    # Add a line in external file
    # @param self : object pointer
    # @param line : line to add
    # @return
    def addLine_external(self, line):
        self.file_content_external.append(line)

    ##
    # Add a list of lines in external file
    # @param self : object pointer
    # @param body : list of lines to add
    # @return
    def addBody_external(self, body):
        self.file_content_external.extend(body)

    ##
    # Add empty line in file
    # @param self : object pointer
    # @return
    def addEmptyLine(self):
        self.file_content.append("\n")

    ##
    # Add a line in file
    # @param self : object pointer
    # @param line : line to add
    # @return
    def addLine(self, line):
        self.file_content.append(line)

    ##
    # Add a list of lines in file
    # @param self : object pointer
    # @param body : list of lines to add
    # @return
    def addBody(self, body):
        self.file_content.extend(body)


    ##
    # define the head of the external file
    # @param self : object pointer
    # @return
    def getHeadExternalCalls(self):
        self.file_content_external.append("#include <math.h>\n")
        self.file_content_external.append("#include \"DYNModelManager.h\"\n") # DYN_assert overload
        if self.init_pb_:
            self.file_content_external.append(HASHTAG_INCLUDE + self.mod_name + "_Init_literal.h\"\n")
        else:
            self.file_content_external.append(HASHTAG_INCLUDE + self.mod_name + "_Dyn_literal.h\"\n")
        self.file_content_external.append(HASHTAG_INCLUDE + self.className + ".h\"\n")
        self.file_content_external.append("namespace DYN {\n")
        self.file_content_external.append("\n")

    ##
    # define the head of the cpp file
    # @param self : object pointer
    # @return
    def getHead(self):
        self.file_content.append("#include <limits>\n")
        self.file_content.append("#include <cassert>\n")
        self.file_content.append("#include <set>\n")
        self.file_content.append("#include <iostream>\n")
        self.file_content.append("#include <string>\n")
        self.file_content.append("#include <vector>\n")
        self.file_content.append("#include <math.h>\n")
        self.file_content.append("\n")
        self.file_content.append("#include \"DYNElement.h\"\n")
        self.file_content.append("#include \"PARParametersSetFactory.h\"\n")
        self.file_content.append("#include \"DYNModelManager.h\"\n")
        self.file_content.append("#pragma GCC diagnostic ignored \"-Wunused-parameter\"\n")
        self.file_content.append("\n")
        self.file_content.append(HASHTAG_INCLUDE + self.className + ".h\"\n")
        if self.init_pb_:
            self.file_content.append(HASHTAG_INCLUDE + self.mod_name + "_Init_definition.h\"\n")
            self.file_content.append(HASHTAG_INCLUDE + self.mod_name + "_Init_literal.h\"\n")
        else:
            self.file_content.append(HASHTAG_INCLUDE + self.mod_name + "_Dyn_definition.h\"\n")
            self.file_content.append(HASHTAG_INCLUDE + self.mod_name + "_Dyn_literal.h\"\n")
        self.file_content.append("\n")
        self.file_content.append("\n")
        self.file_content.append("namespace DYN {\n")
        self.file_content.append("\n")

    ##
    # define the end of the cpp file
    # @param self : object pointer
    # @return
    def fill_tail(self):
        self.addEmptyLine()
        self.addLine("}")

    ##
    # define the end of the external file
    # @param self : object pointer
    # @return
    def fill_tailExternalCalls(self):
        self.addEmptyLine_external()
        self.addLine_external("}")


    ##
    # Add the body of setFomc in the cpp file
    # @param self : object pointer
    # @return
    def fill_setFomc(self):
        self.addEmptyLine()

        self.addLine(self.void_function_prefix+ self.className + "::setFomc(double * f, propertyF_t type)\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_setf())
        self.addLine("}\n")

    ##
    # Add the body of evalMode in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalMode(self):
        self.addEmptyLine()

        self.addLine("modeChangeType_t Model" + self.className + "::evalMode(const double t) const\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_evalmode())
        self.addLine("}\n")

    ##
    # Add the body of setZomc in the cpp file
    # @param self : object pointer
    # @return
    def fill_setZomc(self):
        self.addEmptyLine()

        self.addLine(self.void_function_prefix+ self.className + "::setZomc()\n")
        self.addLine("{\n")

        if (len(self.builder.get_list_for_setz()) > 0):
            self.addLine("  data->simulationInfo->discreteCall = 1;\n")
            self.addBody(self.builder.get_list_for_setz())
            self.addLine("  data->simulationInfo->discreteCall = 0;\n")
        self.addLine("}\n")

    ##
    # Add the body of collectSilentZ in the cpp file
    # @param self : object pointer
    # @return
    def fill_collectSilentZ(self):
        self.addEmptyLine()

        self.addLine(self.void_function_prefix+ self.className + "::collectSilentZ(BitMask* silentZTable)\n")
        self.addLine("{\n")

        if (len(self.builder.get_list_for_collectsilentz()) > 0):
            self.addBody(self.builder.get_list_for_collectsilentz())
        self.addLine("}\n")

    ##
    # Add the body of setGomc in the cpp file
    # @param self : object pointer
    # @return
    def fill_setGomc(self):
        self.addEmptyLine()

        self.addLine(self.void_function_prefix+ self.className + "::setGomc(state_g * gout)\n")
        self.addLine("{\n")

        if (len(self.builder.get_list_for_setg()) > 0):
            self.addLine("  data->simulationInfo->discreteCall = 1;\n")
            self.addBody(self.builder.get_list_for_setg())
            self.addLine("  data->simulationInfo->discreteCall = 0;\n")
        self.addLine("}\n")


    ##
    # Add the body of setY0omc in the cpp file
    # @param self : object pointer
    # @return
    def fill_setY0omc(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::setY0omc()\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_sety0())
        self.addLine("}\n")

    ##
    # Add the body of callCustomParametersConstructors in the cpp file
    # @param self : object pointer
    # @return
    def fill_callCustomParametersConstructors(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::callCustomParametersConstructors()\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_callcustomparametersconstructors())
        self.addLine("}\n")

    ##
    # Add the body of setVariables in the cpp file
    # @param self : object pointer
    # @return
    def fill_setVariables(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_setvariables())
        self.addLine("}\n")

    ##
    # Add the body of defineParameters in the cpp file
    # @param self : object pointer
    # @return
    def fill_defineParameters(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::defineParameters(std::vector<ParameterModeler>& parameters)\n")
        self.addLine("{\n")
        self.addBody(self.builder.get_list_for_defineparameters())
        self.addLine("}\n")

    ##
    # Add the body of initRpar in the cpp file
    # @param self : object pointer
    # @return
    def fill_initRpar(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::initRpar()\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_initrpar())

        self.addEmptyLine()
        self.addLine("  return;\n")
        self.addLine("}\n")

    ##
    # Add the body of setupDataStruc in the cpp file
    # @param self : object pointer
    # @return/
    def fill_setupDataStruc(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::setupDataStruc()\n")
        self.addLine("{\n")
        self.addEmptyLine()

        self.addBody(self.builder.get_setupdatastruc())

        self.addLine("  data->nbVars ="+str(len(self.builder.list_vars_syst) - len(self.builder.reader.auxiliary_vars_counted_as_variables))+";\n")
        self.addLine("  data->nbF = "+str(self.builder.get_nb_eq_dyn()) +";\n")
        self.addLine("  data->nbModes = " +str(self.builder.get_nb_modes()) + ";\n")
        self.addLine("  data->nbZ = "+str(self.builder.nb_z)+";\n")
        self.addLine("  data->nbCalculatedVars = "+str(self.builder.get_nb_calculated_variables())+";\n")
        self.addLine("  data->nbDelays = "+str(self.builder.get_nb_delays()) +";\n")
        self.addLine("  data->constCalcVars.resize("+str(self.builder.get_nb_const_variables())+", 0.);\n")
        self.addLine("}\n")

    ##
    # Add the body of evalStaticYType_omc in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalStaticYType_omc(self):
        self.addEmptyLine()
        if self.init_pb_ and len(self.builder.get_list_for_evalstaticytype()) == 0:
          self.addLine(self.void_function_prefix+ self.className + "::evalStaticYType_omc(propertyContinuousVar_t* /*yType*/)\n")
        else:
          self.addLine(self.void_function_prefix+ self.className + "::evalStaticYType_omc(propertyContinuousVar_t* yType)\n")

        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_evalstaticytype())

        self.addLine("}\n")

    ##
    # Add the body of evalStaticYType_omc in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalDynamicYType_omc(self):
        self.addEmptyLine()
        if self.init_pb_ and len(self.builder.get_list_for_evaldynamicytype()) == 0:
          self.addLine(self.void_function_prefix+ self.className + "::evalDynamicYType_omc(propertyContinuousVar_t* /*yType*/)\n")
        else:
          self.addLine(self.void_function_prefix+ self.className + "::evalDynamicYType_omc(propertyContinuousVar_t* yType)\n")

        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_evaldynamicytype())

        self.addLine("}\n")

    ##
    # Add the body of evalStaticFType_omc in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalStaticFType_omc(self):
        self.addEmptyLine()
        if self.init_pb_ and len(self.builder.get_list_for_evalstaticftype()) == 0:
          self.addLine(self.void_function_prefix+ self.className + "::evalStaticFType_omc(propertyF_t* /*fType*/)\n")
        else:
          self.addLine(self.void_function_prefix+ self.className + "::evalStaticFType_omc(propertyF_t* fType)\n")

        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_evalstaticftype())

        self.addLine("}\n")

    ##
    # Add the body of evalStaticFType_omc in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalDynamicFType_omc(self):
        self.addEmptyLine()
        if self.init_pb_ and len(self.builder.get_list_for_evaldynamicftype()) == 0:
          self.addLine(self.void_function_prefix+ self.className + "::evalDynamicFType_omc(propertyF_t* /*fType*/)\n")
        else:
          self.addLine(self.void_function_prefix+ self.className + "::evalDynamicFType_omc(propertyF_t* fType)\n")

        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_evaldynamicftype())

        self.addLine("}\n")

    ##
    # Add the body of defineElements in the cpp file
    # @param self : object pointer
    # @return
    def fill_defineElements(self):
        self.addEmptyLine()
        if self.init_pb_ and len(self.builder.get_list_for_defelem()) == 0:
          self.addLine(self.void_function_prefix+ self.className + "::defineElements(std::vector<Element>& /*elements*/, std::map<std::string, int >& /*mapElement*/)\n")
        else:
          self.addLine(self.void_function_prefix+ self.className + "::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)\n")
        self.addLine("{\n")

        self.addBody( self.builder.get_list_for_defelem() )
        self.addLine("}\n")

    ##
    # Add the body of setParameters in the cpp file
    # @param self : object pointer
    # @return
    def fill_setParameters(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::setParameters( std::shared_ptr<parameters::ParametersSet> params )\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_setparams())
        self.addLine("}\n")

    ##
    # Add the body of setInternalParameters in the cpp file
    # @param self : object pointer
    # @return
    def fill_setSharedParamsDefault(self):
        self.addEmptyLine()
        self.addLine("std::shared_ptr<parameters::ParametersSet> Model" + self.className + "::setSharedParametersDefaultValues()\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_setsharedparamsdefaultvalue())
        self.addLine("}\n")

    ##
    # Add the body of evalFAdept in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalFAdept(self):
        self.addEmptyLine()
        self.addLine("#ifdef _ADEPT_\n")
        self.addLine(self.void_function_prefix+ self.className + "::evalFAdept(const std::vector<adept::adouble> & x,\n")
        self.addLine("                              const std::vector<adept::adouble> & xd,\n")
        self.addLine("                              std::vector<adept::adouble> & res)\n")
        self.addLine("{\n")

        self.addBody( self.builder.get_list_for_evalfadept() )

        self.addLine("}\n")
        self.addLine("#endif\n")

    ##
    # Add literal constants in .h file
    # @param self : object pointer
    # @return
    def fill_externalLiteralConstants(self):
        new_content_h = []
        for line in self.file_content_literals_h:
            if "__fill_model_name__" in line:
                line = line.replace("__fill_model_name__", self.mod_name)
                new_content_h.append (line)
            elif ("__insert_literals__") in line:
                new_content_h.extend (self.builder.get_list_for_literalconstants())
            else:
                new_content_h.append (line)
        self.file_content_literals_h = new_content_h

    ##
    # Add the body of externalCalls in the external file
    # @param self : object pointer
    # @return
    def fill_externalCalls(self):
        self.addEmptyLine_external()
        body = self.builder.get_list_for_externalcalls()
        body_tmp=[]
        for line in body:
            if "__fill_model_name__" in line:
                line = line.replace("__fill_model_name__", "Model" + self.className)
            body_tmp.append(line)

        external_call_body = self.builder.get_list_for_evalfadept_external_call()
        if len(external_call_body) > 0:
            body_tmp.append("#ifdef _ADEPT_\n")
            for line in external_call_body:
                if "__fill_model_name__" in line:
                    line = line.replace("__fill_model_name__", "Model" + self.className)
                body_tmp.append(line)
            body_tmp.append("#endif\n")
        self.addBody_external(body_tmp)

    ##
    # Add the body of initData in the cpp file
    # @param self : object pointer
    # @return
    def fill_initData(self):
        self.addEmptyLine()
        self.addLine("void Model"+self.className +"::initData(DYNDATA *d)\n")
        self.addLine("{\n")
        self.addLine("  setData(d);\n")
        self.addLine("  setupDataStruc();\n")
        self.addLine("  initializeDataStruc();\n")
        self.addLine("}\n")

    ##
    # Add the body of deInitializeDataStruc in the cpp file
    # @param self : object pointer
    # @return
    def fill_deInitializeDataStruc(self):
        self.addEmptyLine()
        self.addLine("void Model"+ self.className +"::deInitializeDataStruc()\n")
        self.addLine("{\n")

        self.addBody( self.builder.get_list_for_deinitializedatastruc() )

        self.addLine("}\n")

    ##
    # Add the body of initializeDataStruc in the cpp file
    # @param self : object pointer
    # @return
    def fill_initializeDataStruc(self):
        self.addEmptyLine()
        self.addLine("void Model"+ self.className +"::initializeDataStruc()\n")
        self.addLine("{\n")

        self.addBody( self.builder.get_list_for_initializedatastruc() )

        self.addLine("}\n")

    ##
    # Add the body of checkDataCoherence and checkParametersCoherence in the cpp file
    # @param self : object pointer
    # @return
    def fill_warnings(self):
        self.addEmptyLine()
        self.addLine("void Model"+ self.className +"::checkDataCoherence()\n")
        self.addLine("{\n")

        self.addBody( self.builder.get_list_for_warnings() )

        self.addLine("}\n")
        self.addEmptyLine()
        self.addLine("void Model"+ self.className +"::checkParametersCoherence() const\n")
        self.addLine("{\n")

        self.addBody( self.builder.get_list_for_parameters_warnings() )

        self.addLine("}\n")

    ##
    # Add the body of setFequations in the cpp file
    # @param self : object pointer
    # @return
    def fill_setFequations(self):
        self.addEmptyLine()
        self.addLine("void Model"+ self.className +"::setFequations(std::map<int,std::string>& fEquationIndex)\n")
        self.addLine("{\n")
        self.addBody("  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.\n")
        self.addBody( self.builder.get_list_for_setf_equations() )
        self.addLine("}\n")

    ##
    # Add the body of setGequations in the cpp file
    # @param self : object pointer
    # @return
    def fill_setGequations(self):
        self.addEmptyLine()
        self.addLine("void Model"+ self.className +"::setGequations(std::map<int,std::string>& gEquationIndex)\n")
        self.addLine("{\n")
        self.addBody( self.builder.get_list_for_setg_equations() )
        self.addLine("}\n")


    ##
    # Add the body of evalCalculatedVars in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalCalculatedVars(self):
        self.addEmptyLine()
        self.addLine(self.void_function_prefix+ self.className + "::evalCalculatedVars(std::vector<double>& calculatedVars)\n")
        self.addLine("{\n")
        self.addBody(self.builder.get_list_for_evalcalculatedvars())
        self.addLine("}\n")


    ##
    # Add the body of evalCalculatedVarI in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalCalculatedVarI(self):
        self.addEmptyLine()
        self.addLine("double Model" + self.className + "::evalCalculatedVarI(unsigned iCalculatedVar) const\n")
        self.addLine("{\n")
        self.addBody(self.builder.get_list_for_evalcalculatedvari())
        self.addLine("}\n")


    ##
    # Add the body of evalJCalculatedVarI in the cpp file
    # @param self : object pointer
    # @return
    def fill_evalCalculatedVarIAdept(self):
        self.addEmptyLine()
        self.addLine("#ifdef _ADEPT_\n")
        self.addLine("adept::adouble Model" + self.className + "::evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &x, const std::vector<adept::adouble> &xd) const\n")
        self.addLine("{\n")
        self.addBody(self.builder.get_list_for_evalcalculatedvariadept())
        self.addLine("}\n")
        self.addLine("#endif\n")


    ##
    # Add the body of getIndexesOfVariablesUsedForCalculatedVarI in the cpp file
    # @param self : object pointer
    # @return
    def fill_getIndexesOfVariablesUsedForCalculatedVarI(self):
        self.addEmptyLine()
        self.addLine("void Model" + self.className + "::getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const\n")
        self.addLine("{\n")

        self.addBody(self.builder.get_list_for_getindexofvarusedforcalcvari())
        self.addLine("}\n")

    ##
    # Define the header file
    # @param self : object pointer
    # @return
    def getHeaderPattern(self, additional_header_files):
        header_pattern = HeaderPatternDefine(additional_header_files)
        lines =[]
        if self.init_pb_:
            lines = header_pattern.get_init().split('\n')
        else:
            lines = header_pattern.get_dyn().split('\n')

        for line in lines:
            self.file_content_h.append(line + '\n')

        if self.init_pb_:
            lines = header_pattern.get_init_literals().split('\n')
        else:
            lines = header_pattern.get_dyn_literals().split('\n')

        for line in lines:
            self.file_content_literals_h.append(line + '\n')

        if self.init_pb_:
            lines = header_pattern.get_init_definitions().split('\n')
        else:
            lines = header_pattern.get_dyn_definitions().split('\n')

        for line in lines:
            self.file_content_definitions_h.append(line + '\n')

    ##
    # Insert a checkSum to identify the model in header file
    # @param self : object pointer
    # @param input_dir : input directory where the cpp file is created
    # @return
    def insert_checkSum(self,input_dir):
        file_name = os.path.join (input_dir, self.className + ".cpp")
        current_platform = platform.system()
        if current_platform == 'Linux':
            md5sum_pipe = Popen(["md5sum",file_name],stdout = PIPE)
            check_sum = md5sum_pipe.communicate()[0].split()[0]
        elif current_platform == 'Windows':
            md5sum_pipe = Popen(["certutil", "-hashfile", file_name, "MD5"], stdin = PIPE, stdout = PIPE)
            check_sum = md5sum_pipe.communicate()[0].split(os.linesep.encode())[1]

        for n, line in enumerate(self.file_content_h):
            if "__fill_model_checkSum__" in line:
                line_tmp = line.replace("__fill_model_checkSum__", check_sum.decode('utf-8'))
                self.file_content_h [n] = line_tmp

    ##
    # Insert the model name in header file
    # @param self : object pointer
    # @return
    def insert_model_name(self):
        has_check_data_coherence_str = "false" if (not self.builder.get_list_for_warnings()) else "true"
        for n, line in enumerate(self.file_content_h):
            if "__fill_model_name__" in line:
                line_tmp = line.replace("__fill_model_name__", self.mod_name)
                self.file_content_h [n] = line_tmp
            if "__fill_has_check_data_coherence__" in line:
                line_tmp = line.replace("__fill_has_check_data_coherence__", has_check_data_coherence_str)
                self.file_content_h [n] = line_tmp

    ##
    # Insert variables definitions
    # @param self: object pointer
    # @return NONE (act on self variable)
    def fill_variables_definitions(self):
        for n, line in enumerate(self.file_content_definitions_h):
            if "__fill_model_name__" in line:
                line_tmp = line.replace("__fill_model_name__", self.mod_name)
                self.file_content_definitions_h [n] = line_tmp

            elif "__fill_variables_definitions__h" in line:
                self.file_content_definitions_h [n : n+1] = self.builder.get_list_definitions_for_h()
                break

    ##
    # Insert external calls in header file
    # @param self : object pointer
    # @return
    def addExternalCalls(self):

        for n, line in enumerate(self.file_content_h):
            if "__fill_internal_functions__" in line:
                file_content_tmp = []
                if len(self.builder.get_list_for_externalcalls_header())> 0 or len(self.builder.get_list_for_evalfadept_external_call_headers())> 0:
                    file_content_tmp.append("   //External Calls\n")
                    for line in self.builder.get_list_for_externalcalls_header():
                        file_content_tmp.append("     "+line)
                    file_content_tmp.append("\n")
                    if len(self.builder.get_list_for_evalfadept_external_call_headers())> 0 :
                        file_content_tmp.append("#ifdef _ADEPT_\n")
                        for line in self.builder.get_list_for_evalfadept_external_call_headers():
                            file_content_tmp.append("     "+line)
                        file_content_tmp.append("#endif\n")
                else:
                    file_content_tmp.append("   // No External Calls\n")

                self.file_content_h [n : n+1] = file_content_tmp

    ##
    # Add the definition of parameters in header file
    # @param self : object pointer
    # @return
    def addParameters(self):
        for n, line in enumerate(self.file_content_h):
            if "__insert_params__" in line:
                file_content_tmp = []
                file_content_tmp.append("      // Non-internal parameters \n")
                parameters_real = self.builder.get_list_params_real_not_internal_for_h()
                parameters_bool = self.builder.get_list_params_bool_not_internal_for_h()
                parameters_int = self.builder.get_list_params_integer_not_internal_for_h()
                parameters_string = self.builder.get_list_params_string_not_internal_for_h()
                for par in parameters_real + parameters_bool + parameters_int + parameters_string:
                    variable_type = par.get_value_type_modelica_c_code()
                    if (variable_type == "string"):
                        variable_type = "std::string"

                    file_content_tmp.append("      " + variable_type + " " + to_compile_name(par.get_name() + "_") + ";\n")

                self.file_content_h [n : n+1] = file_content_tmp

    ##
    # write the external functions file
    # @param self : object pointer
    # @return
    def writeExternalCallsFile(self):
        write_file (self.file_content_external, self.fileName_external)

    ##
    # write header literals file
    # @param self : object pointer
    # @return
    def writeHeaderLiteralsFile(self):
        write_file (self.file_content_literals_h, self.fileNameLiterals_h)


    ##
    # write header definitions file
    # @param self : object pointer
    # @return
    def writeHeaderDefinitionsFile(self):
        write_file (self.file_content_definitions_h, self.fileNameDefinitions_h)
