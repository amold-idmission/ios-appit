//
//  FaceDetectionViewController.m
//  appit-ios
//
//  Created by idmission on 30/09/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import "FaceDetectionViewController.h"
#import "ImageUtils.h"
#import "NSStringUtils.h"
#import "NSLogUtils.h"

NSString * const SHOW_YOUR_FACE = @"Move Camera Closer To Face.", *TOO_DARK = @"It's too dark to take a good image.\nFind a place with better lighting.", *SMILE_PLEASE=@"Hold camera steady and smile please.", *FACE_DETECTED=@"Face Detected.", *LOW_FOCUS_DETECTED = @"Tap screen to focus \n or move camera closer/away";

@interface FaceDetectionViewController ()

@property int continuousLowLightDetectedCounter, maxLowLightDetectionCounter;
@property int continuousFaceNotDetectedCounter, maxFaceNotDetectedCounter;
@property int continuosCameraMovementCounter, maxCameraMovementCounter;
@property int continuosFaceMovementCounter, maxFaceMovementCounter;
@property int goodFaceDetectionCounter;
@property double secondFrameSmileDetectionPercentage, secondFrameFaceWidthPercentage, secondFrameXPosition, secondFrameYPosition;
@property int allComponentDetectionCounter;
@property double secondFrameFaceHeightPercentage, secondFrameNosePosition, secondFrameNoseMouthDifPercentage, noseMouthDiffPercentage;
@property double smileDiffPercentage;

@property int minFaceWidth, minFaceHeight;
@property cv::CascadeClassifier *faceCascade, *mouthCascade, *eyeCascade, *openEyeCascade, *noseCascade;

@property cv::Mat resultMat;

@end

