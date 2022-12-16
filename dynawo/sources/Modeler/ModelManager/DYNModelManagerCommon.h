//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNModelManagerCommon.h
 *
 * @brief declaration of useful/utilitaries methods
 *
 */
#ifndef MODELER_MODELMANAGER_DYNMODELMANAGERCOMMON_H_
#define MODELER_MODELMANAGER_DYNMODELMANAGERCOMMON_H_

#include <list>
#include <string>
#include <iostream>
#include <cerrno>
#include <cmath>

#define MODELICA_STRING_H_  ///< to avoid definition of macro in modelica_string.h
#define OPENMODELICA_TYPES_H_  ///< to avoid definition of modelica_type
#define BASE_ARRAY_H_   ///< to avoid definition of base_array functions/types
#define BOOLEAN_ARRAY_H_   ///< to avoid definition of boolean_array functions/types
#define STRING_ARRAY_H_   ///< to avoid definition of string_array functions/types
#define REAL_ARRAY_H_   ///< to avoid definition of real_array functions/types
#define INTEGER_ARRAY_H_   ///< to avoid definition of integer_array functions/types

#ifdef _MSC_VER
#define OMC_NO_THREADS   ///< to avoid inclusion of pthread.h
#endif

#include "DYNError.h"
#include "DYNCommon.h"
#include "DYNNumericalUtils.h"
#include "DYNMessage.hpp"
#include "DYNMessageTimeline.h"
#include "DYNTimeline_keys.h"
#include "DYNModelManagerOwnTypes.h"  ///< redefinition of local own types : should be before simulation_data.h
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wc++98-compat-pedantic"
#pragma clang diagnostic ignored "-Wdocumentation"
#if __clang_major__ > 8
#pragma clang diagnostic ignored "-Wextra-semi-stmt"
#endif
#pragma clang diagnostic ignored "-Wold-style-cast"
#pragma clang diagnostic ignored "-Wreserved-id-macro"
#pragma clang diagnostic ignored "-Wundef"
#endif  // __clang__
#include "simulation_data.h"
#ifdef __clang__
#pragma clang diagnostic pop
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreserved-id-macro"
#endif  // __clang__
#include "ModelicaStandardTables.h"
#include "ModelicaStrings.h"
#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__
#include "DYNModelManagerOwnFunctions.h"  ///< redefinition of local own functions
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundef"
#endif  // __clang__
#include "ModelicaUtilities.h"
#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

#ifdef _MSC_VER
#undef isnan    // undef macros defined in omc.msvc.h !
#undef isinf
#endif

/**
 * definition of hysteresis function
 *
 * @param res result of the function
 * @param exp1 first operand
 * @param exp2 second operand
 * @param index position of the relation in the relationsPre map
 * @param op_w operator to used
 */
#define RELATIONHYSTERESIS(res, exp1, exp2, index, op_w) { \
  if (data->simulationInfo->discreteCall == 0) { \
    res = data->simulationInfo->relationsPre[index]; \
  } else { \
    res = ((op_w)((exp1), (exp2))); \
    data->simulationInfo->relations[index] = res; \
  } \
}

/**
 * @brief definition of _event_ceil function
 *
 *  @param x input value
 *  @param index index of the discrete mathematical event
 *  @param data current data
 *
 * @return Returns the smallest integer not less than x.
 * Result and argument shall have type Real.
 */
inline modelica_real  _event_ceil(modelica_real x, modelica_integer index, DATA *data) {
  modelica_real value;\
  if (data->simulationInfo->discreteCall == 1) {
    data->simulationInfo->mathEventsValuePre[index] = x;
  } \
  value = data->simulationInfo->mathEventsValuePre[index];
  return (modelica_real)std::ceil(value);
}

/** @brief  definition of _event_floor function
 *
 *  @param x input value
 *  @param index index of the discrete mathematical event
 *  @param data current data
 *
 *  @return Returns the largest integer not greater than x.
 * Result and argument shall have type Real.
 */
inline modelica_real _event_floor(modelica_real x, modelica_integer index, DATA *data) {
  modelica_real value;
  if (data->simulationInfo->discreteCall == 1) {
    data->simulationInfo->mathEventsValuePre[index] = x;
  } \
  value = data->simulationInfo->mathEventsValuePre[index];
  return (modelica_real)std::floor(value);
}

