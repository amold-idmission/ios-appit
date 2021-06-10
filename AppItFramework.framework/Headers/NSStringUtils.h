//
//  NSStringUtils.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 19/10/16.
//  Copyright © 2016 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtils : NSObject

+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
+(BOOL)isInteger:(NSString*)nsString;
+(void)setLabelStyle:(UILabel*)label;
+(void)setLabelStyle:(UILabel*)label  isEnableShadow:(bool)isEnableShadow;
+(void)set_Label_Style:(UILabel*)label  isEnableShadow:(bool)isEnableShadow;
+(BOOL)isJailbroken;
@end
