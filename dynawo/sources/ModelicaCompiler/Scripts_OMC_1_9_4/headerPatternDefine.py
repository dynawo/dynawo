#!/usr/bin/python

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

##
# Class defining pattern to use when creating header file

##
# Header Pattern Define
#
class headerPatternDefine:
    ##
    # default constructor
    def __init__(self, additionalHeaderFiles):
        ## pattern to use when creating the header file of the model
        self.patternDyn_="""
#ifndef __fill_model_name____Dyn_h
#define __fill_model_name____Dyn_h


#include "DYNModelModelicaDyn.h"
#include "DYNModelManagerCommon.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "PARParameter.h"
#include "DYNSubModel.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#ifdef _ADEPT_
#include "adept.h"
#endif\n"""

        for file in additionalHeaderFiles:
            self.patternDyn_+="#include \""+ file + "\"\n"
    
        self.patternDyn_+="\n"
        self.patternDyn_+="""namespace DYN {

  class Model__fill_model_name___Dyn : public ModelModelicaDyn
  {
    public:
    Model__fill_model_name___Dyn() {dataStructIsInitialized_ = false;}
    ~Model__fill_model_name___Dyn() {if (dataStructIsInitialized_) deInitializeDataStruc();}


    public:
    void initData(DYNDATA * d);
    void initRpar();
    void setFomc(double * f);
    void setGomc(state_g * g);
    bool evalMode(const double & t) const;
    void setZomc();
    void setOomc();
    void setY0omc();
    void setYType_omc(propertyContinuousVar_t* yType);
    void setFType_omc(propertyF_t* fType);
    boost::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues();
    void setParameters( boost::shared_ptr<parameters::ParametersSet> params );
    void defineVariables(std::vector< boost::shared_ptr<Variable> >& variables);
    void defineParameters(std::vector<ParameterModeler>& parameters);
    void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);

#ifdef _ADEPT_
    void evalFAdept(const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F);
#endif

    void checkDataCoherence ();
    void setFequations (std::map<int,std::string>& fEquationIndex);
    void setGequations (std::map<int,std::string>& gEquationIndex);

    inline void setModelType(std::string modelType) { modelType_ = modelType; }
    inline ModelManager * getModelManager() const { return modelManager_; }
    inline void setModelManager (ModelManager * model) { modelManager_ = model; }
    void checkSum(std::string & checkSum) { checkSum = std::string("__fill_model_checkSum__"); }

    private:
    DYNDATA * data;
    ModelManager * modelManager_;
    bool dataStructIsInitialized_;
    std::string modelType_;

    private:
    std::string modelType() const { return modelType_; }
    inline void setData(DYNDATA * d){ data = d; }
    void setupDataStruc();
    void initializeDataStruc();
    void deInitializeDataStruc();

    private:
    __fill_internal_functions__
    __insert_params__

  };
}//end namespace DYN

#endif
"""

        ## pattern to use when creating the header file of the init model
        self.patternInit_="""
#ifndef __fill_model_name___Init_h
#define __fill_model_name___Init_h

#include "DYNModelModelicaInit.h"
#include "DYNModelManagerCommon.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "PARParameter.h"
#include "DYNSubModel.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#ifdef _ADEPT_
#include "adept.h"
#endif

namespace DYN {

  class Model__fill_model_name___Init : public ModelModelicaInit
  {
    public:
    Model__fill_model_name___Init() {dataStructIsInitialized_ = false;}
    ~Model__fill_model_name___Init() {if (dataStructIsInitialized_) deInitializeDataStruc();}


    public:
    void initData(DYNDATA * d);
    void initRpar();
    void setFomc(double * f);
    void setGomc(state_g * g);
    bool evalMode(const double & t) const;
    void setZomc();
    void setY0omc();
    void setYType_omc(propertyContinuousVar_t* yType);
    void setFType_omc(propertyF_t* fType);
    boost::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues(); ///< set parameter values based on internal Modelica data
    void setParameters(boost::shared_ptr<parameters::ParametersSet> params );
    void defineVariables(std::vector< boost::shared_ptr<Variable> >& variables);
    void defineParameters(std::vector<ParameterModeler>& parameters);
    void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
#ifdef _ADEPT_
    void evalFAdept( const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F);
#endif

    void checkDataCoherence ();
    void setFequations (std::map<int,std::string>& fEquationIndex);
    void setGequations (std::map<int,std::string>& gEquationIndex);

    inline void setModelType(std::string modelType) { modelType_ = modelType; }
    inline ModelManager * getModelManager() const { return modelManager_; }
    inline void setModelManager (ModelManager * model) { modelManager_ = model; }
    void checkSum(std::string & checkSum) { checkSum = std::string("__fill_model_checkSum__"); }

    private:
    DYNDATA * data;
    ModelManager * modelManager_;
    bool dataStructIsInitialized_;
    std::string modelType_;

    private:
    std::string modelType() const { return modelType_; }
    inline void setData(DYNDATA * d){ data = d; }
    void setupDataStruc();
    void initializeDataStruc();
    void deInitializeDataStruc();

    private:
    __fill_internal_functions__
    __insert_params__

   };
}//end namespace DYN

#endif
"""
    ## pattern to use for literals header
        self.patternDynLiterals_="""
#ifndef __fill_model_name____Dyn_Literals_h
#define __fill_model_name____Dyn_Literals_h

namespace DYN {
  __insert_literals__
}//end namespace DYN

#endif
"""
        ## pattern to use for literals header for the INIT file
        self.patternInitLiterals_="""
#ifndef __fill_model_name____Init_Literals_h
#define __fill_model_name____Init_Literals_h

namespace DYN {
  __insert_literals__
}//end namespace DYN

#endif
"""

    ## pattern to use for definitions header
        self.patternDynDefinitions_="""
#ifndef __fill_model_name____Dyn_Definitions_h
#define __fill_model_name____Dyn_Definitions_h

namespace DYN {
  // variables definition
__fill_variables_definitions__h
}//end namespace DYN

#endif
"""
        ## pattern to use for definitions headers for the INIT file
        self.patternInitDefinitions_="""
#ifndef __fill_model_name____Init_Definitions_h
#define __fill_model_name____Init_Definitions_h

namespace DYN {
  // variables definition
__fill_variables_definitions__h
}//end namespace DYN

#endif
"""

    ##
    # Getter of the pattern to define header file
    # @param self : object pointer
    # @return pattern to define header file
    def getDyn(self):
        return self.patternDyn_

    ##
    # Getter of the pattern to define header literals file
    # @param self : object pointer
    # @return pattern to define header literals file
    def getDynLiterals(self):
        return self.patternDynLiterals_

    ##
    # Getter of the pattern to define header file of init model
    # @param self : object pointer
    # @return pattern to define header file of init model
    def getInit(self):
        return self.patternInit_

    ##
    # Getter of the pattern to define header literals file of init model
    # @param self : object pointer
    # @return pattern to define header literals file of init model
    def getInitLiterals(self):
        return self.patternInitLiterals_

    ##
    # Getter of the pattern to define header definitions file
    # @param self : object pointer
    # @return pattern to define header definitions file
    def getDynDefinitions(self):
        return self.patternDynDefinitions_

    ##
    # Getter of the pattern to define header definitions file of init model
    # @param self : object pointer
    # @return pattern to define header defintions file of init model
    def getInitDefinitions(self):
        return self.patternInitDefinitions_

