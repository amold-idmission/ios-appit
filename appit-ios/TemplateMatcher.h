//
//  TemplateMatcher.h
//  appit-ios
//
//  Created by Goran Rauker on 2/25/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__TemplateMatcher__
#define __appit_ios__TemplateMatcher__

#include <stdio.h>
#include <opencv2/features2d.hpp>

class TemplateMatcher {
public:
    TemplateMatcher();
    virtual ~TemplateMatcher() {}

protected:
    void train(const cv::Mat &im, std::vector<cv::KeyPoint> &k, cv::Mat &d);
    void find_matches(const std::vector<cv::KeyPoint> &k0, const cv::Mat &d0, const std::vector<cv::KeyPoint> &k1, const cv::Mat &d1, std::vector<cv::DMatch> &matches, std::vector<cv::Point2f> &p0, std::vector<cv::Point2f> &p1, double percent_distance = 0.65);
    
protected:
    cv::FlannBasedMatcher matcher;
    cv::Ptr<cv::Feature2D> orb;
};

#endif /* defined(__appit_ios__TemplateMatcher__) */
