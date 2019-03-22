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
 * @file xml/export/export_functions.cpp
 * @brief implementation of export methods used by xml_exporter
 */

#include <IIDM/xml/export/export_functions.h>

#include <IIDM/xml/export.h>
#include <IIDM/xml/export/attributes_helper.h>

#include <IIDM/Network.h>

#include <IIDM/components/Line.h>
#include <IIDM/components/TieLine.h>
#include <IIDM/components/HvdcLine.h>

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
#include <IIDM/components/VscConverterStation.h>
#include <IIDM/components/LccConverterStation.h>

#include <IIDM/components/ConnectionPoint.h>


#include <xml/sax/formatter/Formatter.h>
#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace xml {

using ::xml::sax::formatter::Element;
using ::xml::sax::formatter::Document;
using ::xml::sax::formatter::AttributeList;


// helps with non const reference and temporaries problems. would be useless with C++11 R-value reference.
inline AttributeList make_attributes(IIDM::Identifiable const& identifiable) {
  AttributeList attrs;
  return attrs << identifiable;
}


/// forces the conversion of reference (to use as element << properties(object); )
inline IIDM::Identifiable const& properties(IIDM::Identifiable const& identifiable) { return identifiable; }

// adds Identifiable's properties
Element& operator << (Element& root, IIDM::Identifiable const& identifiable) {
  typedef IIDM::Identifiable::properties_type::const_iterator const_iterator;

  for (const_iterator it = identifiable.properties().begin(), end = identifiable.properties().end(); it!=end; ++it) {
    root.element( "property", AttributeList("name", it->first)("value", it->second) );
  }
  return root;
}


// support function
template <typename T>
Element& operator << (Element& root, IIDM::Contains<T> const& c) {
  for (typename IIDM::Contains<T>::const_iterator it = c.begin(), end = c.end(); it!=end; ++it) {
    to_xml(root, *it);
  }
  return root;
}

// actual contents
Element to_xml(Document& document, Network const& network) {
  Element e = document.element(
    "network",
      AttributeList()
        ("id", network.id())
        ("caseDate", network.caseDate())
        ("forecastDistance", network.forecastDistance())
        ("sourceFormat", network.sourceFormat())
  );
  e << network.substations();
  e << network.lines();
  e << network.tielines();
  e << network.hvdclines();
  return e;
}

void to_xml(Element& root, IIDM::Line const& line) {
  Element e = root.element(
    "line",
    make_attributes(line)
      ("r" , line.r ())
      ("x" , line.x ())
      ("g1", line.g1())
      ("b1", line.b1())
      ("g2", line.g2())
      ("b2", line.b2())
      << withVoltageLevel(line)
      << pq(line)// itesla has option not to export this (isWithBranchSV)
  );
  e << properties(line);

  if (line.has_currentLimits1()) to_xml(e, "currentLimits1", line.currentLimits1());
  if (line.has_currentLimits2()) to_xml(e, "currentLimits2", line.currentLimits2());
}

void to_xml(Element& root, IIDM::TieLine const& line) {
  Element e = root.element(
    "tieLine",
        (make_attributes(line)
          ("ucteXnodeCode", line.optional_ucteXnodeCode())
          << withVoltageLevel(line)
          << pq(line)// itesla has option not to export this (isWithBranchSV)
        )

        ("id_1"    , line.id_1())
        ("name_1"  , line.optional_name_1())
        ("r_1"     , line.r_1     ())
        ("x_1"     , line.x_1     ())
        ("g1_1"    , line.g1_1    ())
        ("g2_1"    , line.g2_1    ())
        ("b1_1"    , line.b1_1    ())
        ("b2_1"    , line.b2_1    ())
        ("xnodeP_1", line.xnodeP_1())
        ("xnodeQ_1", line.xnodeQ_1())

        ("id_2"    , line.id_2())
        ("name_2"  , line.optional_name_2())
        ("r_2"     , line.r_2     ())
        ("x_2"     , line.x_2     ())
        ("g1_2"    , line.g1_2    ())
        ("g2_2"    , line.g2_2    ())
        ("b1_2"    , line.b1_2    ())
        ("b2_2"    , line.b2_2    ())
        ("xnodeP_2", line.xnodeP_2())
        ("xnodeQ_2", line.xnodeQ_2())

  );
  e << properties(line);

  if (line.has_currentLimits1()) to_xml(e, "currentLimits1", line.currentLimits1());
  if (line.has_currentLimits2()) to_xml(e, "currentLimits2", line.currentLimits2());
}

