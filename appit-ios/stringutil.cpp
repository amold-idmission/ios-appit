//
//  stringutil.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/24/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "b64/encode.h"
#include "stringutil.h"
#include <sstream>

std::string base64_encode(const std::string &string) {

    std::stringstream istream(string),outstream;
    base64::encoder encoder(1024);
    
    encoder.encode(istream,outstream);
    return outstream.str();
}
