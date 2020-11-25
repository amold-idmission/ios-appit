//
//  Document.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/18/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "Document.h"
#include "fileutil.h"
#include "tinyxml2/tinyxml2.h"

cv::Rect parse_rect(tinyxml2::XMLElement *c) {

    auto x1 = c->FirstChildElement("x1")->FirstChild()->ToText();
    auto y1 = c->FirstChildElement("y1")->FirstChild()->ToText();
    auto x2 = c->FirstChildElement("x2")->FirstChild()->ToText();
    auto y2 = c->FirstChildElement("y2")->FirstChild()->ToText();
    
    return cv::Rect(std::stod(x1->Value()), std::stod(y1->Value()),std::stod(x2->Value()) - std::stod(x1->Value()),std::stod(y2->Value()) - std::stod(y1->Value()));
}

cv::Size parse_size(tinyxml2::XMLElement *size) {
    
    return parse_rect(size).size();
}

std::shared_ptr<FaceComponent> parse_photo_component(tinyxml2::XMLElement *c) {

    auto name = c->FirstChildElement("Name")->FirstChild()->ToText()->Value();

    return std::shared_ptr<FaceComponent>( new FaceComponent(name, parse_rect(c) ) );
}

std::shared_ptr<BarCodeComponent> parse_bar_code_component(tinyxml2::XMLElement *c) {
    
    auto name = c->FirstChildElement("Name")->FirstChild()->ToText()->Value();
    auto xslNode = c->FirstChildElement("OCRTransformation")->FirstChildElement("xsl");
    
    auto fontCode = "";
    if (NULL != c->FirstChildElement("fontCode")) {
        fontCode = c->FirstChildElement("fontCode")->FirstChild()->ToText()->Value();
    }
    
    auto whiteListConfigChars = "";
    if (NULL != c->FirstChildElement("whiteListConfigChars")) {
        whiteListConfigChars = c->FirstChildElement("whiteListConfigChars")->FirstChild()->ToText()->Value();
    }
    if (xslNode == NULL) {
        return std::shared_ptr<BarCodeComponent>( new BarCodeComponent(name, parse_rect(c), "", fontCode, whiteListConfigChars ) );;
    }
    auto xsl = c->FirstChildElement("OCRTransformation")->FirstChildElement("xsl")->FirstChild()->ToText()->Value();
    return std::shared_ptr<BarCodeComponent>( new BarCodeComponent(name, parse_rect(c), xsl, fontCode, whiteListConfigChars  ) );
}


LetterSize parse_letter_size_for_width(tinyxml2::XMLElement *c) {

    auto width = c->FirstChildElement("letter_width");
    
    if (NULL == width) {
        return LetterSize(1,1);
    }
    return LetterSize(width->IntAttribute("min"),
                      width->IntAttribute("max"));
}

LetterSize parse_letter_size_for_height(tinyxml2::XMLElement *c) {
    
    auto height = c->FirstChildElement("letter_height");
    
    if (NULL == height) {
        return LetterSize(1,1);
    }
    return LetterSize(height->IntAttribute("min"),
                      height->IntAttribute("max"));
}


