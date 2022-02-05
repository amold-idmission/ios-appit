//
//  VideoRecordingController.h
//  AppItFramework
//
//  Created by  on 05/03/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "CommonImporter.h"

@interface VideoRecordingController : UIViewController <AVCaptureFileOutputRecordingDelegate> {
    
    BOOL recordingInProgress;
    
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *videoInputDevice;
    AVCaptureMovieFileOutput *movieFileOutput;
    
    AVPlayerViewController *playerViewController;
    
    //Screen size CGRect -landscape and portrait
    CGRect portraitLayerRect, landscapeLayerRect;
    
    // For SnackBar
    bool isSnackBarVisible;
    UILabel *showMSGLabel;
    NSTimer *fiveSecondTimer;

}
@property(retain) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)int minRecordingTime;
@property(nonatomic,assign)int maxRecordingTime;
@property(nonatomic,assign)BOOL isEnableBgVideoRecording;
@property(nonatomic,assign)NSString* textDatatoScrolled;

+(NSString*)createVideoJSONString:(NSString*)fileContent formKey:(NSString*)formKey;
+(NSString*)getVideoDataString;

@end