void to_xml(Element& root, IIDM::HvdcLine const& line) {
  const bool isRectifierInverter = (line.convertersMode() == IIDM::HvdcLine::mode_RectifierInverter);

  Element e = root.element(
    "hvdcLine",
    make_attributes(line)
      ("r", line.r())
      ("nominalV", line.nominalV())
      ("convertersMode", isRectifierInverter ? "SIDE_1_RECTIFIER_SIDE_2_INVERTER" : "SIDE_1_INVERTER_SIDE_2_RECTIFIER")
      ("activePowerSetpoint", line.activePowerSetpoint())
      ("maxP", line.maxP())
      ("converterStation1", line.converterStation1())
      ("converterStation2", line.converterStation2())
  );
  e << properties(line);
}


void to_xml(Element& root, IIDM::Substation const& substation) {
  Element e = root.element(
    "substation",
      make_attributes(substation)
        ("country", substation.country())
        ("tso"    , substation.optional_tso())
        ("geographicalTags", substation.optional_geographicalTags())
  );
  e << properties(substation);
  e << substation.voltageLevels();
  e << substation.twoWindingsTransformers();
  e << substation.threeWindingsTransformers();
}


void to_xml(Element& root, IIDM::VoltageLevel const& v) {
  const bool is_node_breaker = (v.mode() == IIDM::VoltageLevel::node_breaker);

  Element voltageLevel = root.element(
    "voltageLevel",
      make_attributes(v)
        ("nominalV", v.nominalV())
        ("lowVoltageLimit", v.optional_lowVoltageLimit())
        ("highVoltageLimit", v.optional_highVoltageLimit())
        ("topologyKind", is_node_breaker ? "NODE_BREAKER" : "BUS_BREAKER")
  );
  voltageLevel << properties(v);

  if (is_node_breaker) {
    Element topology = voltageLevel.element(
      "nodeBreakerTopology",
      AttributeList("nodeCount", v.node_count())
    );
    topology << v.busBarSections();
    topology << v.switches();
  } else {
    Element topology = voltageLevel.element("busBreakerTopology");
    topology << v.buses();
    topology << v.switches();
  }
  voltageLevel << v.generators();
  voltageLevel << v.loads();
  voltageLevel << v.shuntCompensators();
  voltageLevel << v.danglingLines();
  voltageLevel << v.staticVarCompensators();
  voltageLevel << v.vscConverterStations();
  voltageLevel << v.lccConverterStations();
}

void to_xml(Element& root, IIDM::Bus const& bus) {
  Element e = root.element(
    "bus",
    make_attributes(bus)
      ("v"    , bus.optional_v())
      ("angle", bus.optional_angle())
  );
  e << properties(bus);
}

void to_xml(Element& root, IIDM::BusBarSection const& busBarSection) {
  Element e = root.element("busbarSection",
    make_attributes(busBarSection)
      ("node", busBarSection.node())
      ("v", busBarSection.optional_v())
      ("angle", busBarSection.optional_angle())
  );
  e << properties(busBarSection);
}

void to_xml(Element& root, IIDM::Switch const& s) {
  const char* kind;
  switch(s.type()) {
    case IIDM::Switch::breaker:           kind = "BREAKER"; break;
    case IIDM::Switch::disconnector:      kind = "DISCONNECTOR"; break;
    case IIDM::Switch::load_break_switch: kind = "LOAD_BREAK_SWITCH"; break;
    default: kind="UNAVAILABLE";
  }
  const bool bus_mode = (s.mode() == IIDM::Switch::mode_bus);

  Element e = root.element(
    "switch",
    make_attributes(s)
      ("kind", kind)
      ("retained", s.retained())
      ("open", s.opened())
      ("fictitious", s.fictitious() ? boost::optional<bool>(true) : boost::none)
      (bus_mode ? "bus1" : "node1", s.port1().port())
      (bus_mode ? "bus2" : "node2", s.port2().port())
  );
  e << properties(s);
}


