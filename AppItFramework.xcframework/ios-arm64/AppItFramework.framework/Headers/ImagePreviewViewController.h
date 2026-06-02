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

@property(nonatomic, assign)id delegate;
@property(nonatomic, assign)id instruction_screen_delegate;

@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) NSMutableDictionary *imageConfigDictionary;
@property(nonatomic) NSMutableDictionary *barcode_resultDictionary;

@property(nonatomic, retain) UIImage* preview_image;
@property(nonatomic, retain) NSString *imageType;

@property(nonatomic, assign) ScanningModeClass *currentScanningMode;
@property(nonatomic) NSString *genericFieldName;
@property(nonatomic) float idCaptureFocusScore;

@property(nonatomic, assign) BOOL confirm;
@property(nonatomic, assign) bool scanBarcode;
@property(nonatomic, assign) bool spoofImageDetected;
@property(nonatomic, assign) bool isCompressImageSizeTo_800_width;

//+(void)retryCapture:(id)instance captureType:(NSString*)captureType;
+(NSMutableDictionary *)getConfigDataJSON:(NSString*)light focus:(NSString*)focus glare:(NSString*)glare isAutoCapture:(NSString*)isAutoCapture operationTime:(NSString*) operationTime;

@end
