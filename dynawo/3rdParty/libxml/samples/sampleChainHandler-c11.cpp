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

#if __cplusplus < 201103L

#error lambdas from C++11 are required for this sample.

#endif

#include <xml/sax/parser/CDataCollector.h>
#include <xml/sax/parser/ComposableElementHandler.h>
#include <xml/sax/parser/ComposableDocumentHandler.h>

#include <xml/sax/parser/Path.h>

#include <xml/sax/parser/Attributes.h>

#include <xml/sax/parser/Parser.h>
#include <xml/sax/parser/ParserFactory.h>
#include <xml/sax/parser/ParserException.h>

#include <iostream>
#include <string>


namespace parser = xml::sax::parser;

namespace sample {

namespace data {
struct BookBuilder;
class Book {
private:
  Book(){}
  std::string m_id;
  std::string m_title;
  std::string m_author;
  std::string m_genre;
  std::string m_price;
  std::string m_pub_date;
  std::string m_review;
public:
  std::string const & id      () const { return m_id      ; }
  std::string const & title   () const { return m_title   ; }
  std::string const & author  () const { return m_author  ; }
  std::string const & genre   () const { return m_genre   ; }
  std::string const & price   () const { return m_price   ; }
  std::string const & pub_date() const { return m_pub_date; }
  std::string const & review  () const { return m_review  ; }

  friend struct BookBuilder;
};

struct BookBuilder {
  std::string id      ;
  std::string title   ;
  std::string author  ;
  std::string genre   ;
  std::string price   ;
  std::string pub_date;
  std::string review  ;

  void clear() {
    id      .clear();
    title   .clear();
    author  .clear();
    genre   .clear();
    price   .clear();
    pub_date.clear();
    review  .clear();
  }

  Book build() const {
    Book b;
    b.m_id       = id      ;
    b.m_title    = title   ;
    b.m_author   = author  ;
    b.m_genre    = genre   ;
    b.m_price    = price   ;
    b.m_pub_date = pub_date;
    b.m_review   = review  ;
    return b;
  }
};

typedef std::vector<Book> library;

}//sample::data::

namespace io {

using sample::data::BookBuilder;

class BookHandler : public parser::ComposableElementHandler {

  struct PropertyHandler: public parser::CDataCollector {
    std::string& target;
    PropertyHandler(std::string& target): target(target) {}

    void do_endElement(parser::ElementName const&) { target=data(); }
  };

  BookBuilder builder;

  PropertyHandler h_title, h_author, h_genre, h_price, h_pub_date, h_review;

public:
  explicit BookHandler():
    h_title   (builder.title   ),
    h_author  (builder.author  ),
    h_genre   (builder.genre   ),
    h_price   (builder.price   ),
    h_pub_date(builder.pub_date),
    h_review  (builder.review  )
  {
    using parser::ns::empty;

    onStartElement(
      empty("book"),
      [this](parser::ElementName const&, attributes_type const& attributes) {
        builder.clear();
        builder.id = attributes.get<std::string>("id");
      }
    );

    onElement(empty("book/title")   , h_title   );
    onElement(empty("book/author")  , h_author  );
    onElement(empty("book/genre")   , h_genre   );
    onElement(empty("book/price")   , h_price   );
    onElement(empty("book/pub_date"), h_pub_date);
    onElement(empty("book/review")  , h_review  );
  }

  sample::data::Book build() {return builder.build();}
};

}//sample::io::
}//sample::


using std::cout;
using std::cerr;
using std::endl;

int main(int argc, char** argv) {
  if (argc != 3) {
    std::cerr<<" Usage: sampleParser <fileToParse.xml> <fileToParse.xsd>"<<std::endl;
    std::cerr<<" There are example files in <samples/res> directory "<<std::endl;
    return -1;
  }

  const std::string fileName(argv[1]);
  const std::string fileXsd(argv[2]);


  parser::ParserFactory parser_factory;

  parser::ParserPtr parser;
  std::string grammar_target;
  try {
    parser = parser_factory.createParser();
    grammar_target = parser->addXmlSchema(fileXsd);
  } catch (parser::ParserException const& exp) {
    std::cerr<<"grammar error :"<< exp.what()<<std::endl;
    return -1;
  }

  parser::namespace_uri books_uri(grammar_target);

  sample::data::library library;

  sample::io::BookHandler bh;
  bh.onEnd( [&library, &bh]() {library.push_back(bh.build());} );

  parser::ComposableDocumentHandler handler;
  handler.onStartDocument( []() {cout << "loading book definitions..." << endl;} );
  handler.onEndDocument( []() {cout << "book list loaded." << endl;} );
  handler.onElement(books_uri("books") + "book", bh);

  try {
    parser->parse(fileName, handler, true);
  } catch (parser::ParserException const& exp) {
    std::cerr<<"Parsing error :"<< exp.what()<<std::endl;
    return -1;
  }

  for (auto const& b : library) {
    cout << "book:\tid = "<< b.id()
      <<"\n\tauthor = "   << b.author  ()
      <<"\n\ttitle = "    << b.title   ()
      <<"\n\tgenre = "    << b.genre   ()
      <<"\n\tprice = "    << b.price   ()
      <<"\n\tpub_date = " << b.pub_date()
      <<"\n\treview = "   << b.review  ()
      << endl;
  }

  return 0;
}
