//
//  MRZDetector.h
//  appit-ios
//
//  Created by Goran Rauker on 3/9/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__MRZDetector__
#define __appit_ios__MRZDetector__

#include <opencv2/opencv.hpp>
#include "Letters.h"
#include "LetterSize.h"

class MRZDetector {
public:
    MRZDetector() {}
    
    cv::Mat detect(const cv::Mat &gray, const LetterSize &letter_width, const LetterSize &letter_height, float offset);
    std::vector<cv::Mat> extractMrzRegions(const cv::Mat &rgb, bool sharpen_output);
    
    void setNumMrzLines(int lines);
    void setNumMrzCharachtersPerLine(int num);
    
    std::vector<int> mLines;
    Letters mMrzLetters, mLine0Letters, mLine1Letters, mLine1aLetters;
    std::vector<std::vector<cv::Point2f>> mMrzVertices;
    bool validateMrz(const cv::Mat &gray, int yoffset, const LetterSize &letter_width, const LetterSize &letter_height);

    
    int mYOffset;
    int mMrzLines = 2;
    int mMrzCharactersPerLine = 44;

    /*For making mrz detection and extraction process lenient(easy) we have made some changes.
     (like sent cropped image to detect function as well as skip bumps check in MRZDetector.h)
     If we need previous implementation just set below flag false as well as change similar flag in DataExtractor.h to false.
     */
    bool croppedMrz = false;
    
    cv::Mat cleanupBackground(const cv::Mat &im, int mode);
protected:

//    bool validateMrz(const cv::Mat &gray, int yoffset, const LetterSize &letter_width, const LetterSize &letter_height);
    bool lineRatiosOkay();
    
    std::vector<int> filterLines(const std::vector<cv::Vec2f> &lines, double minAngle, double maxAngle, int yoffset);
};


#endif /* defined(__appit_ios__MRZDetector__) */
