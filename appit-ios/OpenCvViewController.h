//
//  OpenCvViewController.h
//  appit-ios
//
//  Created by Goran Rauker on 2/2/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "TargetRectangle.h"

@interface OpenCvViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {

    IBOutlet UIView *baseView;
    IBOutlet UIView *previewView;
    IBOutlet TargetRectangle *targetRectangle;
    IBOutlet UIProgressView *progressView;
    IBOutlet UILabel *textView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *intensityAndFocusTextView;
    IBOutlet UILabel *documentNameLabel;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *backPortraitButton;
    IBOutlet UIButton *rotatePortraitButton;
    IBOutlet UIButton *rotateLandscapeButton;
    IBOutlet UIButton *captureButton;
    
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureVideoDataOutput *videoDataOutput;

    dispatch_queue_t videoDataOutputQueue;
}

@property(nonatomic) NSString *path_to_xml_template;
@property(nonatomic) BOOL single_high_res_snapshot_mode;
@property(nonatomic) NSString *template_ids;
@property(nonatomic) BOOL capturedImagePressed;
@property(nonatomic) BOOL enable_capture_button;
@property(nonatomic, assign) int enable_capture_button_time;
@property(nonatomic) NSString *currentTemplateLocation;
@property(nonatomic) BOOL enable_glare_detection;
@property(nonatomic, assign) int glare_percentage_threshold;
@property(nonatomic, assign) NSString *id_outline_color;
@property(nonatomic, assign) int id_outline_color_alpha;
@property(nonatomic, assign) NSString *id_outline_outside_color;
@property(nonatomic, assign) int id_outline_outside_color_alpha;
@property(nonatomic, assign) NSString *detected_id_outline_color;
@property(nonatomic, assign) int detected_id_outline_color_alpha;
@property(nonatomic, assign) NSString *detected_id_outline_outside_color;
@property(nonatomic, assign) int detected_id_outline_outside_color_alpha;


@property(nonatomic)  size_t ImagesToConsume;
@property(nonatomic)  size_t ImagesToInsert;
@property(nonatomic)  size_t MinImageIntensity;
@property(nonatomic)  size_t MinImageFocusScore;

-(UIImage *)snap;
-(UIImage *)get_input_image;
-(UIImage *)get_face_image;
-(UIImage *)get_barcode_image;
-(UIImage *)get_mrz_image;
-(UIImage *)get_matched_template;
-(NSString *)summary_with_br_instead_of_new_line:(bool)br_instead_of_new_line;
-(NSString *)xml;

- (IBAction)rotatePortrait:(id)sender;
- (IBAction)rotateLandscape:(id)sender;
- (IBAction)backPressedLandscape:(id)sender;
- (IBAction)backPressedPortrait:(id)sender;
- (IBAction)captureImage:(id)sender;

//interapp communication
@property(nonatomic, assign) BOOL launchedFromApp;
@property(nonatomic, retain) NSMutableString *responseUrl;

@end