@implementation FaceDetectionViewController{
    NSMutableDictionary *resultDictionary;
    
    UIButton *flashUIButton, *lightHintUIButton, *smileHintUIButton;
    UILabel *hintMsgUILabel;
    NSBundle * frameworkBundle;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _light_threshold = 60;
        _focus_threshold = 20;
        _face_width_diff_percentage_threshold = 1.7;
        _smile_width_percentage_threshold = 15;
        _face_movement_percentage_threshold = 15;
        _face_height_diff_percentage_threshold = 2.0;
        _nose_movement_percentage_threshold = 1.5;
        
        _continuousLowLightDetectedCounter = 0;
        _maxLowLightDetectionCounter = 5;
        
        _continuousFaceNotDetectedCounter = 0;
        _maxFaceNotDetectedCounter = 10;
        
        _continuosCameraMovementCounter=0;
        _maxCameraMovementCounter=10;
        
        _continuosFaceMovementCounter=0;
        _maxFaceMovementCounter=10;
        
        _allComponentDetectionCounter = 0;
        
        _secondFrameFaceWidthPercentage=0;
        _secondFrameSmileDetectionPercentage=0;
        _secondFrameXPosition=0;
        _secondFrameYPosition=0;
        _smileDiffPercentage=0;
        
        _image_size = 500;
        
        _faceCascade = nil;
        _mouthCascade = nil;
        _eyeCascade = nil;
        _openEyeCascade = nil;
        _noseCascade = nil;
        
        //Setting default value.
        _resultDictionary = [NSMutableDictionary new];
        
        //By default setting responseStatus to back press response code
        _responseStatus = @"18";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set language bundle according to given configuration
    //[[BundleLocalization sharedInstance] setLanguageForFramework:[AppItSDK getLanguage]];
    
    _resultDictionary = [NSMutableDictionary new];
    
    // Do any additional setup after loading the view.
    self.captureGrayscale = YES;
    self.qualityPreset = AVCaptureSessionPresetMedium;
    
    //Load bundle
    frameworkBundle = [NSBundle mainBundle];
    
    //    NSString *faceCascadePath = [frameworkBundle pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    //    NSString *faceCascadePath = [frameworkBundle pathForResource:@"frontalface_default" ofType:@"xml"];
    NSString *faceCascadePath = [frameworkBundle pathForResource:@"lbpcascade_frontalface_fd" ofType:@"xml" inDirectory:@"/opencvdata"];
    _faceCascade = new cv::CascadeClassifier([faceCascadePath UTF8String]);
    
    //    NSString *mouthCascadePath = [frameworkBundle pathForResource:@"haarcascade_smile" ofType:@"xml"];
    NSString *mouthCascadePath = [frameworkBundle pathForResource:@"mouth" ofType:@"xml" inDirectory:@"/opencvdata"];
    _mouthCascade = new cv::CascadeClassifier([mouthCascadePath UTF8String]);
    
    //    NSString *eyeCascadePath = [frameworkBundle pathForResource:@"haarcascade_lefteye_2splits" ofType:@"xml"];
    NSString *eyeCascadePath = [frameworkBundle pathForResource:@"eye" ofType:@"xml" inDirectory:@"/opencvdata"];
    _eyeCascade = new cv::CascadeClassifier([eyeCascadePath UTF8String]);
    
    NSString *openEyeCascadePath = [frameworkBundle pathForResource:@"haarcascade_eye" ofType:@"xml" inDirectory:@"/opencvdata"];
    _openEyeCascade = new cv::CascadeClassifier([openEyeCascadePath UTF8String]);
    
    NSString *noseCascadePath = [frameworkBundle pathForResource:@"nose" ofType:@"xml" inDirectory:@"/opencvdata"];
    _noseCascade = new cv::CascadeClassifier([noseCascadePath UTF8String]);
    
    
    //Launch camera according to confugured value
    if(_launch_front_camera){
        NSString *icon = [frameworkBundle pathForResource:@"front_camera_icon" ofType:@"png"];
        [switchCameraButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [flashButton setHidden:true];
        [flashUIButton setHidden:true];
    }else{
        [self toggleCameraView];
    }
    
    //Disabling switch camera button
    [switchCameraButton setHidden:true];
    
    int viewHeight = self.view.bounds.size.height;
    int viewWidth = self.view.bounds.size.width;
    
    if(!_launch_front_camera){
        //Adding flash button programatically to manitain its position consistent on diffrent devices
        [flashButton setHidden:true];//Hidding button from storyboard
        
        CGRect flashButtonRect = CGRectMake(viewWidth/2-30, viewHeight-60 ,50,50);
        flashUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [flashUIButton addTarget:self action:@selector(toggle_flash:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *icon = [frameworkBundle pathForResource:@"flash_off_icon" ofType:@"png"];
        [flashUIButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [flashUIButton setFrame:flashButtonRect];
        
        [self.view addSubview:flashUIButton];
    }
    
    //Adding hint icon-start
    //Light-Hint icon
    lightHintUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    CGRect lightButtonRect = CGRectMake(10, viewHeight-60, 50, 50);
    CGRect lightButtonRect = CGRectMake(5, 55, 100, 100);
    [lightHintUIButton setFrame:lightButtonRect];
    
    [self.view addSubview:lightHintUIButton];
    
    //Smile-Hint icon
    smileHintUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    CGRect smileButtonRect = CGRectMake(viewWidth-60, viewHeight-60 , 50, 50);
    CGRect smileButtonRect = CGRectMake(viewWidth-120, 55 , 100, 100);
    [smileHintUIButton setFrame:smileButtonRect];
    
    [self.view addSubview:smileHintUIButton];
    //Adding hint icon-end
    
    //Adding hint label-Start
    CGRect hintMsgUILabelRect = CGRectMake(60, 0 ,viewWidth-80,60);
    hintMsgUILabel = [[UILabel alloc] initWithFrame:hintMsgUILabelRect];
    [hintMsgUILabel setNumberOfLines:0];
    [hintMsgUILabel setLineBreakMode:NSLineBreakByWordWrapping];
    [hintMsgUILabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:hintMsgUILabel];
    //Adding hint label-End
    
    //Update text style-Start
    [NSStringUtils setLabelStyle:hintMsgUILabel];
    [NSStringUtils setLabelStyle:thresholdLabel];
    //Update text style-End
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _faceCascade = nil;
    _mouthCascade = nil;
    _eyeCascade = nil;
    _openEyeCascade = nil;
    _noseCascade = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    if(nil != _delegate){
//        [_delegate faceDetectionResponse:_resultDictionary];
//    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [NSLogUtils printLogInDebugMode:@""];
}


- (IBAction)toggleFlash:(id)sender {
    self.torchOn = !self.torchOn;
    
    if(self.torchOn){
        NSString *icon = [frameworkBundle pathForResource:@"flash_on_icon" ofType:@"png"];
        [flashButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }else{
        NSString *icon = [frameworkBundle pathForResource:@"flash_off_icon" ofType:@"png"];
        [flashButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
}

-(void)toggle_flash:(id)sender{
    self.torchOn = !self.torchOn;
    
    if(self.torchOn){
        NSString *icon = [frameworkBundle pathForResource:@"flash_on_icon" ofType:@"png"];
        [flashUIButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }else{
        NSString *icon = [frameworkBundle pathForResource:@"flash_off_icon" ofType:@"png"];
        [flashUIButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
}

- (IBAction)toggleCamera:(id)sender {
    
    [self toggleCameraView];
}

-(void)toggleCameraView{
    
    if (self.camera == 1) {
        self.camera = 0;  //Back Camera Enable
        NSString *icon = [frameworkBundle pathForResource:@"back_camera_icon" ofType:@"png"];
        [switchCameraButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [flashButton setHidden:false];
        [flashUIButton setHidden:false];
    }
    else
    {
        self.camera = 1;  //Front Camera Enable
        NSString *icon = [frameworkBundle pathForResource:@"front_camera_icon" ofType:@"png"];
        [switchCameraButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        [flashButton setHidden:true];
        [flashUIButton setHidden:true];
    }
}

- (IBAction)backPressed:(id)sender {
    
    //Setting response code 18 for back press
    _responseStatus = @"18";
    
    [self exitFromFaceDetectionScreen];
}

- (void)processFrame:(cv::Mat &)bgraMat videoRect:(CGRect)rect videoOrientation:(AVCaptureVideoOrientation)videOrientation actualImage:(UIImage*)actualImage
{
    if([_responseStatus isEqualToString:@"0"]){
        return;
    }
    // Rotate video frame by 90deg to portrait by combining a transpose and a flip
    // Note that AVCaptureVideoDataOutput connection does NOT support hardware-accelerated
    // rotation and mirroring via videoOrientation and setVideoMirrored properties so we
    // need to do the rotation in software here.
    cv::transpose(bgraMat, bgraMat);
    
    if (videOrientation == AVCaptureVideoOrientationLandscapeRight){
        // flip around y axis for back camera
        cv::flip(bgraMat, bgraMat, 1);
    }else {
        // Front camera output needs to be mirrored to match preview layer
        // so no flip is required here
    }
    
    //TODO need to check if it require or not
    //    videOrientation = AVCaptureVideoOrientationPortrait;
    
    cv::Mat grayMat;
    cv::cvtColor(bgraMat, grayMat, cv::COLOR_BGR2GRAY);
    
    //Calculating Light and Focus in current frame -Start
    cv::Mat hsv;
    cv::resize(bgraMat, hsv, cv::Size(), (double)1/4, (double)1/4, cv::INTER_LINEAR);
    cv::cvtColor(hsv, hsv, cv::COLOR_BGR2HSV_FULL);
    std::vector<cv::Mat> channels;
    cv::split(hsv, channels);
    
    //TODO When we flip camera we get one black frame still it has good light and focus score..need to avoid it
    int lightScore = [self getLightLevel:channels[2]];
    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat: @"FACE : light score: %d", lightScore]];
    lightScore = lightScore*0.8;
    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"FACE : light score modified: %d", lightScore]];
    
    int focusScore = [self getFocusScore:channels[2]];
    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"FACE : focus score: %d", focusScore]];
    focusScore = focusScore*1.5;
    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"FACE : focus score modified: %d", focusScore]];
    
    hsv.release();
    //Calculating Light and Focus in current frame -End
    
    bool lowLightDetected = false, lowFocusDetected = false;
    
    if(lightScore <= _light_threshold){
        [NSLogUtils printLogInDebugMode:@"FACE : Low light detected"];
        _continuousLowLightDetectedCounter++;
        lowLightDetected = true;
    }else{
        _continuousLowLightDetectedCounter = 0;
        lowLightDetected = false;
    }
    
    if(focusScore <= _focus_threshold){
        [NSLogUtils printLogInDebugMode:@"FACE : Low Focus detected"];
        lowFocusDetected = true;
    }else{
        lowFocusDetected = false;
    }
    
    if(_continuousLowLightDetectedCounter > _maxLowLightDetectionCounter ){
        [self updateStatus:NSLocalizedString(@"low_light_msg_fd", @"")];
        [self updateStatusIcon:@"light_gray" smileIcon:@"smile_gray"];
    }else if(lowFocusDetected){
        [self updateStatus:NSLocalizedString(@"out_of_focus_fd", @"")];
        [self updateStatusIcon:@"light_gray" smileIcon:@"smile_gray"];
    }else if(_allComponentDetectionCounter < 3){
        [self updateStatus:NSLocalizedString(@"move_camera_closer_to_your_face", @"")];
        [self updateStatusIcon:@"light_green" smileIcon:@"smile_orange"];
    }
    
    if ((_continuousLowLightDetectedCounter > _maxLowLightDetectionCounter)
        || (_continuousFaceNotDetectedCounter > _maxFaceNotDetectedCounter)
        || (_continuosCameraMovementCounter > _maxCameraMovementCounter)
        || (_continuosFaceMovementCounter > _maxFaceMovementCounter)){
        [self resetResultCalculationValues];
    }
    
    _smileDiffPercentage = 0;
    
    if(!lowLightDetected && !lowFocusDetected){
        [NSLogUtils printLogInDebugMode:@"FACE : Processing frames"];
        
        //Maintaining actual bgra mat copy ...before drawing any component in actual bgraMat
        cv::Mat bgraResultMat;
        bgraMat.copyTo(bgraResultMat);
        
        _minFaceWidth = (int)bgraMat.cols*0.2;
        _minFaceHeight = (int)bgraMat.rows*0.2;
        
        
        bool isFaceDetected=false, isMouthDetected=false, isEyesDetected=false, isNoseDetected=false;
        
        cv::Rect faceRect = [self getBiggestFaceRectInFrame:grayMat minWidth:_minFaceWidth minHeight:_minFaceHeight];
        
        if(faceRect.area() > 0 && [self isRectInside:grayMat rect:faceRect]){
            [NSLogUtils printLogInDebugMode:@"FACE : Face detected"];
            isFaceDetected = true;
            _continuousFaceNotDetectedCounter = 0;
            
            //Drawing Face Here
            [self drawFace:bgraMat faceRect:faceRect];
            
            //Cropped Face Mat From Gray Frame
            cv::Mat grayFaceMat;
            grayMat(faceRect).copyTo(grayFaceMat);
            
            /********************************
             * Calculating approx area of Mouth
             ********************************/
            
            int mouthX1 = 0;
            int mouthY1 = (int)round(faceRect.height*0.5);
            cv::Mat approxMouthMat = cv::Mat(grayFaceMat, cv::Rect(mouthX1, mouthY1, faceRect.width-mouthX1, faceRect.height- mouthY1));
            
            //Detecting mouth
            cv::Rect mouthRect = [self getMouthRectInFrame:approxMouthMat];
            
            //Mouth Rect in actual mRgba and mGray frame
            cv::Rect mouthRectInFrame;
            
            //Releasing approxMouthMat
            approxMouthMat.release();
            
            if(mouthRect.area()>0){
                [NSLogUtils printLogInDebugMode:@"FACE : Mouth detected"];
                isMouthDetected = true;
                
                //Drawing Mouth Here
                mouthRectInFrame = [self drawMouth:bgraMat faceRect:faceRect mouthRect:mouthRect mouthX1:mouthX1 mouthY1:mouthY1];
            }
            
            /*********************************************
             *Calculating approx area of Left and Right Eyes
             *********************************************/
            cv::Rect rightEyeArea = cv::Rect(faceRect.x + faceRect.width / 16,
                                             (int) (faceRect.y + (faceRect.height / 4.5)),
                                             (faceRect.width - 2 * faceRect.width / 16) / 2,
                                             (int) (faceRect.height / 3.0));
            cv::Rect leftEyeArea = cv::Rect(faceRect.x + faceRect.width / 16 + (faceRect.width - 2 * faceRect.width / 16) / 2,
                                            (int) (faceRect.y + (faceRect.height / 4.5)),
                                            (faceRect.width - 2 * faceRect.width / 16) / 2,
                                            (int) (faceRect.height / 3.0));
            //Detecting Left and right Eye
            cv::Mat approxRightEyeMat;
            cv::Mat approxLeftEyeMat;
            grayMat(rightEyeArea).copyTo(approxRightEyeMat);
            grayMat(leftEyeArea).copyTo(approxLeftEyeMat);
            
            cv::Rect rightEyeRect = [self getEyeRectInFrame:approxRightEyeMat];
            cv::Rect leftEyeRect = [self getEyeRectInFrame:approxLeftEyeMat];
            
            cv::Rect rightEyeRectInFrame;
            cv::Rect leftEyeRectInFrame;
            if(rightEyeRect.area()>0 && leftEyeRect.area()>0){
                [NSLogUtils printLogInDebugMode:@"FACE : Eyes detected"];
                isEyesDetected = true;
                
                //Drawing Eyes Here
                rightEyeRectInFrame = [self drawEye:bgraMat faceRect:faceRect eyeRect:rightEyeRect eyeX1:rightEyeArea.tl().x eyeY1:rightEyeArea.tl().y];
                leftEyeRectInFrame = [self drawEye:bgraMat faceRect:faceRect eyeRect:leftEyeRect eyeX1:leftEyeArea.tl().x eyeY1:leftEyeArea.tl().y];
            }
            approxRightEyeMat.release();
            approxLeftEyeMat.release();
            
            /********************************
             * Calculating approx area of Nose
             ********************************/
            //            int noseX1 = round(faceRect.width * 0.3);
            int noseX1 = 0;
            int noseY1 = round(faceRect.height * 0.4);
            cv::Rect approxNoseRect = cv::Rect(noseX1, noseY1, faceRect.width - noseX1, faceRect.height*0.50);
            cv::Mat approxNoseMat = cv::Mat(grayFaceMat, approxNoseRect);
            //            cv::Mat approxNoseMat;
            //            grayFaceMat.copyTo(approxNoseMat);
            //
            //            //Existing
            //            [self returnMaskImage:approxNoseMat areaToMask:approxNoseRect];
            
            //Detecting nose
            cv::Rect nose = [self getNoseRectInFrame:approxNoseMat];
            
            //Releasing approxNoseMat
            approxNoseMat.release();
            
            //Nose Rect in actual mRgba and mGray frame
            cv::Rect noseRectInFrame;
            if(nose.area()>0){
                [NSLogUtils printLogInDebugMode:@"FACE : Nose detected"];
                isNoseDetected = true;
                
                
                noseRectInFrame = [self drawNose:bgraMat faceRect:faceRect noseRect:nose noseX1:noseX1 noseY1:noseY1];
                //Existing
                //                noseRectInFrame = [self drawNose:bgraMat faceRect:faceRect noseRect:nose noseX1:0 noseY1:0];
            }
            //Releasing grayFaceMat
            grayFaceMat.release();
            
            if(isFaceDetected && isMouthDetected && isEyesDetected && isNoseDetected){
                _allComponentDetectionCounter++;
                
                double rightEyeCenter = rightEyeRectInFrame.tl().y + rightEyeRectInFrame.height / 2;
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: rightEyeCenter : %f", rightEyeCenter]];
                double noseCenter =  noseRectInFrame.tl().y + noseRectInFrame.height / 2;
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: noseCenter : %f", noseCenter]];
                
                //                double currentFrameFaceHeightPercentage = ((double)faceRect.height/bgraMat.rows)*100.0;
                double currentFrameFaceHeightPercentage = ((double)(noseCenter-rightEyeCenter)/bgraMat.rows)*100.0;
                //                [NSLogUtils printLogInDebugMode:@"Current Frame: faceRect.height : %d mRgba.height() : %d",faceRect.height, bgraMat.rows);
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: nose_eye_diff : %f mRgba.height() : %d",(noseCenter-rightEyeCenter), bgraMat.rows]];
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: current_Frame_Face_Height_Percentage : %f", currentFrameFaceHeightPercentage]];
                
                double currentFrameNosePosition = ((double)(noseRectInFrame.tl().x + noseRectInFrame.width/2)/bgraMat.cols)*100.0;
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: noseRect.tl().x : %d mRgba.width() %d :",noseRectInFrame.tl().x, bgraMat.cols]];
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: currentFrameNosePosition : %f ",currentFrameNosePosition]];
                
                double currentFrameNoseMouthDifPercentage  = ((mouthRectInFrame.tl().y - noseRectInFrame.tl().y)/(noseCenter-rightEyeCenter))*100;
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: Nose : mouthRectInFrame.tl().y : %d noseRectInFrame.tl().y : %d", mouthRectInFrame.tl().y, noseRectInFrame.tl().y]];
                [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: Nose : current_Frame_Nose_Mouth_Dif_Percentage: %f ", currentFrameNoseMouthDifPercentage]];
                
                if(currentFrameFaceHeightPercentage < 8.5){
                    //remove the face oval when the camera is too far
                    bgraMat = bgraResultMat.clone();
                    [self resetResultCalculationValues];
                }
                
                if(_allComponentDetectionCounter == 3){
                    [self updateStatus:NSLocalizedString(@"smile_please", @"")];
                    [self updateStatusIcon:@"light_green" smileIcon:@"face_smile_orange"];
                    
                    //Maintain result image here...if face is detected then use this image as result image
                    bgraResultMat.copyTo(_resultMat);
                    
                    //Maintaining this value for detecting difference between 2nd frame and upcoming frame, this will be used for checking if camera is moving
                    _secondFrameFaceHeightPercentage = currentFrameFaceHeightPercentage;
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Frame 2nd: faceRect.height : %d mRgba.height() : %d", faceRect.height, bgraMat.rows]];
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Frame 2nd: second_Frame_Face_Height_Percentage : %f", _secondFrameFaceHeightPercentage]];
                    
                    _secondFrameNosePosition = currentFrameNosePosition;
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Frame 2nd: noseRect.tl().x : %d mRgba.width() : %d", noseRectInFrame.tl().x, bgraMat.cols]];
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Frame 2nd: secondFrameNosePosition : %f",_secondFrameNosePosition]];
                    
                    _secondFrameNoseMouthDifPercentage = currentFrameNoseMouthDifPercentage;
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Frame 2nd: Nose : mouthRectInFrame.tl().y : %d noseRectInFrame.tl().y : %d faceRect.height : %d ", mouthRectInFrame.tl().y, noseRectInFrame.tl().y, faceRect.height]];
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Frame 2nd: Nose : second_Frame_Nose_Mouth_Dif_Percentage: %f ", _secondFrameNoseMouthDifPercentage]];
                }
                
                if(_allComponentDetectionCounter>3){
                    
                    double heightPercentageDiff = std::abs(currentFrameFaceHeightPercentage - _secondFrameFaceHeightPercentage);
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: Height_Percentage_Absolute_Difference : %f",heightPercentageDiff]];
                    
                    double noseXMovementPercentage = std::abs(currentFrameNosePosition - _secondFrameNosePosition);
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: nose_X_Movement_Percentage : %f",noseXMovementPercentage]];
                    
                    _noseMouthDiffPercentage = std::abs(currentFrameNoseMouthDifPercentage - _secondFrameNoseMouthDifPercentage);
                    [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"Current Frame: Nose : Nose_Mouth_Absolute_Diff_Percentage Between Frames: %f ", _noseMouthDiffPercentage]];
                    
                    if(currentFrameFaceHeightPercentage < 14){
                        double currentFrameFaceHgtPerc = 14 / currentFrameFaceHeightPercentage;
                        if(currentFrameFaceHgtPerc > 1.4){
                            currentFrameFaceHgtPerc = 1.4;
                        }
                        _noseMouthDiffPercentage = _noseMouthDiffPercentage*(currentFrameFaceHgtPerc);
                    }
                    //If true, It means camrea is moving
                    if (heightPercentageDiff > _face_height_diff_percentage_threshold) {
                        _continuosCameraMovementCounter++;
                    }else {
                        _continuosCameraMovementCounter=0;
                    }
                    
                    if (noseXMovementPercentage > _nose_movement_percentage_threshold) {
                        _continuosFaceMovementCounter++;
                    }else {
                        _continuosFaceMovementCounter=0;
                    }
                    
                    //diffPercentage should be greater than configured threshold
                    if ((_noseMouthDiffPercentage >= _smile_width_percentage_threshold) &&
                        (_noseMouthDiffPercentage < _smile_width_percentage_threshold+25)
                        &&(heightPercentageDiff <= _face_height_diff_percentage_threshold)
                        &&(noseXMovementPercentage <= _nose_movement_percentage_threshold )) {
                        
                        _goodFaceDetectionCounter++;
                        
                        if(_goodFaceDetectionCounter > 1){
                            [NSLogUtils printLogInDebugMode:@"FACE : Face detected"];
                            [self updateMessage:lightScore focusScore:focusScore noseMouthDiff:_noseMouthDiffPercentage];
                            [self updateStatus:NSLocalizedString(@"face_detected", @"")];
                            [self updateStatusIcon:@"light_green" smileIcon:@"smile_green"];
                            //Maintain final result image
                            [self maintainFinalImages:_resultMat];
                            
                            //Setting response code 0 for success status
                            _responseStatus = @"0";
                            [self performSelectorOnMainThread:@selector(exitFromFaceDetectionScreen) withObject:self waitUntilDone:FALSE];
                        }
                    }else{
                        _goodFaceDetectionCounter=0;
                        if((heightPercentageDiff > _face_height_diff_percentage_threshold)
                           || (noseXMovementPercentage > _nose_movement_percentage_threshold)){
                            _noseMouthDiffPercentage=0;
                            [self updateStatus:NSLocalizedString(@"camera_movement", @"")];
                            [self updateStatusIcon:@"light_green" smileIcon:@"smile_orange"];
                        }else{
                            [self updateStatus:NSLocalizedString(@"smile_please", @"")];
                            [self updateStatusIcon:@"light_green" smileIcon:@"face_smile_orange"];
                        }
                    }
                }
            }
        }else{
            _continuousFaceNotDetectedCounter++;
        }
    }
    
    [self updateMessage:lightScore focusScore:focusScore noseMouthDiff:_noseMouthDiffPercentage];
}

-(void)updateMessage:(int)lightScore focusScore:(int)focusScore noseMouthDiff:(double)noseMouthDiff{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *light = NSLocalizedString(@"light", @"");
        NSString *focus = NSLocalizedString(@"focus", @"");
        NSString *smile = NSLocalizedString(@"smile", @"");
        
        //TODO update string for multilingual support
        NSString *label = [NSString stringWithFormat:@"%@: %.0d %@: %.0d %@ %: %.0f", light, lightScore, focus, focusScore, smile, noseMouthDiff];
        
        [thresholdLabel setText:label];
    });
}

-(void)updateStatus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hintMsgUILabel setText:status];
    });
}

