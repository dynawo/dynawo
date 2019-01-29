//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libxml, a library to handle XML files parsing.
//

//======================================================================
/**
 * @file XercescStreamInputSource.cpp
 * @brief XML Xerces input source based on std::istream : implementation file
 *
 */
//======================================================================

#include "internals/XercescStreamInputSource.h"

namespace xml {
namespace sax {
namespace parser {

XercescStreamInputStream::XercescStreamInputStream(std::istream& stream): stream_(stream) {}

XercescStreamInputStream::~XercescStreamInputStream() {}

XercescStreamInputStream::file_position_type XercescStreamInputStream::curPos() const {
  return stream_.tellg();
}

XercescStreamInputStream::bytecount_type
XercescStreamInputStream::readBytes(XMLByte* const toFill, bytecount_type maxToRead) {
  stream_.read((char *) toFill, maxToRead);
  return stream_.gcount();
}

XercescStreamInputSource::XercescStreamInputSource(std::istream& stream, xercesc::MemoryManager* const manager):
  InputSource(manager),
  stream_(stream)
{}



XercescStreamInputSource::~XercescStreamInputSource() {}

xercesc::BinInputStream*
XercescStreamInputSource::makeStream() const {
  return new (getMemoryManager()) XercescStreamInputStream(stream_);

}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
