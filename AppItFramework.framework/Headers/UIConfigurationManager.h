//
//  UIConfigurationManager.h
//  AppItFramework
//
//  Created by Sanket Garde on 23/05/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIConfiguration.h"

@interface UIConfigurationManager : NSObject

+(UIConfiguration *)getDefaultIDCaptureFrontConfig ;
+(UIConfiguration *)getDefaultIDCaptureBackConfig;
+(UIConfiguration *)getDefaultDocCaptureConfig;
+(UIConfiguration *)getDefaultSnippetCaptureConfig;
+(UIConfiguration *)getDefaultFaceCaptureConfig;
+(UIConfiguration *)getDefault4FCaptureConfig;
+(UIConfiguration *)getDefaultSlantCaptureConfig;
+(UIConfiguration *)getDefaultSecondaryIDCaptureFrontConfig;
+(UIConfiguration *)getDefaultSecondaryIDCaptureBackConfig;
+(UIConfiguration *)getDefaultBarcodeCaptureConfig;
+(UIConfiguration *)getDefaultVoiceRecordingConfig;
+(UIConfiguration *)getDefaultSignatureCaptureConfig;

+(UIConfiguration *)getCustomIDCaptureFrontUIConfig;
+(UIConfiguration *)getCustomIDCaptureBackUIConfig;
+(UIConfiguration *)getCustomDocCaptureUIConfig;
+(UIConfiguration *)getCustomSnippetCaptureUIConfig;
+(UIConfiguration *)getCustomFaceCaptureUIConfig;
+(UIConfiguration *)getCustom4FCaptureUIConfig;
+(UIConfiguration *)getCustomSlantCaptureUIConfig;
+(UIConfiguration *)getCustomSecondaryIDCaptureFrontUIConfig;
+(UIConfiguration *)getCustomSecondaryIDCaptureBackUIConfig;
+(UIConfiguration *)getCustomBarcodeCaptureUIConfig;
+(UIConfiguration *)getCustomVoiceRecordingUIConfig;
+(UIConfiguration *)getCustomSignatureCaptureUIConfig;


+(void) initDefaultUIConfig;
+(void) initCustomUIConfig:(NSMutableDictionary *)uiConfigJsonString;

@end
