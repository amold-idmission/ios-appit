//
//  DocumentMatcher.cpp
//  appit-ios
//
//  Created by Goran Rauker on 2/25/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "DocumentMatcher.h"


bool DocumentMatcher::match(const cv::Mat& template_image, float up_sf, const cv::Mat &im, float down_sf) {

    this->warped = cv::Mat();
    this->top_line_angle = 0.0;
    this->right_line_angle = 0.0;
    this->bottom_line_angle = 0.0;
    this->left_line_angle = 0.0;
    this->perspective_transform_matrix = cv::Mat();
    
    if (im.empty() || template_image.empty())
        return false;
    
    std::vector<cv::KeyPoint> k0, k1;
    cv::Mat d0, d1;
    
    cv::Mat reduced, reduced_template;
    if ( down_sf != 1.0) {
        cv::resize(im, reduced, cv::Size(), 1.0/down_sf, 1.0/down_sf, cv::INTER_LINEAR);
        this->train(reduced,k1,d1);
//        cv::resize(template_image, reduced_template, cv::Size(), 1.0/sf, 1.0/sf, cv::INTER_LINEAR);
//        this->train(reduced_template,k0,d0);
    } else {
        this->train(im,k1,d1);
    }

    this->train(template_image,k0,d0);

    std::vector<cv::DMatch> matches;
    std::vector<cv::Point2f> p0, p1;

    this->find_matches(k0, d0, k1, d1, matches, p0, p1, 0.75);
    
    if (matches.size() < 40)
        return false;
    
    // run through all of the ransac projection errors and pick the one that results in the best transform
    cv::Mat H;
    double best_sum = 0;
    
    for (int i=1; i < 11; i++) {
        cv::Mat status;
        cv::Mat h = cv::findHomography(p0, p1, cv::RANSAC, i, status);
        cv::Scalar status_sum = sum(status);
        
        if (status_sum[0] > best_sum) {
            H = h;
            best_sum = status_sum[0];
        }
    }
  
    if (H.empty() || best_sum < 30)
        return false;
    
    H.at<double>(0,0) *= down_sf; // scale the matrix back to the original image size
    H.at<double>(1,1) *= down_sf;
    H.at<double>(0,2) *= down_sf; // translate the matrix back to the original image size
    H.at<double>(1,2) *= down_sf;
    
    std::vector<cv::Point2f> sceneQuad;
    std::vector<cv::Point2f> srcQuad = { cv::Point2f(0,0), cv::Point2f(template_image.cols,0), cv::Point2f(template_image.cols,template_image.rows), cv::Point2f(0,template_image.rows) };
    cv::perspectiveTransform(srcQuad, sceneQuad, H);
    
    // the sceneQuad should be well aligned and not wonky since it is taken in a well aligned position ....
    if (are_angles_okay(sceneQuad) == false)
        return false;

    srcQuad = { cv::Point2f(0,0), cv::Point2f(template_image.cols*up_sf,0), cv::Point2f(template_image.cols*up_sf,template_image.rows*up_sf), cv::Point2f(0,template_image.rows*up_sf) };

    // warp the quad of the id card into the template space ...
    perspective_transform_matrix = cv::getPerspectiveTransform(sceneQuad, srcQuad);
    cv::warpPerspective(im, warped, perspective_transform_matrix, cv::Size(template_image.size().width*up_sf,template_image.size().height*up_sf));

    return true;
}

bool DocumentMatcher::are_angles_okay(const std::vector<cv::Point2f> &quad) {
    
    double topLineSlope = (quad[1].y - quad[0].y) / (quad[1].x - quad[0].x );
    double rightLineSlope = (quad[2].y - quad[1].y) / (quad[2].x - quad[1].x );
    double bottomLineSlope = (quad[3].y - quad[2].y) / (quad[3].x - quad[2].x );
    double leftLineSlope = (quad[3].y - quad[0].y) / (quad[3].x - quad[0].x );
    
    top_line_angle = std::abs(atan(topLineSlope) * 180.0 / M_PI);
    right_line_angle = std::abs(atan(rightLineSlope) * 180.0 / M_PI);
    bottom_line_angle = std::abs(atan(bottomLineSlope) * 180.0 / M_PI);
    left_line_angle = std::abs(atan(leftLineSlope) * 180.0 / M_PI);

//    return true;

    
    if (top_line_angle > 3 )
        return false;
    else if (bottom_line_angle > 3)
        return false;
    else if (std::abs(90-right_line_angle) > 10 )
        return false;
    else if (std::abs(90-left_line_angle) > 10 )
        return false;
    else
        return true;
}


