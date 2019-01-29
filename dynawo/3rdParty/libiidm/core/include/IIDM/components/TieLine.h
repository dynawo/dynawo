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
 * @file components/TieLine.h
 * @brief Line interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_TIELINE_H
#define LIBIIDM_COMPONENTS_GUARD_TIELINE_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Connectable.h>
#include <IIDM/components/ContainedIn.h>
#include <IIDM/components/CurrentLimit.h>

namespace IIDM {

class Network;
class VoltageLevel;

namespace builders {
class TieLineBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief TieLine in the network
 */
class IIDM_EXPORT TieLine: public Identifiable, public Connectable<TieLine, side_2>, public ContainedIn<Network> {
public:
  //aliases of parent()
  ///tells if a parent network is specified
  bool has_network() const { return has_parent(); }

  ///gets a constant reference to the parent network
  Network const& network() const { return parent(); }
  ///gets a reference to the parent network
  Network      & network()       { return parent(); }

  VoltageLevel const& voltageLevel1() const;

  VoltageLevel const& voltageLevel2() const;

public:

  std::string const& id_1() const { return m_id_1; }

  /**
   * @name name_1 attribute
   * @{
   */
  /** @brief tells if the name at side 1 is set */
  bool has_name_1() const { return static_cast<bool>(m_name_1); }

  /**
   * @brief gets the name at side 1
   * @throws boost::bad_optional_access if not set
   */
  std::string name_1() const { return m_name_1.value(); }

  /** @brief gets the optional  */
  boost::optional<std::string> const& optional_name_1() const { return m_name_1; }

  /** @brief sets the name at side 1 */
  TieLine& name_1(std::string value) { m_name_1 = value; return *this; }

  /** @brief sets the name at side 1 (or unsets if used with boost::none or an empty optional) */
  TieLine& name_1(boost::optional<std::string> const& value) { m_name_1 = value; return *this; }
  /** @} */

  double r_1 () const { return m_r_1; }
  double x_1 () const { return m_x_1; }
  double g1_1() const { return m_g1_1; }
  double g2_1() const { return m_g2_1; }
  double b1_1() const { return m_b1_1; }
  double b2_1() const { return m_b2_1; }
  double xnodeP_1() const { return m_xnodeP_1; }
  double xnodeQ_1() const { return m_xnodeQ_1; }




  std::string const& id_2() const { return m_id_2; }


  /**
   * @name name_2 attribute
   * @{
   */
  /** @brief tells if the name at side 2 is set */
  bool has_name_2() const { return static_cast<bool>(m_name_2); }

  /**
   * @brief gets the name at side 2
   * @throws boost::bad_optional_access if not set
   */
  std::string name_2() const { return m_name_2.value(); }

  /** @brief gets the optional  */
  boost::optional<std::string> const& optional_name_2() const { return m_name_2; }

  /** @brief sets the name at side 2 */
  TieLine& name_2(std::string value) { m_name_2 = value; return *this; }

  /** @brief sets the name at side 2 (or unsets if used with boost::none or an empty optional) */
  TieLine& name_2(boost::optional<std::string> const& value) { m_name_2 = value; return *this; }
  /** @} */


  double r_2 () const { return m_r_2; }
  double x_2 () const { return m_x_2; }
  double g1_2() const { return m_g1_2; }
  double g2_2() const { return m_g2_2; }
  double b1_2() const { return m_b1_2; }
  double b2_2() const { return m_b2_2; }
  double xnodeP_2() const { return m_xnodeP_2; }
  double xnodeQ_2() const { return m_xnodeQ_2; }




  /**
   * @name ucteXnodeCode attribute
   * @{
   */
  /** @brief tells if ucteXnodeCode is set */
  bool has_ucteXnodeCode() const { return static_cast<bool>(m_ucteXnodeCode); }

  /**
   * @brief gets ucteXnodeCode
   * @throws boost::bad_optional_access if not set
   */
  std::string ucteXnodeCode() const { return m_ucteXnodeCode.value(); }

  /** @brief gets the optional  */
  boost::optional<std::string> const& optional_ucteXnodeCode() const { return m_ucteXnodeCode; }

  /** @brief sets ucteXnodeCode */
  TieLine& ucteXnodeCode(std::string value) { m_ucteXnodeCode = value; return *this; }

  /** @brief sets ucteXnodeCode (or unsets if used with boost::none or an empty optional) */
  TieLine& ucteXnodeCode(boost::optional<std::string> const& value) { m_ucteXnodeCode = value; return *this; }
  /** @} */

  /**
   * @name p1 attribute
   * @{
   */
  /** @brief tells if the active power at side 1 is set */
  bool has_p1() const { return static_cast<bool>(m_p1); }

  /**
   * @brief gets the active power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double p1() const { return m_p1.value(); }

  /** @brief gets the optional active power at side 1 */
  boost::optional<double> const& optional_p1() const { return m_p1; }

  /** @brief sets the active power at side 1 */
  TieLine& p1(double p1) { m_p1 = p1; return *this; }

