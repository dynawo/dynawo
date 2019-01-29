//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file components/TapChanger.h
 * @brief TapChanger interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_TAPCHANGER_H
#define LIBIIDM_COMPONENTS_GUARD_TAPCHANGER_H

#include <vector>

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/TerminalReference.h>

namespace IIDM {

/**
 * @brief Base class for RatioTapChanger and PhaseTapChanger
 *
 * @tparam CRTP_TapChanger the actual builder class. CRTP_TapChanger shall inherit from this class.
 * @tparam Step the actual step type of this TapChanger
 *
 */
template <typename CRTP_TapChanger, typename Step>
class TapChanger {
public:
  typedef CRTP_TapChanger TapChanger_type;
  
/**
 * @name Steps management
 * @{
 */
public:
  ///step type
  typedef Step step_type;
private:
  typedef std::vector<step_type> steps_type;
public:
  typedef typename steps_type::const_iterator const_iterator;

  #if __cplusplus < 201103L
  TapChanger_type& add(step_type const& step) {
    m_steps.push_back(step);
    return static_cast<TapChanger_type&>(*this);
  }
  #else
  template<typename... Args>
  TapChanger_type& add(Args&&... args) {
    m_steps.emplace_back(std::forward<Args>(args)...);
    return static_cast<TapChanger_type&>(*this);
  }
  #endif

  const_iterator begin() const { return m_steps.begin(); }
  const_iterator end  () const { return m_steps.end  (); }
/** @} */

public:
  ///Gets the low tap position.
  int lowTapPosition() const { return m_lowTapPosition; }


  ///Gets the tap position.
  int tapPosition() const { return m_tapPosition; }

  void tapPosition(int tapPosition) { m_tapPosition = tapPosition; }
  
  ///Gets the number of taps.
  int tapCount() const { return m_steps.size(); }

  /**
   * @brief sets the tap position.
   *
   * The new tap position must be in [lowTapPosition(), lowTapPosition()+tapCount())
   *
   * @throw std::runtime_error if position is invalid.
   * @param position the new tap position
   */
  TapChanger_type& tapPosition(int position) const {
    if (position<lowTapPosition() || position >= lowTapPosition()+tapCount() ) throw std::runtime_error("invalid tap position");
    m_tapPosition = position;
    return static_cast<TapChanger_type&>(*this);
  }


  /** @brief tells if the regulating status is set. */
  bool has_regulating() const { return static_cast<bool>(m_regulating); }

  /**
   * @brief Tells if this TapChanger is regulating.
   * @throws boost::bad_optional_access if not set
   */
  bool regulating() const { return m_regulating.value(); }

  /** @brief gets the optional regulating status */
  boost::optional<bool> const& optional_regulating() const { return m_regulating; }

  /** @brief sets the regulating status. */
  TapChanger_type& regulating(bool regulating) {
    m_regulating = regulating;
    return static_cast<TapChanger_type&>(*this);
  }

  /** @brief sets the regulating status (or unsets if used with boost::none or an empty optional). */
  TapChanger_type& regulating(boost::optional<bool> const& regulating) {
    m_regulating = regulating;
    return static_cast<TapChanger_type&>(*this);
  }
  
  
  
  
  

  /** @brief tells if the terminal reference is set. */
  bool has_terminalReference() const { return static_cast<bool>(m_ref); }

  /**
   * @brief gets the terminal reference.
   * @throws boost::bad_optional_access if not set
   */
  TerminalReference const& terminalReference() const { return m_ref.value(); }

  /** @brief gets the optional terminal reference */
  boost::optional<TerminalReference> const& optional_terminalReference() const { return m_ref; }

  /** @brief sets the terminal reference. */
  TapChanger_type& terminalReference(TerminalReference ref) {
    m_ref = ref;
    return static_cast<TapChanger_type&>(*this);
  }

