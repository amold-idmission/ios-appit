//
//  ImageProcessingTests.m
//  appit-ios
//
//  Created by Goran Rauker on 2/17/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "CardDetector.h"

@interface ImageProcessingTests : XCTestCase

@end

@implementation ImageProcessingTests {
    CardDetector *detector;
}

- (void)setUp {
    [super setUp];
    
    detector = new CardDetector();
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    delete detector;
}


- (void)testExample {
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"pattern" ofType:@"bmp"];
//    const char * cpath = [path cStringUsingEncoding:NSUTF8StringEncoding];
//    cv::Mat im = cv::imread( cpath, CV_LOAD_IMAGE_GRAYSCALE );
    cv::Mat im;
//    XCTAssert(detector->isGoodImage(im), @"Not a good image");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
