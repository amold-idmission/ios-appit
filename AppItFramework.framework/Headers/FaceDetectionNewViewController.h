//
//  FaceDetectionNewViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 12/11/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptureViewController.h"
#import "CommonImporter.h"
//#import <GoogleMobileVision/GoogleMobileVision.h>

@interface FaceDetectionNewViewController : VideoCaptureViewController{
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *flashButton;
  //  IBOutlet UIButton *switchCameraButton;
    IBOutlet FaceFrameUIView *faceFrameUIView;
    IBOutlet UIButton *backUIButton;
    
    IBOutlet UILabel *thresholdLabel, *titleUiLableBottom,*titleMsgUiLabelTop;
}

- (IBAction)backPressed:(id)sender;
- (IBAction)toggleFlash:(id)sender;
//- (IBAction)toggleCamera:(id)sender;

//Property define for adding configured value
@property(nonatomic) int light_threshold;
@property(nonatomic) int focus_threshold;
@property(nonatomic) int smile_width_percentage_threshold;
@property(nonatomic) double face_height_diff_percentage_threshold;
@property(nonatomic) double face_movement_percentage_threshold;
@property(nonatomic) BOOL launch_front_camera;
@property(nonatomic) BOOL showPreviewScreen;
@property(nonatomic) BOOL allowBothCamera;
@property(nonatomic) NSString *face_outline_color;
@property(nonatomic) int face_outline_color_alpha;
@property(nonatomic) NSString *detected_face_outline_color;
@property(nonatomic) int detected_face_outline_color_alpha;
@property(nonatomic) NSString *outside_face_outline_color;
@property(nonatomic) int outside_face_outline_color_alpha;
@property(nonatomic) NSString *detected_outside_face_outline_color;
@property(nonatomic) int detected_outside_face_outline_color_alpha;
//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic) UIImage *titleImageFace;

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
//@property(nonatomic) GMVDetector *detector;

@end
