//
//  IDCaptureModelController.h
//  AppItFramework
//
//  Created by Sanket Garde on 26/08/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NSStringUtils.h"
#import "AppItSDK.h"
#import "TargetRectangleModelDetect.h"
#import "TFDetectedDataClass.h"
#import "MRZDataAndAngleClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface IDCaptureModelController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate> {
    
    IBOutlet UIView *baseView;
    IBOutlet UIView *previewView;
    IBOutlet TargetRectangleModelDetect *targetRectangle;
    IBOutlet UIButton *captureButton;
    IBOutlet UIButton *captureButton_portrait;
    IBOutlet NSLayoutConstraint *captureButtonBottomConstraint;
    
    dispatch_queue_t videoDataOutputQueue;
    
}
@property(nonatomic, retain) IBOutlet UILabel* debugScore_Label;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)id instructionScreen_delegate;
@property(nonatomic) NSString *imageType;
@property (nonatomic, assign) BOOL isUploadIDZipData;
@property(nonatomic) NSString *genericFieldName;
@property(nonatomic) BOOL capture_in_portrait_mode;
@property(nonatomic, assign) int mrzRetryCount;
@property(nonatomic, assign) int mrzAndBarcodeRetryCount;
@property(nonatomic, assign) int enable_capture_button_time;

@property(nonatomic, assign) NSString* showcaseUserEmailId;
@property(nonatomic) BOOL capturedImagePressed;
@property(nonatomic) int imageWidth;
@property(nonatomic) int imageHeight;
@property(nonatomic) NSMutableDictionary *resultDictionary;

@property(nonatomic, assign) NSString *back_button_color;
@property(nonatomic, assign) int back_button_color_alpha;

@property(nonatomic, assign) NSString *title_message_color;
@property(nonatomic, assign) int title_message_color_alpha;
@property(nonatomic, assign) NSString *title_message_style;
@property(nonatomic, assign) NSString *header_font_size;

@property(nonatomic, assign) NSString *id_outline_outside_color;
@property(nonatomic, assign) int id_outline_outside_color_alpha;
@property(nonatomic, assign) NSString *detected_id_outline_outside_color;
@property(nonatomic, assign) int detected_id_outline_outside_color_alpha;

@property(nonatomic, assign) NSString *id_outline_color;
@property(nonatomic, assign) int id_outline_color_alpha;
@property(nonatomic, assign) NSString *detected_id_outline_color;
@property(nonatomic, assign) int detected_id_outline_color_alpha;

@property(nonatomic, assign) NSString *hint_message_color;
@property(nonatomic, assign) int hint_message_color_alpha;
@property(nonatomic, assign) NSString *hint_message_style;
@property(nonatomic, assign) NSString *text_font_size;

-(IBAction)captureImage:(id)sender;
+(void)sendGTE_ZipUploadRequest_WithFilePath:(NSString*)outFileDirectoryPath;

@end

NS_ASSUME_NONNULL_END
