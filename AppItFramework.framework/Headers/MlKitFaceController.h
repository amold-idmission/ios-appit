//
//  MlKitFaceController.h
//  AppItFramework
//
//  Created by  on 05/12/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MlKitFaceController : UIViewController {
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *flashButton;
    //  IBOutlet UIButton *switchCameraButton
    IBOutlet UIButton *backUIButton;
    IBOutlet UILabel *thresholdLabel, *titleUiLableBottom,*titleMsgUiLabelTop;
}

@property (weak, nonatomic) IBOutlet UIButton *manual_Capture_Button;

//Property define for adding configured value
@property(nonatomic) int light_threshold;
@property(nonatomic) int focus_threshold;
@property(nonatomic) int glare_threshold;
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
@property(nonatomic) NSString *instPreview_outline_color;
@property(nonatomic) int instPreview_outline_color_alpha;
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

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
//@property(nonatomic) GMVDetector *detector;

@property(nonatomic) int leftDelta;
@property(nonatomic) int rightDelta;
@property(nonatomic) int upDelta;
@property(nonatomic) int downDelta;

@property(nonatomic) BOOL show_custom_ui;
@property(nonatomic, assign) NSString *custom_image_bundle_id;
@property(nonatomic, assign) NSString *custom_face_outline_image_id;
@property(nonatomic, assign) NSString *custom_face_outside_outline_image_id;
@property(nonatomic, assign) NSString *custom_face_outline_progress_images;
@property(nonatomic) int face_outline_progress_images_delay;
@property(nonatomic, assign) NSString* left_turn_arrow_custom, *up_move_arrow_custom, *right_turn_arrow_custom, *down_move_arrow_custom;
@property(nonatomic, assign) NSString* toggle_camera_button_icon;

- (IBAction)manual_Capture_Action:(id)sender;

@end
