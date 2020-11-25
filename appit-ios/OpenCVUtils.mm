//
//  OpenCVUtils.mm
//  appit-ios
//
//  Created by idmission on 30/07/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenCVUtils.h"
#include "MRZDetector.h"
#include "LetterSize.h"
#include "ImageUtils.h"

@interface OpenCVUtils ()
@end

@implementation OpenCVUtils

+(void) executeMRZ{
    ImageUtils *imageUtils = [ImageUtils alloc];
    cv::Mat gray = [imageUtils read_image_data:@""];
    LetterSize letter_width = LetterSize(10, 50);
    LetterSize letter_height = LetterSize(10, 50);
    MRZDetector mrzDetector;
    mrzDetector.setNumMrzLines(2);
    mrzDetector.validateMrz(gray, 0, letter_width, letter_height);
}
@end