std::shared_ptr<TextComponent> parse_text_component(tinyxml2::XMLElement *c) {
    
    auto name = c->FirstChildElement("Name")->FirstChild()->ToText()->Value();
    int text_lines = 0;
    if (NULL != c->FirstChildElement("text_lines")) {
        text_lines = std::stoi(c->FirstChildElement("text_lines")->FirstChild()->ToText()->Value());
    }
    
    auto type = "";
    if(NULL != c->FirstChildElement("Type")){
        if(NULL != c->FirstChildElement("Type")->FirstChild()){
            type = c->FirstChildElement("Type")->FirstChild()->ToText()->Value();
        }
    }
    
    auto fontCode = "";
    if (NULL != c->FirstChildElement("fontCode")) {
        if(NULL != c->FirstChildElement("fontCode")->FirstChild()){
            fontCode = c->FirstChildElement("fontCode")->FirstChild()->ToText()->Value();
        }
    }
    
    auto whiteListConfigChars = "";
    if (NULL != c->FirstChildElement("whiteListConfigChars")) {
        if(NULL != c->FirstChildElement("whiteListConfigChars")->FirstChild()){
            whiteListConfigChars = c->FirstChildElement("whiteListConfigChars")->FirstChild()->ToText()->Value();
        }
    }
    
    auto whiteListConfigCode = "";
    if (NULL != c->FirstChildElement("whiteListConfigCode")) {
        if(NULL != c->FirstChildElement("whiteListConfigCode")->FirstChild()){
            whiteListConfigCode = c->FirstChildElement("whiteListConfigCode")->FirstChild()->ToText()->Value();
        }
    }
    
    std::string preserveSpace = "";
    if (NULL != c->FirstChildElement("PreserveSpace")) {
        if(NULL != c->FirstChildElement("PreserveSpace")->FirstChild()){
            preserveSpace = c->FirstChildElement("PreserveSpace")->FirstChild()->ToText()->Value();
            
        }
        if(preserveSpace.empty()){
            preserveSpace = "Y";
        }
    }
    
    std::string format = "";
    if (NULL != c->FirstChildElement("Format")) {
        if(NULL != c->FirstChildElement("Format")->FirstChild()){
            format = c->FirstChildElement("Format")->FirstChild()->ToText()->Value();
        }
    }
    
    std::map<std::string, std::string> regulareExpressionMap;
    std::string dateFormat="";
    
    tinyxml2::XMLElement  *regulareExpression = c->FirstChildElement("RegulareExpression");
    
    if (NULL != regulareExpression->FirstChildElement("DateFormat")) {
        if(NULL != regulareExpression->FirstChildElement("DateFormat")->FirstChild()){
            dateFormat = regulareExpression->FirstChildElement("DateFormat")->FirstChild()->ToText()->Value();
        }
    }
    
    for(tinyxml2::XMLElement* e = regulareExpression->FirstChildElement("Expression"); e != NULL; e = regulareExpression->NextSiblingElement("Expression"))
    {
        std::string replaceRegex="";
        std::string replaceWith="";
        if (NULL != e->FirstChildElement("ReplaceRegex")) {
            if(NULL != e->FirstChildElement("ReplaceRegex")->FirstChild()){
                replaceRegex = e->FirstChildElement("ReplaceRegex")->FirstChild()->ToText()->Value();
            }
        }
        
        if (NULL != e->FirstChildElement("ReplaceWith")) {
            if(NULL != e->FirstChildElement("ReplaceWith")->FirstChild()){
                replaceWith = e->FirstChildElement("ReplaceWith")->FirstChild()->ToText()->Value();
            }
        }
        
        if(!replaceRegex.empty()){
            regulareExpressionMap[replaceRegex] = replaceWith;
        }
    }
    
    
    return std::shared_ptr<TextComponent>( new TextComponent(name,
                                                             parse_rect(c),
                                                             parse_letter_size_for_width(c),
                                                             parse_letter_size_for_height(c),
                                                             text_lines,
                                                             fontCode,
                                                             whiteListConfigChars,
                                                             whiteListConfigCode,
                                                             preserveSpace,
                                                             format,
                                                             dateFormat,
                                                             regulareExpressionMap,
                                                             type)
                                          );
}

void parse_component(tinyxml2::XMLElement *c, Document *doc) {
    
    if (c == nullptr)
        return;

    bool has_type( c->FirstChildElement("Type") != nullptr );
    std::string type = has_type ? c->FirstChildElement("Type")->FirstChild()->ToText()->Value() : "";
    std::string name = c->FirstChildElement("Name")->FirstChild()->ToText()->Value();

    if ((name.compare("Photo") == 0 || name.compare("FaceImage") == 0) && type.compare("Image") == 0) {
        doc->face_fields.push_back(parse_photo_component(c));
    }
    else if (name.compare("Machine Readable") == 0 ) {
        auto field = parse_text_component(c);
        field->set_confidence_level(2);
        doc->mrz_fields.push_back(field);
    }else if (name.compare("MRZData") == 0 ) {
        auto field = parse_text_component(c);
        field->set_confidence_level(2);
        doc->mrz_fields.push_back(field);
    }
    else if (name.compare("BarCode") == 0 ) {
        doc->bar_code_fields.push_back(parse_bar_code_component(c));
    }
    else {
        auto field = parse_text_component(c);
        field->set_confidence_level(4);
        doc->text_fields.push_back(field);
    }
}

void parse_security(tinyxml2::XMLElement *c, Document *doc) {
    
    if (c == nullptr)
        return;

    std::string name( c->FirstChildElement("Name")->FirstChild()->ToText()->Value() );
    cv::Rect template_rectangle(parse_rect(c));
    //cv::Rect roi(parse_rect(c));
    cv::Rect roi(parse_rect(c));
    cv::Mat im( FileUtil::base64_decode_image(c->FirstChildElement("Image")->FirstChild()->ToText()->Value()) );
    
    doc->security_check_fields.push_back(std::shared_ptr<SecurityCheckComponent>(new SecurityCheckComponent(name, roi, im, template_rectangle)));
}

void parse_template(tinyxml2::XMLElement *c, Document *doc) {
   
    if (c == nullptr)
        return;
    
    std::string name( c->FirstChildElement("Name")->FirstChild()->ToText()->Value() );
    cv::Mat im( FileUtil::base64_decode_image(c->FirstChildElement("Image")->FirstChild()->ToText()->Value()) );
    
    doc->_template_image = im;
    doc->_template_size = im.size();
}

