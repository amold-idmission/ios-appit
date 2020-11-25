//
//  NSStringUtils.h
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 17/11/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtils : NSObject

+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
+(BOOL)isInteger:(NSString*)nsString;
+(void)setLabelStyle:(UILabel*)label;

@end
