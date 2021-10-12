//
//  CaptureSignatureController.h
//  AppItFramework
//
//  Created by  on 08/06/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UviSignatureView.h"

@class CanvasView;
@interface CaptureSignatureController : UIViewController

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) BOOL capture_in_portrait_mode;
//@property(nonatomic) BOOL is_Digital_Signature_Enabled;

+(NSString *)getsignatureCaptureNode;
+(NSString*)getSignatureImage;
+(void)setSignatureImage:(NSString*)signatureImageData;

@end
