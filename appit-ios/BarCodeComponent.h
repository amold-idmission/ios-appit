//
//  BarCodeComponent.h
//  appit-ios
//
//  Created by Goran Rauker on 3/24/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef appit_ios_BarCodeComponent_h
#define appit_ios_BarCodeComponent_h

#include <atomic>
#include "Component.h"
#include "stringutil.h"

class BarCodeComponent : public Component{
public:

    std::atomic<bool> found;
    
    BarCodeComponent( const std::string &name, const cv::Rect &roi, const std::string &base64xsl, const std::string & fontCode, const std::string & whiteListConfChars) : Component(name,roi) {
        this->_base64xsl = base64xsl;
        this->_fontCode = fontCode;
        this->_whiteListConfigChars = whiteListConfChars;
    }
    
    void setText(const std::string &text) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _text = text;
    }
    
    std::string text() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _text;
    }
    
    std::string font_code() {
        return _fontCode;
    }
    
    std::string white_List_Config_Chars() {
        return _whiteListConfigChars;
    }
    
    void setBarcodeImage(const cv::Mat &barcode_image) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _barcode_image = barcode_image;
    }
    
    cv::Mat getBarCodeImage() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _barcode_image;
    }
    
    std::string base64xsl() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _base64xsl;
    }
    
    std::string toXml() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        std::string xml = "";
        xml += "<Component>\n";
        xml += "<Name>" + this->name() + "</Name>\n";
        xml += "<Type>BarCode</Type>\n";
        xml += "<Value>" + (found ? std::string("true") : std::string("false") ) + "</Value>\n";
        //MA xml += "<Data>" + base64_encode(_text) + "</Data>\n";
        xml += "</Component>\n";
        xml += _text;
        return xml;
    }
protected:
    std::string _text = "";
    std::string _base64xsl = "";
    std::string _fontCode = "";
    std::string _whiteListConfigChars = "";
    cv::Mat _barcode_image;
};

#endif
