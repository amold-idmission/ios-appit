//
//  ImageUtils.m
//  appit-ios
//
//  Created by Goran Rauker on 3/20/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import "ImageUtils.h"
#include "MRZDetector.h"
#include "LetterSize.h"

@interface ImageUtils ()
@end

@implementation ImageUtils

+(UIImage *)UIImageFromCVMat:(cv::Mat)im convert_color:(bool)convert_color
{
    //NSLog(@"%@%d", @"image type", im.type());
    //if (im.type() != 0) {
        
        
        cv::Mat cvMat = im;
//        NSLog(@"%@%d", @"image type", im.type());
//        NSLog(@"%@%d", @"image channels", im.channels());
        if (im.type() != 0 && convert_color)
            cv::cvtColor(im, cvMat, cv::COLOR_BGR2RGB);
        
        NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
        CGColorSpaceRef colorSpace;
        
        if (cvMat.elemSize() == 1) {
            colorSpace = CGColorSpaceCreateDeviceGray();
        } else {
            colorSpace = CGColorSpaceCreateDeviceRGB();
        }
        
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
        
        // Creating CGImage from cv::Mat
        CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                            cvMat.rows,                                 //height
                                            8,                                          //bits per component
                                            8 * cvMat.elemSize(),                       //bits per pixel
                                            cvMat.step[0],                              //bytesPerRow
                                            colorSpace,                                 //colorspace
                                            kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                            provider,                                   //CGDataProviderRef
                                            NULL,                                       //decode
                                            false,                                      //should interpolate
                                            kCGRenderingIntentDefault                   //intent
                                            );
        
        
        // Getting UIImage from CGImage
        UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpace);
        
        return finalImage;
   // }
    return nil;
}

-(cv::Mat)read_image_data:(NSString*) filepath{
    NSString *originalFilePath = filepath;
    originalFilePath = [[NSBundle mainBundle] pathForResource:@"twolinemrz" ofType:@"jpg" inDirectory:@"/htdocs"];
//    UIImage *image = [UIImage imageWithContentsOfFile:originalFilePath];
//    cv::Mat im = [ImageUtils CVMatFromUIImage:image];
    const char * cpath = [originalFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    cv::Mat img_object = imread( cpath, cv::IMREAD_GRAYSCALE);
    return img_object;
}


+(cv::Mat)CVMatFromUIImage:(UIImage*)im isGrayRequired:(BOOL)isGrayRequired{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(im.CGImage);
    CGFloat cols = im.size.width;
    CGFloat rows = im.size.height;
    
    cv::Mat cvMat;
    
    if(isGrayRequired){
        cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    }else{
        cvMat = cv::Mat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    }
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), im.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    // (1) Construct the correct color space
    CGColorSpaceRef colorSpace;
    if ( cvMat.channels() == 1 ) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    // (2) Create image data reference
    CFDataRef data = CFDataCreate(kCFAllocatorDefault, cvMat.data, (cvMat.elemSize() * cvMat.total()));
    
    // (3) Create CGImage from cv::Mat container
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGImageRef imageRef = CGImageCreate(cvMat.cols,
                                        cvMat.rows,
                                        8,
                                        8 * cvMat.elemSize(),
                                        cvMat.step[0],
                                        colorSpace,
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault);
    
    // (4) Create UIImage from CGImage
    UIImage * finalImage = [UIImage imageWithCGImage:imageRef];
    
    // (5) Release the references
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CFRelease(data);
    CGColorSpaceRelease(colorSpace);
    
    // (6) Return the UIImage instance
    return finalImage;
}

// Create a UIImage from sample buffer data

+ (UIImage *) UIImageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    NSLog(@"imageFromSampleBuffer: called");
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

+(UIImage*)rotatingUIImageByOrientation:(UIImage*)initImage fromImageOrientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef = initImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = orientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            return initImage;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    // Create the bitmap context
    CGContextRef    context = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (bounds.size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * bounds.size.height);
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        return nil;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imgRef);
    context = CGBitmapContextCreate (bitmapData,bounds.size.width,bounds.size.height,8,bitmapBytesPerRow,
                                     colorspace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    if (context == NULL)
        // error creating context
        return nil;
    
    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextTranslateCTM(context, -bounds.size.width, -bounds.size.height);
    
    CGContextConcatCTM(context, transform);
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context, CGRectMake(0,0,width, height), imgRef);
    
    CGImageRef imgRef2 = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    free(bitmapData);
    UIImage * image = [UIImage imageWithCGImage:imgRef2 scale:initImage.scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef2);
    return image;
}