-(void)updateStatusIcon:(NSString*)lightIcon smileIcon:(NSString*)smileIcon{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *light_icon = [frameworkBundle pathForResource:lightIcon ofType:@"png"];
        [lightHintUIButton setImage:[UIImage imageNamed:light_icon] forState:UIControlStateNormal];
        
        NSString *smile_icon = [frameworkBundle pathForResource:smileIcon ofType:@"png"];
        [smileHintUIButton setImage:[UIImage imageNamed:smile_icon] forState:UIControlStateNormal];
        
    });
}

-(int)getLightLevel:(cv::Mat&)channel{
    return cv::mean(channel)[0];
}

-(int)getFocusScore:(cv::Mat&)channel{
    assert(channel.channels() == 1);
    assert(channel.depth() == CV_8U);
    
    cv::Mat sobel_image;
    cv::Sobel(channel, sobel_image, CV_16S, 1, 1);
    
    //    cv::Mat r = cv::abs(sobel_image);
    cv::Mat r;
    cv::absdiff(sobel_image, cv::Scalar(0), r);
    cv::Scalar meanScalar,devScalar;
    
    cv::meanStdDev(r, meanScalar, devScalar);
    return devScalar[0];
}

-(cv::Rect)getBiggestFaceRectInFrame:(cv::Mat&)grayMat minWidth:(int)minWidth minHeight:(int)minHeight{
    
    cv::Rect faceRect;
    
    if(nil!=_faceCascade && !grayMat.empty()){
        
        std::vector<cv::Rect> faceRects;
        
        _faceCascade->detectMultiScale(grayMat, faceRects, 1.1, 2, CV_HAAR_SCALE_IMAGE, cv::Size(minWidth, minHeight));
        
        [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"getBiggestFaceRectInFrame face rects size: %lu",faceRects.size()]];
        
        if(faceRects.size() > 0){
            
            for (int i=0; i<faceRects.size(); i++) {
                cv::Rect rect = faceRects[i];
                
                if(faceRect.area() < rect.area()){
                    faceRect = rect;
                }
            }
        }
    }
    return faceRect;
}

