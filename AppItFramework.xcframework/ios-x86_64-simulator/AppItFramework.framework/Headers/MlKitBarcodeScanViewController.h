//
//  MlKitBarcodeScanViewController.h
//  AppItFramework
//
//  Created by Sanket Garde on 18/09/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CommonImporter.h"

@interface MlKitBarcodeScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, readonly) AVCaptureSession *captureSession;
@property (nonatomic, readonly) AVCaptureDevice *captureDevice;
@property (nonatomic, readonly) AVCaptureMetadataOutput *videoOutput;
@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (strong, nonatomic) AVCaptureStillImageOutput *avCaptureStillImageOutput;

@property (nonatomic, assign) int camera;
@property (nonatomic, assign) NSString *qualityPreset;
@property (nonatomic, assign) BOOL captureGrayscale;

@property (nonatomic, assign) BOOL drawMatOnPreview;
@property (nonatomic, assign) BOOL landscapeMode;

@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) NSString *barcodeImageData;
@property(nonatomic, strong) NSString *defaultBarcodeImageStringData;
@property(nonatomic, strong) NSString *barcodeContentData;
@property(nonatomic, strong) NSString *barcodeFormatType;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) NSString *barcodeScanStringData;
@property(nonatomic) bool isFromEvolvApp;
@property(nonatomic) int maxImageSize;

+(NSString *)getBarcodeNode;

+(void)setBarcodeContent:(NSString*)barcodeContentData;
+(void)setBarcodeType:(NSString*)barcodeTypeData;
+(void)setBarcodeImage:(NSString*)barcodeImageData;

@end

