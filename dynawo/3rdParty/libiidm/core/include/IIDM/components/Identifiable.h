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
 * @file components/Identifiable.h
 * @brief Identifiable interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_IDENTIFIABLE_H
#define LIBIIDM_COMPONENTS_GUARD_IDENTIFIABLE_H

#include <string>
#include <map>
#include <stdexcept>

#include <boost/type_index.hpp>
#include <boost/optional.hpp>


#include <IIDM/BasicTypes.h>
#include <IIDM/Extension.h>
#include <IIDM/pointers.h>

namespace IIDM {

/**
 * @brief Carries an identifier expected to be unique in some scope, and an optional name.
 */
struct Identifier {
public:
  ///constructs an unnamed Identifier
  Identifier(const char * id): m_id(id) {}

  ///constructs an unnamed Identifier
  Identifier(id_type const& id): m_id(id) {}

  ///constructs an Identifier with a given name
  Identifier(id_type const& id, std::string const& name): m_id(id), m_name(name) {}

  /**
   * @brief Gets the unique identifier of the object.
   * @returns the id provided at construction time.
   */
  id_type const& id() const { return m_id; }


  /**
   * @brief Tells if this Identifier has a name
   * @returns true if name() returns a name, false otherwise
   */
  bool named() const { return !name().empty(); }

  /**
   * @brief Gets the optional name of the object.
   * @returns the name of this Identifier if available, or an empty string
   */
  std::string const& name() const { return m_name; }

  /**
   * @brief Get the optional name of the object.
   * @returns the name of this Identifiable if available, or an empty string
   */
  Identifier& rename(std::string const& name) { m_name = name; return *this; }

private:
  id_type m_id;
  std::string m_name;
};


/**
 * @brief An IIDM identifiable object has an id, a potential name and properties.
 *
 * An object that is part of the network model and that is uniquely identified by an id.
 */
class Identifiable {
public:
  ///type of a property identifier
  typedef std::string property_id_type;
  ///type of a property value
  typedef std::string property_value_type;
  ///map type binding propertie identifiers to their values
  typedef std::map<property_id_type, property_value_type> properties_type;


private:
  typedef boost::typeindex::type_index extension_id_type;
  /**
   * @brief map type binding extension identifiers to the extension.
   *
   * pointers are used due to inheritence, but they shall not be null.
   */
  typedef std::map<extension_id_type, IIDM::Extension*> extensions_type;


public:
  /**
   * @brief Get the unique identifier of the object.
   * @returns the id provided at construction time.
   */
  id_type const& id() const { return m_id.id(); }


  /**
   * @brief Tells if this Identifiable is named
   * @returns true if name() returns a name, false otherwise
   */
  bool named() const { return m_id.named(); }

  /**
   * @brief Get the optional name of the object.
   * @returns the name of this Identifiable if available, or an empty string
   */
  std::string const& name() const { return m_id.name(); }

  /**
   * @brief Get the optional name of the object.
   * @returns the name of this Identifiable if available, or an empty string
   */
  void rename(std::string const& name) {m_id.rename(name);}

  /**
   * @brief Get properties associated to the object.
   * @returns properties map
   */
  properties_type const& properties() const { return m_properties; }

  /**
   * @brief Get property associated to the object.
   * @param property the name of the property to extract
   * @returns the value of the property
   * @throw std::runtime_error if no value is available
   */
  std::string value_of(property_id_type const& property) const;

  /**
   * @brief Get property associated to the object.
   * @param property the name of the property to extract
   * @returns the value of the property if available, or boost::none
   */
  boost::optional<std::string> find_property(property_id_type const& property) const;


  /**
   * @brief Get property associated to this object.
   * @param property the name of the property to get
   * @param defaultValue the default value if the property does not exist
   * @returns the value of the property if available, the default value otherwise
   */
  std::string find_property(property_id_type const& property, std::string const& defaultValue) const;

