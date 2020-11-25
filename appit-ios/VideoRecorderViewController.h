//
//  VideoRecorderViewController.h
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 29/08/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface VideoRecorderViewController : UIViewController<AVCaptureFileOutputRecordingDelegate>{

    BOOL recordingInProgress;
    
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *videoInputDevice;
    AVCaptureMovieFileOutput *movieFileOutput;
    
    AVPlayerViewController *playerViewController;
    
    //Screen size CGRect -landscape and portrait
    CGRect portraitLayerRect, landscapeLayerRect;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *toggleRecordingButton;
    IBOutlet UIButton *toggleCameraButton;
    
}

- (IBAction)backPressed:(id)sender;
- (IBAction)donePressed:(id)sender;
- (IBAction)toggleRecording:(id)sender;
- (IBAction)toggleCamera:(id)sender;

@property (retain) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end
