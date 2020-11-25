//
//  Settings.m
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 17/11/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

#import "Settings.h"
#import "IDServerInterface.h"

@implementation Settings


//getter setter for Storying URL
+(NSString*) getCurrentURL{
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [nsUserDefaults valueForKey:@"URL"];
    
    if(url && url.length){
        return url;
    }else{
        NSString *url = [IDServerInterface getURLFromProperty:@"InformUrl"];
        [self setCurrentURL:url];
        return url;
    }
}

+(void) setCurrentURL:(NSString*)url{
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    [nsUserDefaults setValue:url forKey:@"URL"];
    [nsUserDefaults synchronize];
}

//getter setter for Storying Password
+(NSString*)getCurrentPassword{
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *pass = [nsUserDefaults valueForKey:@"PASSWORD"];
    
    if(pass && pass.length){
        return pass;
    }else{
        return @"0000";
//        return @"1289";
    }
}
+(void)setCurrentPassword:(NSString*)password{
    NSUserDefaults *nsUserDefaults = [NSUserDefaults standardUserDefaults];
    [nsUserDefaults setValue:password forKey:@"PASSWORD"];
    [nsUserDefaults synchronize];
}

@end
