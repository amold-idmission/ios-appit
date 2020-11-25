//
//  FaceDetectionViewController.h
//  appit-ios
//
//  Created by idmission on 30/09/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptureViewController.h"
#import "FaceFrameUIView.h"
#import "CommonImporter.h"

@interface FaceDetectionViewController : VideoCaptureViewController{

    IBOutlet UIButton *backButton;
    IBOutlet UIButton *flashButton;
    IBOutlet UIButton *switchCameraButton;
    IBOutlet FaceFrameUIView *faceFrameUIView;
    
    IBOutlet UILabel *thresholdLabel;
    
}

- (IBAction)backPressed:(id)sender;
- (IBAction)toggleFlash:(id)sender;
- (IBAction)toggleCamera:(id)sender;

//Property define for adding configured value
@property(nonatomic) int light_threshold;
@property(nonatomic) int focus_threshold;
@property(nonatomic) double face_width_diff_percentage_threshold;
@property(nonatomic) int smile_width_percentage_threshold;
@property(nonatomic) double face_height_diff_percentage_threshold;
@property(nonatomic) double nose_movement_percentage_threshold;
@property(nonatomic) double face_movement_percentage_threshold;
@property(nonatomic) BOOL launch_front_camera;
@property(nonatomic) BOOL showPreviewScreen;
//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus;

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
+(NSMutableDictionary *)getConfigDataJSON:(NSString*)light focus:(NSString*)focus smilePercentage:(NSString*)smilePercentage operationTime:(NSString*) operationTime;
@end
