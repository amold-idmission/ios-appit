//
//  FingerDetectionViewController2.h
//  appit-ios
//
//  Created by  on 09/11/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptureFingerprintViewController.h"
#import "CommonImporter.h"
#import "FingerDetectionLayerView.h"

@interface FingerDetectionViewController2 : VideoCaptureFingerprintViewController{
    
}
@property(nonatomic) int focus_threshold;
@property(nonatomic) BOOL init;
@property (assign) NSString *good_frames;
@property (assign) NSString *right_left_UIFlag;

//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus, *respOrigionalImgData, *respEllipseImgData;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic, assign) NSString *back_button_color;
@property(nonatomic, assign) int back_button_color_alpha;
@property(nonatomic) NSString *outside_finger_outline_color;
@property(nonatomic) int outside_finger_outline_color_alpha;

+(void)retryCapture:(id)instance fingerType:(NSString*)fingerType;
@end
