//
//  Letter.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__Letter__
#define __appit_ios__Letter__

#include <opencv2/opencv.hpp>

class Letter {
public:
    Letter(const cv::Rect &r) {
        this->rect = r;
        this->center = cv::Point( (2*r.x + r.width)/2.0, (2*r.y+r.height)/2.0);
    }
    Letter(const cv::Rect &br, const cv::Mat &im) : Letter(br) {
        image = im;
    }

    bool operator==(const Letter &other) const {
        return this->rect == other.rect;
    }
    
    bool operator<(const Letter &other) const {
        return this->center.x < other.center.x;
    }
    
    cv::Rect rect;
    cv::Point center;
    cv::Mat image;
};
#endif /* defined(__appit_ios__Letter__) */
