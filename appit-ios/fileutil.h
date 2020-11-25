//
//  fileutil.h
//  appit-ios
//
//  Created by Goran Rauker on 3/18/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef appit_ios_fileutil_h
#define appit_ios_fileutil_h

#include <string>
#include <opencv2/opencv.hpp>

class FileUtil {
public:
    
    static cv::Mat base64_decode_image(const std::string &encoded_image);
    static std::string base64_encode_image(const cv::Mat &im);
};

#endif
