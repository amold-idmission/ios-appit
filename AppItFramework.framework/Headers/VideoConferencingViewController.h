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

@interface VideoConferencingViewController : UIViewController<ARDAppClientDelegate>{
    
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

+(NSString*)getVideoConferenceNode;

@end

NS_ASSUME_NONNULL_END
