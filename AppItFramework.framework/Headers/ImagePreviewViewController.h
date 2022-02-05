//
//  ImagePreviewViewController.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 08/05/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItSDK.h"
#import "ScanningModeClass.h"

@interface ImagePreviewViewController : UIViewController

@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) NSMutableDictionary *imageConfigDictionary;
@property(nonatomic) NSMutableDictionary *barcode_resultDictionary;
@property(nonatomic,assign) bool scanBarcode;

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)id instruction_screen_delegate;
@property (nonatomic, retain) UIImage* preview_image;
@property (nonatomic, retain) NSString *imageType;
@property (nonatomic, retain) NSString *headerMsgStyle;
@property (nonatomic, retain) NSString *hintMsgStyle;
@property (nonatomic, retain) NSString *header_message_color;
@property (nonatomic, retain) NSString *hint_message_color;
@property(nonatomic, assign) int header_message_color_alpha;
@property(nonatomic, assign) int hint_message_color_alpha;
@property (nonatomic, retain) NSString *retry_button_color;
@property (nonatomic, retain) NSString *confirm_button_color;
@property (nonatomic, retain) NSString *retry_button_border;
@property (nonatomic, retain) NSString *confirm_button_style;
@property(nonatomic, assign) int retry_button_color_alpha;
@property(nonatomic, assign) int confirm_button_color_alpha;
@property(nonatomic, assign) int retry_button_border_alpha;
@property(nonatomic, assign) int confirm_button_style_alpha;
@property (nonatomic, retain) NSString *header_Size;
@property (nonatomic, retain) NSString *text_Size;
@property(nonatomic,assign) BOOL confirm;
@property(nonatomic) NSString *genericFieldName;
@property(nonatomic, assign) ScanningModeClass *currentScanningMode;
@property(nonatomic, assign) bool spoofImageDetected;
@property(nonatomic) float idCaptureFocusScore;
@property(nonatomic, assign) bool isCompressImageSizeTo_800_width;

//+(void)retryCapture:(id)instance captureType:(NSString*)captureType;
+(NSMutableDictionary *)getConfigDataJSON:(NSString*)light focus:(NSString*)focus glare:(NSString*)glare isAutoCapture:(NSString*)isAutoCapture operationTime:(NSString*) operationTime;

@end
