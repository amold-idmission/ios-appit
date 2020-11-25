//
//  main.cpp
//  MRZDetector
//
//  Created by Goran Rauker on 3/9/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include <opencv2/opencv.hpp>
#include "MRZDetector.h"
#include <iostream>
#include <regex>
#include "stringutil.h"
#include "TextComponent.h"
#include "TextExtractor.h"
#include <tesseract/baseapi.h>

std::string ocr_extracted_text(tesseract::TessBaseAPI &ocr, const cv::Mat &im) {
    
    if (im.empty())
        return "";
    
    ocr.SetImage(im.data, im.cols, im.rows, im.channels(), (int)im.step1());
    ocr.Recognize(0);
    std::string text(ocr.GetUTF8Text());
    return text;
}

int main(int argc, const char * argv[]) {

    tesseract::TessBaseAPI ocr;
    ocr.Init("/Users/goranrauker/Development/appit-ios/appit-ios/Resources/", "eng");

    cv::Mat im = cv::imread("/users/goranrauker/Downloads/IMG_0948.JPG",1);
    cv::Mat gray;
    
    cv::cvtColor(im, gray, cv::COLOR_BGRA2GRAY);
    
    double sfx = im.cols / 800.0;
    double sfy = im.rows / 545.0;
    
    TextComponent text("MRZ", cv::Rect(10,410,780,110), LetterSize(4*sfx,16*sfx), LetterSize(10*sfy,22*sfy), 4);

    MRZDetector mrz;
    TextExtractor text_extractor;
    cv::Mat detected = mrz.detect(gray, text.letterWidth(), text.letterHeight(), 0.7f);
    
    if ( !detected.empty()) {
        cv::cvtColor(detected,detected,cv::COLOR_GRAY2BGR);
        
        for (auto snippet : mrz.extractMrzRegions(detected,true) ) {
            cv::imshow("snip",snippet);
            cv::waitKey();
            auto clips = text_extractor.extract_text(snippet, text);
            for (auto clip : clips) {
                
                std::cout << clean_mrz(ocr_extracted_text(ocr, clip.first) ) << std::endl;
                cv::imshow("detected", clip.first);
                cv::waitKey();
            }
        }
    }
    
    return 0;
    
    // TODO put text lines independantly back into the TextComponent
    int line_number(0);
    for (auto snippet : mrz.extractMrzRegions(im,true) ) {

        cv::imshow("im", snippet);
        cv::waitKey();

        
        auto clips = text_extractor.extract_text(snippet, text);
        
        for (auto clip : clips) {

            if (text.hasTextConfidence())
                break;
            
            cv::Mat reduced;
            cv::resize(clip.second, reduced, cv::Size(), 1.5,1.5 );
            
            std::string reconstructed( clean_mrz(ocr_extracted_text(ocr, clip.first) ) );
            std::string cropped( clean_mrz(ocr_extracted_text(ocr, clip.second) ) );
            std::string resized( clean_mrz(ocr_extracted_text(ocr, reduced) ) );
            
            text.putText(reconstructed, line_number);
            std::cout << reconstructed << std::endl;
            
            text.putText(cropped, line_number);
            std::cout << cropped << std::endl;

            std::cout << resized << std::endl;
            text.putText(resized, line_number);
            
            cv::imshow("extracted", clip.first);
            cv::imshow("cropped", clip.second);

        }
        line_number++;
    }

    
    std::cout << "Result:" << std::endl << text.text() << std::endl;
    
    cv::waitKey();
    return 0;
}
