//
//  Component.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__Component__
#define __appit_ios__Component__

#include <stdio.h>
#include <string>
#include <thread>
#include "Roi.h"

/* 
 The base of all Document Components that are analyzed in the captured image set.  
 
 All classes deriving from this class must be thread safe
 */
class Component {
public:
    Component( const std::string &name, const cv::Rect &roi) : _name(name), _roi(Roi(roi)) {}
    Component() {}
    virtual ~Component() {}
    
    std::string name() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return _name;
    }

    Roi roi(double sf=1.0) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return Roi(cv::Rect(_roi.x1*sf,_roi.y1*sf,(_roi.x2-_roi.x1)*sf,(_roi.y2-_roi.y1)*sf));
    }

    Roi roi(double sfx, double sfy) {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        return Roi(cv::Rect(_roi.x1*sfx,_roi.y1*sfy,(_roi.x2-_roi.x1)*sfx,(_roi.y2-_roi.y1)*sfy));
    }

    
    // Used to return values to a calling activity in the form of an XML response ...
    std::string toXml() {
        std::lock_guard<std::recursive_mutex> lock(_mutex);
        
        std::string xml = "";
        xml += "<Component>\n";
        xml += "<Name>" + _name + "</Name>\n";
        xml += "</Component>\n";	    
        return xml;
    }
    
protected:
    std::string _name = "";
    Roi _roi;
    mutable std::recursive_mutex _mutex;
};

#endif /* defined(__appit_ios__Component__) */
