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
 * @file DYDXmlParser.cpp
 * @brief XML parser : implementation file
 *
 */

#include "DYNXmlString.h"
#include "DYDXmlParser.h"
#include "DYNXmlCharConversion.h"
#include "DYDModelTemplate.h"
#include "DYDBlackBoxModel.h"
#include "DYDModelTemplateExpansion.h"
#include "DYNMacrosMessage.h"

#pragma GCC diagnostic ignored "-Wunused-parameter"

namespace dynamicdata {

void validationErrorHandler(void* /*userData*/, xmlErrorPtr error) {
    std::string message = "XML error: ";
    if (error != nullptr) {
        if (error->message != nullptr) {
            message += error->message;
        }
        if (error->file != nullptr) {
            message += " in file ";
            message += error->file;
        }
        message += " at line ";
        message += std::to_string(error->line);
    }
    throw DYNError(DYN::Error::API, XsdValidationError, message);
}

XmlParser::XmlParser(boost::shared_ptr<DynamicModelsCollection> dynamicModelsCollection, const std::string& filename) :
    dynamicModelsCollection_(dynamicModelsCollection),
    reader_(xmlNewTextReaderFilename(filename.c_str())),
    filename_(filename) {
    if (!reader_) {
        throw DYNError(DYN::Error::API, FileSystemItemDoesNotExist, filename);
    }
    xmlSetStructuredErrorFunc(NULL, &validationErrorHandler);
}

void
XmlParser::parseXML() {
    try {
        while (xmlTextReaderRead(reader_.get()) == 1) {
            if (xmlTextReaderNodeType(reader_.get()) == XML_READER_TYPE_ELEMENT) {
                const DYN::XmlString nodeName(xmlTextReaderName(reader_.get()));
                if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:dynamicModelsArchitecture"))) {
                    parseDynamicModelsArchitecture();
                }
            }
        }
    } catch (const std::exception& err) {
        throw DYNError(DYN::Error::API, XmlFileParsingError, filename_, err.what());
    }
}

void
XmlParser::activateXSDValidation(const std::string& xsdSchemaFile) {
    xmlTextReaderSchemaValidate(reader_.get(), xsdSchemaFile.c_str());
}

void
XmlParser::parseDynamicModelsArchitecture() {
    while (xmlTextReaderRead(reader_.get()) == 1) {
        if (xmlTextReaderNodeType(reader_.get()) == XML_READER_TYPE_ELEMENT) {
            const DYN::XmlString nodeName(xmlTextReaderName(reader_.get()));
            if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:modelicaModel"))) {
                parseModelicaModel();
            } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:modelTemplate"))) {
                parseModelTemplate();
            } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:blackBoxModel"))) {
                parseBlackBoxModel();
            } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:modelTemplateExpansion"))) {
                parseModelTemplateExpansion();
            } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:connect"))) {
                parseConnect();
            } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:macroConnect"))) {
                parseMacroConnect();
            } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:macroConnector"))) {
                parseMacroConnector();
            } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:macroStaticReference"))) {
                parseMacroStaticReference();
            } else {
                throw DYNError(DYN::Error::API, XmlUnknownNodeName, nodeName.get(), filename_);
            }
        } else if (xmlTextReaderNodeType(reader_.get()) == XML_READER_TYPE_END_ELEMENT) {
            const DYN::XmlString nodeName(xmlTextReaderName(reader_.get()));
            if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:dynamicModelsArchitecture"))) {
                break;
            }
        }
    }
}

void
XmlParser::parseModelicaModel() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseModelTemplate() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseBlackBoxModel() {
    try {
        boost::shared_ptr<BlackBoxModel> blackBoxModel = nullptr;
        const DYN::XmlString blackBoxModelId(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("id")));
        if (blackBoxModelId != nullptr) {
            blackBoxModel = boost::shared_ptr<BlackBoxModel>(new BlackBoxModel(DYN::XML2S(blackBoxModelId.get())));
            const DYN::XmlString blackBoxModelStaticId(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("staticId")));
            const DYN::XmlString blackBoxModelLib(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("lib")));
            const DYN::XmlString blackBoxModelParFile(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("parFile")));
            const DYN::XmlString blackBoxModelParId(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("parId")));
            if (blackBoxModelStaticId != nullptr) {
                blackBoxModel->setStaticId(DYN::XML2S(blackBoxModelStaticId.get()));
            }
            if (blackBoxModelLib != nullptr) {
                blackBoxModel->setLib(DYN::XML2S(blackBoxModelLib.get()));
            }
            if (blackBoxModelParFile != nullptr) {
                blackBoxModel->setParFile(DYN::XML2S(blackBoxModelParFile.get()));
            }
            if (blackBoxModelParId != nullptr) {
                blackBoxModel->setParId(DYN::XML2S(blackBoxModelParId.get()));
            }
        }
        parseBlackBoxModelOrModelTemplateExpansion(blackBoxModel);
        dynamicModelsCollection_->addModel(blackBoxModel);
    } catch (const std::exception& err) {
        throw DYNError(DYN::Error::API, XmlFileParsingError, filename_, err.what());
    }
}