/**
 *  @brief definition of _event_floor function
 *
 *  @param x input value
 *  @param index index of the discrete mathematical event
 *  @param data current data
 *
 *  @return Returns the largest integer not greater than x.
 */
inline modelica_integer _event_integer(modelica_real x, modelica_integer index, DATA *data) {
  modelica_real value;
  if (data->simulationInfo->discreteCall == 1) {
    data->simulationInfo->mathEventsValuePre[index] = x;
  } \
  value = data->simulationInfo->mathEventsValuePre[index];
  return (modelica_integer)std::floor(value);
}

/**
 * @brief Returns the algebraic quotient x/y with any fractional part discarded
 *
 * @param x1 first input value
 * @param x2 second input value
 * @param index index of the discrete mathematical event
 * @param data current data
 *
 * @return Returns the algebraic quotient x/y with any fractional part discarded
 */
inline modelica_real _event_div_real(modelica_real x1, modelica_real x2, modelica_integer index, DATA *data) {
  modelica_real value1, value2;
  if (data->simulationInfo->discreteCall && !data->simulationInfo->solveContinuous) {
    data->simulationInfo->mathEventsValuePre[index] = x1;
    data->simulationInfo->mathEventsValuePre[index+1] = x2;
  }

  value1 = data->simulationInfo->mathEventsValuePre[index];
  value2 = data->simulationInfo->mathEventsValuePre[index+1];

  return trunc(value1/value2);
}


/**
 * less operator definition
 * @param exp1 first operand
 * @param exp2 second operand
 * @return @b exp2 if exp2 is less than exp1, @b exp1 otherwise
 */
template<typename T>
T FMIN(T exp1, T exp2) {
  if (Greater(exp1, exp2))
    return exp2;
  else
    return exp1;
}

/**
 * greater operator definition
 * @param exp1 first operand
 * @param exp2 second operand
 * @return @b exp1 if exp1 is greater than exp2, @b exp2 otherwise
 */
template<typename T>
T FMAX(T exp1, T exp2) {
  if (Greater(exp1, exp2))
    return exp1;
  else
    return exp2;
}

/**
 * generic less operator
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is less than b, @b false otherwise
 */
template<typename T>
modelica_boolean Less(T a, T b) {
  return a < b;
}

/**
 * generic greater operator
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is greater than b, @b b otherwise
 */
template<typename T>
modelica_boolean Greater(T a, T b) {
  return a > b;
}

/**
 * generic less-equal operator
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is less or equal to b, @b false otherwise
 */
template<typename T>
modelica_boolean LessEq(T a, T b) {
  return a <= b;
}

/**
 * generic greater-equal operator
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is greater or equal to b, @b false otherwise
 */
template<typename T>
modelica_boolean GreaterEq(T a, T b) {
  return a >= b;
}

/**
 * specialization of less operator for double
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is less than b, @b false otherwise
 */
template<>
inline modelica_boolean Less<double>(double a, double b) {
  return DYN::doubleNotEquals(a, b) && a < b;
}

/**
 * specialization of greater operator for double
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is greater than b, @b b otherwise
 */
template<>
inline modelica_boolean Greater<double>(double a, double b) {
  return DYN::doubleNotEquals(a, b) && a > b;
}

/**
 * specialization of less-equal operator for double
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is less or equal to b, @b false otherwise
 */
template<>
inline modelica_boolean LessEq<double>(double a, double b) {
  return DYN::doubleEquals(a, b) || a < b;
}

/**
 * specialization of greater-equal operator for double
 * @param a first operand
 * @param b second operand
 * @return  @b true if a is greater or equal to b, @b false otherwise
 */
template<>
inline modelica_boolean GreaterEq<double>(double a, double b) {
  return DYN::doubleEquals(a, b) || a > b;
}

#ifndef DOXYGEN_SHOULD_SKIP_THIS
#define  LessZC(a, b, direction) Less(a, b)
#define  LessEqZC(a, b, direction) LessEq(a, b)
#define  GreaterZC(a, b, direction) Greater(a, b)
#define  GreaterEqZC(a, b, direction) GreaterEq(a, b)

