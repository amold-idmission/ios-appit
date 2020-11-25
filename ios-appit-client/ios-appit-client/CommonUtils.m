//
//  CommonUtils.m
//  ios-appit-client
//
//  Created by idmission on 04/11/15.
//  Copyright © 2015 idmission. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(NSDictionary*)getUrlParams:(NSString*)urlParamString{
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    
    if(nil != urlParamString && [urlParamString containsString:@"&"]){
        NSArray *paramsArray = [urlParamString componentsSeparatedByString:@"&"];
        
        for (NSString *tempObject in paramsArray) {
//            NSLog(@"Single element: %@", tempObject);
            
            NSRange match = [tempObject rangeOfString:@"="];
            if(match.location != NSNotFound)
            {
                
                NSString *str1 = [tempObject substringWithRange: NSMakeRange (0, match.location)];
                NSString *str2 = [tempObject substringWithRange: NSMakeRange (match.location+match.length,(tempObject.length-match.location)-match.length)];
                
                [requestParam setObject:str2 forKey:str1];
            }
        }
        
    }
    return requestParam;
}

@end
