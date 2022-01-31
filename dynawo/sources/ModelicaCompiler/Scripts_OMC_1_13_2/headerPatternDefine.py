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
class HeaderPatternDefine:
    ##
    # default constructor
    def __init__(self, additional_header_files):
        ## pattern to use when creating the header file of the model
        self.pattern_dyn_="""
#ifndef __fill_model_name____Dyn_h
#define __fill_model_name____Dyn_h


#include "DYNModelModelica.h"
#include "DYNModelManagerCommon.h"
#include "PARParametersSet.h"
#include "PARParameter.h"
#include "DYNSubModel.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#ifdef _ADEPT_
#include "adept.h"
#endif\n"""

        for file in additional_header_files:
            self.pattern_dyn_+="#include \""+ file + "\"\n"

        self.pattern_dyn_+="\n"
        self.pattern_dyn_+="""namespace DYN {

  class Model__fill_model_name___Dyn : public ModelModelica
  {
    public:
    Model__fill_model_name___Dyn() {
        dataStructInitialized_ = false;
        hasCheckDataCoherence_ = __fill_has_check_data_coherence__;
    }
    ~Model__fill_model_name___Dyn() {if (dataStructInitialized_) deInitializeDataStruc();}


    public:
    void initData(DYNDATA * d);
    void initRpar();
    void setFomc(double * f, propertyF_t type);
    void setGomc(state_g * g);
    modeChangeType_t evalMode(const double t) const;
    void setZomc();
    void collectSilentZ(BitMask* silentZTable);
    void setOomc();
    void setY0omc();
    void callCustomParametersConstructors();
    void evalStaticYType_omc(propertyContinuousVar_t* yType);
    void evalStaticFType_omc(propertyF_t* fType);
    void evalDynamicYType_omc(propertyContinuousVar_t* yType);
    void evalDynamicFType_omc(propertyF_t* fType);
    boost::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues();
    void setParameters( boost::shared_ptr<parameters::ParametersSet> params );
    void defineVariables(std::vector< boost::shared_ptr<Variable> >& variables);
    void defineParameters(std::vector<ParameterModeler>& parameters);
    void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
    void evalCalculatedVars(std::vector<double>& calculatedVars);
    double evalCalculatedVarI(unsigned iCalculatedVar) const;
    void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;
#ifdef _ADEPT_
    void evalFAdept(const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F);
    adept::adouble evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp) const;
#endif

    void checkDataCoherence ();
    void checkParametersCoherence () const;
    void setFequations (std::map<int,std::string>& fEquationIndex);
    void setGequations (std::map<int,std::string>& gEquationIndex);

    inline void setModelType(std::string modelType) { modelType_ = modelType; }
    inline ModelManager * getModelManager() const { return modelManager_; }
    inline void setModelManager (ModelManager * model) { modelManager_ = model; }
    void checkSum(std::string & checkSum) { checkSum = std::string("__fill_model_checkSum__"); }
    inline bool isDataStructInitialized() const { return dataStructInitialized_; }

    private:
    DYNDATA * data;
    ModelManager * modelManager_;
    bool dataStructInitialized_;
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
        self.pattern_init_="""
#ifndef __fill_model_name___Init_h
#define __fill_model_name___Init_h

#include "DYNModelModelica.h"
#include "DYNModelManagerCommon.h"
#include "PARParametersSet.h"
#include "PARParameter.h"
#include "DYNSubModel.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#ifdef _ADEPT_
#include "adept.h"
#endif

namespace DYN {

  class Model__fill_model_name___Init : public ModelModelica
  {
    public:
    Model__fill_model_name___Init() {
        dataStructInitialized_ = false;
        hasCheckDataCoherence_ = __fill_has_check_data_coherence__;
    }
    ~Model__fill_model_name___Init() {if (dataStructInitialized_) deInitializeDataStruc();}


    public:
    void initData(DYNDATA * d);
    void initRpar();
    void setFomc(double * f, propertyF_t type);
    void setGomc(state_g * g);
    modeChangeType_t evalMode(const double t) const;
    void setZomc();
    void collectSilentZ(BitMask* silentZTable);
    void setY0omc();
    void callCustomParametersConstructors();
    void evalStaticYType_omc(propertyContinuousVar_t* yType);
    void evalStaticFType_omc(propertyF_t* fType);
    void evalDynamicYType_omc(propertyContinuousVar_t* yType);
    void evalDynamicFType_omc(propertyF_t* fType);
    boost::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues(); ///< set parameter values based on internal Modelica data
    void setParameters(boost::shared_ptr<parameters::ParametersSet> params );
    void defineVariables(std::vector< boost::shared_ptr<Variable> >& variables);
    void defineParameters(std::vector<ParameterModeler>& parameters);
    void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
    void evalCalculatedVars(std::vector<double>& calculatedVars);
    double evalCalculatedVarI(unsigned iCalculatedVar) const;
    void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;
#ifdef _ADEPT_
    void evalFAdept( const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F);
    adept::adouble evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp) const;
#endif

    void checkDataCoherence ();
    void checkParametersCoherence () const;
    void setFequations (std::map<int,std::string>& fEquationIndex);
    void setGequations (std::map<int,std::string>& gEquationIndex);

    inline void setModelType(std::string modelType) { modelType_ = modelType; }
    inline ModelManager * getModelManager() const { return modelManager_; }
    inline void setModelManager (ModelManager * model) { modelManager_ = model; }
    void checkSum(std::string & checkSum) { checkSum = std::string("__fill_model_checkSum__"); }
    inline bool isDataStructInitialized() const { return dataStructInitialized_; }

    private:
    DYNDATA * data;
    ModelManager * modelManager_;
    bool dataStructInitialized_;
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
        self.pattern_dyn_literals_="""
#ifndef __fill_model_name____Dyn_Literals_h
#define __fill_model_name____Dyn_Literals_h

namespace DYN {
  __insert_literals__
}//end namespace DYN

#endif
"""
        ## pattern to use for literals header for the INIT file
        self.pattern_init_literals_="""
#ifndef __fill_model_name____Init_Literals_h
#define __fill_model_name____Init_Literals_h

namespace DYN {
  __insert_literals__
}//end namespace DYN

#endif
"""

    ## pattern to use for definitions header
        self.pattern_dyn_definitions_="""
#ifndef __fill_model_name____Dyn_Definitions_h
#define __fill_model_name____Dyn_Definitions_h

namespace DYN {
  // variables definition
__fill_variables_definitions__h
}//end namespace DYN

#endif
"""
        ## pattern to use for definitions headers for the INIT file
        self.pattern_init_definitions_="""
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
    def get_dyn(self):
        return self.pattern_dyn_

    ##
    # Getter of the pattern to define header literals file
    # @param self : object pointer
    # @return pattern to define header literals file
    def get_dyn_literals(self):
        return self.pattern_dyn_literals_

    ##
    # Getter of the pattern to define header file of init model
    # @param self : object pointer
    # @return pattern to define header file of init model
    def get_init(self):
        return self.pattern_init_

    ##
    # Getter of the pattern to define header literals file of init model
    # @param self : object pointer
    # @return pattern to define header literals file of init model
    def get_init_literals(self):
        return self.pattern_init_literals_

    ##
    # Getter of the pattern to define header definitions file
    # @param self : object pointer
    # @return pattern to define header definitions file
    def get_dyn_definitions(self):
        return self.pattern_dyn_definitions_

    ##
    # Getter of the pattern to define header definitions file of init model
    # @param self : object pointer
    # @return pattern to define header defintions file of init model
    def get_init_definitions(self):
        return self.pattern_init_definitions_
