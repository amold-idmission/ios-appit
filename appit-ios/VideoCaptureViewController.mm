//
//  VideoCaptureViewController.m
//  appit-ios
//
//  Created by idmission on 30/09/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import "VideoCaptureViewController.h"
#import "ImageUtils.h"

@interface VideoCaptureViewController ()
- (BOOL)initVideoCameraSession:(NSInteger)camera qualityPreset:(NSString *)qualityPreset grayscale:(BOOL)grayscale;
- (void)destroyVideoCameraSession;
- (void)processFrame:(cv::Mat&)mat videoRect:(CGRect)rect videoOrientation:(AVCaptureVideoOrientation)orientation actualImage:(UIImage*)actualImage;
@end

@implementation VideoCaptureViewController

@synthesize captureSession = _captureSession;
@synthesize captureDevice = _captureDevice;
@synthesize videoOutput = _videoOutput;
@synthesize videoPreviewLayer = _videoPreviewLayer;

@synthesize camera = _camera;
@synthesize captureGrayscale = _captureGrayscale;
@synthesize qualityPreset = _qualityPreset;

@dynamic showDebugInfo;
@dynamic torchOn;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _camera = 1; //Setting Front Camera Default
    _qualityPreset = AVCaptureSessionPresetMedium;
    _captureGrayscale = YES;
    
    [self initVideoCameraSession:_camera qualityPreset:_qualityPreset grayscale:_captureGrayscale];
}

- (void)viewDidUnload {
    [self viewDidUnload];
    
    [self destroyVideoCameraSession];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self destroyVideoCameraSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set torch on or off (if supported)
- (void)setTorchOn:(BOOL)torch
{
    NSError *error = nil;
    if ([_captureDevice hasTorch]) {
        BOOL locked = [_captureDevice lockForConfiguration:&error];
        if (locked) {
            _captureDevice.torchMode = (torch)? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
            [_captureDevice unlockForConfiguration];
        }
    }
}

// Return YES if the torch is on
- (BOOL)torchOn
{
    return (_captureDevice.torchMode == AVCaptureTorchModeOn);
}

// Switch camera 'on-the-fly'
//
// camera: 0 for back camera, 1 for front camera
//
- (void)setCamera:(int)camera
{
    if (camera != _camera)
    {
        _camera = camera;
        
        if (_captureSession) {
            NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            
            [_captureSession beginConfiguration];
            
            [_captureSession removeInput:[[_captureSession inputs] lastObject]];
            
            
            if (_camera >= 0 && _camera < [devices count]) {
                _captureDevice = [devices objectAtIndex:camera];
            }
            else {
                _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            }
            
            // Create device input
            NSError *error = nil;
            AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:&error];
            [_captureSession addInput:input];
            
            [_captureSession commitConfiguration];
        }
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate delegate methods

// AVCaptureVideoDataOutputSampleBufferDelegate delegate method called when a video frame is available
//
// This method is called on the video capture GCD queue. A cv::Mat is created from the frame data and
// passed on for processing with OpenCV.
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    UIImage *actualImage = [ImageUtils UIImageFromSampleBuffer:sampleBuffer];
    if(_camera == 0){
        actualImage = [ImageUtils rotatingUIImageByOrientation:actualImage fromImageOrientation:UIImageOrientationRight];
    }else{
        actualImage = [ImageUtils rotatingUIImageByOrientation:actualImage fromImageOrientation:UIImageOrientationRightMirrored];
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    /*Get information about the image*/
    unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t stride = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    try {
        AVCaptureVideoOrientation videoOrientation = [[[_videoOutput connections] objectAtIndex:0] videoOrientation];
        CGRect videoRect = CGRectMake(0.0f, 0.0f, width, height);
        
        cv::Mat bgra((int)height, (int)width, CV_8UC4, baseAddress);
        
        [self processFrame:bgra videoRect:videoRect videoOrientation:videoOrientation actualImage:actualImage];
        
        //Drawing updated Mat image on preview layer
        CGImageRef imageRef = [ImageUtils CGImageFromCVMat:bgra];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.videoPreviewLayer.contents = (__bridge id)imageRef;
        });
        CGImageRelease(imageRef);
        
    } catch(NSException * e){
        NSLog(@"VideoCaptureViewController.captureOutput: %@", e);
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0 );
}

