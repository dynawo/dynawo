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

#include "sample.h"

#include <iostream>
#include <boost/optional/optional_io.hpp>

#include <map>
#include <string>

#include <IIDM/Network.h>

#include <IIDM/components/Line.h>
#include <IIDM/components/TieLine.h>

#include <IIDM/components/Substation.h>

#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/BusBarSection.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/Switch.h>

#include <IIDM/components/Load.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/Generator.h>
#include <IIDM/components/StaticVarCompensator.h>

#include <IIDM/components/ConnectionPoint.h>

//first, a few utilities

#define MACRO_INDENT "  "

//forces the conversion of reference (to use as attributes << connectable(object); )
template <typename T, IIDM::side_id side>
inline IIDM::Connectable<T, side> const&
connectable(IIDM::Connectable<T, side> const& that) { return that; }




inline std::ostream& operator << (std::ostream& stream, IIDM::Identifiable const& that) {
	return that.named() ?
		stream << '"' << that.id() << "\" as \"" << that.name() <<'"':
		stream << '"' << that.id() << '"';
}

template <typename T, IIDM::side_id side>
inline std::ostream& operator << (std::ostream& stream, IIDM::Connectable<T, side> const& that) {
	stream << " {";
	std::vector<IIDM::side_id> sides = that.connectedSides();
	
	for (std::vector<IIDM::side_id>::const_iterator it=sides.begin(), end=sides.end(); it!=end; ++it) {
		if (*it!=IIDM::side_begin) stream << ", ";
		stream << (1+*it) << '=';
		boost::optional<IIDM::Connection> cp = that.connection(*it);
		if (cp) stream << cp->connectionPoint() << ':' << (that.isConnected(*it)? "on ":"off");
	}
	return stream << '}';
}

template <typename T>
inline std::ostream& operator << (std::ostream& stream, IIDM::Connectable<T, IIDM::side_1> const& that) {
	stream << " {1=";
  boost::optional<IIDM::Connection> cp = that.connection();
  if (cp) stream << cp->connectionPoint() << ':' << (that.isConnected()? "on ":"off");
  
	return stream << '}';
}


template <typename T>
inline std::ostream& operator << (std::ostream& stream, IIDM::Contains<T> const& that) {
	if (that.empty()) return stream;
	typedef IIDM::Contains<T> that_type;
	
	for (typename that_type::const_iterator it=that.begin(), end = that.end(); it!=end; ++it) {
		stream << "\n" << *it;
	}
	return stream;
}


template <typename T>
inline std::ostream& operator << (std::ostream& stream, IIDM::ContainedIn<T> const& that) {
  if (!that.has_parent()) return stream << "[parentless]";
  return stream << "[parent:" << (that.parent().id())<<']';
}


//internal data

inline std::ostream& operator << (std::ostream& stream, IIDM::CurrentLimits const& that) {
	stream << "{perm="<<that.permanent_limit()<<" :";
	for (IIDM::CurrentLimits::const_iterator it=that.begin(), end=that.end(); it!=end; ++it) {
		stream << " (" << (it->value) << " for " << (it->acceptableDuration) << ')';
  }
	return stream << '}';
}


inline std::ostream& operator << (std::ostream& stream, IIDM::TerminalReference const& that) {
	return stream << that.side << '@' << that.id;
}

inline std::ostream& operator << (std::ostream& stream, IIDM::MinMaxReactiveLimits const& that) {
	return stream << '[' << that.min() << ',' << that.max() << ']';
}

inline std::ostream& operator << (std::ostream& stream, IIDM::ReactiveCapabilityCurve const& that) {
	stream << '{';
	for (IIDM::ReactiveCapabilityCurve::const_iterator it=that.begin(), end=that.end(); it!=end; ++it) {
    stream << '{' << it->p << '[' << it->qmin << ',' << it->qmax << ']' << '}';
  }
	return stream << '}';
}



//Network

std::ostream& operator << (std::ostream& stream, IIDM::Network const& that) {
	return stream << "Network: "
		<< that.id() << " [" << that.sourceFormat() << ", " << that.caseDate() << ", forecast: " << that.forecastDistance()<<']'
		<< "\n{"
		<< that.substations()
		<< that.lines()
		// << that.tielines()
		<< "\n}"
	;
}

//transversal components (*WTs, lines)


std::ostream& operator << (std::ostream& stream, IIDM::Line const& that) {
	return stream << MACRO_INDENT "Line: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< ", " << static_cast<IIDM::ContainedIn<IIDM::Network> const&>(that)
		<< ", r=" << that.r()
		<< ", x=" << that.x()
		<< ", g1=" << that.g1()
		<< ", b1=" << that.b1()
		<< ", g2=" << that.g2()
		<< ", b2=" << that.b2()
		<< connectable(that)
	;
}


std::ostream& operator << (std::ostream& stream, IIDM::Substation const& that) {
	stream
    << MACRO_INDENT "Substation: "
    << static_cast<IIDM::Identifiable const&>(that)
    << static_cast<IIDM::ContainedIn<IIDM::Network> const&>(that)
  ;
  
  if (that.has_tso()) stream << ", TSO: " << that.tso();
  stream << ", country: " << that.country();
  if (that.has_geographicalTags()) stream << ", geo: " << that.geographicalTags();
  
  stream
    << "\n" MACRO_INDENT "{"
    << that.voltageLevels()
    << "\n" MACRO_INDENT "}"
	;
  return stream;
}


//voltage level and sub parts

