//
//  VoiceRecorder.m
//  VoiceRecord
//
//  Created by Avinash on 10/5/10.
//  Copyright PocketPpl 2010. All rights reserved.
//

#import "VoiceRecorder.h"

#define TMP_RECORDING_FOLDER [NSTemporaryDirectory() stringByAppendingPathComponent:@"/recording"]


@implementation VoiceRecorder

- (void) handleTimer
{
        counter--;
        NSLog(@"counter: %d",counter);
        if(counter < 0)
        {
            [timer invalidate];
            timer = nil;
        }
}

- (void) startRecording:(NSDictionary *) voiceRecordingConfig;
{
    NSString *fieldId = [voiceRecordingConfig objectForKey:@"fieldId"];
    NSString *format = [voiceRecordingConfig objectForKey:@"format"];
    NSString *fileLimit = [voiceRecordingConfig objectForKey:@"fileLimit"];
    int iFileLimit = [fileLimit integerValue];
    
    /*
     * We are recording voice in .wav format only.
     * In case request contain .mp3 format we are converting .wav to .mp3 once voice recorded.
     */
//    NSString *fileName = [NSString stringWithFormat:@"%@%@%@", fieldId, @".", format];
    NSString *fileName = [NSString stringWithFormat:@"%@%@%@", fieldId, @".", @"wav"];
    
    //counter =  30;
    counter = iFileLimit;
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
	
	recordSetting = [[NSMutableDictionary alloc] init];
	
	// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
	//MA [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];

	// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
    //[recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    
    ///[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
	
	// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
	//MA [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
        ////[recordSetting setValue :[NSNumber  numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //[recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    ///[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    ///[recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];

	
	// These settings are used if we are using kAudioFormatLinearPCM format
	//[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	//
    ///[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	//
    ///[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue :[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue :[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [recordSetting setValue :[NSNumber numberWithBool:0] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsNonInterleaved];
    [recordSetting setValue :[NSData data] forKey:AVChannelLayoutKey];
	
    
    //recordSetting = audioSetting;
	
	// Create a new dated file
	//NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
//	NSString *caldate = [now description];
//	recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
//MA recorderFilePath = [NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER];
    //recorderFilePath = [NSString stringWithFormat:@"%@/MySound.wav", DOCUMENTS_FOLDER];
    recorderFilePath = [NSString stringWithFormat:@"%@/%@", TMP_RECORDING_FOLDER, fileName];
    recordingFormat = format;
    fieldID = fieldId;
    
	NSLog(@"recorderFilePath: %@",recorderFilePath);
	
	NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
	
	err = nil;
	
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
	if(audioData)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
	}
	
	err = nil;
	recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        /*UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        [alert release];*/
        return;
	}
	
	//prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	[recorder setMeteringEnabled:YES];
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (! audioHWAvailable) {
        NSLog(@"recorder: %@", @"Audio input hardware not available");
        /*UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
								   message: @"Audio input hardware not available"
								  delegate: nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; */
        return;
	}
	
	// start recording
//MA    [recorder recordForDuration:(NSTimeInterval) counter];
    [recorder record];
	
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (IBAction) stopRecording
{
    //[self audioRecorderDidFinishRecording:recorder successfully:true];
	[recorder stop];
    counter = 0;
    [self handleTimer];
}

/*- (IBAction)playSound
{
    if(!recorderFilePath){
//MA		recorderFilePath = [[NSString stringWithFormat:@"%@/MySound.caf", DOCUMENTS_FOLDER] retain];
    recorderFilePath = [NSString stringWithFormat:@"%@/MySound.wav", DOCUMENTS_FOLDER];
    }
	//NSLog(@"Playing sound from Path: %@",recorderFilePath);
	
	if(soundID)
	{
		AudioServicesDisposeSystemSoundID(soundID);
	}
	
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:recorderFilePath isDirectory:NO];
	
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
	
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
}*/

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	NSLog (@"audioRecorderDidFinishRecording:successfully:");
	[timer invalidate];

    if([@"mp3" isEqualToString:recordingFormat]){
        [self convertFromWavToMp3:recorderFilePath];
    }
    
    //audioData = [[NSData alloc] initWithContentsOfFile:recorderFilePath];
    [self.delegate audioRecorderDidFinishRecording:aRecorder successfully:flag];
}

-(NSString *) getRecorderFilePath
{
    return recorderFilePath;
}

-(void)convertFromWavToMp3:(NSString *)filePath {
    
    NSLog(@"VoiceRecording source file path: %@", filePath);
    
    NSString *mp3FileName = fieldID;
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:mp3FileName];
    
    NSLog(@"VoiceRecording mp3 file path: %@", mp3FilePath);
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        
        //Removing origional file content
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:recorderFilePath error:&err];
        recorderFilePath = mp3FilePath;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"");
    }
}

@end
