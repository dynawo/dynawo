//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNModelTapChangerStep.h
 *
 * @brief Tap changer step header : definition of a tap
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGERSTEP_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGERSTEP_H_

namespace DYN {

/**
 * @class TapChangerStep
 * @brief Management of tap changer steps
 */
class TapChangerStep {
 public:
  /**
   * @brief Empty constructor
   */
  inline TapChangerStep() : rho_(1), alpha_(0), r_(0), x_(0), g_(0), b_(0) {}

  /**
   * @brief Constructor
   *
   * @param rho step conversion ratio
   * @param alpha step phase shift
   * @param r step resistance
   * @param x step reactance
   * @param g step conductance
   * @param b step susceptance
   */
  inline TapChangerStep(const double rho, const double alpha, const double r, const double x, const double g,
                        const double b)
      : rho_(rho), alpha_(alpha), r_(r), x_(x), g_(g), b_(b) {}

  /**
   * @brief Get the step conversion ratio
   * @return The conversion ratio of the step
   */
  inline double getRho() const { return rho_; }

  /**
   * @brief Get the step phase shift
   * @return The phase shift of the step
   */
  inline double getAlpha() const { return alpha_; }

  /**
   * @brief Get the step resistance
   * @return The resistance of the step
   */
  inline double getR() const { return r_; }

  /**
   * @brief Get the step reactance
   * @return The reactance of the step
   */
  inline double getX() const { return x_; }

  /**
   * @brief Get the step conductance
   * @return The conductance of the step
   */
  inline double getG() const { return g_; }

  /**
   * @brief Get the step susceptance
   * @return The susceptance of the step
   */
  inline double getB() const { return b_; }

 private:
  double rho_;    ///< conversion ratio
  double alpha_;  ///< phase shift
  double r_;      ///< resistance
  double x_;      ///< reactance
  double g_;      ///< conductance
  double b_;      ///< susceptance
};                // class TapeChangerStep
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGERSTEP_H_