+(int)compareImageMat: (cv::Mat)matImage1 matImg2:(cv::Mat)matImage2 minMatches:(int)minMatches{

    if(nil==matImage1.data || nil==matImage2.data){
        return 0;
    }
    
    //Converting Mat to gray mat
    cv::cvtColor(matImage1, matImage1, cv::COLOR_BGR2GRAY);
    cv::cvtColor(matImage2, matImage2, cv::COLOR_BGR2GRAY);
    
    std::vector<cv::KeyPoint> keypoints_1, keypoints_2;
    cv::Mat descriptor_1, descriptor_2;
    
    cv::Ptr<cv::BRISK> briskDetector = cv::BRISK::create();
    
    // Step -1, Detect keypoints using BRISK detector
    briskDetector->detect(matImage1, keypoints_1);
    briskDetector->detect(matImage2, keypoints_2);
    
    // Step -2, Calculate descriptors (feature vector)
    briskDetector->compute(matImage1,keypoints_1,descriptor_1);
    briskDetector->compute(matImage2,keypoints_2,descriptor_2);
    
    //step - 3, Matching descriptor vectors with a brute force mathcher
    cv::Ptr<cv::DescriptorMatcher> matcher = cv::DescriptorMatcher::create("BruteForce-Hamming");
    std::vector<cv::DMatch> matches;
    matcher->match(descriptor_1, descriptor_2, matches);
    
    // quick calcualation of max and min distances between keypoints
    double max_dist=0; double min_dist = 1000;
    for (int i =0; i < matches.size();i++)
    {
        double dist = matches[i].distance;
        if(max_dist<dist) max_dist = dist;
        if(min_dist>dist) min_dist = dist;
    }

    std::vector<cv::DMatch> good_matches;
//    min_dist = min_dist + (max_dist- min_dist)* 0.3;
    min_dist = max_dist/2;
    for (int i=0;i<matches.size();i++)
    {
        if( matches[i].distance<= min_dist)
            good_matches.push_back(matches[i]);
    }
    
    // Draw Good Matches
//    cv::Mat img_goodmatches;
//    drawMatches(matImage1,keypoints_1,matImage2,keypoints_2,good_matches,img_goodmatches,
//                cv::Scalar::all(-1),cv::Scalar::all(-1),std::vector<char>(),cv::DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS);
//    UIImage *temp = [ImageUtils UIImageFromCVMat:img_goodmatches];

    if(good_matches.size()>minMatches){
        NSLog(@":::::MAY_BE_DUPLICATE");
        return 3;
    }else{
        NSLog(@":::::NOT_DUPLICATE");
        return 2;
    }
    return 0;
}

+(UIImage*)imageScaledToSize:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSString*)reduceImageSize:(UIImage*)image imageSize:(int)imageSize{
    
    int imageSizeLimit = 512 * 1024;
    if (imageSize != 0) {
        imageSizeLimit = imageSize*1024;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    while ([imageData length] > imageSizeLimit) {
        CGFloat height = image.size.height;
        CGFloat width = image.size.width;
        height = height * 0.9f;
        width = width * 0.9f;
        image = [self imageWithImage:image convertToSize:CGSizeMake(width, height)];
        imageData = UIImageJPEGRepresentation(image, 0.9);
    }
    
    NSString *base64 = [imageData base64EncodedStringWithOptions:0];
    return base64;
}

+(UIImage*)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (CGImageRef)CGImageFromCVMat:(cv::Mat)cvMat {
    if (cvMat.elemSize() == 4) {
        cv::cvtColor(cvMat, cvMat, cv::COLOR_BGRA2RGBA);
    }
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}

+(NSString*)createImageJSONString:(NSString*)fileBase64 formKey:(NSString*)formKey{
    
    NSInteger timestampInt = [[NSDate date] timeIntervalSince1970]*1000;
    
    NSMutableDictionary *contentDictionary = [[NSMutableDictionary alloc]init];
    
    [contentDictionary setValue:[@(timestampInt) stringValue] forKey:@"uniqueId"];
    [contentDictionary setValue:@"Y" forKey:@"isImageControlData"];
    [contentDictionary setValue:@"data:image/jpeg;base64" forKey:@"type"];
    [contentDictionary setValue:@"Dummy.jpeg" forKey:@"name"];
    [contentDictionary setValue:@"0.92" forKey:@"imageQuality"];
    [contentDictionary setValue:@"Y" forKey:@"fileUploadType"];
    [contentDictionary setValue:formKey forKey:@"formKey"];
    [contentDictionary setValue:@"" forKey:@"fieldId"];
    [contentDictionary setValue:@"N" forKey:@"isWatermarked"];
    [contentDictionary setValue:@"N" forKey:@"suspectedTampering"];
    [contentDictionary setValue:fileBase64 forKey:@"fileContent"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:contentDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+(int)getStartTime{
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]);
    NSInteger minutes = floor(time/60);
    NSInteger seconds = round(time - minutes * 60);
    return seconds;
}
+(NSString*)getEndTime:(int)startTime{
    
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]);
    NSInteger minutes = floor(time/60);
    NSInteger endTime = round(time - minutes * 60);
    NSInteger timeDiff=((endTime-startTime));
    NSString *seconds = [NSString stringWithFormat:@"%i",timeDiff];
    return seconds;
}

@end
