//
//  zxingwrapper.m
//  appit-ios
//
//  Created by Goran Rauker on 3/24/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "ImageUtils.h"
#import <ZXingObjC.h>
#include "zxingwrapper.h"
#import "BarCodeParser.h"

// C "trampoline" function to invoke Objective-C method
bool read_barcode (const cv::Mat &image, std::string &text, std::string &xsl)
{
    UIImage *img = [ImageUtils UIImageFromCVMat:image convert_color:true];
   // NSLog(@"%@%d", @"image found ", image.type());
    if (img != nil) {
    
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
            
            //convert plain text to xml
            BarCodeParser *parser = [BarCodeParser alloc];
            NSString *xslContents = [NSString stringWithUTF8String:xsl.c_str()];
            contents = [parser parse_text:contents xsl:xslContents];
            
            text = [contents UTF8String];
            
            return true;
            // The barcode format, such as a QR code or UPC-A
    //        ZXBarcodeFormat format = result.barcodeFormat;
        } else {
            // Use error to determine why we didn't get a result, such as a barcode
            // not being found, an invalid checksum, or a format inconsistency.
        }
    }
    return false;
}

bool read_mrzdata (std::string &text, std::string &originaltext){
    
    NSString *contents = [NSString stringWithUTF8String:text.c_str()];
    
    //convert plain text to xml
    BarCodeParser *parser = [BarCodeParser alloc];
    contents = [parser parse_mrz_text:contents];
    
    NSString *originalContents = [NSString stringWithUTF8String:text.c_str()];
    originalContents = [parser esacpeXML:originalContents];
    
    text = [contents UTF8String];
    originaltext = [originalContents UTF8String];
    
    return true;
}

void write_image (const cv::Mat &image){
    UIImage *img = [ImageUtils UIImageFromCVMat:image convert_color:false];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
}

void show_image (const cv::Mat &image){
    UIImage *img = [ImageUtils UIImageFromCVMat:image convert_color:false];
    NSLog(@"");
}

cv::Mat read_image(std::string filepath){
    NSString *originalFilePath = [NSString stringWithUTF8String:filepath.c_str()];
    originalFilePath = [[NSBundle mainBundle] pathForResource:@"mrz" ofType:@"jpg" inDirectory:@"/images"];
    UIImage *image = [UIImage imageWithContentsOfFile:originalFilePath];
    cv::Mat im = [ImageUtils CVMatFromUIImage:image isGrayRequired:true];
    return im;
}

cv::Mat read_image_with_name(std::string filename, std::string extension){
//    NSString *imagepath = [[NSBundle mainBundle] pathForResource:@"mrz" ofType:@"jpg"];
    NSString *imagepath = [[NSBundle mainBundle] pathForResource:@(filename.c_str()) ofType:@(extension.c_str())];
    UIImage *image = [UIImage imageWithContentsOfFile:imagepath];
    cv::Mat im = [ImageUtils CVMatFromUIImage:image isGrayRequired:false];
    return im;
}

std::string process_mrz_string(std::string mrzstring){
    
    NSString *nsString = [NSString stringWithUTF8String:mrzstring.c_str()];
    
    nsString = [nsString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *nsArray=[nsString componentsSeparatedByString:@"\n"];
    
    NSMutableString *mrz = [NSMutableString stringWithString:@""];
    for (NSString* str in nsArray) {
        if([str length] > 0){
            [mrz appendString:str];
            [mrz appendString:@"\n"];
        }
    }
    
    return [mrz UTF8String];
}