#define addLogConstraintBegin(key) \
  addLogConstraintBegin_((this)->getModelManager(), (Message("CONSTRAINT", DYN::KeyConstraint_t::names(DYN::KeyConstraint_t::value(key)))))
#define addLogConstraintEnd(key) \
  addLogConstraintEnd_((this)->getModelManager(), (Message("CONSTRAINT", DYN::KeyConstraint_t::names(DYN::KeyConstraint_t::value(key)))))

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wc++98-compat-pedantic"
#endif  // __clang__

/**
 * @brief Macro to define a timeline message from a Modelica model
 * @param key key to find the message
 */
#define DYNTimelineFromModelica(key, ...) (DYN::MessageTimeline(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::value(key))), ##__VA_ARGS__ )

#define addLogEvent1(key) if ((this)->getModelManager()->hasTimeline()) \
  addLogEvent_((this)->getModelManager(), DYNTimelineFromModelica(key))
#define addLogEvent2(key, arg1) if ((this)->getModelManager()->hasTimeline()) \
  addLogEvent_((this)->getModelManager(), DYNTimelineFromModelica(key, arg1))
#define addLogEvent3(key, arg1, arg2) if ((this)->getModelManager()->hasTimeline()) \
  addLogEvent_((this)->getModelManager(), DYNTimelineFromModelica(key, arg1, arg2))
#define addLogEvent4(key, arg1, arg2, arg3) if ((this)->getModelManager()->hasTimeline()) \
  addLogEvent_((this)->getModelManager(), DYNTimelineFromModelica(key, arg1, arg2, arg3))
#define addLogEvent5(key, arg1, arg2, arg3, arg4) if ((this)->getModelManager()->hasTimeline()) \
  addLogEvent_((this)->getModelManager(), DYNTimelineFromModelica(key, arg1, arg2, arg3, arg4))

#define addLogEventRaw1(key) if ((this)->getModelManager()->hasTimeline()) \
  addLogEvent_((this)->getModelManager(), (MessageTimeline("", key)))
#define addLogEventRaw2(key1, key2) addLogEventRaw2_((this)->getModelManager(), key1, key2)
#define addLogEventRaw3(key1, key2, key3) addLogEventRaw3_((this)->getModelManager(), key1, key2, key3)
#define addLogEventRaw4(key1, key2, key3, key4) addLogEventRaw4_((this)->getModelManager(), key1, key2, key3, key4)
#define addLogEventRaw5(key1, key2, key3, key4, key5) addLogEventRaw5_((this)->getModelManager(), key1, key2, key3, key4, key5)

#define printLogToStdOut(message) printLogToStdOut_((this)->getModelManager(), std::string(message))
#define printLogExecution(message) printLogExecution_((this)->getModelManager(), std::string(message))

#define omc_terminate(info, message, ...) terminate_((this)->getModelManager(), (MessageTimeline(std::string(message)), ##__VA_ARGS__))
#define omc_assert(info, message, ...) assert_((this)->getModelManager(), (Message("", std::string(message)), ##__VA_ARGS__))
#define omc_assert_warning(message, ...) assert_((this)->getModelManager(), (Message("", std::string(message)), ##__VA_ARGS__))

#define omc_assert_withEquationIndexes(info, equationIndexes, message, ...) assert_((this)->getModelManager(), (Message("", std::string(message)), \
                                       ##__VA_ARGS__))

#define omc_assert_warning_withEquationIndexes(equationIndexes, message, ...) assert_((this)->getModelManager(), (Message("", std::string(message)), \
                                               ##__VA_ARGS__))

#define throwStreamPrint(data, message, ...) throw_((this)->getModelManager(), (Message("", std::string(message)), ##__VA_ARGS__))

#define throwStreamPrintWithEquationIndexes(equationIndexes, message, ...) throw_((this)->getModelManager(), (Message("", std::string(message)), ##__VA_ARGS__))

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

#define stringEqual(x, y) compareString_(std::string(x), std::string(y))

#define size_of_dimension_base_array(x, y) sizeOffArray_ (x.dim_size, y - 1)

#define MMC_STRINGDATA(x) x
#define MMC_THROW_INTERNAL() assert(false)