  /** @brief sets the terminal reference (or unsets if used with boost::none or an empty optional). */
  TapChanger_type& terminalReference(boost::optional<TerminalReference> const& ref) {
    m_ref = ref;
    return static_cast<TapChanger_type&>(*this);
  }


protected:
  ///explicit constructor
  TapChanger(int lowTapPosition, int tapPosition, boost::optional<bool> const& regulating = boost::none, boost::optional<TerminalReference> const& ref = boost::none):
    m_lowTapPosition(lowTapPosition),
    m_tapPosition(tapPosition),
    m_regulating(regulating),
    m_ref(ref)
  {}

private:
  int m_lowTapPosition;
  int m_tapPosition;
  boost::optional<bool> m_regulating;
  boost::optional<TerminalReference> m_ref;
  steps_type m_steps;
};




struct RatioTapChangerStep {
  double r, x, g, b;
  double rho;
  RatioTapChangerStep(double r, double x, double g, double b, double rho);
};


/** @brief a RatioTapChanger, used to describe Transformers. */
class RatioTapChanger: public TapChanger<RatioTapChanger, RatioTapChangerStep> {
private:
  typedef TapChanger<RatioTapChanger, RatioTapChangerStep> parent_type;

public:
  ///partial constructor with neither terminal reference, regulating status nor target voltage
  RatioTapChanger(int lowStepPosition, int position, bool loadTapChangingCapabilities);

  using parent_type::add;
  
  #if __cplusplus < 201103L
  RatioTapChanger& add(double r, double x, double g, double b, double rho) {
    return add(step_type(r, x, g, b, rho));
  }
  #endif

  RatioTapChanger& step(double r, double x, double g, double b, double rho) {
    return add(r, x, g, b, rho);
  }

  /// gets the "Load Tap Changing Capabilities" status
  bool loadTapChangingCapabilities() const { return m_loadTapChangingCapabilities; }


  /** @brief tells if the target voltage is set. */
  bool has_targetV() const { return static_cast<bool>(m_targetV); }

  /**
   * @brief gets the target voltage.
   * @throws boost::bad_optional_access if not set.
   */
  double targetV() const { return m_targetV.value(); }

  /** @brief gets the optional target voltage. */
  boost::optional<double> const& optional_targetV() const { return m_targetV; }

  /** @brief sets the target voltage. */
  RatioTapChanger& targetV(double targetV) { m_targetV = targetV; return *this; }

  /** @brief sets the target voltage (or unsets if used with boost::none or an empty optional). */
  RatioTapChanger& targetV(boost::optional<double> const& targetV) { m_targetV = targetV; return *this; }

private:
  boost::optional<double> m_targetV;
  bool m_loadTapChangingCapabilities;
};



struct PhaseTapChangerStep {
  double r, x, g, b;
  double rho, alpha;
  PhaseTapChangerStep(double r, double x, double g, double b, double rho, double alpha);
};

/** @brief a PhaseTapChanger, used to describe Transformers. */
class PhaseTapChanger: public TapChanger<PhaseTapChanger, PhaseTapChangerStep> {
private:
  typedef TapChanger<PhaseTapChanger, PhaseTapChangerStep> parent_type;

public:
  enum e_mode {mode_current_limiter, mode_active_power_control, mode_fixed_tap};

  ///partial constructor without TerminalReference nor regulating status
  PhaseTapChanger(int lowStepPosition, int position, e_mode regulationMode);

  #if __cplusplus < 201103L
  using parent_type::add;
  PhaseTapChanger& add(double r, double x, double g, double b, double rho, double alpha) {
    return add(step_type(r, x, g, b, rho, alpha));
  }
  #endif

  PhaseTapChanger& step(double r, double x, double g, double b, double rho, double alpha) {
    return add(r, x, g, b, rho, alpha);
  }
  

  /**
   * @brief gets the regulation mode.
   */
  e_mode regulationMode() const { return m_regulationMode; }

  /** @brief sets the regulation mode. */
  PhaseTapChanger& regulationMode(e_mode mode) { m_regulationMode = mode; return *this; }

  

  /** @brief tells if the regulation value is set. */
  bool has_regulationValue() const { return static_cast<bool>(m_regulationValue); }

  /**
   * @brief gets the regulation value.
   * @throws boost::bad_optional_access if not set.
   */
  double regulationValue() const { return m_regulationValue.value(); }

  /** @brief gets the optional regulation value. */
  boost::optional<double> const& optional_regulationValue() const { return m_regulationValue; }

  /** @brief sets the regulation value. */
  PhaseTapChanger& regulationValue(double value) { m_regulationValue = value; return *this; }

  /** @brief sets the regulation value (or unsets if used with boost::none or an empty optional). */
  PhaseTapChanger& regulationValue(boost::optional<double> const& value) { m_regulationValue = value; return *this; }

private:
  e_mode m_regulationMode;
  boost::optional<double> m_regulationValue;
};

} // end of namespace IIDM::

#endif
