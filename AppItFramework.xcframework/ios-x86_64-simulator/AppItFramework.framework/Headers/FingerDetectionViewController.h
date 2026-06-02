//
//  FingerDetectionViewController.h
//  AppItFramework
//
//  Created by Dipen Patel on 18/07/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CommonImporter.h"

@interface FingerDetectionViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, readonly) AVCaptureSession *session;
@property (nonatomic, readonly) AVCaptureDevice *device;
@property (nonatomic, readonly) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, readonly) AVCaptureStillImageOutput *avCaptureStillImageOutput;
@property (nonatomic, assign) BOOL processHighDefinitionImage;

@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

extern int const DEFAULT, NO_FINGERPRINT, INCORRECT_FINGERPRINT_COUNT, INCORRECT_HAND, HOLD_STEADY, HAND_CLOSE, HAND_TOO_CLOSE, HAND_FAR, HAND_TOO_FAR, CAPTURING;

+(void)retryCapture:(id)instance fingerType:(NSString*)fingerType;
+(NSString *)getFingerPrintXMLNodeFor:(NSString*)process;
@end
