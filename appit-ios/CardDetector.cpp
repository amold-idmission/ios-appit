//
//  test.cpp
//  appit-ios
//
//  Created by Goran Rauker on 2/17/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include <cassert>
#include "CardDetector.h"

void CardDetector::detect(const cv::Mat &bgr, double scale_factor, float min_image_intensity, float min_image_focus_score, bool enableGlareDetection, int glareThresholdPercentage,  const cv::Rect &roi){

    this->potential_rois.clear();
    
    cv::Mat hsv;
    cv::resize(bgr, hsv, cv::Size(), 1/scale_factor, 1/scale_factor, cv::INTER_LINEAR);
    cv::cvtColor(hsv, hsv, cv::COLOR_BGR2HSV_FULL);
    
    std::vector<cv::Mat> channels;
    cv::split(hsv, channels);
    
    this->intensity = cv::mean(channels[2])[0]; // detect intensity
    this->focus = CvUtils::focus_score_for_image(channels[2]); // check to see if image is in focus

    if(enableGlareDetection){
        //We have scalled actual image with given 'scale_factor' so we need to scale roi as well
        cv::Rect resizeRoi = cvRect(roi.x/scale_factor, roi.y/scale_factor, roi.width/scale_factor, roi.height/4);
        this->glare = CvUtils::checkGlarePercentage(channels[2], resizeRoi);
        if(this->glare > glareThresholdPercentage){
            return;
        }
    }
    
    if (this->intensity < min_image_intensity || this->focus < min_image_focus_score)
        return;
    
    double sfx = 1.0 * bgr.cols / hsv.cols;
    double sfy = 1.0 * bgr.rows / hsv.rows;

    for (auto channel : channels) {
        this->potential_rois.push_back(CvUtils::find_rect_1d(channel, 0, 0, sfx, sfy));
    }
}

cv::Rect CardDetector::get_document_rectangle(const cv::Rect& searchRoi, bool isLandscapeMode) {
    for (auto rect : this->potential_rois) {
        if (is_rect_a_document_rectangle(searchRoi, rect, isLandscapeMode))
            return rect;
    }
    return cv::Rect();
}

bool CardDetector::is_rect_a_document_rectangle(const cv::Rect& searchRoi, const cv::Rect &r, bool isLandscapeMode) {

    double percent = 0.12;
    if(!isLandscapeMode){//Portrait mode
        percent = 0.12;
    }
    
    if (r.area() <= 0)
        return false;
    else if (r.x < searchRoi.x || r.x > searchRoi.x + searchRoi.width * percent) // left
        return false;
    else if (r.br().x > searchRoi.br().x || r.br().x < searchRoi.br().x - searchRoi.width * percent) // right
        return false;
    else if (r.br().y > searchRoi.br().y || r.br().y < searchRoi.br().y - searchRoi.height * percent) // bottom
        return false;
    else if (r.y < searchRoi.y || r.y > searchRoi.y + searchRoi.height * percent) { // top
            return false;
    }
    
    return true;
}

cv::Rect CvUtils::find_rect_1d(const cv::Mat &im, int x_offset, int y_offset, double sfx, double sfy) {
    
    int height = im.rows;;
    int width = im.cols;
    
    const int cols_len = width - 1;
    double* cols = new double[cols_len];

    const int rows_len = height - 1;
    double* rows = new double[rows_len];
    
    for (int c = 0; c < width - 1; c++) {
        cols[c] = std::abs(cv::mean(cv::Mat(im, cv::Rect(c, 0, 1, height))).val[0] - cv::mean(cv::Mat(im, cv::Rect(c + 1, 0, 1, height))).val[0]);
    }

    for (int r = 0; r < height - 1; r++) {
        rows[r] = std::abs(cv::mean(cv::Mat(im, cv::Rect(0, r, width, 1))).val[0] - cv::mean(cv::Mat(im, cv::Rect(0, r + 1, width, 1))).val[0]);
    }
    
    int left = -1, right = -1, top = -1, bottom = -1;
    
    for (int c = 0; c < cols_len; c++)
        if (cols[c] > 5) {
            left = c;
            break;
        }
    for (int c = cols_len - 1; c >= 0; c--)
        if (cols[c] > 5) {
            right = c;
            break;
        }
    
    for (int r = 0; r < rows_len; r++)
        if (rows[r] > 5) {
            top = r;
            break;
        }
    
    for (int r = rows_len - 1; r >= 0; r--)
        if (rows[r] > 5) {
            bottom = r;
            break;
        }
    
    delete [] cols;
    delete [] rows;

    if (left == -1 || right == -1 || top == -1 || bottom == -1)
        return cv::Rect();
    
    
    return cv::Rect(cv::Point(x_offset + left * sfx, y_offset + top * sfy),
                    cv::Point(x_offset + right * sfx, y_offset + bottom * sfy));
}

float CvUtils::focus_score_for_image(const cv::Mat &image) {
    
    assert(image.channels() == 1);
    assert(image.depth() == CV_8U);
    
    cv::Mat sobel_image;
    cv::Sobel(image, sobel_image, CV_16S, 1, 1);
    
    cv::Mat r = cv::abs(sobel_image);
    cv::Scalar meanScalar,devScalar;
    
    cv::meanStdDev(r, meanScalar, devScalar);
    return devScalar[0];
}

double CvUtils::checkGlarePercentage(const cv::Mat &valueChannel, const cv::Rect &roi){
    
//    if(!CvUtils::isRectInside(valueChannel, roi)){
//        //If unabele to crop mat then return from here
//        return 99;
//    }
    
    cv::Mat glare;
    
    cv::Mat croppedMat = cv::Mat(valueChannel, roi);
    
    cv::threshold(croppedMat, glare, 245, 255, cv::THRESH_BINARY);
    
    std::vector<cv::Mat> contours;
    cv::Mat hierarchy;
    cv::findContours(glare, contours, hierarchy, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    
    double maxGlareArea = 0;
    
    for (int i = 0; i < contours.size(); i++) {
        double area = cv::contourArea(contours[i]);
        if(area>5){
            maxGlareArea += area;
        }
    }
    
    double imageTotalArea = roi.area();
    
    double glarePercent = maxGlareArea*100/imageTotalArea;
    
    return glarePercent;
}

bool CvUtils::isRectInside(cv::Mat mMat, cv::Rect mRect){
    cv::Rect rect_mat(0, 0, mMat.cols, mMat.rows);
    return (mRect & rect_mat) == mRect;
}
