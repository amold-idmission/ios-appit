//
//  ImageUtils.h
//  appit-ios
//
//  Created by Goran Rauker on 3/20/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <opencv2/opencv.hpp>

@interface ImageUtils : NSObject

+(UIImage*)UIImageFromCVMat:(cv::Mat)im convert_color:(bool)convert_color;

+(cv::Mat)CVMatFromUIImage:(UIImage*)im isGrayRequired:(BOOL)isGrayRequired;

-(cv::Mat)read_image_data:(NSString*) filepath;

+(UIImage*)UIImageFromCVMat:(cv::Mat)im;

+(UIImage*)UIImageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

+(UIImage*)rotatingUIImageByOrientation:(UIImage*)initImage fromImageOrientation:(UIImageOrientation)orientation;

+(int)compareImageMat: (cv::Mat)matImage1 matImg2:(cv::Mat)matImage2 minMatches:(int)minMatches;

+(UIImage*)imageScaledToSize:(UIImage*)image scaledToSize:(CGSize)newSize;

+(NSString*)reduceImageSize:(UIImage*)image imageSize:(int)imageSize;

+(UIImage*)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

+(CGImageRef)CGImageFromCVMat:(cv::Mat)cvMat;

+(NSString*)createImageJSONString:(NSString*)fileBase64 formKey:(NSString*)formKey;

+(NSString*)createVoiceJSONString:(NSString*)fileBase64 formKey:(NSString*)formKey;

@end