- (BOOL)initVideoCameraSession:(NSInteger)camera qualityPreset:(NSString *)qualityPreset grayscale:(BOOL)grayscale
{
    // Set up AV capture
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if ([devices count] == 0) {
        NSLog(@"No video capture devices found");
        return NO;
    }
    
    if (camera == -1) {
        _camera = -1;
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    else if (camera >= 0 && camera < [devices count]) {
        _camera = camera;
        _captureDevice = [devices objectAtIndex:camera];
    }
    else {
        _camera = -1;
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSLog(@"Camera number out of range. Using default camera");
    }
    
    NSError *error = nil;
    
    [_captureDevice lockForConfiguration:&error];
    if([_captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
        [_captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    [_captureDevice unlockForConfiguration];
    
    // Create the capture session
    _captureSession = [AVCaptureSession new];
    if (UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPhone){
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }else if(UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPad){
        _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    }else{
        NSLog(@"setupAVCapture : Unable to set sessionPreset");
    }
    
    // Create device input
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:&error];
    
    // Create and configure device output
    _videoOutput = [AVCaptureVideoDataOutput new];
    
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [_videoOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    
    // For grayscale mode, the luminance channel from the YUV fromat is used
    // For color mode, BGRA format is used
    OSType format = kCMPixelFormat_32BGRA;
    
    //    // Check YUV format is available before selecting it (iPhone 3 does not support it)
    //    if (grayscale && [_videoOutput.availableVideoCVPixelFormatTypes containsObject:
    //                      [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]) {
    //        format = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    //    }
    
    NSDictionary *rgbOutputSettings =[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:format] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [_videoOutput setVideoSettings:rgbOutputSettings];
    
    // Connect up inputs and outputs
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    }
    
    if ([_captureSession canAddOutput:_videoOutput]) {
        [_captureSession addOutput:_videoOutput];
    }
    
    
    // Create the preview layer
    /*
     * Initializing blank _videoPreviewLayer as we are going to display
     * updated Mat from 'captureOutput' method on preview screen
     */
    //Uncomment below line if actual frame need to be drawn on preview screen
    //    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    [_videoPreviewLayer setFrame:self.view.bounds];
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
    [_captureSession startRunning];
    return YES;
}

- (void)destroyVideoCameraSession
{
    [_captureSession removeOutput:_videoOutput];
    [_captureSession stopRunning];
    [_videoPreviewLayer removeFromSuperlayer];
    
    _videoPreviewLayer = nil;
    _videoOutput = nil;
    _captureDevice = nil;
    _captureSession = nil;
}

- (void)processFrame:(cv::Mat &)bgra videoRect:(CGRect)rect videoOrientation:(AVCaptureVideoOrientation)orientation actualImage:(UIImage*)actualImage
{
    
}

- (CGAffineTransform)affineTransformForVideoFrame:(CGRect)videoFrame orientation:(AVCaptureVideoOrientation)videoOrientation
{
    CGSize viewSize = self.view.bounds.size;
    NSString * const videoGravity = _videoPreviewLayer.videoGravity;
    CGFloat widthScale = 1.0f;
    CGFloat heightScale = 1.0f;
    
    // Move origin to center so rotation and scale are applied correctly
    CGAffineTransform t = CGAffineTransformMakeTranslation(-videoFrame.size.width / 2.0f, -videoFrame.size.height / 2.0f);
    
    switch (videoOrientation) {
        case AVCaptureVideoOrientationPortrait:
            widthScale = viewSize.width / videoFrame.size.width;
            heightScale = viewSize.height / videoFrame.size.height;
            break;
            
        case AVCaptureVideoOrientationPortraitUpsideDown:
            t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(M_PI));
            widthScale = viewSize.width / videoFrame.size.width;
            heightScale = viewSize.height / videoFrame.size.height;
            break;
            
        case AVCaptureVideoOrientationLandscapeRight:
            t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(M_PI_2));
            widthScale = viewSize.width / videoFrame.size.height;
            heightScale = viewSize.height / videoFrame.size.width;
            break;
            
        case AVCaptureVideoOrientationLandscapeLeft:
            t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(-M_PI_2));
            widthScale = viewSize.width / videoFrame.size.height;
            heightScale = viewSize.height / videoFrame.size.width;
            break;
    }
    
    // Adjust scaling to match video gravity mode of video preview
    if (videoGravity == AVLayerVideoGravityResizeAspect) {
        heightScale = MIN(heightScale, widthScale);
        widthScale = heightScale;
    }
    else if (videoGravity == AVLayerVideoGravityResizeAspectFill) {
        heightScale = MAX(heightScale, widthScale);
        widthScale = heightScale;
    }
    
    // Apply the scaling
    t = CGAffineTransformConcat(t, CGAffineTransformMakeScale(widthScale, heightScale));
    
    // Move origin back from center
    t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(viewSize.width / 2.0f, viewSize.height / 2.0f));
    
    return t;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
