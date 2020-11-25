//
//  FaceComponent.h
//  appit-ios
//
//  Created by Goran Rauker on 3/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__FaceComponent__
#define __appit_ios__FaceComponent__

#include <atomic>
#include "Component.h"

class FaceComponent : public Component{
public:
    
    std::atomic<bool> found_face;

    FaceComponent( const std::string &name, const cv::Rect &roi) : Component(name,roi), found_face(false) {
        _type = "Photo";
    }
    
    void set_base64_encoded_face_image(const std::string &b64) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _base64EncodedFaceImage = b64;
    }
    
    void set_face_image(const cv::Mat im) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        _face_image = im;
    }

    
    std::string toXml() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        std::string xml = "";
        xml += "<Component>\n";
        xml += "<Name>" + _name + "</Name>\n";
        xml += "<Value>" + (found_face ? std::string("true") : std::string("false") ) + "</Value>\n";
        xml += "<Type>IMAGE</Type>\n";
        //MA xml += "<Image>" + _base64EncodedFaceImage +"</Image>\n";
        xml += "</Component>\n";
        xml += "<Component>\n";
        xml += "<Name>IsFaceDetected</Name>\n";
        xml += "<Value>" + (found_face ? std::string("true") : std::string("false") ) + "</Value>\n";
        xml += "</Component>\n";
        return xml;
    }
    
    cv::Mat get_face_image() {
        if (NULL != _face_image.data) {
            cv::resize(_face_image, _face_image, cv::Size(), 2, 2, cv::INTER_CUBIC);
        }
        return _face_image;
    }

    
protected:
    std::string _base64EncodedFaceImage = "";
    std::string _type = "";
    cv::Mat _face_image;
};

#endif /* defined(__appit_ios__FaceComponent__) */