-(cv::Rect)getMouthRectInFrame:(cv::Mat&)grayMat{
    
    cv::Rect mouthRect;
    
    if(nil!=_mouthCascade && !grayMat.empty()){
        
        std::vector<cv::Rect> mouthRects;
        
        _mouthCascade->detectMultiScale(grayMat, mouthRects, 1.2, 10, 0, cv::Size(grayMat.cols*0.3, grayMat.rows*0.1), cv::Size(grayMat.cols, grayMat.rows));
        
        [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"getMouthRectInFrame mouth rects size: %lu",mouthRects.size()]];
        
        if(mouthRects.size() > 0){
            
            for (int i=0; i<mouthRects.size(); i++) {
                cv::Rect rect = mouthRects[i];
                
                if(mouthRect.area() < rect.area()){
                    mouthRect = rect;
                }
            }
        }
    }
    return mouthRect;
}

-(cv::Rect)getEyeRectInFrame:(cv::Mat&)grayMat{
    cv::Rect eyeRect;
    
    if(nil!=_eyeCascade && nil!=_openEyeCascade && !grayMat.empty()){
        
        std::vector<cv::Rect> eyeRects;
        if(_allComponentDetectionCounter > 2){
            _eyeCascade->detectMultiScale(grayMat, eyeRects, 1.15, 2, CV_HAAR_FIND_BIGGEST_OBJECT|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
        }else{
            _openEyeCascade->detectMultiScale(grayMat, eyeRects, 1.15, 2, CV_HAAR_FIND_BIGGEST_OBJECT|CV_HAAR_SCALE_IMAGE, cv::Size(30, 30));
        }
        
        [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"getEyeRectInFrame eye rects size: %lu",eyeRects.size()]];
        
        if(eyeRects.size() > 0){
            
            for (int i=0; i<eyeRects.size(); i++) {
                cv::Rect rect = eyeRects[i];
                
                if(eyeRect.area() < rect.area()){
                    eyeRect = rect;
                }
            }
        }
    }
    
    return eyeRect;
}

