//
//  MlKitFaceController.h
//  AppItFramework
//
//  Created by  on 05/12/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceDetectionResponse <NSObject>
@required
-(void)faceDetectionResponse : (NSMutableDictionary*) result instance:(id)instance;
@end

@interface MlKitFaceController : UIViewController {
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *flashButton;
    //  IBOutlet UIButton *switchCameraButton
    IBOutlet UIButton *backUIButton;
    IBOutlet UILabel *thresholdLabel, *titleUiLableBottom,*titleMsgUiLabelTop;
}

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
@property(nonatomic) int image_size;
@property(nonatomic) NSString *face_outline_color;
@property(nonatomic) int face_outline_color_alpha;
@property(nonatomic) NSString *detected_face_outline_color;
@property(nonatomic) int detected_face_outline_color_alpha;
@property(nonatomic) NSString *outside_face_outline_color;
@property(nonatomic) int outside_face_outline_color_alpha;
@property(nonatomic) NSString *detected_outside_face_outline_color;
@property(nonatomic) int detected_outside_face_outline_color_alpha;
@property(nonatomic, assign) NSString *title_message_style;
@property(nonatomic, assign) NSString *title_message_size;
@property(nonatomic, assign) NSString *hint_message_style;
@property(nonatomic, assign) NSString *hint_message_size;
@property(nonatomic, assign) NSString *title_message_color;
@property(nonatomic, assign) NSString *hint_message_color;
@property(nonatomic, assign) int title_message_color_alpha;
@property(nonatomic, assign) int hint_message_color_alpha;
@property(nonatomic, assign) NSString *back_button_color;
@property(nonatomic, assign) int back_button_color_alpha;

@property (nonatomic, retain) NSString *retry_button_color;
@property (nonatomic, retain) NSString *confirm_button_color;
@property (nonatomic, retain) NSString *retry_button_border_color;
@property (nonatomic, retain) NSString *confirm_button_style;
@property(nonatomic, assign) int retry_button_color_alpha;
@property(nonatomic, assign) int confirm_button_color_alpha;
@property(nonatomic, assign) int retry_button_border_color_alpha;
@property(nonatomic, assign) int confirm_button_style_alpha;

//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic) UIImage *titleImageFace;
@property(nonatomic) BOOL isFaceTitleOnTop;
@property(nonatomic) BOOL isFaceHintMessageOnTop;
@property(nonatomic) BOOL hideFaceTitleMsgAlignment;
@property(nonatomic) BOOL hideFaceHintMsgAlignment;

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
//@property(nonatomic) GMVDetector *detector;
//Property define for maintaining response data
@property(nonatomic, strong) NSString *respOrigionalImgData, *respEllipseImgData;

@property(nonatomic) int leftDelta;
@property(nonatomic) int rightDelta;
@property(nonatomic) int upDelta;
@property(nonatomic) int downDelta;

@end
