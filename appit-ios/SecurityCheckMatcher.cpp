//
//  SecurityFeatureMatcher.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include <opencv2/calib3d.hpp>
#include "SecurityCheckMatcher.h"

bool SecurityCheckMatcher::match(const cv::Mat& template_image, const cv::Mat &im) {
    
    mMatchedFeatures = 0;
    
    std::vector<cv::KeyPoint> k0, k1;
    cv::Mat d0, d1;

    this->train(template_image, k0, d0);
    this->train(im,k1,d1);
    
    std::vector<cv::DMatch> matches;
    std::vector<cv::Point2f> p0, p1;
    this->find_matches(k0, d0, k1, d1, matches, p0, p1);

    if (matches.size() < 10) {
        return false;
    }

    cv::Mat status;
    cv::Mat H = cv::findHomography(p0, p1, cv::RANSAC, 3, status);
    
    mMatchedFeatures = (int)(cv::sum(status).val[0]);
    
    if (mMatchedFeatures < 5)
        return false;
    
    return true;
}
