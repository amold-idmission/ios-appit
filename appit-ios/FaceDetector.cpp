//
//  FaceDetector.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include <cassert>
#include "FaceDetector.h"

FaceDetector::~FaceDetector() {
    delete mDetector;
}

void FaceDetector::init(const std::string &path_to_cascade_classifier) {
    
    delete mDetector;
    mDetector = new cv::CascadeClassifier(path_to_cascade_classifier);
}

bool FaceDetector::detect(const cv::Mat &gray) {
    
    assert(mDetector != nullptr);
    
    int faceSize = 0;
    int height = gray.rows;
    
    if (std::round(height * mMinimumRelativeFaceSize) > 0) {
        faceSize = std::round(height * mMinimumRelativeFaceSize);
    }
    
    mFaces.clear();
    mDetector->detectMultiScale(gray, mFaces, 1.1, 3, 2, cv::Size(faceSize, faceSize), cv::Size(height, height));
    
    // check to see if this face has been seen before ...
    return !mFaces.empty();
}