//
//  LanguageUtils.h
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 21/02/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSStringUtils.h"

@interface LanguageUtils : NSObject

+(BOOL)isLanguageSupported:(NSString*)language;
+(int)getStartTime;
+(NSString*)getEndTime:(int)startTime;
+(NSString*)getOperationTime:(NSDate*)startDate endDate:(NSDate*)endDate;
+(NSString*)getCaptureTime:(NSDate*)startDate endDate:(NSDate*)endDate;
@end
