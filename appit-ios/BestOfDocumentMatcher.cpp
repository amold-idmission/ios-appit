//
//  BestOfDocumentMatcher.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/11/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "BestOfDocumentMatcher.h"

std::shared_ptr<Document> BestOfDocumentMatcher::findmatch(const cv::Mat &im, float sf) {

    std::shared_ptr<Document> match = nullptr;
    double homographySum = 0;
    
    for (auto doc : documents) {
        
        std::cout << "BestOfDocumentMatcher : DOC NAME IS " << doc->name() << std::endl;
        
        cv::Mat template_image = doc->template_image();
        if (template_image.empty())
            continue;
        
//        if (sf != 1.0 )
//            cv::resize(template_image, template_image, cv::Size(), 1/sf, 1/sf, cv::INTER_LINEAR);

        std::vector<cv::KeyPoint> k0,k1;
        cv::Mat d0,d1;
        
        train(template_image, k0, d0);
        
        if (sf != 1.0) {
            cv::Mat reduced;
            cv::resize(im, reduced, cv::Size(), 1 / sf, 1 / sf, cv::INTER_LINEAR);
            train(reduced,k1,d1);
        } else {
            train(im,k1,d1);
        }
        
        std::vector<cv::DMatch> matches;
        std::vector<cv::Point2f> p0, p1;

        find_matches(k0,d0,k1,d1,matches,p0,p1,0.75);
        
        if (matches.size() < 60 / sf) {
//            std::cout << "BestOfDocumentMatcher : " << doc->name() << " rejected for too few matches: " << matches.size() << std::endl;
            continue;
        }
                
        cv::Mat status;
        cv::Mat H = cv::findHomography(p0, p1, cv::RANSAC, 3.0, status);
        
        cv::Scalar sum = cv::sum(status);
        
//        std::cout << "BestOfDocumentMatcher : Found " << matches.size() << " matches with a homography sum of " << sum.val[0] << " for " << doc->name() << std::endl;
        
        if (sum.val[0] < 10 || sum.val[0] < homographySum) {
            std::cout << "homography sum too low " << sum.val[0] << " " << doc->name() << std::endl;
            continue;
        }
        else {
            match = doc;
            homographySum = sum.val[0];
            std::cout << "BestOfDocumentMatcher : Best match sum so far is " << homographySum << " for " << doc->name() << std::endl;
        }
    }
    
//    if ( match != nullptr )
//        std::cout << "BestOfDocumentMatcher " << match->name() << std::endl;
    
    return match;
}
