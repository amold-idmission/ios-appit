//
//  CaptureSignatureController.h
//  AppItFramework
//
//  Created by  on 08/06/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UviSignatureView.h"

@protocol captureSignatureResponse <NSObject>
@required
-(void)captureSignatureResponse : (NSMutableDictionary*) result instance:(id)instance;
@end
@interface CaptureSignatureController : UIViewController

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

+(NSString *)getsignatureCaptureNode;

+(void)setSignatureImage:(NSString*)signatureImageData;
@property(nonatomic, strong) NSString *defaultSignatureStringData;
@property(nonatomic, strong) NSString *responseStatus;

@end