void to_xml(Element& root, IIDM::Load const& load) {
  boost::optional<std::string> kind;
  switch(load.type()) {
    case IIDM::Load::type_undefined : kind = std::string("UNDEFINED"); break;
    case IIDM::Load::type_auxiliary : kind = std::string("AUXILIARY"); break;
    case IIDM::Load::type_fictitious: kind = std::string("FICTITIOUS"); break;
  }

  Element e = root.element(
    "load",
    make_attributes(identifiable(load))
      ("loadType", kind)
      ("p0", load.p0())
      ("q0", load.q0())
      << connectable(load)
      << pq(load)
  );
  e << properties(load);
}

void to_xml(Element& root, IIDM::ShuntCompensator const& shunt) {
  Element e = root.element(
    "shunt",
    make_attributes(identifiable(shunt))
      ("bPerSection", shunt.bPerSection())
      ("maximumSectionCount", shunt.maximumSectionCount())
      ("currentSectionCount", shunt.currentSection())
      << connectable(shunt)
      << q(shunt)
  );
  e << properties(shunt);
}

void to_xml(Element& root, IIDM::DanglingLine const& danglingLine) {
  Element e = root.element(
    "danglingLine",
    make_attributes(identifiable(danglingLine))
      ("p0", danglingLine.p0())
      ("q0", danglingLine.q0())
      ("r" , danglingLine.r ())
      ("x" , danglingLine.x ())
      ("g" , danglingLine.g ())
      ("b" , danglingLine.b ())
      ("ucteXnodeCode", danglingLine.optional_ucte_xNodeCode())
      << connectable(danglingLine)
      << pq(danglingLine)
  );
  e << properties(danglingLine);

  if (danglingLine.has_currentLimits()) {
    to_xml(e, "currentLimits", danglingLine.currentLimits());
  }
}

void to_xml(Element& root, IIDM::StaticVarCompensator const& svc) {
  const char* kind;
  switch(svc.regulationMode()) {
    case IIDM::StaticVarCompensator::regulation_voltage:        kind = "VOLTAGE"; break;
    case IIDM::StaticVarCompensator::regulation_reactive_power: kind = "REACTIVE_POWER"; break;
    case IIDM::StaticVarCompensator::regulation_off:            kind = "OFF"; break;
    default: kind="UNAVAILABLE";
  }

  Element e = root.element(
    "staticVarCompensator",
    make_attributes(identifiable(svc))
      ("bMin", svc.bmin())
      ("bMax", svc.bmax())
      ("voltageSetPoint", svc.optional_voltageSetPoint())
      ("reactivePowerSetPoint", svc.optional_reactivePowerSetPoint())
      ("regulationMode", kind)
      << connectable(svc)
      << pq(svc)
  );
  e << properties(svc);
}

void to_xml(Element& root, IIDM::Generator const& generator) {
  const char* energySource;
  switch(generator.energySource()) {
    case IIDM::Generator::source_hydro:   energySource = "HYDRO"  ; break;
    case IIDM::Generator::source_nuclear: energySource = "NUCLEAR"; break;
    case IIDM::Generator::source_wind:    energySource = "WIND"   ; break;
    case IIDM::Generator::source_thermal: energySource = "THERMAL"; break;
    case IIDM::Generator::source_solar:   energySource = "SOLAR"  ; break;
    case IIDM::Generator::source_other:   energySource = "OTHER"  ; break;
    default: energySource="UNAVAILABLE";
  }

  Element e = root.element(
    "generator",
    make_attributes(generator)
      ("energySource", energySource)
      ("minP", generator.pmin())
      ("maxP", generator.pmax())
      ("ratedS", generator.optional_ratedS())
      ("voltageRegulatorOn", generator.voltageRegulatorOn())
      ("targetP", generator.targetP())
      ("targetQ", generator.optional_targetQ())
      ("targetV", generator.optional_targetV())
      << connectable(generator)
      << pq(generator)
  );
  e << properties(generator);

  if (generator.has_regulatingTerminal())      to_xml(e, "regulatingTerminal", generator.regulatingTerminal());
  if (generator.has_reactiveCapabilityCurve()) to_xml(e, "reactiveCapabilityCurve", generator.reactiveCapabilityCurve());
  if (generator.has_minMaxReactiveLimits())    to_xml(e, "minMaxReactiveLimits", generator.minMaxReactiveLimits());
}

