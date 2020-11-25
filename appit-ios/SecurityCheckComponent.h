//
//  SecurityCheckComponent.h
//  appit-ios
//
//  Created by Goran Rauker on 3/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__SecurityCheckComponent__
#define __appit_ios__SecurityCheckComponent__

#include <atomic>
#include "Component.h"

class SecurityCheckComponent : public Component {
public:
    
    SecurityCheckComponent( const std::string &name, const cv::Rect &roi, const cv::Mat &template_image, const cv::Rect &template_rectangle) : Component(name,roi), found_security_check(false) {
        this->_template_image = template_image;
        this->_template_rectangle = template_rectangle;
    }
    
    cv::Mat template_image() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _template_image.clone();
    }
    
    cv::Rect template_rectangle() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _template_rectangle;
    }
    
    std::string toXml() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        std::string xml = "";
        xml += "<Component>\n";
        xml += "<Name>" + _name + "</Name>\n";
        xml += "<Value>" + (found_security_check ? std::string("true") : std::string("false") ) + "</Value>\n";
        xml += "</Component>\n";
        return xml;
    }
    
    std::atomic<bool> found_security_check;
    
protected:
    cv::Mat _template_image;
    cv::Rect _template_rectangle;
};

#endif /* defined(__appit_ios__SecurityCheckComponent__) */
