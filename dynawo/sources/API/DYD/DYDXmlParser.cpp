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
#include "DYDModelTemplateExpansion.h"
#include "DYDBlackBoxModel.h"
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

XmlParser::~XmlParser() {
    xmlFreeTextReader(reader_);
}

void
XmlParser::parseXML() {
    try {
        while (xmlTextReaderRead(reader_) == 1) {
            if (xmlTextReaderNodeType(reader_) == XML_READER_TYPE_ELEMENT) {
                const xmlChar *nodeName = xmlTextReaderConstName(reader_);
                if (xmlStrEqual(nodeName, DYN::S2XML("dyn:dynamicModelsArchitecture"))) {
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
    xmlTextReaderSchemaValidate(reader_, xsdSchemaFile.c_str());
}

void
XmlParser::parseDynamicModelsArchitecture() {
    while (xmlTextReaderRead(reader_) == 1) {
        if (xmlTextReaderNodeType(reader_) == XML_READER_TYPE_ELEMENT) {
            const xmlChar *nodeName = xmlTextReaderConstName(reader_);
            if (xmlStrEqual(nodeName, DYN::S2XML("dyn:modelicaModel"))) {
                parseParentNode("dyn:modelicaModel");
            } else if (xmlStrEqual(nodeName, DYN::S2XML("dyn:blackBoxModel"))) {
                parseParentNode("dyn:blackBoxModel");
            } else if (xmlStrEqual(nodeName, DYN::S2XML("dyn:macroConnector"))) {
                parseChildNode("dyn:macroConnector");
            } else if (xmlStrEqual(nodeName, DYN::S2XML("dyn:macroStaticReference"))) {
                parseChildNode("dyn:macroStaticReference");
            } else if (xmlStrEqual(nodeName, DYN::S2XML("dyn:modelTemplateExpansion"))) {
                parseParentNode("dyn:modelTemplateExpansion");
            } else if (xmlStrEqual(nodeName, DYN::S2XML("dyn:connect"))) {
                parseChildNode("dyn:connect");
            } else {
                throw DYNError(DYN::Error::API, XmlUnknownNodeName, nodeName, filename_);
            }
        } else if (xmlTextReaderNodeType(reader_) == XML_READER_TYPE_END_ELEMENT) {
            const xmlChar *nodeName = xmlTextReaderConstName(reader_);
            if (xmlStrEqual(nodeName, DYN::S2XML("dyn:dynamicModelsArchitecture"))) {
                break;
            }
        }
    }
}

void
XmlParser::parseParentNode(const std::string& parentNodeName) {
    if (parentNodeName == "dyn:modelTemplateExpansion") {
        boost::shared_ptr<ModelTemplateExpansion> modelTemplateExpansion = nullptr;
        const DYN::XmlString modelTemplateExpansionId(xmlTextReaderGetAttribute(reader_, DYN::S2XML("id")));
        if (modelTemplateExpansionId != nullptr) {
            modelTemplateExpansion = boost::shared_ptr<ModelTemplateExpansion>(
                                                    new ModelTemplateExpansion(DYN::XML2S(modelTemplateExpansionId.get())));
            const DYN::XmlString modelTemplateExpansionTemplateId(xmlTextReaderGetAttribute(reader_, DYN::S2XML("templateId")));
            const DYN::XmlString modelTemplateExpansionStaticId(xmlTextReaderGetAttribute(reader_, DYN::S2XML("staticId")));
            const DYN::XmlString modelTemplateExpansionParFile(xmlTextReaderGetAttribute(reader_, DYN::S2XML("parFile")));
            const DYN::XmlString modelTemplateExpansionParId(xmlTextReaderGetAttribute(reader_, DYN::S2XML("parId")));

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
        addStaticRefsToModel(modelTemplateExpansion);
        dynamicModelsCollection_->addModel(modelTemplateExpansion);
    } else if (parentNodeName == "dyn:blackBoxModel") {
        try {
            boost::shared_ptr<BlackBoxModel> blackBoxModel = nullptr;
            const DYN::XmlString blackBoxModelId(xmlTextReaderGetAttribute(reader_, DYN::S2XML("id")));
            if (blackBoxModelId != nullptr) {
                blackBoxModel = boost::shared_ptr<BlackBoxModel>(new BlackBoxModel(DYN::XML2S(blackBoxModelId.get())));
                const DYN::XmlString blackBoxModelStaticId(xmlTextReaderGetAttribute(reader_, DYN::S2XML("staticId")));
                const DYN::XmlString blackBoxModelLib(xmlTextReaderGetAttribute(reader_, DYN::S2XML("lib")));
                const DYN::XmlString blackBoxModelParFile(xmlTextReaderGetAttribute(reader_, DYN::S2XML("parFile")));
                const DYN::XmlString blackBoxModelParId(xmlTextReaderGetAttribute(reader_, DYN::S2XML("parId")));
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
            addStaticRefsToModel(blackBoxModel);
            dynamicModelsCollection_->addModel(blackBoxModel);
        } catch (const std::exception& e) {
            std::cout << e.what() << std::endl;
        }
    } else {
        throw DYNError(DYN::Error::API, XmlUnknownNodeName, parentNodeName, filename_);
    }
}

void
XmlParser::addStaticRefsToModel(boost::shared_ptr<Model> model) {
    while (xmlTextReaderRead(reader_) == 1 && xmlTextReaderNodeType(reader_) != XML_READER_TYPE_END_ELEMENT) {
        if (xmlTextReaderNodeType(reader_) == XML_READER_TYPE_ELEMENT) {
            const xmlChar *nodeName = xmlTextReaderConstName(reader_);
            if (xmlStrEqual(nodeName, DYN::S2XML("dyn:staticRef"))) {
                model->addStaticRef(DYN::XML2S(xmlTextReaderGetAttribute(reader_, DYN::S2XML("var"))),
                                    DYN::XML2S(xmlTextReaderGetAttribute(reader_, DYN::S2XML("staticVar"))));
            } else {
                throw DYNError(DYN::Error::API, XmlUnknownNodeName, nodeName, filename_);
            }
        }
    }
}

void
XmlParser::parseChildNode(const std::string& childNodeName) {
    // à remplir
}

}  // namespace dynamicdata
