//
//  FacePreviewViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 07/09/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AppItSDK.h"

@protocol FaceDetectionResponse <NSObject>
@required
-(void)faceDetectionResponse : (NSMutableDictionary*) result instance:(id)instance;
@end

@interface FacePreviewViewController : UIViewController{

}

@property(nonatomic) NSMutableDictionary *resultDictionary;

@property(nonatomic) int light_threshold;
@property(nonatomic) int focus_threshold;
@property(nonatomic) BOOL launch_front_camera;
@property(nonatomic) int smile_width_percentage_threshold;
//
@property(nonatomic) BOOL showPreviewScreen;
@property(nonatomic) NSString *face_outline_color;
@property(nonatomic) int face_outline_color_alpha;
@property(nonatomic) NSString *detected_face_outline_color;
@property(nonatomic) int detected_face_outline_color_alpha;
@property(nonatomic) NSString *outside_face_outline_color;
@property(nonatomic) int outside_face_outline_color_alpha;
@property(nonatomic) NSString *detected_outside_face_outline_color;
@property(nonatomic) int detected_outside_face_outline_color_alpha;
@property (nonatomic, retain) NSString *headerMsgStyle;
@property (nonatomic, retain) NSString *hintMsgStyle;
@property (nonatomic, retain) NSString *header_message_color;
@property (nonatomic, retain) NSString *hint_message_color;
@property(nonatomic, assign) int header_message_color_alpha;
@property(nonatomic, assign) int hint_message_color_alpha;
@property (nonatomic, retain) NSString *retry_button_color;
@property (nonatomic, retain) NSString *confirm_button_color;
@property (nonatomic, retain) NSString *retry_button_border_color;
@property (nonatomic, retain) NSString *confirm_button_style;
@property(nonatomic, assign) int retry_button_color_alpha;
@property(nonatomic, assign) int confirm_button_color_alpha;
@property(nonatomic, assign) int retry_button_border_color_alpha;
@property(nonatomic, assign) int confirm_button_style_alpha;
@property(nonatomic, assign) NSString *title_message_size;
@property(nonatomic, assign) NSString *hint_message_size;

@property(nonatomic, assign) NSString *title_message_color;
@property(nonatomic, assign) int title_message_color_alpha;
@property(nonatomic, assign) NSString *back_button_color;
@property(nonatomic, assign) int back_button_color_alpha;

@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic) BOOL allowBothCamera;
@property(nonatomic) int image_size;
@property(nonatomic) BOOL isFaceTitleOnTop;
@property(nonatomic) BOOL isFaceHintMessageOnTop;
@property(nonatomic) int glare_threshold;
//
@property(nonatomic,assign)id delegate;
@property (nonatomic, retain) UIImage* preview_image;
@property(nonatomic,assign) BOOL confirm;

@property(nonatomic, strong) NSString *respOrigionalImgData, *respEllipseImgData;

@end