std::unique_ptr<Document> Document::load(const std::string &path_to_xml) {
    
    // parse the document and bail if there was error during the parsing process
    tinyxml2::XMLDocument xml;
    if ( xml.LoadFile(path_to_xml.c_str()) != tinyxml2::XMLError::XML_SUCCESS )
        return nullptr;
    
    std::unique_ptr<Document> doc = std::unique_ptr<Document>(new Document());
    
    auto root = xml.FirstChildElement("OCRLayoutDef");
    
    doc->_name = root->FirstChildElement("Name")->FirstChild()->ToText()->Value();
    doc->_template_size = parse_size(root->FirstChildElement("Size"));
    
    if(NULL != root->FirstChildElement("UpdatedOn")){
        if(NULL != root->FirstChildElement("UpdatedOn")->FirstChild()){
            doc->_last_updated_on = root->FirstChildElement("UpdatedOn")->FirstChild()->ToText()->Value();
        }
    }
    
    auto component = root->FirstChildElement("Component");
    while (component != nullptr) {
        
        parse_component(component, doc.get());
        component = component->NextSiblingElement("Component");
    }
    
    auto security = root->FirstChildElement("SecurityCheckTemplate");
    while (security != nullptr) {
        parse_security(security, doc.get());
        security = security->NextSiblingElement("SecurityCheckTemplate");
    }
    
    auto template_image = root->FirstChildElement("IdentificationTemplate");
    parse_template(template_image, doc.get());
    
    if (doc->_template_image.empty())
        doc->requires_accurate_matching = false;
    
    return doc;
}

std::string Document::to_xml() const {

    std::string xml = "";
    xml += "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
    xml += "<OCRLayoutDef xmlns=\"http://www.idmission.com/idp\">\n";
    xml += "<Name>" + this->name() + "</Name>";
    
    for (auto c : text_fields)
        xml += c->toXml();
    
    for (auto c : mrz_fields)
        xml += c->toXml();
    
    for (auto c : face_fields)
        xml += c->toXml();
    
    for (auto c : security_check_fields)
        xml += c->toXml();
    
    for (auto c : bar_code_fields)
        xml += c->toXml();
    
    xml+=get_name_component();
    
    xml += "<Component>\n";
    xml += "<Name>InputImage</Name>\n";
    xml += "<Value>Y</Value>\n";
    xml += "<Type>IMAGE</Type>\n";
    xml += "</Component>\n";
    
    
    // if (countNonZero(_template_image) >= 1) {
    xml += "<Component>\n";
    xml += "<Name>MatchedTemplate</Name>\n";
    xml += "<Value>Y</Value>\n";
    xml += "<Type>IMAGE</Type>\n";
    xml += "</Component>\n";
    
    xml += "<IdentificationTemplate>\n";
    xml += "<Name>MatchedTemplate</Name>\n";
    xml += "<Value>Y</Value>\n";
    xml += "<Type>IMAGE</Type>\n";
    xml += "</IdentificationTemplate>\n";
    //}
    
    xml += "</OCRLayoutDef>\n";
    return xml;
    
    
    return "";
}

std::string Document::get_name_component() const {
    std::string xml = "";
    std::map<std::string,std::string> name_map;
    name_map.insert(std::make_pair("Name",""));
    name_map.insert(std::make_pair("FirstName",""));
    name_map.insert(std::make_pair("MiddleName",""));
    name_map.insert(std::make_pair("LastName",""));
    
    for (auto c : text_fields){
        if (name_map.find(c->name()) != name_map.end() ){
            name_map[c->name()] = c->text();
        }
    }
    for (auto c : mrz_fields){
        if (name_map.find(c->name()) != name_map.end() ){
            name_map[c->name()] = c->text();
        }
    }
    
    xml += "<Component>\n";
    xml += "<Name>Name</Name>\n";
    xml += "<Value>"+name_map.find("Name")->second+" "+name_map.find("FirstName")->second+" "+name_map.find("MiddleName")->second+" "+name_map.find("LastName")->second+"</Value>\n";
    xml += "</Component>\n";
    return xml;
}

cv::Mat Document::get_face_image() const {
    
    cv::Mat faceImage;
    
    for (auto c : face_fields)
        faceImage = c->get_face_image();
    
    return faceImage;
}

cv::Mat Document::get_barcode_image() const {
    
    cv::Mat barcodeImage;
    
    for (auto c : bar_code_fields)
        barcodeImage = c->getBarCodeImage();
    
    return barcodeImage;
}

cv::Mat Document::get_mrz_image() const {
    
    //cv::Mat mrzImage;
    std::string mrzImageString;
    
    for (auto c : mrz_fields)
        mrzImageString = c->get_mrz_image();
    
    if(mrzImageString != ""){
        return  FileUtil::base64_decode_image(mrzImageString); // c->get_mrz_image();
    }
    return cv::Mat();
}


void Document::draw_security_feature(std::shared_ptr<Document> doc, cv::Mat image_result) const {
    for (auto c : doc->security_check_fields) {
        if (c->found_security_check == true) {
            cv::rectangle(image_result, c->template_rectangle(), cv::Scalar( 0, 255, 0 ), 5);
        }else{
            cv::rectangle(image_result, c->template_rectangle(), cv::Scalar( 0, 0, 255 ), 5);
        }
        
    }
}
