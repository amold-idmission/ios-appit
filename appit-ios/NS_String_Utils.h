//
//  NS_String_Utils.h
//  appit-ios
//
//  Created by Sanket Garde on 09/02/21.
//  Copyright © 2021 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NS_String_Utils : NSObject

+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
+(BOOL)isInteger:(NSString*)nsString;
+(void)setLabelStyle:(UILabel*)label;

@end

NS_ASSUME_NONNULL_END
