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

/** 
 * @file XercescParser.cpp
 * @brief XML Xerces c++ parser description : implementation file
 *
 */

#include "internals/XercescParser.h"

#include <fstream>
#include <iostream>
#include <memory>

#include <xercesc/sax2/Attributes.hpp>
#include <xercesc/sax2/DefaultHandler.hpp>

#include <xercesc/sax2/SAX2XMLReader.hpp>
#include <xercesc/sax2/XMLReaderFactory.hpp>

#include <xercesc/framework/XMLGrammarPool.hpp>
#if XERCES_VERSION_MAJOR == 3
#include <xercesc/framework/XMLGrammarPoolImpl.hpp>
#else
#include <xercesc/internal/XMLGrammarPoolImpl.hpp>
#endif
#include <xercesc/util/PlatformUtils.hpp>


#include <xml/sax/parser/DocumentHandler.h>
#include <xml/sax/parser/Attributes.h>

#include <xml/sax/parser/ParserException.h>

#include <xml/pointers.h>

#include "internals/XercescStreamInputSource.h"

#include <boost/optional.hpp>

namespace xml {
namespace sax {
namespace parser {

/**
 * @brief Simple class used to transcode XercesC++ XMLCh* to std::string
 */
class XmlToString {
public:
  XmlToString(const XMLCh* toTranscode): xmlChar_(xercesc::XMLString::transcode(toTranscode)) {}
  
  ~XmlToString() { xercesc::XMLString::release(&xmlChar_); }
  
  std::string xml2S() const { return std::string(xmlChar_); }
  
private:
  char* xmlChar_;
};

// pour des simplicites de lecture du code
inline std::string XML2S( const XMLCh *xmlCh) { return XmlToString(xmlCh).xml2S(); }


class XercescParser::XercesHandler: public xercesc::DefaultHandler {
private:
  DocumentHandler & handler_;

  std::string parsedFile_;

  namespace_uri default_uri;
  
  namespace_uri make_namespace_uri(const XMLCh *const raw_ns_uri) {
    const std::string ns_uri = XML2S(raw_ns_uri);
    return (!ns_uri.empty()) ? namespace_uri(ns_uri) : default_uri;
  }
  
public:
  XercesHandler(DocumentHandler & handler): xercesc::DefaultHandler(), handler_(handler) {}
  
  XercesHandler(DocumentHandler & handler, std::string filename):
    xercesc::DefaultHandler(),
    handler_(handler), parsedFile_(filename)
  {}
  
  std::string const& filename() const {return parsedFile_;}
  
//extends xercesc::DefaultHandler
public:
  /**
   * @brief Receive notification of the beginning of the document.
   */
  virtual void startDocument() XML_OVERRIDE {
    handler_.startDocument();
    default_uri = namespace_uri();
  }

  /**
   * Receive notification of the end of the document.
   */
  virtual void endDocument() XML_OVERRIDE { handler_.endDocument(); }
  
  
  
  virtual void startPrefixMapping(const XMLCh *const prefix, const XMLCh *const uri) XML_OVERRIDE {
    if (XML2S(prefix).empty()) default_uri = namespace_uri(XML2S(uri));
  }
  
  
  
  void
  startElement(const XMLCh *const raw_ns_uri, const XMLCh *const localname, const XMLCh *const /*qname*/, xercesc::Attributes const& attributes) XML_OVERRIDE {
    namespace_uri ns = make_namespace_uri(raw_ns_uri);
    
    Attributes att;
    for (unsigned int i = 0; i < attributes.getLength(); i++) {
      att.set( XML2S(attributes.getQName(i)), XML2S(attributes.getValue(i)) );
    }

    handler_.startElement(ElementName(ns, XML2S(localname)), att);
  }



  void
  endElement(const XMLCh *const raw_ns_uri, const XMLCh *const localname, const XMLCh *const /*qname*/) XML_OVERRIDE {
    handler_.endElement( ElementName( make_namespace_uri(raw_ns_uri), XML2S(localname) ) );
  }