-(cv::Rect)getNoseRectInFrame:(cv::Mat&)grayMat{
    cv::Rect noseRect;
    
    if(nil!=_noseCascade && !grayMat.empty()){
        
        std::vector<cv::Rect> noseRects;
        
        _noseCascade->detectMultiScale(grayMat, noseRects, 1.13, 2, CV_HAAR_FIND_BIGGEST_OBJECT|CV_HAAR_SCALE_IMAGE, cv::Size(15, 15));
        
        [NSLogUtils printLogInDebugMode:[NSString stringWithFormat:@"getNoseRectInFrame nose rects size: %lu",noseRects.size()]];
        
        if(noseRects.size() > 0){
            
            for (int i=0; i<noseRects.size(); i++) {
                cv::Rect rect = noseRects[i];
                
                if(noseRect.area() < rect.area()){
                    noseRect = rect;
                }
            }
        }
    }
    
    return noseRect;
}

-(BOOL)isRectInside:(cv::Mat &)mMat rect:(cv::Rect)mRect{
    cv::Rect rect_mat(0, 0, mMat.cols, mMat.rows);
    return (mRect & rect_mat) == mRect;
}


-(void)drawFace:(cv::Mat&)rgba faceRect:(cv::Rect)faceRect{
    
    double xCenter = faceRect.x + (faceRect.width/2);
    double yCenter = faceRect.y + (faceRect.height/2);
    cv::Point center = cv::Point(xCenter, yCenter);
    
    // Covering outside area of face with color
    cv::Mat blur = cv::Mat(rgba.size(), rgba.type());
    cv::rectangle(blur, cv::Point(0, 0), cv::Point(rgba.size().width, rgba.size().height), cv::Scalar(255, 255, 255), cv::FILLED);
    cv::Mat mask = cv::Mat::ones(rgba.size(), rgba.type());
    cv::bitwise_not(mask, mask);
    cv::ellipse(mask, center, cv::Size(faceRect.width * 0.52, faceRect.height * 0.7), 0, 0, 360, cv::Scalar(0, 0, 0), cv::FILLED, cv::FILLED, 0);
    blur.copyTo(rgba, mask);
}

