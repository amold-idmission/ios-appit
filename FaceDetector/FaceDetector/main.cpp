//
//  main.cpp
//  FaceDetector
//
//  Created by Goran Rauker on 3/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "FaceDetector.h"
#include <iostream>

int main(int argc, const char * argv[]) {
    // insert code here...
    
    FaceDetector detector;
    detector.init("/Users/goranrauker/Downloads/lbpcascade_frontalface.xml");
    cv::Mat im = cv::imread("/Users/goranrauker/Downloads/IMG_0610.JPG");
    if ( detector.detect(im) ) {
        for (auto face : detector.mFaces) {
            cv::rectangle(im, face, cv::Scalar(255,0,0), 2);
        }
    }
        
    cv::imshow("face detector", im);
    cv::waitKey();
    return 0;
}