void
XmlParser::parseModelTemplateExpansion() {
    try {
        boost::shared_ptr<ModelTemplateExpansion> modelTemplateExpansion = nullptr;
        const DYN::XmlString modelTemplateExpansionId(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("id")));
        if (modelTemplateExpansionId != nullptr) {
            modelTemplateExpansion = boost::shared_ptr<ModelTemplateExpansion>(
                                                    new ModelTemplateExpansion(DYN::XML2S(modelTemplateExpansionId.get())));
            const DYN::XmlString modelTemplateExpansionTemplateId(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("templateId")));
            const DYN::XmlString modelTemplateExpansionStaticId(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("staticId")));
            const DYN::XmlString modelTemplateExpansionParFile(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("parFile")));
            const DYN::XmlString modelTemplateExpansionParId(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("parId")));

            if (modelTemplateExpansionTemplateId != nullptr) {
                modelTemplateExpansion->setTemplateId(DYN::XML2S(modelTemplateExpansionTemplateId.get()));
            }
            if (modelTemplateExpansionStaticId != nullptr) {
                modelTemplateExpansion->setStaticId(DYN::XML2S(modelTemplateExpansionStaticId.get()));
            }
            if (modelTemplateExpansionParFile != nullptr) {
                modelTemplateExpansion->setParFile(DYN::XML2S(modelTemplateExpansionParFile.get()));
            }
            if (modelTemplateExpansionParId != nullptr) {
                modelTemplateExpansion->setParId(DYN::XML2S(modelTemplateExpansionParId.get()));
            }
        }
        parseBlackBoxModelOrModelTemplateExpansion(modelTemplateExpansion);
        dynamicModelsCollection_->addModel(modelTemplateExpansion);
    } catch (const std::exception& err) {
        throw DYNError(DYN::Error::API, XmlFileParsingError, filename_, err.what());
    }
}

void
XmlParser::parseConnect() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseMacroConnection() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseMacroConnect() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseMacroConnector() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseMacroStaticReference() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseUnitDynamicModel() {
    // à remplir
    throw std::logic_error("À remplir");
}

void
XmlParser::parseStaticRef(boost::shared_ptr<Model> model) {
    try {
        model->addStaticRef(DYN::XML2S(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("var"))),
                            DYN::XML2S(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("staticVar"))));
    } catch (const std::exception& err) {
        throw DYNError(DYN::Error::API, XmlFileParsingError, filename_, err.what());
    }
}

void
XmlParser::parseMacroStaticRef(boost::shared_ptr<Model> model) {
    try {
        boost::shared_ptr<MacroStaticRef> macroStaticRef = boost::shared_ptr<MacroStaticRef>(
                            new MacroStaticRef(DYN::XML2S(xmlTextReaderGetAttribute(reader_.get(), DYN::S2XML("id")))));
        model->addMacroStaticRef(macroStaticRef);
    } catch (const std::exception& err) {
        throw DYNError(DYN::Error::API, XmlFileParsingError, filename_, err.what());
    }
}

void
XmlParser::parseBlackBoxModelOrModelTemplateExpansion(boost::shared_ptr<Model> model) {
    while (xmlTextReaderRead(reader_.get()) == 1 && xmlTextReaderNodeType(reader_.get()) != XML_READER_TYPE_END_ELEMENT) {
        if (xmlTextReaderNodeType(reader_.get()) == XML_READER_TYPE_ELEMENT) {
            try {
                const DYN::XmlString nodeName(xmlTextReaderName(reader_.get()));
                if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:staticRef"))) {
                    parseStaticRef(model);
                } else if (xmlStrEqual(nodeName.get(), DYN::S2XML("dyn:macroStaticRef"))) {
                    parseMacroStaticRef(model);
                } else {
                    throw DYNError(DYN::Error::API, XmlUnknownNodeName, nodeName.get(), filename_);
                }
            } catch (const std::exception& err) {
                throw DYNError(DYN::Error::API, XmlFileParsingError, filename_, err.what());
            }
        }
    }
}

}  // namespace dynamicdata