  #if XERCES_VERSION_MAJOR == 2
  void characters(const XMLCh *const chars, const unsigned int /*length*/) XML_OVERRIDE {
    handler_.readCharacters(XML2S(chars));
  }
  #else
  void characters(const XMLCh *const chars, const XMLSize_t /*length*/) XML_OVERRIDE {
    handler_.readCharacters(XML2S(chars));
  }
  #endif



  void warning(const xercesc::SAXParseException& exception) XML_OVERRIDE {
    std::cerr << "Warn: " << XML2S(exception.getMessage()) << " at line: " << exception.getLineNumber() << std::endl;
  }



  void error(xercesc::SAXParseException const& exception) XML_OVERRIDE {
    throw ParserException(XML2S(exception.getMessage()), parsedFile_, exception.getLineNumber());
  }

  void fatalError(xercesc::SAXParseException const& exception) XML_OVERRIDE {
    throw ParserException(XML2S(exception.getMessage()), parsedFile_, exception.getLineNumber());
  }
};







XercescParser::XercescParser():
  grammarPool_( new xercesc::XMLGrammarPoolImpl(xercesc::XMLPlatformUtils::fgMemoryManager) )
{
  grammarPool_->lockPool();
}

XercescParser::~XercescParser() {}



std::string XercescParser::addXmlSchema(std::string const& schemaPath) {
  if (schemaPath == "") throw ParserException("Schema path is empty");

  // try to open the schema file. if it fails, throw. Otherwise, closes the stream by ifstream destructor, so that Xerces can open it.
  if ( !std::ifstream(schemaPath.c_str()).is_open() ) {
    throw ParserException("Schema path is not valid: "+schemaPath);
  }
  
  grammarPool_->unlockPool();
  
  // Load the schema into the grammar pool
  XML_OWNER_PTR<xercesc::SAX2XMLReader> reader(
    xercesc::XMLReaderFactory::createXMLReader(xercesc::XMLPlatformUtils::fgMemoryManager, grammarPool_.get())
  );

  xercesc::Grammar * g = reader->loadGrammar(schemaPath.c_str(), xercesc::Grammar::SchemaGrammarType, true);
  std::string ns = XML2S(g->getTargetNamespace());
  
  grammarPool_->lockPool();
  return ns;
}










void XercescParser::parse(std::string const& filename, DocumentHandler & handler, bool xsdCheck) {
  std::ifstream stream(filename.c_str(), std::ios::binary);
  XercesHandler xh(handler, filename);
  parse(stream, xh, xsdCheck);
}


void XercescParser::parse(std::istream& stream, DocumentHandler & handler, bool xsdCheck) {
  XercesHandler xh(handler);
  parse(stream, xh, xsdCheck);
}


void XercescParser::parse(std::istream& stream, XercesHandler & handler, bool xsdCheck) {
  // Create a SAX reader object.
  // Then, according to what we were told on the command line, set it to validate or not.

  XML_OWNER_PTR<xercesc::SAX2XMLReader> reader(
    xercesc::XMLReaderFactory::createXMLReader(xercesc::XMLPlatformUtils::fgMemoryManager, grammarPool_.get())
  );

  if (xsdCheck) {
    reader->setFeature(xercesc::XMLUni::fgSAX2CoreNameSpaces, true);
    reader->setFeature(xercesc::XMLUni::fgSAX2CoreNameSpacePrefixes, true);
    reader->setFeature(xercesc::XMLUni::fgSAX2CoreValidation, true);

    reader->setFeature(xercesc::XMLUni::fgXercesSchema, true);
    reader->setFeature(xercesc::XMLUni::fgXercesSchemaFullChecking, true);
    reader->setFeature(xercesc::XMLUni::fgXercesValidationErrorAsFatal, true);

    reader->setFeature(xercesc::XMLUni::fgXercesUseCachedGrammarInParse, true);
  }

  reader->setContentHandler(&handler);
  reader->setErrorHandler(&handler);

  try {
    XercescStreamInputSource source(stream);
    reader->parse(source);
  }
  catch (xercesc::XMLException& e) {
    throw ParserException(XML2S(e.getMessage()), handler.filename(), e.getSrcLine());
  }
  catch (ParserException const&) {
    throw;
  }
  catch (std::exception const& e) {
    throw ParserException(e.what(), handler.filename());
  }
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

