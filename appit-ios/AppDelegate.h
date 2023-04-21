//
//  AppDelegate.h
//  appit-ios
//
//  Created by Goran Rauker on 1/29/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
}

@property (strong, nonatomic) UIWindow *window;

-(NSString*) templates_path;
@property BOOL restrictOrientationToSupportAll;


@end