#define integer_array_element_addr1(source, ndims, dim1) integerArrayElementAddress1_(*source, dim1)

#define enum_to_modelica_string(index, table, minLength, leftJustified) enumToModelicaString_(index, table)

#define modelica_string_to_modelica_string(item, index1, index2) item

#define callExternalAutomaton(command, time, inputs, inputs_name, nbInputs, nbMaxInputs, outputs, outputs_name, nbOutputs, nbMaxOutputs) \
    callExternalAutomatonModel((this)->getModelManager()->name(), command, time, inputs, inputs_name, nbInputs, nbMaxInputs, outputs, outputs_name, nbOutputs, \
nbMaxOutputs, this->getModelManager()->getWorkingDirectory());

#define delayImpl(data, exprNumber, exprValue, time, delayTime, delayMax) \
  computeDelay((this)->getModelManager(), data, exprNumber, exprValue, time, delayTime, delayMax)

#define createDelay(exprNumber, time, exprValue, delayMax) \
  addDelay((this)->getModelManager(), exprNumber, time, exprValue, delayMax)

#endif  // DOXYGEN_SHOULD_SKIP_THIS

/**
 * @brief Class DYNDATA : class to define new data needed for describing memory structure
 * @class DYNDATA
 */
class DYNDATA : public DATA {
 public:
  int nbDummy;  ///< number of dummy variables
  int nbVars;  ///< number of variables
  int nbF;  ///< number of residual functions
  int nbModes;  ///< number of modes
  int nbZ;  ///< number of discrete variables
  int nbCalculatedVars;  ///< number of calculated variables
  int nbDelays;  ///< Number of delays handled
  std::vector<double> constCalcVars;  ///< values of constant calculated variables with complex initialization
};

namespace DYN {

/**
 * @class memoryManagerChars
 * @brief Keep track of chars created and which should be deleted at the end of the execution
 */
class memoryManagerChars {
 private:
  /**
   * @brief Default constructor
   */
  memoryManagerChars() { }

  /**
   * @brief Get instance of modelica chars manager
   * @return the unique instance
   */
  static memoryManagerChars& getInstance() {
    static memoryManagerChars mmChars;
    return mmChars;
  }

 public:
  /**
   * @brief Default destructor
   */
  ~memoryManagerChars() { }

  /**
   * @brief Keep track of a string
   * @param str the string to keep track of
   * @return the string as null-terminated const char pointer
   */
  static const char* keep(const std::string& str) {
    getInstance().string2Keep_.push_back(str);
    return getInstance().string2Keep_.back().c_str();
  }

