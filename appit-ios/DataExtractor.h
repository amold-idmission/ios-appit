//
//  DataExtractor.h
//  appit-ios
//
//  Created by Goran Rauker on 3/6/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__DataExtractor__
#define __appit_ios__DataExtractor__

#include "Document.h"
#include "DocumentMatcher.h"
#include "FaceComponent.h"
#include "FaceDetector.h"
#include "MRZDetector.h"
#include <opencv2/opencv.hpp>
#include <tesseract/baseapi.h>
#include "TextExtractor.h"
#include "SecurityCheckComponent.h"
#include "SecurityCheckMatcher.h"
#include <string>

class DataExtractor {
public:
    
    DataExtractor(const Document &d,
                  tesseract::TessBaseAPI &ocr,
                  const std::string &face_detector_classifier_path,
                  std::atomic<size_t> &processed_counter,
                  const std::string &tess_data_path,
                  const std::size_t image_to_consume);
    
    bool is_complete();
    void extract(cv::Mat &image, const cv::Rect &roi);
    std::string summary(bool br_instead_of_new_line=false);
    
protected:
    std::string ocr_extracted_text(const cv::Mat &im);
    
    void process_bar_code_tasks(const cv::Mat &warped, double up_sf);
    void process_text_tasks(const cv::Mat &warped, double up_sf);
    void process_security_check_tasks(const cv::Mat &warped, double up_sf);
    void process_face_detect_tasks(const cv::Mat &warped, double up_sf);
    void process_mrz_tasks(const cv::Mat &warped, double up_sf, const cv::Mat &resizewarped);
    std::string process_cropped_mrz(const cv::Mat &warped, const std::shared_ptr<TextComponent> &text_component);
    bool fileExists(const std::string& filename);
    bool isFontFileExist(const std::string& fontCode);
public:

    Document document;
    DocumentMatcher document_matcher;
    tesseract::TessBaseAPI &ocr;
    FaceDetector face_detector;
    TextExtractor text_extractor;
    SecurityCheckMatcher security_check;
    cv::Mat warped;
    
    std::atomic<size_t> &num_images_processed;
    std::size_t images_to_consume;
    std::string datapath;
    
    /*For making mrz detection and extraction process lenient(easy) we have made some changes.
     (like sent cropped image to detect function as well as skip bumps check in MRZDetector.h)
    If we need previous implementation just set below flag false as well as change similar flag in MRZDetector.h to false.
     */
    bool croppedMrz = false;
};
#endif /* defined(__appit_ios__DataExtractor__) */
