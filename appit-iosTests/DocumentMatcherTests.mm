//
//  ImageProcessingTests.m
//  appit-ios
//
//  Created by Goran Rauker on 2/17/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#include "DocumentMatcher.h"
#include <opencv2/opencv.hpp>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>


@interface DocumentMatcherTests : XCTestCase
@end

@implementation DocumentMatcherTests {
    cv::Mat template_image;
    DocumentMatcher matcher;
}

- (void)setUp {
    [super setUp];
    
    NSString *imgPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"colorado_template" ofType:@"jpg" inDirectory:@"/TestData/DocumentMatcher"];
    template_image = cv::imread([imgPath cStringUsingEncoding:NSUTF8StringEncoding], 0);
//    cv::cvtColor(template_image, template_image, cv::COLOR_BGRA2BGR);
    XCTAssert(template_image.empty() == false);

}

- (void)tearDown {
    [super tearDown];
}

- (void)test_images {
    
    cv::Mat test_image = [self load_image_from_bundle:@"000_test_target"];

    XCTAssert( matcher.match(template_image, 1.0f, test_image, 1.0f) == true);
//    XCTAssert( matcher.match(template_image, test_image, 2.0f) == true);
}

- (cv::Mat)load_image_from_bundle:(NSString*)basefilename {
    
    NSString *imgPath = [[NSBundle bundleForClass:[self class]] pathForResource:basefilename ofType:@"png" inDirectory:@"/TestData/DocumentMatcher"];
    return cv::imread([imgPath cStringUsingEncoding:NSUTF8StringEncoding], 0);
}

@end
