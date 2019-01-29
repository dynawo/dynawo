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
   * @brief Default constructor
   */
  TapChangerStep();

  /**
   * @brief Constructor
   *
   * @param rho step conversion ratio
   * @param alpha step dephasage
   * @param r step resistance
   * @param x step reactance
   * @param g step conductance
   * @param b step susceptance
   */
  TapChangerStep(const double& rho, const double& alpha,
          const double& r, const double& x,
          const double& g, const double& b);

  /**
   * @brief Copy constructor
   *
   * @param source instance of tap changer step to copy
   */
  TapChangerStep(const TapChangerStep& source);

  /**
   * @brief destructor
   */
  ~TapChangerStep();

  /**
   * @brief Get the step conversion ratio
   * @return The conversion ratio of the step
   */
  double getRho() const;

  /**
   * @brief Get the step dephasage
   * @return The dephasage of the step
   */
  double getAlpha() const;

  /**
   * @brief Get the step resistance
   * @return The resistance of the step
   */
  double getR() const;

  /**
   * @brief Get the step reactance
   * @return The reactance of the step
   */
  double getX() const;

  /**
   * @brief Get the step conductance
   * @return The conductance of the step
   */
  double getG() const;

  /**
   * @brief Get the step susceptance
   * @return The susceptance of the step
   */
  double getB() const;

 private:
  double rho_;  ///< conversion ratio
  double alpha_;  ///< dephasage
  double r_;  ///< resistance
  double x_;  ///< reactance
  double g_;  ///< conductance
  double b_;  ///< susceptance
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGERSTEP_H_
