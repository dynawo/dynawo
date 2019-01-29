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
 * @file XercescStreamInputSource.h
 * @brief XML Xerces input source based on std::istream : header file
 *
 */
//======================================================================

#ifndef XML_SAX_PARSER_XERCESC_STREAM_INPUT_SOURCE_H
#define XML_SAX_PARSER_XERCESC_STREAM_INPUT_SOURCE_H

#include <istream>

#include <xercesc/sax/InputSource.hpp>
#include <xercesc/util/BinInputStream.hpp>
#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/util/XercesDefs.hpp>

#include <xml/cpp11.h>

namespace xml {
namespace sax {
namespace parser {

class XercescStreamInputStream : public xercesc::BinInputStream {
public:
  XercescStreamInputStream(std::istream& stream);
  virtual ~XercescStreamInputStream();

#if XERCES_VERSION_MAJOR < 3
  typedef unsigned int file_position_type;
  typedef unsigned int bytecount_type;
#else
  typedef XMLFilePos file_position_type;
  typedef XMLSize_t bytecount_type;
#endif
  
  virtual file_position_type curPos() const XML_OVERRIDE;

  virtual bytecount_type readBytes(XMLByte* const toFill, bytecount_type maxToRead) XML_OVERRIDE;

#if XERCES_VERSION_MAJOR >= 3
  virtual const XMLCh* getContentType() const XML_OVERRIDE {return 0;}
#endif

protected:
  std::istream& stream_;
};

class XercescStreamInputSource : public xercesc::InputSource {
public:
  XercescStreamInputSource(std::istream& stream, xercesc::MemoryManager* const manager = xercesc::XMLPlatformUtils::fgMemoryManager);
  virtual ~XercescStreamInputSource();

  virtual xercesc::BinInputStream* makeStream() const XML_OVERRIDE;

protected:
  std::istream& stream_;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
