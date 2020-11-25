//
//  ImageProcessingTests.m
//  appit-ios
//
//  Created by Goran Rauker on 2/17/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include <opencv2/opencv.hpp>
#include <tesseract/baseapi.h>
#import <XCTest/XCTest.h>

@interface TesseractTests : XCTestCase

@end

@implementation TesseractTests {

    tesseract::TessBaseAPI tesseract;
}

- (void)setUp {
    [super setUp];
    
    // Set up the tessdata path. This is included in the application bundle
    // but is copied to the Documents directory on the first run.
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath]) {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
        }
    }
    
    // ensure that the tesseract engine can be initialized ...
    XCTAssertEqual(tesseract.Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng"), 0);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)test_images {
//    [self _testImageWithBaseFileName:@"GORAN MATKO RAUKER"];
    [self _testImageWithBaseFileName:@"4608 portofino dr"];
    [self _testImageWithBaseFileName:@"longmont co 80503"];
    [self _testImageWithBaseFileName:@"03152016"];
    [self _testImageWithBaseFileName:@"01 059 862"];
    //    [self _testImageWithBaseFileName:@""];
}

- (void)_testImageWithBaseFileName:(NSString*)basefilename {

    NSString *imgPath = [[NSBundle bundleForClass:[self class]] pathForResource:basefilename ofType:@"png" inDirectory:@"/TestData/Tesseract"];
    cv::Mat im = cv::imread([imgPath cStringUsingEncoding:NSUTF8StringEncoding]);
    cv::Mat gray;
    
    cv::cvtColor(im, gray, cv::COLOR_BGR2GRAY);
    tesseract.SetImage(gray.data, gray.cols, gray.rows, gray.channels(), (int)gray.step1());
    tesseract.Recognize(nil);
    
    auto txt = tesseract.GetUTF8Text();
    XCTAssert(txt != nullptr);
    
    NSString *decoded = [NSString stringWithUTF8String:txt];
    decoded = [decoded stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSLog(@"%@", decoded);
    XCTAssert([decoded caseInsensitiveCompare:basefilename] == NSOrderedSame);
}

@end