  /**
   * @brief Set property associated to the object.
   * @param name the name of the property to define
   * @param value the value to give to the property
   */
  void configure(property_id_type const& name, std::string const& value);




public:
  struct missing_extension : public std::runtime_error {
    missing_extension(): std::runtime_error("missing extension") {}
  };

  /**
   * @brief tells if any extension exists.
   */
  bool has_extensions() const { return !m_extensions.empty(); }


  /**
   * @brief tells if an extension exists for the given name.
   * @param name the name to look for
   */
  template <typename ExtensionType>
  bool has_extension() const { return has_extension(boost::typeindex::type_id<ExtensionType>()); }

  /**
   * @brief Get an extension by its type.
   * @tparam the type of extension to look for. It shall extend Extension.
   * @returns the searched extension or IIDM_NULLPTR if not found
   */
  template <typename ExtensionType>
  ExtensionType const* findExtension() const {
    return dynamic_cast<ExtensionType const*>( find_extension(boost::typeindex::type_id<ExtensionType>()) );
  }

  /**
   * @brief Get an extension by its type.
   * @tparam the type of extension to look for. It shall extend Extension.
   * @returns the searched extension or IIDM_NULLPTR if not found
   */
  template <typename ExtensionType>
  ExtensionType* findExtension() {
    return dynamic_cast<ExtensionType*>( find_extension(boost::typeindex::type_id<ExtensionType>()) );
  }

  /**
   * @brief Get an extension by its type.
   * @tparam the type of extension to look for. It shall extend Extension.
   * @returns the searched extension
   * @throws missing_extension if no extension is available
   */
  template <typename ExtensionType>
  ExtensionType const& getExtension() const {
    ExtensionType const* e = findExtension<ExtensionType>();
    if (!e) throw missing_extension();
    return *e;
  }

  /**
   * @brief Get an extension by its type.
   * @tparam the type of extension to look for. It shall extend Extension.
   * @returns the searched extension
   * @throws missing_extension if no extension is available
   */
  template <typename ExtensionType>
  ExtensionType& getExtension() {
    ExtensionType* e = findExtension<ExtensionType>();
    if (!e) throw missing_extension();
    return *e;
  }

  /**
   * @brief Set an extension for the given type.
   * @param name the name of the property to define
   * @param value the value to give to the property
   */
  void setExtension(IIDM_UNIQUE_PTR<Extension> e) {
    extension_id_type id = boost::typeindex::type_id_runtime(*e);
    return setExtension(id, e.release());
  }

  /**
   * @brief Set an extension for the given type.
   * @param name the name of the property to define
   * @param value the value to give to the property
   */
  template <typename ExtensionType>
  void setExtension(ExtensionType const& e) {
    extension_id_type id = boost::typeindex::type_id_runtime(e);
    return setExtension(id, new ExtensionType(e));
  }


private:
  bool has_extension(extension_id_type const& t) const;

  void setExtension(extension_id_type const& name, Extension* e);

  Extension* find_extension(extension_id_type const& name);
  Extension const* find_extension(extension_id_type const& name) const;


public:
  ///destructs an Identifiable.
  virtual ~Identifiable();

  Identifiable(Identifiable const&);

  Identifiable& operator=(Identifiable);

  Identifiable& swap(Identifiable&);

protected:
  ///constructs an identifiable with no properties
  Identifiable(Identifier const& id): m_id(id) {}

  ///constructs an identifiable with no name nor properties
  Identifiable(id_type const& id): m_id(id) {}

  ///constructs an identifiable with no properties
  Identifiable(id_type const& id, std::string const& name): m_id(id, name) {}

  ///constructs an identifiable with some properties
  Identifiable(Identifier const&, properties_type const&);

private:
  Identifier m_id;
  properties_type m_properties;
  extensions_type m_extensions;
};

inline void swap(Identifiable & a, Identifiable & b) { a.swap(b); }

} // end of namespace IIDM::

#endif
