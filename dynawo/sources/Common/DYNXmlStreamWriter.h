//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
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
 * @file DYNXmlStreamWriter.h
 * @brief XML Stream Writer
 *
 */

#ifndef COMMON_DYNXMLSTREAMWRITER_H_
#define COMMON_DYNXMLSTREAMWRITER_H_

#include <functional>
#include <memory>
#include <libxml/xmlwriter.h>

namespace DYN {

class XmlStreamWriter {
 public:
  XmlStreamWriter(std::ostream &stream, bool indent);

  void writeAttribute(const std::string &attributeName, bool attributeValue);

  void writeAttribute(const std::string &attributeName, const char *attributeValue);

  void writeAttribute(const std::string &attributeName, int attributeValue);

  void writeAttribute(const std::string &attributeName, double attributeValue);

  void writeAttribute(const std::string &attributeName, long attributeValue);

  void writeAttribute(const std::string &attributeName, unsigned long attributeValue);

  void writeAttribute(const std::string &attributeName, const std::string &attributeValue);

  void writeStartDocument(const std::string &encoding, const std::string &version);

  void writeEndDocument();

  void writeStartElement(const std::string &prefix);

  void writeEndElement();

 private:
  using XmlStreamWriterPtr = std::unique_ptr<xmlTextWriter, std::function<void(xmlTextWriter *)> >;

  std::ostream &stream_;
  bool indent_;
  XmlStreamWriterPtr writer_;
};

}  // end of namespace DYN

#endif  // COMMON_DYNXMLSTREAMWRITER_H_
