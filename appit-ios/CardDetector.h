//
//  test.h
//  appit-ios
//
//  Created by Goran Rauker on 2/17/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __goodimagedetector_h__
#define __goodimagedetector_h__

#include <stdio.h>
#include <opencv2/opencv.hpp>

class CardDetector {
public:
    CardDetector() {}
    CardDetector(const cv::Mat &bgr, double scale_factor, float min_image_intensity, float min_image_focus_score, bool enableGlareDetection, int glareThresholdPercentage, const cv::Rect &roi) {
        detect(bgr, scale_factor, min_image_intensity, min_image_focus_score, enableGlareDetection, glareThresholdPercentage, roi);
    }
    void detect(const cv::Mat &bgr, double scale_factor, float min_image_intensity, float min_image_focus_score, bool enableGlareDetection, int glareThresholdPercentage, const cv::Rect &roi);
    cv::Rect get_document_rectangle(const cv::Rect& searchRoi, bool isLandscapeMode);
    bool is_rect_a_document_rectangle(const cv::Rect& searchRoi, const cv::Rect &r, bool isLandscapeMode);

    float intensity = 0;
    float focus = 0;
    float glare = 0;
    std::vector<cv::Rect> potential_rois;
};

class CvUtils {
public:
    static cv::Rect find_rect_1d(const cv::Mat &im, int x_offset, int y_offset, double sfx, double sfy);
    static float focus_score_for_image(const cv::Mat &image);
    static double checkGlarePercentage(const cv::Mat &valueChannel, const cv::Rect &roi);
    static bool isRectInside(cv::Mat mMat, cv::Rect mRect);
};


#endif // __goodimagedetector_h__
