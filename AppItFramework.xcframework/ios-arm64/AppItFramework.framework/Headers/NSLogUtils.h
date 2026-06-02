//
//  NSLogUtils.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 02/03/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSLogUtils : NSObject

+(void)printLog:(NSString*)logString;
+(void)printLogInDebugMode:(NSString*)logString;
+(CGSize)getUILabelSizeFromLabel:(NSString*)labelText size:(float)size;
+(NSString*)getString2;

@end
