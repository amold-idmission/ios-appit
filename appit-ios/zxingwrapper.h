//
//  zxingwrapper.h
//  appit-ios
//
//  Created by Goran Rauker on 3/24/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef appit_ios_zxingwrapper_h
#define appit_ios_zxingwrapper_h

#include <opencv2/opencv.hpp>

bool read_barcode (const cv::Mat &image, std::string &text, std::string &xsl);

bool read_mrzdata (std::string &text, std::string &originaltext);

void write_image (const cv::Mat &image);

void show_image (const cv::Mat &image);

cv::Mat read_image(std::string filepath);

cv::Mat read_image_with_name(std::string filename, std::string extension);

std::string process_mrz_string(std::string mrzstring);

#endif
