//
//  DocumentMatcher.h
//  appit-ios
//
//  Created by Goran Rauker on 2/25/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__DocumentMatcher__
#define __appit_ios__DocumentMatcher__

#include <opencv2/opencv.hpp>
#include <stdio.h>
#include "TemplateMatcher.h"

class DocumentMatcher : public TemplateMatcher {
public:
    bool match(const cv::Mat& template_image, float up_sf, const cv::Mat &im, float down_sf);

    cv::Mat warped;
    cv::Mat perspective_transform_matrix;
    
    double top_line_angle = 0;
    double right_line_angle = 0;
    double bottom_line_angle = 0;
    double left_line_angle = 0;
    
protected:
    bool are_angles_okay(const std::vector<cv::Point2f> &quad);
};

#endif /* defined(__appit_ios__DocumentMatcher__) */