 private:
  std::list<std::string> string2Keep_;  ///< string created along the simulation and that should be deleted at the end of the simulation
};


class ModelManager;
class Message;
/**
 * @brief compare two strings
 *
 * @param x first string to compare
 * @param y second string to compare
 *
 * @return @b true if the two strings are equals
 */
bool compareString_(const std::string& x, const std::string& y);

/**
 * @brief creates a string of a given size
 *
 * @param size size of the string to create
 *
 * @return an empty string with a given size
 */
std::string mmc_strings_len1(unsigned int size);

/**
 * @brief concatenation of two modelica strings
 *
 * @param s1 first string to concatenate
 * @param s2 second string to concatenate
 *
 * @return concatenantion of the two strings
 */
const char* stringAppend(const modelica_string s1, const modelica_string s2);

/**
 * @brief concatenation of two modelica strings
 *
 * @param s1 first string to concatenate
 * @param s2 second string to concatenate
 *
 * @return concatenantion of the two strings
 */
const char* stringAppend(const modelica_string s1, const std::string s2);

/**
 * @brief concatenation of two modelica strings
 *
 * @param s1 first string to concatenate
 * @param s2 second string to concatenate
 *
 * @return concatenantion of the two strings
 */
const char* stringAppend(const std::string s1, const modelica_string s2);

/**
 * @brief Computes the delayed value
 *
 * Calls the corresponding function of @p manager
 *
 * @param manager the model manager to use
 * @param data the data of the current simulation
 * @param exprNumber the id of the delay, in practice the index in the arrays of delayed variables
 * @param exprValue the value corresponding to @p time
 * @param time the current time point
 * @param delayTime the delay to apply to the value
 * @param delayMax the maximum delay allowed
 *
 * @returns the computed delayed value
 */
modelica_real computeDelay(ModelManager* manager, DYNDATA* data, int exprNumber, double exprValue, double time, double delayTime, double delayMax);

/**
 * @brief Add a new delay to manage
 *
 * calls the corresponding function in @p manager
 *
 * @param manager The model manager to use
 * @param exprNumber the id of the delay to create
 * @param time pointer to the time that will be externally updated at runtime
 * @param exprValue pointer to the value that will be externally updated at runtime
 * @param delayMax maximum allowed delay
 *
 */
void addDelay(ModelManager* manager, int exprNumber, const double* time, const double* exprValue, double delayMax);

/**
 * @brief print log to std output
 * @param model model where the log appears
 * @param message message to print
 */
void printLogToStdOut_(ModelManager* model, const std::string& message);

/**
 * @brief print execution log
 * @param model model where the log appears
 * @param message message to print
 */
void printLogExecution_(ModelManager* model, const std::string& message);

/**
 * @brief add the beginning of a constraint
 * @param model model where the constraint appears
 * @param message description of the constraint
 */
void addLogConstraintBegin_(ModelManager* model, const Message& message);

/**
 * @brief add the end of a constraint
 * @param model model where the constraint disappears
 * @param message description of the constraint
 */
void addLogConstraintEnd_(ModelManager* model, const Message& message);
/**
 * @brief add an event log
 * @param model model where the event appears
 * @param messageTimeline description of the event
 */
void addLogEvent_(ModelManager* model, const MessageTimeline& messageTimeline);

/**
 * @brief add a raw event log based on multiple sub-log messages
 * @param model model where the event appears
 * @param message1 the first sub message
 * @param message2 the second sub message
 */
void addLogEventRaw2_(ModelManager* model, const char* message1, const char* message2);

/**
 * @brief add a raw event log based on multiple sub-log messages
 * @param model model where the event appears
 * @param message1 the first sub message
 * @param message2 the second sub message
 * @param message3 the third sub message
 */
void addLogEventRaw3_(ModelManager* model, const char* message1, const char* message2, const char* message3);

/**
 * @brief add a raw event log based on multiple sub-log messages
 * @param model model where the event appears
 * @param message1 the first sub message
 * @param message2 the second sub message
 * @param message3 the third sub message
 * @param message4 the fourth sub message
 */
void addLogEventRaw4_(ModelManager* model, const char* message1, const char* message2, const char* message3, const char* message4);

/**
 * @brief add a raw event log based on multiple sub-log messages
 * @param model model where the event appears
 * @param message1 the first sub message
 * @param message2 the second sub message
 * @param message3 the third sub message
 * @param message4 the fourth sub message
 * @param message5 the fifth sub message
 */
void addLogEventRaw5_(ModelManager* model, const char* message1, const char* message2, const char* message3, const char* message4, const char* message5);

/**
 * @brief  conversion of a modelica real number to modelica string
 *
 *
 * @param r modelica real to convert
 * @param minLen length of the string to create
 * @param leftJustified @b true if the  real should be left justified inside the string
 * @param signDigits  number of digits to keep for the real
 *
 * @return modelica string created
 */
const char* modelica_real_to_modelica_string(modelica_real r, modelica_integer minLen, modelica_boolean leftJustified, modelica_integer signDigits);

/**
 * @brief  conversion of a modelica integer number to modelica string
 *
 *
 * @param i modelica integer to convert
 * @param minLen length of the string to create
 * @param leftJustified @b true if the  integer should be left justified inside the string
 *
 * @return modelica string created
 */
const char* modelica_integer_to_modelica_string(modelica_integer i, modelica_integer minLen, modelica_boolean leftJustified);

/**
 * @brief  conversion of a modelica boolean number to modelica string
 *
 *
 * @param b modelica boolean to convert
 * @param minLen length of the string to create
 * @param leftJustified @b true if the  boolean should be left justified inside the string
 *
 * @return modelica string created
 */
const char* modelica_boolean_to_modelica_string(modelica_boolean b, modelica_integer minLen, modelica_boolean leftJustified);

/**
 * @brief conversion of a modelica enumeration to modelica string
 * @param nr enumerate to convert
 * @param e ???
 * @param minLen length of the string to create
 * @param leftJustified @b true if the  enumerate should be left justified inside the string
 * @return modelica string created
 */
const char* modelica_enumeration_to_modelica_string(modelica_integer nr, const modelica_string_t e[], modelica_integer minLen, modelica_boolean leftJustified);

/**
 * @brief concatanation of two modelica strings
 * @param s1 first string to concatanate
 * @param s2 secon string to concatanate
 * @return string concatanation of the two strings
 */
const char* cat_modelica_string(modelica_string_const s1, modelica_string_const s2);

/**
 * @brief concatanation of two modelica strings
 * @param s1 first string to concatanate
 * @param s2 secon string to concatanate
 * @return string concatanation of the two strings
 */
const char* cat_modelica_string(std::string s1, modelica_string_const s2);

/**
 * @brief concatanation of two modelica strings
 * @param s1 first string to concatanate
 * @param s2 secon string to concatanate
 * @return string concatanation of the two strings
 */
const char* cat_modelica_string(modelica_string_const s1, std::string s2);

/**
 * @brief conversion of a modelica real number to modelica string
 * @param r modelica real to convert
 * @param format format of the conversion
 * @return modelica string created
 */
const char* modelica_real_to_modelica_string_format(modelica_real r, std::string format);

/**
 * @brief conversion of a modelica integer number to modelica string
 * @param i modelica integer to convert
 * @param format format of the conversion
 * @return modelica string created
 */
const char* modelica_integer_to_modelica_string_format(modelica_integer i, std::string format);

/**
 * @brief transforms an assert (done in modelica model) to a throw instruction
 *
 * @param model model where the assert appears
 * @param message Message to add
 */
void assert_(ModelManager* model, const Message& message);

/**
 * @brief transforms a terminate in a modelica model to a dynawoTerminate instruction
 *
 *
 * @param model model where the terminate appears
 * @param message Message of the terminate
 */
void terminate_(ModelManager* model, const MessageTimeline& message);

/**
 * @brief transforms a throw in a modelica model to a throw instruction
 *
 *
 * @param model model where the throw appears
 * @param message message of the throw
 */
void throw_(ModelManager* model, const Message& message);

/**
 * @brief retrieve the address of an integer element in an array
 *
 *
 * @param source the integer array
 * @param dim1 the first array dimension
 * @return the address of an integer element in an array
 */
const modelica_integer* integerArrayElementAddress1_(const modelica_integer * source, int dim1);

/**
 * @brief compute the size of an integer array
 *
 * @param array the integer array
 * @param dim the dimension to analyze (0 = nb rows, 1 = nb columns)
 * @return the size of the array (0 for an empty array)
 */
modelica_integer sizeOffArray_(const modelica_integer array[], modelica_integer dim);

/**
 * @brief convert an enum value to string
 *
 *
 * @param nr the enum index value
 * @param e the array gathering enum string values
 * @return the enum value as a string
 */
modelica_string enumToModelicaString_(modelica_integer nr, const char *e[]);

/**
 * @brief call an external code of automaton
 *
 * @param modelName name of the model where the call is made
 * @param command command used to launch the automaton
 * @param time current time
 * @param inputs current values needed by the automaton
 * @param inputs_name name associated to each input value
 * @param nbInputs number of inputs needed by the automaton
 * @param nbMaxInputs maximum number of inputs
 * @param outputs values calculated by the automaton
 * @param outputs_name name associated to each ouput value
 * @param nbOutputs number of outputs calculated by the automaton
 * @param nbMaxOutputs maximum number of outputs
 * @param workingDirectory Working directory of the simulation.
 */
void callExternalAutomatonModel(const std::string& modelName, const char* command, const double time,
    const double* inputs, const char** inputs_name, const int nbInputs, const int nbMaxInputs,
    double* outputs, const char** outputs_name, const int nbOutputs, const int nbMaxOutputs,
    const std::string& workingDirectory);

}  // namespace DYN
#endif  // MODELER_MODELMANAGER_DYNMODELMANAGERCOMMON_H_
