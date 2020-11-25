//
//  TemplateMatcher.cpp
//  appit-ios
//
//  Created by Goran Rauker on 2/25/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "TemplateMatcher.h"

TemplateMatcher::TemplateMatcher() : matcher() {
    orb = cv::ORB::create(30000, 1.2f, 8, 10);
}

void TemplateMatcher::train(const cv::Mat &im, std::vector<cv::KeyPoint> &k, cv::Mat &d) {
    
    orb->detect(im, k);
    orb->compute(im, k, d);
    d.convertTo(d, CV_32F);
}

void TemplateMatcher::find_matches(const std::vector<cv::KeyPoint> &k0, const cv::Mat &d0, const std::vector<cv::KeyPoint> &k1, const cv::Mat &d1, std::vector<cv::DMatch> &matches, std::vector<cv::Point2f> &p0, std::vector<cv::Point2f> &p1, double percent_distance) {
    
    std::vector<std::vector<cv::DMatch>> potential;
    try {
        this->matcher.knnMatch(d1, d0, potential, 2);
    } catch (const std::exception & e) {
        printf("TemplateMatcher.find_matches  Exception %s", e.what());
    }
    
    for (std::vector<cv::DMatch> m : potential) {
        if (m[0].distance < m[1].distance * percent_distance) {
            
            matches.push_back(m[0]);
            
            p0.push_back(k0[m[0].trainIdx].pt);
            p1.push_back(k1[m[0].queryIdx].pt);
        }
    }
}

