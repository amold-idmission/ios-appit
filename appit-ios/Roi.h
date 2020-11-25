//
//  Roi.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__Roi__
#define __appit_ios__Roi__

#include <opencv2/opencv.hpp>
#include <stdio.h>

class Roi {
public:
    double x1=0, x2=0, y1=0, y2=0;
    
    Roi() {}
    
    Roi(const cv::Rect &roi) {
        this->x1 = roi.x;
        this->y1 = roi.y;
        
        this->x2 = roi.br().x;
        this->y2 = roi.br().y;
    }
    
    cv::Point tl() const {
        return cv::Point(x1,y1);
    }
    
    cv::Point br() const {
        return cv::Point(x2,y2);
    }
    
    cv::Rect toRect() const {
        return cv::Rect(cv::Point(x1, y1), cv::Point(x2, y2));
    }
    
    bool isValid() const {
        return toRect().area() > 0;
    }
};


#endif /* defined(__appit_ios__Roi__) */