-(cv::Rect)drawMouth:(cv::Mat&)rgba faceRect:(cv::Rect)faceRect mouthRect:(cv::Rect)mouthRect mouthX1:(int)mouthX1 mouthY1:(int)mouthY1{
    
    cv::Point pt1 = cv::Point(faceRect.tl().x + mouthX1 + mouthRect.x,
                              faceRect.tl().y + mouthY1 + mouthRect.y);
    
    cv::Point center = cv::Point(pt1.x + (mouthRect.width/ 2), pt1.y + (mouthRect.height/2));
    
    cv::ellipse(rgba, center, cv::Size(mouthRect.width * 0.6, mouthRect.height * 0.5),
                0, 0, 360, cv::Scalar(250, 250, 250, 80), 2, cv::LINE_AA, 0);
    
    cv::Point pt2 = cv::Point(faceRect.tl().x + mouthX1 + mouthRect.br().x,
                              faceRect.tl().y + mouthY1 + mouthRect.br().y);
    
    return cv::Rect(pt1, pt2);
}

-(cv::Rect)drawEye:(cv::Mat&)rgba faceRect:(cv::Rect)faceRect eyeRect:(cv::Rect)eyeRect eyeX1:(int)eyeX1 eyeY1:(int)eyeY1{
    
    cv::Point pt1 = cv::Point(eyeX1+eyeRect.tl().x, eyeY1+eyeRect.tl().y);
    
    cv::Point center = cv::Point(pt1.x + (eyeRect.width/ 2), pt1.y + (eyeRect.height/2));
    
    cv::ellipse(rgba, center, cv::Size(eyeRect.width * 0.7, eyeRect.height * 0.5),
                0, 0, 360, cv::Scalar(250, 250, 250, 80), 2, cv::LINE_AA, 0);
    
    cv::Point pt2 = cv::Point(eyeX1+eyeRect.width, eyeY1+eyeRect.height);
    
    return cv::Rect(pt1, pt2);
}

