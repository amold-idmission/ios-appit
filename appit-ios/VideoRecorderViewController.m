//
//  VideoRecorderViewController.m
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 29/08/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

/**
 Referenced from below URL:
 http://www.ios-developer.net/iphone-ipad-programmer/development/camera/record-video-with-avcapturesession-2
 **/

#import "VideoRecorderViewController.h"

@interface VideoRecorderViewController ()

- (BOOL)initVideoCameraSession;
- (void)destroyVideoCameraSession;

@end

@implementation VideoRecorderViewController

@synthesize videoPreviewLayer = _videoPreviewLayer;

- (void)viewDidLoad {
    [super viewDidLoad];

    //Adding observer for orientation change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self initVideoCameraSession];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    [self destroyVideoCameraSession];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    recordingInProgress = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self destroyVideoCameraSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)initVideoCameraSession{
    
    NSLog(@"initVideoCameraSession - Start");
    
    captureSession = [[AVCaptureSession alloc] init];
    
    //Adding Video Input
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (videoDevice){
        NSError *error;
        videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (!error){
            if ([captureSession canAddInput:videoInputDevice]){
                [captureSession addInput:videoInputDevice];
            }else{
                NSLog(@"Couldn't add video input");
            }
        }else{
            NSLog(@"Couldn't create video input");
        }
    }else{
        NSLog(@"Couldn't create video capture device");
    }
    
    
    //Adding Audio Input
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput){
        [captureSession addInput:audioInput];
    }
    
    
    //Adding Movie File Output
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    Float64 totalSeconds = 10;			//Total seconds
    int32_t preferredTimeScale = 30;	//Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(totalSeconds, preferredTimeScale);	//<<SET MAX DURATION
    [movieFileOutput setMaxRecordedDuration:maxDuration];
    //    [movieFileOutput setMinFreeDiskSpaceLimit:1024*1024];
    
    if ([captureSession canAddOutput:movieFileOutput]){
        [captureSession addOutput:movieFileOutput];
    }
    
    
    //Setting image quality
    [captureSession setSessionPreset:AVCaptureSessionPresetMedium];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]){
        [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    
    //Adding Video Preview Layer
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    //Screen size according to current orientation
    CGRect layerRect = [[[self view] layer] bounds];
    //Creating CGRect of landscape and portrait mode...according to current screen size
    if(layerRect.size.height > layerRect.size.width){ //Launched in portrait mode
        portraitLayerRect = layerRect;
        landscapeLayerRect = CGRectMake(layerRect.origin.x, layerRect.origin.y, layerRect.size.height, layerRect.size.width);
    }else{                                            //Launched in landscape mode
        landscapeLayerRect = layerRect;
        portraitLayerRect = CGRectMake(layerRect.origin.x, layerRect.origin.y, layerRect.size.height, layerRect.size.width);
    }
    //Display Preview Layer
    [_videoPreviewLayer setBounds:layerRect];
    [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    //[[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
    UIView *cameraView = [[UIView alloc] init];
    [[self view] addSubview:cameraView];
    [self.view sendSubviewToBack:cameraView];
    
    [[cameraView layer] addSublayer:_videoPreviewLayer];
    
    
    //Start The Capture Session Running
    [captureSession startRunning];
    
    NSLog(@"initVideoCameraSession - End");
    
    return TRUE;
}

-(void)destroyVideoCameraSession{
    [captureSession removeInput:videoInputDevice];
    [captureSession removeOutput:movieFileOutput];
    [captureSession stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    [playerViewController.view removeFromSuperview];
    
    _videoPreviewLayer = nil;
    playerViewController = nil;
    videoInputDevice = nil;
    captureSession = nil;
    movieFileOutput = nil;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    NSLog(@"captureOutput - Start");
    
    BOOL recordedSuccessfully = YES;
    if ([error code] != noErr){
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value){
            recordedSuccessfully = [value boolValue];
        }
    }
    
    if (recordedSuccessfully){
        NSLog(@"Recorded Successfully");
        
        AVPlayer *player = [AVPlayer playerWithURL:outputFileURL];
        playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        
        [self addChildViewController:playerViewController];
        [self.view addSubview:playerViewController.view];
        playerViewController.view.frame = CGRectMake(100,100,self.view.frame.size.width-100-100,self.view.frame.size.height-100-100);
        
        //For getting thumbnail image from video
        //        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outputFileURL options:nil];
        //        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        //        imageGenerator.appliesPreferredTrackTransform = YES;
        //        CMTime time = CMTimeMake(1, 1); // time range in which you want screenshot
        //        CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        //        UIImage *uiimage = [[UIImage alloc] initWithCGImage:imgRef];
        
    }
    
    NSLog(@"captureOutput - End");
}

-(void) orientationChanged {
    
    AVCaptureConnection *captureConnection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        //Updating preview layer orientation
        [_videoPreviewLayer setBounds:portraitLayerRect];
        [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(portraitLayerRect), CGRectGetMidY(portraitLayerRect))];
        [_videoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
        
        //Updating actual video orientation
        [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
    }else if (deviceOrientation == UIInterfaceOrientationPortrait){
        [_videoPreviewLayer setBounds:portraitLayerRect];
        [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(portraitLayerRect), CGRectGetMidY(portraitLayerRect))];
        [_videoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft){
        [_videoPreviewLayer setBounds:landscapeLayerRect];
        [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(landscapeLayerRect), CGRectGetMidY(landscapeLayerRect))];
        [_videoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
        [captureConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    }else{
        [_videoPreviewLayer setBounds:landscapeLayerRect];
        [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(landscapeLayerRect), CGRectGetMidY(landscapeLayerRect))];
        [_videoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        [captureConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
}


-(BOOL)toggleVideoRecording{
    
    if (!recordingInProgress){
        
        NSLog(@"START RECORDING");
        
        recordingInProgress = YES;
        
        //Create temporary URL to record to
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath]){
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO){
                //Error - handle if requried
            }
        }
        
        //Start recording
        [movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
    }else{
        NSLog(@"STOP RECORDING");
        recordingInProgress = NO;
        [movieFileOutput stopRecording];
    }
    return recordingInProgress;
}

- (BOOL)toggleCameraPosition{
    
    BOOL isBackCamera = YES;
    //Only do if device has multiple cameras
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1){
        NSLog(@"Toggle camera");
        NSError *error;
        //AVCaptureDeviceInput *videoInput = [self videoInput];
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInputDevice device] position];
        if (position == AVCaptureDevicePositionBack){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&error];
            isBackCamera = NO;
        }else if (position == AVCaptureDevicePositionFront){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack] error:&error];
            isBackCamera = YES;
        }
        
        if (newVideoInput != nil){
            [captureSession beginConfiguration];//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [captureSession removeInput:videoInputDevice];
            if ([captureSession canAddInput:newVideoInput]){
                [captureSession addInput:newVideoInput];
                videoInputDevice = newVideoInput;
            }else{
                [captureSession addInput:videoInputDevice];
            }
            
            [captureSession commitConfiguration];
        }
    }
    return isBackCamera;
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if ([device position] == position){
            return device;
        }
    }
    return nil;
}

- (IBAction)backPressed:(id)sender {
    
}

- (IBAction)donePressed:(id)sender {
    
}

- (IBAction)toggleRecording:(id)sender {
    
    [playerViewController.view removeFromSuperview];
    BOOL recording = [self toggleVideoRecording];
    if(recording){
        [toggleRecordingButton setImage:[UIImage imageNamed:@"stop_recording.png"] forState:UIControlStateNormal];
    }else{
        [toggleRecordingButton setImage:[UIImage imageNamed:@"start_recording.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)toggleCamera:(id)sender {
    
    [playerViewController.view removeFromSuperview];
    BOOL isBackCamera = [self toggleCameraPosition];
    if(isBackCamera){
        [toggleCameraButton setImage:[UIImage imageNamed:@"front_camera_icon.png"] forState:UIControlStateNormal];
    }else{
        [toggleCameraButton setImage:[UIImage imageNamed:@"back_camera_icon.png"] forState:UIControlStateNormal];
    }
}


@end
