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

@property (nonatomic, assign) int camera;
@property (nonatomic, assign) NSString *qualityPreset;
@property (nonatomic, assign) BOOL captureGrayscale;

@property (nonatomic, assign) BOOL drawMatOnPreview;
@property (nonatomic, assign) BOOL landscapeMode;

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)id instructionScreen_delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;


@property(nonatomic) int light_threshold;
@property(nonatomic) int focus_threshold;
@property(nonatomic) int glare_threshold;
@property(nonatomic) int smile_width_percentage_threshold;
@property(nonatomic) int passive_face_detection_threshold;
@property(nonatomic) int eyes_open_threshold;
@property(nonatomic) int face_spoofDetection_threshold;
@property(nonatomic) double face_height_diff_percentage_threshold;
@property(nonatomic) double face_movement_percentage_threshold;
@property(nonatomic) BOOL launch_front_camera;
@property(nonatomic) BOOL showPreviewScreen;
@property(nonatomic) BOOL allowBothCamera;
@property(nonatomic) NSString *face_outline_color;
@property(nonatomic) int face_outline_color_alpha;
@property(nonatomic) NSString *instPreview_outline_color;
@property(nonatomic) int instPreview_outline_color_alpha;
@property(nonatomic) NSString *detected_face_outline_color;
@property(nonatomic) int detected_face_outline_color_alpha;
@property(nonatomic) NSString *outside_face_outline_color;
@property(nonatomic) int outside_face_outline_color_alpha;
@property(nonatomic) NSString *detected_outside_face_outline_color;
@property(nonatomic) int detected_outside_face_outline_color_alpha;
@property(nonatomic, assign) NSString *title_message_style;
@property(nonatomic, assign) NSString *hint_message_style;
@property(nonatomic, assign) NSString *title_message_color;
@property(nonatomic, assign) NSString *hint_message_color;
@property(nonatomic, assign) int title_message_color_alpha;
@property(nonatomic, assign) int hint_message_color_alpha;
@property(nonatomic, assign) NSString *back_button_color;
@property(nonatomic, assign) int back_button_color_alpha;
//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic) UIImage *titleImageFace;

@property(nonatomic) BOOL show_custom_ui;
@property(nonatomic, assign) NSString *custom_image_bundle_id;
@property(nonatomic, assign) NSString *custom_face_outline_image_id;
@property(nonatomic, assign) NSString *custom_face_outside_outline_image_id;
@property(nonatomic, assign) NSString *custom_face_outline_progress_images;
@property(nonatomic) int face_outline_progress_images_delay;
@property(nonatomic, assign) NSString* left_turn_arrow_custom, *up_move_arrow_custom, *right_turn_arrow_custom, *down_move_arrow_custom;
@property(nonatomic, assign) NSString* toggle_camera_button_icon;

@property(nonatomic, assign) NSString* showcaseUserEmailId;
@property (nonatomic, assign) BOOL isForShowCaseZipUpload;
@property (nonatomic, assign) BOOL isBGRConversionEnable;

-(IBAction)manualCapture_Action:(id)sender;
+(void)sendGTE_ZipUploadRequest:(NSString*)real_spoof_string outFileDirectoryPath:(NSString*)outFileDirectoryPath;

@end