-(cv::Rect)drawNose:(cv::Mat&)rgba faceRect:(cv::Rect)faceRect noseRect:(cv::Rect)noseRect noseX1:(int)noseX1 noseY1:(int)noseY1{
    
    cv::Point pt1 = cv::Point(faceRect.tl().x + noseX1 + noseRect.x, faceRect.tl().y + noseY1 + noseRect.y);
    
    cv::Point center = cv::Point(pt1.x + (noseRect.width/ 2), pt1.y + (noseRect.height/2));
    cv::ellipse(rgba, center, cv::Size(noseRect.width * 0.4, noseRect.height * 0.4), 0, 0, 360, cv::Scalar(250, 250, 250, 80), 2, cv::LINE_AA, 0);
    
    cv::Point pt2 = cv::Point(faceRect.tl().x + noseX1 + noseRect.br().x, faceRect.tl().y + noseY1 + noseRect.br().y);
    
    return cv::Rect(pt1, pt2);
}

-(void)resetResultCalculationValues{
    //Counter
    _allComponentDetectionCounter = 0;
    _continuousFaceNotDetectedCounter = 0;
    _continuosCameraMovementCounter = 0;
    _continuosFaceMovementCounter = 0;
    //For result checking
    //    _secondFrameFaceWidthPercentage = 0.0;
    //    _secondFrameSmileDetectionPercentage = 0.0;
    _secondFrameFaceHeightPercentage = 0.0;
    _secondFrameNoseMouthDifPercentage = 0.0;
    _secondFrameNosePosition = 0.0;
}

