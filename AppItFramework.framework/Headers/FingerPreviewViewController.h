//
//  FingerPreviewViewController.h
//  appit-ios
//
//  Created by Pranjal Lamba on 08/11/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FingerPreviewViewController : UIViewController{
    
}

@property(nonatomic) NSMutableDictionary *resultDictionary;

@property(nonatomic) int focus_threshold;

@property(nonatomic,assign)id delegate;
@property (nonatomic, retain) UIImage* preview_image_1;
@property (nonatomic, retain) UIImage* preview_image_2;
@property (nonatomic, retain) UIImage* preview_image_3;
@property (nonatomic, retain) UIImage* preview_image_4;
@property(nonatomic,assign) BOOL confirm;
@property(nonatomic,assign) BOOL leftHandCaptured, rightHandCaptured, currentHandLeft;

@end
