//
//  Settings.h
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 17/11/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

//getter setter for Storying URL
+(NSString*) getCurrentURL;
+(void) setCurrentURL:(NSString*)url;

//getter setter for Storying Password
+(NSString*)getCurrentPassword;
+(void)setCurrentPassword:(NSString*)password;

@end
