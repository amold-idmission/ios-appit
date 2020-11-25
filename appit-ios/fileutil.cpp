//
//  fileutil.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/18/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "b64/decode.h"
#include "b64/encode.h"
#include "fileutil.h"
#include <sstream>

cv::Mat FileUtil::base64_decode_image(const std::string &encoded_image) {
    
    std::stringstream instream(encoded_image), outstream;
    base64::decoder decoder(1024);
    
    decoder.decode(instream,outstream);
    
    std::string const& s = outstream.str();
    
    std::vector<char> chars(s.size());
    chars.assign(s.begin(), s.end());
    
    return cv::imdecode( chars, 1 );
}

std::string FileUtil::base64_encode_image(const cv::Mat &im) {
    
    std::vector<uchar> buf;
    cv::imencode(".jpg", im, buf);
    
    std::string image(buf.begin(),buf.end());
    
    std::stringstream istream(image),outstream;
    base64::encoder encoder(1024);
    
    encoder.encode(istream,outstream);
    
    return outstream.str();
}