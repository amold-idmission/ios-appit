//
//  Document.h
//  MRZDetector
//
//  Created by Goran Rauker on 3/11/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef MRZDetector_Document_h
#define MRZDetector_Document_h

#include "BarCodeComponent.h"
#include "FaceComponent.h"
#include <memory>
#include <opencv2/opencv.hpp>
#include "SecurityCheckComponent.h"
#include "TextComponent.h"

class Document {
public:

    Document(const std::string &name,
             const cv::Mat &document_template_image,
             const std::vector<std::shared_ptr<BarCodeComponent>> &barcode,
             const std::vector<std::shared_ptr<TextComponent>> &text,
             const std::vector<std::shared_ptr<SecurityCheckComponent>> &security,
             const std::vector<std::shared_ptr<FaceComponent>> &face,
             const std::vector<std::shared_ptr<TextComponent>> &mrz) :
    _name(name),
    requires_accurate_matching(true),
    _template_image(document_template_image),
    _template_size(document_template_image.size()),
    bar_code_fields(barcode),
    text_fields(text),
    security_check_fields(security),
    face_fields(face),
    mrz_fields(mrz)
    {}

    Document(const std::string &name,
             const cv::Size &document_template_size,
             const std::vector<std::shared_ptr<BarCodeComponent>> &barcode,
             const std::vector<std::shared_ptr<TextComponent>> &text,
             const std::vector<std::shared_ptr<SecurityCheckComponent>> &security,
             const std::vector<std::shared_ptr<FaceComponent>> &face,
             const std::vector<std::shared_ptr<TextComponent>> &mrz) :
    _name(name),
    requires_accurate_matching(false),
    _template_image(),
    _template_size(document_template_size),
    bar_code_fields(barcode),
    text_fields(text),
    security_check_fields(security),
    face_fields(face),
    mrz_fields(mrz)
    {}
    
public:
    Document() {}

public:
    std::string name() const {
        return _name;
    }
    
    std::string last_updated_on() const {
        return _last_updated_on;
    }
    
    float aspect_ratio() const {
        return 1.0f * _template_size.width / _template_size.height;
    }
    
    cv::Mat template_image() const {
        return _template_image.clone();
    }

    cv::Size template_size() const {
        return _template_size;
    }
    
    std::string to_xml() const;
    std::string get_name_component() const;
    cv::Mat get_face_image() const;
    cv::Mat get_barcode_image() const;
    cv::Mat get_mrz_image() const;
    void draw_security_feature(std::shared_ptr<Document> doc, cv::Mat image_result) const;

    static std::unique_ptr<Document> load(const std::string &path_to_xml);
    
    std::string _name = "";
    std::string _last_updated_on = "";
    
    bool requires_accurate_matching = true;
    
    cv::Mat _template_image;
    cv::Size _template_size;
    
    std::vector<std::shared_ptr<BarCodeComponent>> bar_code_fields;
    std::vector<std::shared_ptr<TextComponent>> text_fields;
    std::vector<std::shared_ptr<SecurityCheckComponent>> security_check_fields;
    std::vector<std::shared_ptr<FaceComponent>> face_fields;
    std::vector<std::shared_ptr<TextComponent>> mrz_fields;
};

#endif
