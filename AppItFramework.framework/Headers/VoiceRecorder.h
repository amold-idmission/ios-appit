//
//  VoiceRecorder.h
//  VoiceRecord
//
//  Created by Avinash on 10/5/10.
//  Copyright PocketPpl 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
//#import "lame/lame.h"


@interface VoiceRecorder : NSObject <AVAudioRecorderDelegate>
{
	
	NSMutableDictionary *recordSetting;
	NSMutableDictionary *editedObject;
	NSString *recorderFilePath;
    NSString *recordingFormat;
    NSString *fieldID;
    AVAudioRecorder *recorder;
    
    int counter;
    NSTimer *timer;
    NSData *audioData;
	
	SystemSoundID soundID;
}

@property (assign) id<AVAudioRecorderDelegate>  delegate;

- (void) startRecording:(NSDictionary *) voiceRecordingConfig;
- (void) stopRecording;
//- (void) playSound;
- (void) handleTimer;
-(NSString *) getRecorderFilePath;
-(void)convertFromWavToMp3:(NSString *)filePath;

@end

