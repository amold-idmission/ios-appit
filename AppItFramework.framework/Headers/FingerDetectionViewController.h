//
//  FingerDetectionViewController.h
//  AppItFramework
//
//  Created by Dipen Patel on 18/07/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptureFingerprintViewController.h"
#import "CommonImporter.h"

@interface FingerDetectionViewController : VideoCaptureFingerprintViewController{
    
}
//@property (assign) NSString *right_left_UIFlag;

//Property define for maintaining response data
@property(nonatomic, strong) NSString *responseStatus;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
//@property(nonatomic, assign) NSString *back_button_color;
//@property(nonatomic, assign) int back_button_color_alpha;
@property(nonatomic) NSString *outside_finger_outline_color;
@property(nonatomic) int outside_finger_outline_color_alpha;

extern int const DEFAULT, NO_FINGERPRINT, INCORRECT_FINGERPRINT_COUNT, INCORRECT_HAND, HOLD_STEADY, HAND_CLOSE, HAND_TOO_CLOSE, HAND_FAR, HAND_TOO_FAR, CAPTURING;

+(void)retryCapture:(id)instance fingerType:(NSString*)fingerType;
    
@end
