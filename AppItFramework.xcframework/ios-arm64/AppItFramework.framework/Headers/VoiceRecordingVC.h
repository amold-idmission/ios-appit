//
//  VoiceRecordingVC.h
//  AppItFramework
//
//  Created by Dipen Patel on 14/01/21.
//  Copyright © 2021 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CommonImporter.h"

@interface VoiceRecordingVC : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    NSTimer *timer;
}

+(NSString*)createVoiceJSONString:(NSString*)fileContent formKey:(NSString*)formKey;
   
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)int recordingTime;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic,assign) BOOL confirm;

@property(nonatomic) NSString *play_button_color;//
@property(nonatomic) int play_button_color_alpha;//

@property(nonatomic) NSString *stop_button_color;//
@property(nonatomic) int stop_button_color_alpha;//

@property(nonatomic) NSString *pause_button_color;//
@property(nonatomic) int pause_button_color_alpha;//

@property(nonatomic) NSString *delete_button_color;//
@property(nonatomic) int delete_button_color_alpha;//

@property(nonatomic) NSString *save_button_color;//
@property(nonatomic) int save_button_color_alpha;//

@property(nonatomic) NSString *replay_button_color;//
@property(nonatomic) int replay_button_color_alpha;//

@property(nonatomic) NSString *view_background_color;//
@property(nonatomic) int view_background_color_alpha;//

@property(nonatomic) NSString *title_label_alignment;//

@property(nonatomic) NSString *view_position;

@property(nonatomic) NSString *auto_play;

@property(nonatomic) NSString *title_text_label_color;//
@property(nonatomic) int title_text_label_color_alpha;//

@property(nonatomic) NSString *text_label_color;//
@property(nonatomic) int text_label_color_alpha;//

@property(nonatomic) int title_text_label_size;//

@property(nonatomic) int text_label_size;//

@property(nonatomic) int counter_label_size;//

@end
