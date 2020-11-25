//
//  CommonUtils.h
//  appit-ios
//
//  Created by idmission on 04/11/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject

+(NSDictionary*)getUrlParams:(NSString*)urlParamString;
+(BOOL)isEmpty:(NSString*)string;

@end
