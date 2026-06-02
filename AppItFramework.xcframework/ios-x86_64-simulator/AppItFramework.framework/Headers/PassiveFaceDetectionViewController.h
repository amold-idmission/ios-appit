//
//  PassiveFaceDetectionViewController.h
//  AppItFramework
//
//  Created by Sanket Garde on 02/01/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CommonImporter.h"
#import "PassiveFaceView.h"

@interface PassiveFaceDetectionViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UIButton *manualCaptureButton;

@property (nonatomic, readonly) AVCaptureSession *captureSession;
@property (nonatomic, readonly) AVCaptureDevice *captureDevice;
@property (nonatomic, readonly) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)id instructionScreen_delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

//All Threshold Set By User
@property(nonatomic) int userDefinedFaceLivenessThreshold;
@property(nonatomic) int userDefinedFaceFocusThreshold;
@property(nonatomic) int userDefinedFaceMaskThreshold;
@property(nonatomic) int userDefinedEyesOpeningThreshold;

//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic, assign) NSString *showcaseUserEmailId;
@property(nonatomic, assign) int camera;
@property(nonatomic, assign) BOOL landscapeMode;

-(IBAction)manualCapture_Action:(id)sender;
+(void)sendGTE_ZipUploadRequest_WithFilePath:(NSString*)outFileDirectoryPath;

@end


