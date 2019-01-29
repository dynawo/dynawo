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
 * @file IIDM/extensions/remoteMeasurements/xml/RemoteMeasurementsHandler.h
 * @brief Provides RemoteMeasurementsHandler interface, used for input
 */

#ifndef LIBIIDM_EXTENSIONS_REMOTEMEASUREMENTS_XML_GUARD_REMOTEMEASUREMENTS_HANDLER_H
#define LIBIIDM_EXTENSIONS_REMOTEMEASUREMENTS_XML_GUARD_REMOTEMEASUREMENTS_HANDLER_H

#include <IIDM/xml/import/ExtensionHandler.h>
#include <IIDM/extensions/remoteMeasurements/RemoteMeasurements.h>

#include <xml/sax/parser/Attributes.h>
#include <xml/sax/parser/ComposableElementHandler.h>
#include <xml/sax/parser/CDataCollector.h>

#include <IIDM/cpp11.h>
#include <vector>

namespace IIDM {
namespace extensions {
namespace remotemeasurements {
namespace xml {

class RemoteMeasurementHandler : public ::xml::sax::parser::SimpleElementHandler {
public:
  RemoteMeasurementHandler():remoteMeasurement(boost::none){}
  boost::optional<RemoteMeasurements::RemoteMeasurement> remoteMeasurement;

protected:
  virtual void do_startElement(elementName_type const& name, attributes_type const& attributes) IIDM_OVERRIDE;
};

class TapPositionHandler  : public ::xml::sax::parser::SimpleElementHandler {
public:
  TapPositionHandler():tapPosition(boost::none){}
  boost::optional<RemoteMeasurements::TapPosition> tapPosition;

protected:
  virtual void do_startElement(elementName_type const& name, attributes_type const& attributes) IIDM_OVERRIDE;
};

class RemoteMeasurementsHandler: public IIDM::xml::ExtensionHandler, private ::xml::sax::parser::ComposableElementHandler {
public:
  RemoteMeasurementsHandler();
  static const elementName_type root;
  static std::string const& uri() { return root.ns; }
  static std::string xsd_path();
  virtual elementName_type const& root_element() const IIDM_OVERRIDE IIDM_FINAL { return root; }

private:
  RemoteMeasurementHandler m_pHandler;
  RemoteMeasurementHandler m_qHandler;
  RemoteMeasurementHandler m_p1Handler;
  RemoteMeasurementHandler m_q1Handler;
  RemoteMeasurementHandler m_p2Handler;
  RemoteMeasurementHandler m_q2Handler;
  RemoteMeasurementHandler m_vHandler;
  TapPositionHandler m_tapPositionHandler;


  virtual RemoteMeasurements* do_make() IIDM_OVERRIDE IIDM_FINAL;
};

} // end of namespace IIDM::extensions::remotemeasurements::xml::
} // end of namespace IIDM::extensions::remotemeasurements::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