void to_xml(Element& root, IIDM::VscConverterStation const& vcs) {
  Element e = root.element(
    "vscConverterStation",
    make_attributes(vcs)
      ("voltageRegulatorOn", vcs.voltageRegulatorOn())
      ("lossFactor", vcs.lossFactor())
      ("voltageSetpoint", vcs.optional_voltageSetpoint())
      ("reactivePowerSetpoint", vcs.optional_reactivePowerSetpoint())
      << connectable(vcs)
      << pq(vcs)
  );
  e << properties(vcs);

  if (vcs.has_reactiveCapabilityCurve()) to_xml(e, "reactiveCapabilityCurve", vcs.reactiveCapabilityCurve());
  if (vcs.has_minMaxReactiveLimits())    to_xml(e, "minMaxReactiveLimits", vcs.minMaxReactiveLimits());
}

void to_xml(Element& root, IIDM::LccConverterStation const& lcs) {
  Element e = root.element(
    "lccConverterStation",
    make_attributes(lcs)
      ("lossFactor", lcs.lossFactor())
      ("powerFactor", lcs.powerFactor())
      << connectable(lcs)
      << pq(lcs)
  );
  e << properties(lcs);
}


void to_xml(Element& root, IIDM::Transformer2Windings const& transformer) {
  Element e = root.element(
    "twoWindingsTransformer",
      make_attributes(transformer)
        ("r", transformer.r())
        ("x", transformer.x())
        ("g", transformer.g())
        ("b", transformer.b())
        ("ratedU1", transformer.ratedU1())
        ("ratedU2", transformer.ratedU2())
        << withVoltageLevel(transformer)
        << pq(transformer)
  );
  e << properties(transformer);
  if (transformer.has_ratioTapChanger()) to_xml(e, "ratioTapChanger", transformer.ratioTapChanger());
  if (transformer.has_phaseTapChanger()) to_xml(e, "phaseTapChanger", transformer.phaseTapChanger());
  if (transformer.has_currentLimits1 ()) to_xml(e, "currentLimits1", transformer.currentLimits1 ());
  if (transformer.has_currentLimits2 ()) to_xml(e, "currentLimits2", transformer.currentLimits2 ());
}

void to_xml(Element& root, IIDM::Transformer3Windings const& transformer) {
  Element e = root.element(
    "threeWindingsTransformer",
      (make_attributes(transformer)
        ("r1", transformer.r1())
        ("x1", transformer.x1())
        ("g1", transformer.g1())
        ("b1", transformer.b1())
        ("ratedU1", transformer.ratedU1())
        ("r2", transformer.r2())
        ("x2", transformer.x2())
        ("ratedU2", transformer.ratedU2())
        ("r3", transformer.r3())
        ("x3", transformer.x3())
        ("ratedU3", transformer.ratedU3())
        << withVoltageLevel(transformer)
        << pq(transformer)
      )
  );
  e << properties(transformer);
  if (transformer.has_ratioTapChanger2()) to_xml(e, "ratioTapChanger2", transformer.ratioTapChanger2());
  if (transformer.has_ratioTapChanger3()) to_xml(e, "ratioTapChanger3", transformer.ratioTapChanger3());
  if (transformer.has_currentLimits1 ()) to_xml(e, "currentLimits1", transformer.currentLimits1());
  if (transformer.has_currentLimits2 ()) to_xml(e, "currentLimits2", transformer.currentLimits2());
  if (transformer.has_currentLimits3 ()) to_xml(e, "currentLimits3", transformer.currentLimits3());
}