-(void)maintainFinalImages:(cv::Mat &)mat{
    
    if(!mat.empty()){
        
        //Maitaining one actual image copy.
        UIImage *origionalImage = [ImageUtils UIImageFromCVMat:mat convert_color:true];
        _respOrigionalImgData = [ImageUtils reduceImageSize:origionalImage imageSize:_image_size];
        
        cv::Rect mRect = [self getBiggestFaceRectInFrame:mat minWidth:_minFaceWidth minHeight:_minFaceHeight];
        
        if(mRect.area() > 0){
            double xCenter = (mRect.x + mRect.width + mRect.x)/2;
            double yCenter = (mRect.y + mRect.height + mRect.y)/2;
            
            cv::Point center = cv::Point(xCenter, yCenter);
            cv::Mat blur = cv::Mat(mat.size(), mat.type());
            cv::rectangle(blur, cv::Point(0,0), cv::Point(mat.size().width, mat.size().height), cv::Scalar(255, 255, 255), -1);
            cv::Mat mask = cv::Mat::ones(mat.size(), mat.type());
            cv::bitwise_not(mask, mask);
            cv::ellipse(mask, center, cv::Size(mRect.width*0.52, mRect.height*0.7), 0, 0, 360, cv::Scalar(0, 0, 0), -1, -1, 0);
            blur.copyTo(mat, mask);
        }
        
        UIImage *ellipseImage = [ImageUtils UIImageFromCVMat:mat convert_color:true];
        _respEllipseImgData = [ImageUtils reduceImageSize:ellipseImage imageSize:_image_size];
    }
}


-(void)updateResultObject : (NSString*)resultCode resultMessage:(NSString*)resultMessage{
    [_resultDictionary setObject:resultCode forKey:@"statusCode"];
    [_resultDictionary setObject:resultMessage forKey:@"statusMessage"];
}

-(void)updateResultObjectWithData : (NSString*)key resultMessage:(NSObject*)value{
    [_resultDictionary setObject:value forKey:key];
}

-(void)exitFromFaceDetectionScreen{
    
    [self resetResultCalculationValues];
    
//    if([_responseStatus isEqualToString:@"0"]){
//        [self updateResultObject:@"0" resultMessage:NSLocalizedString(@"success_msg", @"")];
//        
//        NSString *face = [AppItSDK getFaceImage];
//        NSString *croppedface = [AppItSDK getCroppedFaceImage];
//        if(nil != face){
//            [self updateResultObjectWithData:@"FACE" resultMessage:face];
//        }
//        if(nil != croppedface){
//            [self updateResultObjectWithData:@"PROCESSED_FACE" resultMessage:croppedface];
//        }
//    }else{
//        [self updateResultObject:@"5" resultMessage:NSLocalizedString(@"face_not_detected", @"")];
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSegueWithIdentifier: @"FaceDetectionExitSegue" sender: self];
}

-(void)returnMaskImage:(cv::Mat&)imageToMask areaToMask:(cv::Rect&)areaToMask{
    
    // Covering outside area of face with color
    cv::Mat blur = cv::Mat(imageToMask.size(), imageToMask.type());
    cv::rectangle(blur, cv::Point(0, 0), cv::Point(imageToMask.size().width, imageToMask.size().height), cv::Scalar(255, 255, 255), cv::FILLED);
    cv::Mat mask = cv::Mat::ones(imageToMask.size(), imageToMask.type());
    cv::bitwise_not(mask, mask);
    cv::rectangle(mask, cv::Point(areaToMask.tl().x, areaToMask.tl().y), cv::Point(areaToMask.br().x, areaToMask.br().y), cv::Scalar(0, 0, 0), cv::FILLED);
    blur.copyTo(imageToMask, mask);
}

@end
