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
 * @file RemoteMeasurementsFormatter.cpp
 * @brief Provides RemoteMeasurementsFormatter definition
 */

#include <IIDM/extensions/remoteMeasurements/xml/RemoteMeasurementsFormatter.h>
#include <IIDM/extensions/remoteMeasurements/RemoteMeasurements.h>
#include <IIDM/components/Identifiable.h>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace remotemeasurements {
namespace xml {

using ::xml::sax::formatter::Element;
using ::xml::sax::formatter::AttributeList;

void toXml( Element& parent, const std::string& elementName,
        const boost::optional<RemoteMeasurements::RemoteMeasurement>& rm, std::string const& xml_prefix)
{
  if(rm){
    parent.empty_element(xml_prefix, elementName,
            AttributeList("value",              rm->value())
                         ("standardDeviation",  rm->standardDeviation())
                         ("valid",              rm->valid())
                         ("masked",             rm->masked())
                         ("critical",           rm->critical())
    );
  }
}


void toXml( Element& parent, const std::string& elementName,
        const boost::optional<RemoteMeasurements::TapPosition>& tp, std::string const& xml_prefix)
{
  if(tp){
    parent.empty_element(xml_prefix, elementName,
            AttributeList("position",              tp->position())
    );
  }
}

void exportRemoteMeasurements(IIDM::Identifiable const& identifiable, Element& root, std::string const& xml_prefix) {
	RemoteMeasurements const* ext = identifiable.findExtension<RemoteMeasurements>();

	if (ext) {
		Element remoteMeasurements = root.element(xml_prefix, "remoteMeasurements");

		toXml(remoteMeasurements, "p",							ext->p(),							xml_prefix);
		toXml(remoteMeasurements, "q",							ext->q(),							xml_prefix);
		toXml(remoteMeasurements, "p1",							ext->p1(),						xml_prefix);
		toXml(remoteMeasurements, "q1",							ext->q1(),						xml_prefix);
		toXml(remoteMeasurements, "p2",							ext->p2(),						xml_prefix);
		toXml(remoteMeasurements, "q2",							ext->q2(),						xml_prefix);
		toXml(remoteMeasurements, "v",							ext->v(),							xml_prefix);
		toXml(remoteMeasurements, "tapPosition" ,		ext->tapPosition(),		xml_prefix);
	}
}

} // end of namespace IIDM::extensions::remotemeasurements::xml::
} // end of namespace IIDM::extensions::remotemeasurements::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