//internal data

void to_xml(Element& root, std::string const& name, IIDM::CurrentLimits const& limits, std::string const& xml_prefix) {
  Element e = root.element(
    xml_prefix,
    name,
    AttributeList("permanentLimit", limits.optional_permanent_limit())
  );
  for (IIDM::CurrentLimits::const_iterator it=limits.begin(), end=limits.end(); it!=end; ++it) {
    e.empty_element("temporaryLimit",
      AttributeList
        ("name", (it->name))
        ("acceptableDuration", (it->acceptableDuration))
        ("value", (it->value))
        ("fictitious", (it->fictitious))
    );
  }
}


void to_xml(Element& root, std::string const& name, IIDM::TerminalReference const& ref) {
  if (ref.side==IIDM::side_end) {
    root.element( name, AttributeList("id", ref.id) );
  } else {
    const char* side;
    switch(ref.side) {
      case IIDM::side_1: side = "ONE"; break;
      case IIDM::side_2: side = "TWO"; break;
      case IIDM::side_3: side = "THREE"; break;
      default: side="OTHER";
    }
    root.element( name, AttributeList("id", ref.id)("side", side) );
  }
}




void to_xml(Element& root, std::string const& name, IIDM::MinMaxReactiveLimits const& limits) {
  root.element( name, AttributeList("minQ", limits.min())("maxQ", limits.max()) );
}



void to_xml(Element& root, std::string const& name, IIDM::ReactiveCapabilityCurve const& curve) {
  Element e = root.element(name);

  for (IIDM::ReactiveCapabilityCurve::const_iterator it=curve.begin(), end=curve.end(); it!=end; ++it) {
    e.element("point", AttributeList("p", it->p)("minQ", it->qmin)("maxQ", it->qmax) );
  }
}


void to_xml(Element& root, std::string const& name, IIDM::RatioTapChanger const& rtc) {
  Element e = root.element(name,
    AttributeList()
      ("lowTapPosition", rtc.lowTapPosition())
      ("tapPosition", rtc.tapPosition())
      ("loadTapChangingCapabilities", rtc.loadTapChangingCapabilities())
      ("regulating", rtc.optional_regulating())
      ("targetV", rtc.optional_targetV())
  );
  if (rtc.has_terminalReference()) to_xml(e, "terminalRef", rtc.terminalReference());

  for (IIDM::RatioTapChanger::const_iterator it=rtc.begin(), end=rtc.end(); it!=end; ++it) {
    e.element(
      "step",
      AttributeList("r", it->r)("x", it->x)("g", it->g)("b", it->b)("rho", it->rho)
    );
  }
}


void to_xml(Element& root, std::string const& name, IIDM::PhaseTapChanger const& ptc) {
  const char* mode;
  switch(ptc.regulationMode()) {
    case IIDM::PhaseTapChanger::mode_current_limiter : mode = "CURRENT_LIMITER" ; break;
    case IIDM::PhaseTapChanger::mode_active_power_control : mode = "ACTIVE_POWER_CONTROL" ; break;
    case IIDM::PhaseTapChanger::mode_fixed_tap: mode = "FIXED_TAP"; break;
    default: mode="UNAVAILABLE";
  }

  Element e = root.element(name,
    AttributeList()
      ("lowTapPosition", ptc.lowTapPosition())
      ("tapPosition", ptc.tapPosition())
      ("regulationMode", mode)
      ("regulationValue", ptc.optional_regulationValue())
      ("regulating", ptc.regulating())
  );
  if (ptc.has_terminalReference()) to_xml(e, "terminalRef", ptc.terminalReference());

  for (IIDM::PhaseTapChanger::const_iterator it=ptc.begin(), end=ptc.end(); it!=end; ++it) {
    e.empty_element(
      "step",
      AttributeList("r", it->r)("x", it->x)("g", it->g)("b", it->b)("rho", it->rho)("alpha", it->alpha)
    );
  }
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
