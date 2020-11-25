//
//  VideoCaptureViewController.h
//  appit-ios
//
//  Created by idmission on 30/09/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
{
 
}

@property (nonatomic, readonly) AVCaptureSession *captureSession;
@property (nonatomic, readonly) AVCaptureDevice *captureDevice;
@property (nonatomic, readonly) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, assign) int camera;
@property (nonatomic, assign) NSString *qualityPreset;
@property (nonatomic, assign) BOOL captureGrayscale;

@property (nonatomic, assign) BOOL showDebugInfo;
@property (nonatomic, assign) BOOL torchOn;

- (CGAffineTransform)affineTransformForVideoFrame:(CGRect)videoFrame orientation:(AVCaptureVideoOrientation)videoOrientation;

@end