  /** @brief sets the active power at side 1 (or unsets if used with boost::none or an empty optional) */
  TieLine& p1(boost::optional<double> const& p1) { m_p1 = p1; return *this; }
  /** @} */

  /**
   * @name q1 attribute
   * @{
   */
  /** @brief tells if the reactive power at side 1 is set */
  bool has_q1() const { return static_cast<bool>(m_q1); }

  /**
   * @brief gets the reactive power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double q1() const { return m_q1.value(); }

  /** @brief gets the optional reactive power at side 1 */
  boost::optional<double> const& optional_q1() const { return m_q1; }

  /** @brief sets the reactive power at side 1 */
  TieLine& q1(double q1) { m_q1 = q1; return *this; }

  /** @brief sets the reactive power at side 1 (or unsets if used with boost::none or an empty optional) */
  TieLine& q1(boost::optional<double> const& q1) { m_q1 = q1; return *this; }
  /** @} */

  /**
   * @name p2 attribute
   * @{
   */
  /** @brief tells if the active power at side 2 is set */
  bool has_p2() const { return static_cast<bool>(m_p2); }

  /**
   * @brief gets the active power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double p2() const { return m_p2.value(); }

  /** @brief gets the optional active power at side 2 */
  boost::optional<double> const& optional_p2() const { return m_p2; }

  /** @brief sets the active power at side 2 */
  TieLine& p2(double p2) { m_p2 = p2; return *this; }

  /** @brief sets the active power at side 2 (or unsets if used with boost::none or an empty optional) */
  TieLine& p2(boost::optional<double> const& p2) { m_p2 = p2; return *this; }
  /** @} */

  /**
   * @name q2 attribute
   * @{
   */
  /** @brief tells if the reactive power at side 2 is set */
  bool has_q2() const { return static_cast<bool>(m_q2); }

  /**
   * @brief gets the reactive power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double q2() const { return m_q2.value(); }

  /** @brief gets the optional reactive power at side 2 */
  boost::optional<double> const& optional_q2() const { return m_q2; }

  /** @brief sets the reactive power at side 2 */
  TieLine& q2(double q2) { m_q2 = q2; return *this; }

  /** @brief sets the reactive power at side 2 (or unsets if used with boost::none or an empty optional) */
  TieLine& q2(boost::optional<double> const& q2) { m_q2 = q2; return *this; }
  /** @} */

  /**
   * @name currentLimits1 attribute
   * @{
   */
  /** @brief tells if  at side 1 is set */
  bool has_currentLimits1() const { return static_cast<bool>(m_currentLimits1); }

  /**
   * @brief gets  at side 1
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits1() const { return m_currentLimits1.value(); }

  /** @brief gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits1() const { return m_currentLimits1; }

  /** @brief sets  */
  TieLine& currentLimits1(CurrentLimits const& l) { m_currentLimits1 = l; return *this; }

  /** @brief sets  (or unsets if used with boost::none or an empty optional) */
  TieLine& currentLimits1(boost::optional<CurrentLimits> const& l) { m_currentLimits1 = l; return *this; }
  /** @} */

  /**
   * @name currentLimits2 attribute
   * @{
   */
  /** @brief tells if  at side 2 is set */
  bool has_currentLimits2() const { return static_cast<bool>(m_currentLimits2); }

  /**
   * @brief gets  at side 2
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits2() const { return m_currentLimits2.value(); }

  /** @brief gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits2() const { return m_currentLimits2; }

  /** @brief sets  */
  TieLine& currentLimits2(CurrentLimits const& l) { m_currentLimits2 = l; return *this; }

  /** @brief sets  (or unsets if used with boost::none or an empty optional) */
  TieLine& currentLimits2(boost::optional<CurrentLimits> const& l) { m_currentLimits2 = l; return *this; }
  /** @} */

private:
  std::string m_id_1;
  boost::optional<std::string> m_name_1;
  double m_r_1     ;
  double m_x_1     ;
  double m_g1_1    ;
  double m_g2_1    ;
  double m_b1_1    ;
  double m_b2_1    ;
  double m_xnodeP_1;
  double m_xnodeQ_1;

  std::string m_id_2;
  boost::optional<std::string> m_name_2;
  double m_r_2     ;
  double m_x_2     ;
  double m_g1_2    ;
  double m_g2_2    ;
  double m_b1_2    ;
  double m_b2_2    ;
  double m_xnodeP_2;
  double m_xnodeQ_2;

  boost::optional<std::string> m_ucteXnodeCode;

  boost::optional<double> m_p1;
  boost::optional<double> m_q1;
  boost::optional<double> m_p2;
  boost::optional<double> m_q2;

  boost::optional<CurrentLimits> m_currentLimits1;
  boost::optional<CurrentLimits> m_currentLimits2;
private:
  TieLine(Identifier const&, properties_type const&);
  friend class IIDM::builders::TieLineBuilder;
};

} // end of namespace IIDM

#endif
