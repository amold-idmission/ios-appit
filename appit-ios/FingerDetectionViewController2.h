//
//  FingerDetectionViewController2.h
//  appit-ios
//
//  Created by  on 09/11/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptureFingerprintViewController.h"



@interface FingerDetectionViewController2 : VideoCaptureFingerprintViewController{
    
}
@property(nonatomic) int focus_threshold;
@property(nonatomic) BOOL init;
@property (assign) NSString *good_frames;

//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus, *respOrigionalImgData, *respEllipseImgData;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

@end
