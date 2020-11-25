//
//  FaceDetector.h
//  appit-ios
//
//  Created by Goran Rauker on 3/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__FaceDetector__
#define __appit_ios__FaceDetector__

#include <opencv2/opencv.hpp>

class FaceDetector {
public:
    ~FaceDetector();
    void init(const std::string &path_to_cascade_classifier);
    bool detect(const cv::Mat &gray);
    
    float mMinimumRelativeFaceSize = 0.2f;
    std::vector<cv::Rect> mFaces;
private:
    cv::CascadeClassifier *mDetector = nullptr;
};



#endif /* defined(__appit_ios__FaceDetector__) */
