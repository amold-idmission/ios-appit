//
//  NSStringUtils.m
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 17/11/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

#import "NSStringUtils.h"

@implementation NSStringUtils

+(BOOL)stringIsNilOrEmpty:(NSString*)nsString {
    if(nsString == nil){
        return true;
    }
    
    NSString *trimmed = [nsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmed.length == 0){
        return true;
    }
    return false;
}

+(BOOL)isInteger:(NSString*)nsString{
    NSScanner* scan = [NSScanner scannerWithString:nsString];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+(void)setLabelStyle:(UILabel*)label{
    //    [label setTextColor:[UIColor colorWithRed:69/255.f green:69/255.f blue:69/255.f alpha:0.5]];
//    [label setTextColor:[UIColor colorWithRed:58/255.f green:58/255.f blue:58/255.f alpha:0.5]];
//    [label setShadowColor:[UIColor whiteColor]];
//    [label setShadowOffset:CGSizeMake(1.0, 1.0)];
    [label setTextColor:[UIColor whiteColor]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(2.0, 2.0)];
}

+(int)getStartTime{
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]);
    NSInteger minutes = floor(time/60);
    NSInteger seconds = round(time - minutes * 60);
    return seconds;
}

@end
