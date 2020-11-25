//
//  NSLogUtils.m
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 02/03/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import "NSLogUtils.h"

@implementation NSLogUtils

bool isDebug = false;

+(void)printLog:(NSString*)logString{
    NSLog(@"%@", logString);
}

+(void)printLogInDebugMode:(NSString*)logString{
    if(isDebug){
        NSLog(@"%@", logString);
    }
}

+(CGSize)getUILabelSizeFromLabel:(NSString*)labelText size:(float)size{
    //        size = size + 2.0; //Adding little bit padding
    size = size + 1.0; //Adding little bit padding
    CGSize sizeDynamic  = [labelText sizeWithFont:[UIFont fontWithName:@"Arial-BoldMT" size:size] constrainedToSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeDynamic;
}
@end
