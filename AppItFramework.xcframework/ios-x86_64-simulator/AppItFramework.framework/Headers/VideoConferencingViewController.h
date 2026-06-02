//
//  VideoConferencingViewController.h
//  IDMVideoConferencing
//
//  Created by Dipen Patel on 01/08/19.
//  Copyright © 2019 Dipen Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARDAppClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoConferencingViewController : UIViewController<ARDAppClientDelegate, NSURLSessionDataDelegate>{
    
    IBOutlet UIImageView *waiting_imageview;
    IBOutlet UIButton *back_button_uibutton;
}

@property (strong, nonatomic) ARDAppClient *client;
@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;

@property(nonatomic, assign) NSString *videoConferenceSource;
@property(nonatomic, assign) NSString *videoConferenceDestination;
@property(nonatomic, assign) NSString *videoConferenceAppName;
@property(nonatomic) NSString *videoConferenceServerURL;
@property(nonatomic) NSString *videoConferenceTargetorigin;
@property(nonatomic) NSString *videoConferenceID;
@property(nonatomic) NSString *formID;

@property(nonatomic) NSString *instruction_text;
@property(nonatomic) NSString *instruction_text_fontName;
@property(nonatomic) float instruction_text_fontSize;
@property(nonatomic) NSString *instruction_text_color;
@property(nonatomic) NSString *instruction_text_background_color;
@property(nonatomic) float instruction_text_color_alpha;
@property(nonatomic) float instruction_text_background_color_alpha;
@property(nonatomic)NSString *instruction_text_position;

+(NSString*)getVideoConferenceNode;
-(void)userDisconnected;

@end

NS_ASSUME_NONNULL_END