std::ostream& operator << (std::ostream& stream, IIDM::VoltageLevel const& that) {
	stream << MACRO_INDENT MACRO_INDENT "VoltageLevel: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::Substation> const&>(that)
		<< ", mode: " << that.mode()
		<< ", nominalV: " << that.nominalV()
  ;
  
  if (that.has_lowVoltageLimit ()) stream << ", lowVoltageLimit: "  << that.lowVoltageLimit ();
  if (that.has_highVoltageLimit()) stream << ", highVoltageLimit: " << that.highVoltageLimit();
  
  return stream
		<< "\n" MACRO_INDENT MACRO_INDENT "{"
		<< that.buses()
		<< that.busBarSections()
		<< that.switches()
		<< that.shuntCompensators()
		<< that.loads()
		<< that.danglingLines()
		<< "\n" MACRO_INDENT MACRO_INDENT "}"
	;
}


std::ostream& operator << (std::ostream& stream, IIDM::Bus const& that) {
	stream
    << MACRO_INDENT MACRO_INDENT MACRO_INDENT "Bus: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
	;
  
	if (that.has_v()) stream << ", v=" << that.v();
	if (that.has_angle()) stream << ", angle=" << that.angle();
  return stream;
}

std::ostream& operator << (std::ostream& stream, IIDM::BusBarSection const& that) {
	return stream << MACRO_INDENT MACRO_INDENT MACRO_INDENT "BusBarSection: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
		<< ", node=" << that.node()
	;
}

std::ostream& operator << (std::ostream& stream, IIDM::Switch const& that) {
	stream << MACRO_INDENT MACRO_INDENT MACRO_INDENT "Switch: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
		<< ", " << (that.retained() ? "retained" : "unretained")
		<< ", " << (that.opened() ? "opened" : "closed")
  ;
  if (that.connected()) {
    stream
      << ", port1: " << that.port1()
      << ", port2: " << that.port2()
    ;
  }
  return stream;
}



// terminals

std::ostream& operator << (std::ostream& stream, IIDM::Load const& that) {
	stream << MACRO_INDENT MACRO_INDENT MACRO_INDENT "Load: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
  ;
  switch (that.type()) {
    case IIDM::Load::type_auxiliary : stream << " (auxiliary)"; break;
    case IIDM::Load::type_fictitious: stream << " (fictitious)"; break;
    default:;
  }
  stream
		<< ", p0=" << that.p0()
		<< ", q0=" << that.q0()
  ;
  if (that.has_p()) stream << ", p=" << that.p();
  if (that.has_q()) stream << ", q=" << that.q();
  return stream << connectable(that);
}

std::ostream& operator << (std::ostream& stream, IIDM::ShuntCompensator const& that) {
	stream << MACRO_INDENT MACRO_INDENT MACRO_INDENT "ShuntCompensator: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
		<< ", b per section=" << that.suspectancePerSection()
		<< ", section= " << that.currentSection() << '/' << that.maximumSection()
  ;
  if (that.has_q()) stream << ", q=" << that.q();
	return stream << connectable(that);
}

std::ostream& operator << (std::ostream& stream, IIDM::DanglingLine const& that) {
	stream << MACRO_INDENT MACRO_INDENT MACRO_INDENT "DanglingLine: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
		<< ", p0=" << that.p0()
		<< ", q0=" << that.q0()
    << ", r=" << that.r()
		<< ", x=" << that.x()
		<< ", g=" << that.g()
		<< ", b=" << that.b()
    << ", ucte=" << that.ucte_xNodeCode()
  ;
  if (that.has_currentLimits()) stream << ", current limits=" << that.currentLimits();
  if (that.has_p()) stream << ", p=" << that.p();
  if (that.has_q()) stream << ", q=" << that.q();
  return stream << connectable(that);
}

std::ostream& operator << (std::ostream& stream, IIDM::StaticVarCompensator const& that) {
	stream << MACRO_INDENT MACRO_INDENT MACRO_INDENT "StaticVarCompensator: "
		<< static_cast<IIDM::Identifiable const&>(that)
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
  ;
  stream
    << ", bmin=" << that.bmin()
		<< ", bmax=" << that.bmax()
    << ", voltageSetPoint=" << that.voltageSetPoint()
		<< ", reactivePowerSetPoint=" << that.reactivePowerSetPoint()
  ;
  if (that.has_p()) stream << ", p=" << that.p();
  if (that.has_q()) stream << ", q=" << that.q();
  return stream << connectable(that);
}

std::ostream& operator << (std::ostream& stream, IIDM::Generator const& that) {
	stream << MACRO_INDENT MACRO_INDENT MACRO_INDENT "Generator: "
		<< static_cast<IIDM::ContainedIn<IIDM::VoltageLevel> const&>(that)
		<< static_cast<IIDM::Identifiable const&>(that)
    
    << ", energySource=" << that.energySource()
    << ", regulating="   << (that.voltageRegulatorOn() ? "on ": "off")
    << ", pmin="         << that.pmin   ()
    << ", pmax="         << that.pmax   ()
    << ", targetP="      << that.targetP()
    << ", targetQ="      << that.targetQ()
    << ", targetV="      << that.targetV()
    << ", ratedS="       << that.ratedS ()
  ;
  if (that.has_p()) stream << ", p=" << that.p();
  if (that.has_q()) stream << ", q=" << that.q();
  if (that.has_minMaxReactiveLimits())    stream << ", minMaxReactiveLimits="   << that.minMaxReactiveLimits();
  if (that.has_reactiveCapabilityCurve()) stream << ", reactiveCapabilityCurve="<< that.reactiveCapabilityCurve();
  if (that.has_regulatingTerminal())      stream << ", regulatingTerminal="     << that.regulatingTerminal()
  ;
  return stream << connectable(that);
}
