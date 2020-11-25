//
//  TextExtractor.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__TextExtractor__
#define __appit_ios__TextExtractor__

#include <opencv2/opencv.hpp>
#include <stdio.h>
#include "TextComponent.h"

class ExtractedText {
public:
    ExtractedText() : name(), text(), reconstructed(), cropped() {}
    ExtractedText(const std::string &name, const std::string &text, const cv::Mat &reconstructed, const cv::Mat &cropped ) {
        this->name = name;
        this->text = text;
        this->reconstructed = reconstructed;
        this->cropped = cropped;
    }

    std::string name, text;
    cv::Mat reconstructed, cropped;
};


class TextExtractor {
public:
//    ExtractedText extract(const cv::Mat &im, TextComponent &text, bool reconstruct);
    std::vector<std::pair<cv::Mat,cv::Mat>> extract_text(const cv::Mat &im, TextComponent &text);
    std::pair<cv::Mat,cv::Mat> findText(const cv::Mat &colorSnippet, const cv::Mat &gray, TextComponent &text, int threshold);
    
    cv::Mat cleanTopBottom(const cv::Mat &orig);
};

#endif /* defined(__appit_ios__TextExtractor__) */
