//
//  ImageProcessingTests.m
//  appit-ios
//
//  Created by Goran Rauker on 2/17/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <ZXingObjC.h>

@interface ZXingTests : XCTestCase

@end

@implementation ZXingTests {

}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)test_colorado_back {

    NSString *imgPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"IMG_1256" ofType:@"jpg" inDirectory:@"/TestData/ZXingTests"];
    
    UIImage *img = [UIImage imageNamed: imgPath];

    CGImageRef imageToDecode =  [img CGImage];  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];

    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];

    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
    }
}

@end
