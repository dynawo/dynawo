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

#include <cmath>
#include <cstring>
#include <boost/format.hpp>

#include "DYNXmlStreamWriter.h"
#include "DYNXmlCharConversion.h"

namespace DYN {

XmlStreamWriter::XmlStreamWriter(std::ostream &stream, bool indent) :
    stream_(stream),
    indent_(indent),
    writer_(nullptr) {}

void XmlStreamWriter::writeAttribute(const std::string &attributeName, bool attributeValue) {
  writeAttribute(attributeName, std::string(attributeValue ? "true" : "false"));
}

void XmlStreamWriter::writeAttribute(const std::string &attributeName, const char *attributeValue) {
  writeAttribute(attributeName, std::string(attributeValue));
}

void XmlStreamWriter::writeAttribute(const std::string &attributeName, double attributeValue) {
  if (!std::isnan(attributeValue)) {
    writeAttribute(attributeName, std::to_string(attributeValue));
  }
}

void XmlStreamWriter::writeAttribute(const std::string &attributeName, int attributeValue) {
  writeAttribute(attributeName, std::to_string(attributeValue));
}

void XmlStreamWriter::writeAttribute(const std::string &attributeName, const std::string &attributeValue) {
  int written = xmlTextWriterWriteAttribute(writer_.get(), S2XML(attributeName), S2XML(attributeValue));
  if (written < 0) {
    throw std::runtime_error((boost::format("Failed to write attribute %s") % attributeName).str());
  }
}

void XmlStreamWriter::writeAttribute(const std::string &attributeName, long attributeValue) {
  writeAttribute(attributeName, std::to_string(attributeValue));
}

void XmlStreamWriter::writeAttribute(const std::string &attributeName, unsigned long attributeValue) {
  writeAttribute(attributeName, std::to_string(attributeValue));
}

void XmlStreamWriter::writeStartDocument(const std::string &encoding, const std::string &version) {
  if (writer_) {
    throw std::runtime_error("XmlStreamWriter::WriteStartDocument should be call once");
  }

  xmlCharEncodingHandlerPtr encoder = xmlFindCharEncodingHandler(encoding.c_str());
  if (encoder == nullptr) {
    throw std::runtime_error((boost::format("Unable to get encoder for encoding %s") % encoding).str());
  }

  // initialize writer
  auto writeCallback = [](void *context, const char *buffer, int len) {
    XmlStreamWriter &writer = *static_cast<XmlStreamWriter *>(context);

    size_t beforeWrite = writer.stream_.tellp();
    writer.stream_.write(buffer, len);
    size_t afterWrite = writer.stream_.tellp();

    return static_cast<int>(afterWrite - beforeWrite);
  };

  auto closeCallback = [](void * /*context*/) { return 0; };

  auto deleteWriterCallback = [](void *ptr) {
    xmlFreeTextWriter(static_cast<xmlTextWriterPtr>(ptr));
  };

  xmlOutputBufferPtr buffer = xmlOutputBufferCreateIO(writeCallback, closeCallback, this, encoder);

  writer_ = XmlStreamWriterPtr(xmlNewTextWriter(buffer), deleteWriterCallback);

  if (!writer_) {
    throw std::runtime_error("Unable to create xml writer");
  }

  int ok = xmlTextWriterSetIndent(writer_.get(), indent_ ? 1 : 0);
  if (ok == 0) {
    ok = xmlTextWriterSetIndentString(writer_.get(), S2XML(std::string(2, ' ')));
  }

  if (ok < 0) {
    throw std::runtime_error("Cannot set indentation");
  }

  int written = xmlTextWriterStartDocument(writer_.get(), version.c_str(), encoding.c_str(), "no");

  if (written < 0) {
    throw std::runtime_error("Failed to write start document");
  }
}

void XmlStreamWriter::writeEndDocument() {
  // deleting the xmlTextWriter pointer automatically calls xmlTextWriterFlush()
  // and write to stream writer_ is instanciated in writeStartElement, so it
  // must be deleted here
  writer_.reset();
}

void XmlStreamWriter::writeStartElement(const std::string &name) {
  int written = xmlTextWriterStartElement(writer_.get(), S2XML(name));
  if (written < 0) {
    throw std::runtime_error((boost::format("Failed to write start element %s") % name).str());
  }
}

void XmlStreamWriter::writeEndElement() {
  int written = xmlTextWriterEndElement(writer_.get());
  if (written < 0) {
    throw std::runtime_error("Failed to write end element");
  }
}

}  // end of namespace DYN
