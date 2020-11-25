//
//  MlKitFaceController.m
//  AppItFramework
//
//  Created by  on 05/12/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import "MlKitFaceController.h"
#import "Firebase.h"
#import "UIUtilities.h"
//@import AVFoundation;
//@import CoreVideo;
#import "ImageUtils.h"
#import "FacePreviewViewController.h"
#import "UIColor+fromHex.h"
#import "NSStringUtils.h"
#import "NSLogUtils.h"

static NSString *const alertControllerTitle = @"Vision Detectors";
static NSString *const alertControllerMessage = @"Select a detector";
static NSString *const cancelActionTitleText = @"Cancel";
static NSString *const videoDataOutputQueueLabel = @"com.google.firebaseml.visiondetector.VideoDataOutputQueue";
static NSString *const sessionQueueLabel = @"com.google.firebaseml.visiondetector.SessionQueue";
static NSString *const noResultsMessage = @"No Results";
static const CGFloat FIRSmallDotRadius = 4.0;
static const CGFloat FIRconstantScale = 41.0;

//
 int FACE_OUTLINE_PADDING, FD_X_START_POINT_ACCRD_TO_PADDING, FD_Y_START_POINT_ACCRD_TO_PADDING, DETECT_FACE_INSIDE_FACE_OUTLINE_WIDTH_PER, DETECT_FACE_INSIDE_FACE_OUTLINE_HEIGHT_PER;
//

@interface MlKitFaceController () <AVCaptureVideoDataOutputSampleBufferDelegate>

typedef NS_ENUM(NSInteger, Detector) {
    DetectorOnDeviceFace
};
@property (nonatomic) NSArray *detectors;
@property (nonatomic) Detector currentDetector;
@property (nonatomic) bool isUsingFrontCamera;
@property (nonatomic, nonnull) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) FIRVision *vision;
@property (nonatomic) UIView *annotationOverlayView;
@property (nonatomic) UIImageView *previewOverlayView;
@property (nonatomic) IBOutlet UIView *cameraView;
@property (nonatomic) CMSampleBufferRef lastFrame;


//
@property int continuousLowLightDetectedCounter, maxLowLightDetectionCounter;
@property int continuousFaceNotDetectedCounter, maxFaceNotDetectedCounter;
@property int continuosCameraMovementCounter, maxCameraMovementCounter;
@property int continuosFaceMovementCounter, maxFaceMovementCounter;
@property int goodFaceDetectionCounter;
@property int allComponentDetectionCounter;
@property BOOL isLabelVisible;
@property int initialDeltaX, initialDeltaY;
@property int numberOfFrames;
@property BOOL initialFrameCaptured;
@property int currentTest;
@property BOOL isFaceDetected;
@property BOOL middleFrameTestResult;
//

@property UIImage *resultUiImage;
@property CGRect faceRect;

@end

@implementation MlKitFaceController {

float faceOutlineColorAlpha;
float detectedFaceOutlineColorAlpha,detectedOutsideFaceOutlineColor,detectedOutsideFaceOutlineColorTrans;
float outsideFaceOutlineColorAlpha;
    
    bool isPaddingWithAspectRatio;
    int actualImageHeight;
    int actualImageWidth;
    bool isiPhoneX, isiPad, isiPhone4_4s_5_5c_5s;
    
    NSString *faceOutlineImage, *faceOutlineBorderImage;
    
    UIImage *faceOutlineIcon, *faceOutlineOutsideIcon;
    NSBundle * frameworkBundle;
    UIButton *switchCameraButton;
    UIImageView *faceOutlineUIImage, *faceOutlineOutsideUIImage,*faceTitleImageTop,*faceTitleImageBottom,*face_title_ui_image_view;
    UIButton *flashUIButton, *lightHintUIBtnTop,*lightHintUIBtnBottom, *smileHintUIBtnTop,*smileHintUIBtnBottom;
    UILabel *hintMsgUILabelTop,*hintMsgUILabelBottom;
    UILabel *fd_title_ui_label, *fd_hint_msg_ui_label;
    UIButton *light_hint_ui_button, *smile_hint_ui_button;
    UIImageView *topArrow, *bottomArrow, *leftArrow, *rightArrow;
    
    bool isLaunchFirstTime;
    
    NSString *subject_is_too_dark_fc_detect, *out_of_focus_fc_detect, *move_camera_closer_to_your_face, *smile_please, *face_detected, *camera_movement_fc_detect, *light, *focus, *smile, *keep_face_steady, *page_title_face_detection, *look_straight, *turn_left, *turn_right, *move_up, *move_down, *too_much_glare_face_capture;
    
    FIRVisionFaceDetectorOptions *options;
    FIRVisionFaceDetector *faceDetector;
    NSTimer *testResetTimerTask;
    
    NSMutableDictionary *imageCaptureConfig;
    int startTime;
    NSString* faceContourValue;
    int powerdByLabel_iphoneXPadd;
}

- (NSString *)stringForDetector:(Detector)detector {
    switch (detector) {
        case DetectorOnDeviceFace:
            return @"On-Device Face Detection";
//        case DetectorOnDeviceText:
//            return @"On-Device Text Recognition";
    }
}

-(void)initDefaultValues{
    //    _light_threshold = 60;
    //    _focus_threshold = 20;
    //    _smile_width_percentage_threshold = 15;
    _face_movement_percentage_threshold = 5.0;
    _face_height_diff_percentage_threshold = 5.0;
    
    _continuousLowLightDetectedCounter = 0;
    _maxLowLightDetectionCounter = 5;
    
    _continuousFaceNotDetectedCounter = 0;
    _maxFaceNotDetectedCounter = 10;
    
    _continuosCameraMovementCounter=0;
    _maxCameraMovementCounter=3;
    
    _continuosFaceMovementCounter=0;
    _maxFaceMovementCounter=3;
    
    _allComponentDetectionCounter = 0;
    
    _leftDelta = 30;
    _rightDelta = 30;
    _upDelta = 8;
    _downDelta = 12;
    
    //    _faceCascade = nil;
    //    _mouthCascade = nil;
    //    _eyeCascade = nil;
    //    _openEyeCascade = nil;
    //    _noseCascade = nil;
    //    _detector = nil;
    
    //Setting default value.
    _resultDictionary = [NSMutableDictionary new];
    
    //By default setting responseStatus to back press response code
    _responseStatus = @"18";
    
//    _face_outline_color = @"FFAD36";
//    _face_outline_color_alpha = 1.0;
//    _detected_face_outline_color = @"6EB24C";
//    _detected_face_outline_color_alpha = 1.0;
//    _outside_face_outline_color = @"487D95";
//    _outside_face_outline_color_alpha = 1.0;
    
    //TODO Start
    faceOutlineColorAlpha = [self getAlpha:_face_outline_color_alpha];
    detectedFaceOutlineColorAlpha = [self getAlpha:_detected_face_outline_color_alpha];
    outsideFaceOutlineColorAlpha = [self getAlpha:_outside_face_outline_color_alpha];
    detectedOutsideFaceOutlineColorTrans = [self getAlpha:_detected_outside_face_outline_color_alpha];
//    _title_message_style = @"Default";
//    _hint_message_style = @"Default";
//
//    _title_message_color = @"FFFFFF";
//    _title_message_color_alpha = 1.0;
//    _hint_message_color = @"FFFFFF";
//    _hint_message_color_alpha = 1.0;
//
//    _back_button_color =  @"FFFFFF";
//    _back_button_color_alpha = 1.0;
    //TODO End
    
    //Face outline related variables-Start
    /**
     * FACE_OUTLINE_PADDING
     * If FACE-OUTLINE-IMAGE is edge to edge, according to screen size then we need to add some padding so that it does not overlap other UI part
     * Right now we have created image with 10% face outline padding so we are not adding any padding right now (FACE_OUTLINE_PADDING = 0)
     **/
    FACE_OUTLINE_PADDING = 0;
    
    /**
     * FD_START_POINT_ACCRD_TO_PADDING
     *If face outline has some padding then we also need to add that much padding while face-detection so that face is detected inside face-outline
     *Right now we have created image with 10% face outline padding so we need to add 10% padding in FD starting point
     **/
    FD_X_START_POINT_ACCRD_TO_PADDING = 10;
    //    private static int FD_START_POINT_ACCRD_TO_PADDING = FACE_OUTLINE_PADDING;
    
    /**
     * FD_Y_START_POINT_ACCRD_TO_PADDING
     *If face outline has some padding then we also need to add that much padding while face-detection so that face is detected inside face-outline
     *Adding Y padding with little extra padding as hight has some extra padding
     **/
    FD_Y_START_POINT_ACCRD_TO_PADDING = 10;
    
    /**
     * DETECT_FACE_INSIDE_FACE_OUTLINE_WIDTH_PER
     * Detected face only when face is inside face-outline with below threshold
     * */
    DETECT_FACE_INSIDE_FACE_OUTLINE_WIDTH_PER = 45;
    
    /**
     * DETECT_FACE_INSIDE_FACE_OUTLINE_HEIGHT_PER
     * Detected face only when face is inside face-outline with below threshold
     * */
    DETECT_FACE_INSIDE_FACE_OUTLINE_HEIGHT_PER = 45;
    
    //Is padding added according to width and height percentage
    isPaddingWithAspectRatio = true;
    
    actualImageHeight = 0;
    actualImageWidth = 0;
    
    isiPhoneX = false;
    isiPad = false;
    isiPhone4_4s_5_5c_5s = false;
    powerdByLabel_iphoneXPadd = 0;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        faceOutlineImage = @"face_outline_ipad";
        faceOutlineBorderImage = @"face_outline_border_ipad";
    }else{
        faceOutlineImage = @"face_outline";
        faceOutlineBorderImage = @"face_outline_border";
    }
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        
        switch (height) {
                
            case 960:
                //"iPhone 4 4s"
                isiPhone4_4s_5_5c_5s = true;
                break;
            case 1136:
                //"iPhone 5 or 5S or 5C"
                faceOutlineImage = @"face_outline_1136";
                faceOutlineBorderImage = @"face_outline_border_1136";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //10
                FD_Y_START_POINT_ACCRD_TO_PADDING = 10; //20
                isiPhone4_4s_5_5c_5s = true;
                break;
            case 1334:
                //"iPhone 6/6S/7/8"
                faceOutlineImage = @"face_outline_1334";
                faceOutlineBorderImage = @"face_outline_border_1334";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //11
                FD_Y_START_POINT_ACCRD_TO_PADDING = 10; //20
                isiPhone4_4s_5_5c_5s = true;
                break;
            case 2208:
                //"iPhone 6+/6S+/7+/8+"
                faceOutlineImage = @"face_outline_2208";
                faceOutlineBorderImage = @"face_outline_border_2208";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //10
                FD_Y_START_POINT_ACCRD_TO_PADDING = 10; //20
                break;
            case 2436:
                //"iPhone X"
                faceOutlineImage = @"face_outline_2436";
                faceOutlineBorderImage = @"face_outline_border_2436";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //10
                FD_Y_START_POINT_ACCRD_TO_PADDING = 10; //25
                powerdByLabel_iphoneXPadd = 25;
                
                isiPhoneX = true;
                break;
            case 1792:
                //"iPhone X"
                faceOutlineImage = @"face_outline_2436";
                faceOutlineBorderImage = @"face_outline_border_2436";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //10
                FD_Y_START_POINT_ACCRD_TO_PADDING = 10; //25
                powerdByLabel_iphoneXPadd = 25;
                
                isiPhoneX = true;
                break;
            default:
                printf("unknown");
        }
    }else if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        NSLog(@"iPad");
        isiPad = true;
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        
        switch (height) {
                
            case 2048:
                //"7.9" iPad mini 4 or 9.7" iPad"
                faceOutlineImage = @"face_outline_2048";
                faceOutlineBorderImage = @"face_outline_border_2048";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //10
                FD_Y_START_POINT_ACCRD_TO_PADDING = 5; //11
                break;
            case 2224:
                //"10.5" iPad Pro"
                faceOutlineImage = @"face_outline_2224";
                faceOutlineBorderImage = @"face_outline_border_2224";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //10
                FD_Y_START_POINT_ACCRD_TO_PADDING = 5; //10
                break;
            case 2208:
                //"12.9" iPad Pro"
                faceOutlineImage = @"face_outline_2208";
                faceOutlineBorderImage = @"face_outline_border_2208";
                
                FD_X_START_POINT_ACCRD_TO_PADDING = 5; //10
                FD_Y_START_POINT_ACCRD_TO_PADDING = 10; //20
                break;
            default:
                printf("unknown");
        }
    }
}

-(void)dismissCurrentViewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set language bundle according to given configuration
    startTime = [ImageUtils getStartTime];
    faceContourValue = @"Medium";
    [self initDefaultValues];
        
    _resultDictionary = [NSMutableDictionary new];
        
        // Do any additional setup after loading the view.
    //    self.captureGrayscale = YES;
    //    self.qualityPreset = AVCaptureSessionPresetMedium;
        
        //Load bundle
    frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
        
    int viewHeight = self.view.bounds.size.height;
    int viewWidth = self.view.bounds.size.width;
    //FIX FOR : If this view-controller is launched from landscape viewcontroller(caller VC)
    if(self.view.bounds.size.height < self.view.bounds.size.width){
        viewHeight = self.view.bounds.size.width;
        viewWidth = self.view.bounds.size.height;
    }
    int iconSize = 100;
        if(viewHeight < 586){
            iconSize = 50;
        }
        
        //Adding switch camera button -Start
        switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect switchCameraRect = CGRectMake(viewWidth-60, viewHeight-60 , 50, 50);
        [switchCameraButton setFrame:switchCameraRect];
        
        NSString *switchcam_icon = [frameworkBundle pathForResource:@"back_camera_icon" ofType:@"png"];
        [switchCameraButton setImage:[UIImage imageNamed:switchcam_icon] forState:UIControlStateNormal];
        
        [switchCameraButton addTarget:self action:@selector(toggleCameraView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:switchCameraButton];
        
        //Adding face outline-Start
        
        faceOutlineOutsideUIImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [faceOutlineOutsideUIImage setTintColor:[UIColor colorwithHexString:_outside_face_outline_color alpha:outsideFaceOutlineColorAlpha]];
        NSString *faceOutlineOutsideIconPath = [frameworkBundle pathForResource:faceOutlineBorderImage ofType:@"png"];
        faceOutlineOutsideIcon = [[UIImage imageNamed:faceOutlineOutsideIconPath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [faceOutlineOutsideUIImage setImage:faceOutlineOutsideIcon];
        [self.view addSubview:faceOutlineOutsideUIImage];
        
        faceOutlineUIImage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [faceOutlineUIImage setTintColor:[UIColor colorwithHexString:_face_outline_color alpha:faceOutlineColorAlpha]];
        NSString *faceOutlineIconPath = [frameworkBundle pathForResource:faceOutlineImage ofType:@"png"];
        faceOutlineIcon = [[UIImage imageNamed:faceOutlineIconPath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [faceOutlineUIImage setImage:faceOutlineIcon];
        [self.view addSubview:faceOutlineUIImage];
        //Adding face outline-End
        
        if(!_launch_front_camera || _allowBothCamera){
            //Adding flash button programatically to manitain its position consistent on diffrent devices
            // [flashButton setHidden:true];//Hidding button from storyboard
            
            CGRect flashButtonRect = CGRectMake(viewWidth/2-30, viewHeight-60 ,50,50);
            flashUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            //        [flashUIButton addTarget:self action:@selector(toggle_flash:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *icon = [frameworkBundle pathForResource:@"flash_off_icon" ofType:@"png"];
            [flashUIButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            [flashUIButton setFrame:flashButtonRect];
            
            [self.view addSubview:flashUIButton];
        }
        
        //Hiding flashbutton as it is not present in android
        [flashButton setHidden:true];
        [flashUIButton setHidden:true];
        
        //Launch camera according to confugured value
        if(_launch_front_camera){
            _isUsingFrontCamera = YES;
            NSString *icon = [frameworkBundle pathForResource:@"back_camera_icon" ofType:@"png"];
            [switchCameraButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            //[flashButton setHidden:true];
            //[flashUIButton setHidden:true];
        }else{
            _isUsingFrontCamera = false;
            NSString *icon = [frameworkBundle pathForResource:@"front_camera_icon" ofType:@"png"];
            [switchCameraButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            //  [self toggleCameraView];
        }
        
        //Disabling switch camera button
        // [switchCameraButton setHidden:true];
        
        if(_allowBothCamera){
            [switchCameraButton setHidden:false];
        }else{
            //Disabling switch camera button
            [switchCameraButton setHidden:true];
        }
        
        //Adding switch camera button -End
        
        //Adding hint icon-start
        //Light-Hint icon
        lightHintUIBtnTop = [UIButton buttonWithType:UIButtonTypeCustom];
        //    CGRect lightButtonRect = CGRectMake(10, viewHeight-60, 50, 50);
        CGRect lightButtonRect = CGRectMake(5,60, iconSize, iconSize);
        [lightHintUIBtnTop setFrame:lightButtonRect];
        
        [self.view addSubview:lightHintUIBtnTop];
        
        lightHintUIBtnBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        //    CGRect lightButtonRect = CGRectMake(10, viewHeight-60, 50, 50);
        CGRect lightButtonRect1 = CGRectMake(5,viewHeight -  iconSize -20, iconSize, iconSize);
        [lightHintUIBtnBottom setFrame:lightButtonRect1];
        
        [self.view addSubview:lightHintUIBtnBottom];
        
        
        //Smile-Hint icon
        smileHintUIBtnTop = [UIButton buttonWithType:UIButtonTypeCustom];
        //    CGRect smileButtonRect = CGRectMake(viewWidth-60, viewHeight-60 , 50, 50);
        CGRect smileButtonRect = CGRectMake(viewWidth-(iconSize+20),60 , iconSize, iconSize);
        [smileHintUIBtnTop setFrame:smileButtonRect];
        
        [self.view addSubview:smileHintUIBtnTop];
        //Adding hint icon-end
        
        smileHintUIBtnBottom = [UIButton buttonWithType:UIButtonTypeCustom];
        //    CGRect smileButtonRect = CGRectMake(viewWidth-60, viewHeight-60 , 50, 50);
        CGRect smileButtonRect1 = CGRectMake(viewWidth-(iconSize+20), viewHeight - iconSize - 20 , iconSize, iconSize);
        [smileHintUIBtnBottom setFrame:smileButtonRect1];
        
        [self.view addSubview:smileHintUIBtnBottom];
        
        //Adding BACK button -Start
        backUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        int backTopPadding = 10;
        if(isiPhoneX){
            backTopPadding = backTopPadding + 15;
        }
        CGRect backButtonRect = CGRectMake(10, backTopPadding , 50, 50);
        [backUIButton setFrame:backButtonRect];
        
        NSString *back_icon = [frameworkBundle pathForResource:@"back_cancel_arrow" ofType:@"png"];
        
        UIImage *backImage = [[UIImage imageNamed:back_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [backUIButton setImage:backImage forState:UIControlStateNormal];
//        [backUIButton setTintColor:[UIColor colorwithHexString:_face_outline_color alpha:faceOutlineColorAlpha]];
    
        [backUIButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
        float blackButtonColorAlpha = [self getAlpha:_back_button_color_alpha];
        [backUIButton setTintColor:[UIColor colorwithHexString:_back_button_color alpha:blackButtonColorAlpha]];
        [self.view addSubview:backUIButton];
        //Adding BACK button -End
        
        //Adding Threshold Label -Start
        CGRect thresholdLabelRect = CGRectMake(backUIButton.frame.origin.x ,
                                               backUIButton.frame.origin.y + backUIButton.frame.size.height,
                                               viewWidth-backUIButton.frame.size.width,
                                               200);
        thresholdLabel = [[UILabel alloc] initWithFrame:thresholdLabelRect];
        [thresholdLabel setNumberOfLines:0];
        [thresholdLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [thresholdLabel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:thresholdLabel];
        //Adding Threshold Label -End
        
        //Update text style-Start
        
        [NSStringUtils setLabelStyle:thresholdLabel];
        
        //Update text style-End
        
      //  if(![AppItSDK isDebugEnable]){
            [thresholdLabel setHidden:true];
      //  }
        
        _isLabelVisible = ![thresholdLabel isHidden];
        
        [self initializeLabels];
        
        //Initializing CUSTOMIZE UI views
        [self init_customize_ui];
        
        [fd_title_ui_label setText:page_title_face_detection];
        [face_title_ui_image_view setImage:_titleImageFace];
        [self.view bringSubviewToFront:switchCameraButton];
        
        /////
        
        
        int width = [UIScreen mainScreen].bounds.size.width;
        int height = [UIScreen mainScreen].bounds.size.height;
        
        //    _cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //    _cameraView = [[UIView alloc] init];
        //    _cameraView.frame = CGRectMake(0, 0, width, height);
        
        _cameraView.frame = CGRectMake(0, 0, width, height);
        
        //    _detectors = @[[NSNumber numberWithInt:DetectorOnDeviceFace], [NSNumber numberWithInt:DetectorOnDeviceText]];
        _detectors = @[[NSNumber numberWithInt:DetectorOnDeviceFace]];
        _currentDetector = DetectorOnDeviceFace;
    //    _isUsingFrontCamera = YES;
        _captureSession = [[AVCaptureSession alloc] init];
        _sessionQueue = dispatch_queue_create(sessionQueueLabel.UTF8String, nil);
        _vision = [FIRVision vision];
        //_previewOverlayView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _previewOverlayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [_previewOverlayView setContentMode:UIViewContentModeScaleAspectFit];
        
        
        //_previewOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
        // _annotationOverlayView = [[UIView alloc] initWithFrame:CGRectZero];
        _annotationOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        //_annotationOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
        
        options = [[FIRVisionFaceDetectorOptions alloc] init];
        // When performing latency tests to determine ideal detection settings,
        // run the app in 'release' mode to get accurate performance metrics
        options.performanceMode = FIRVisionFaceDetectorPerformanceModeFast;
        options.contourMode = FIRVisionFaceDetectorContourModeAll;
        options.landmarkMode = FIRVisionFaceDetectorLandmarkModeNone;
        options.classificationMode = FIRVisionFaceDetectorClassificationModeNone;
        faceDetector = [_vision faceDetectorWithOptions:options];
        
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [self setUpPreviewOverlayView];
        [self setUpAnnotationOverlayView];
        [self setUpCaptureSessionOutput];
        [self setUpCaptureSessionInput];
        [_cameraView.layer addSublayer:_previewLayer];
        [_cameraView bringSubviewToFront:_previewOverlayView];
        [_cameraView bringSubviewToFront:_annotationOverlayView];
        
        //Top
        NSString *top_icon = [frameworkBundle pathForResource:@"arrow_up" ofType:@"png"];
        UIImage *topImage = [[UIImage imageNamed:top_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        int topPadding = 60;
        if(isiPhoneX){
            topPadding = topPadding + 30;
        }
        topArrow = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-topImage.size.width/2, topPadding, topImage.size.width, topImage.size.width)];
        [topArrow setImage:topImage];
        [topArrow setTintColor:[UIColor colorwithHexString:_face_outline_color alpha:faceOutlineColorAlpha]];
        [topArrow setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:topArrow];
        
        //Bottom
        NSString *bottom_icon = [frameworkBundle pathForResource:@"arrow_down" ofType:@"png"];
        UIImage *bottomImage = [[UIImage imageNamed:bottom_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        int bottomPadding = 50;
        if(isiPhoneX){
            bottomPadding = bottomPadding + 25;
        }
        bottomArrow = [[UIImageView alloc] initWithFrame:CGRectMake(width/2 -topImage.size.width/2, height - topImage.size.height -bottomPadding, topImage.size.width, topImage.size.height)];
        [bottomArrow setImage:bottomImage];
        [bottomArrow setTintColor:[UIColor colorwithHexString:_face_outline_color alpha:faceOutlineColorAlpha]];
        [bottomArrow setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:bottomArrow];
        
        //Left
        NSString *left_icon = [frameworkBundle pathForResource:@"arrow_left" ofType:@"png"];
        UIImage *leftImage = [[UIImage imageNamed:left_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        leftArrow = [[UIImageView alloc] initWithFrame:CGRectMake(5, (height/2)-leftImage.size.height/2, leftImage.size.width, leftImage.size.height)];
        [leftArrow setImage:leftImage];
        [leftArrow setTintColor:[UIColor colorwithHexString:_face_outline_color alpha:faceOutlineColorAlpha]];
        [leftArrow setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:leftArrow];
        
        //Right
        NSString *right_icon = [frameworkBundle pathForResource:@"arrow_right" ofType:@"png"];
        UIImage *rightImage = [[UIImage imageNamed:right_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(width -rightImage.size.width -5, (height/2)-rightImage.size.height/2, rightImage.size.width, rightImage.size.height)];
        [rightArrow setImage:rightImage];
        [rightArrow setTintColor:[UIColor colorwithHexString:_face_outline_color alpha:faceOutlineColorAlpha]];
        [rightArrow setContentMode:UIViewContentModeScaleAspectFit];
        [self.view addSubview:rightArrow];
        
        [topArrow setHidden:YES];
        [bottomArrow setHidden:YES];
        [leftArrow setHidden:YES];
        [rightArrow setHidden:YES];
//    }
}

-(void)init_customize_ui{
    
    int viewHeight = self.view.bounds.size.height;
    int viewWidth = self.view.bounds.size.width;
    //FIX FOR : If this view-controller is launched from landscape viewcontroller(caller VC)
    if(self.view.bounds.size.height < self.view.bounds.size.width){
        viewHeight = self.view.bounds.size.width;
        viewWidth = self.view.bounds.size.height;
    }
    
    /******** Customize UI -START  ********/
    
    //TOP -START
    //Ttle image top -Start
    UIImage *topTitleUiImage;
    //TODO Start
   // if([AppItSDK getFaceTitleImageOnTop] && ![AppItSDK getHideFacetitleImage]) {
    if(false) {
        topTitleUiImage = _titleImageFace;
    }
    //TODO End
    int paddingTop = 5;
    if(isiPhoneX) {
        paddingTop = paddingTop + 30;
    }
    
    faceTitleImageTop = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/2) - (topTitleUiImage.size.width/2),
                                                                      paddingTop,
                                                                      topTitleUiImage.size.width,
                                                                      topTitleUiImage.size.height)];
    [self.view addSubview:faceTitleImageTop];
    //Title image top -End
    
    //Adding hint label-Start
    CGRect hintMsgUILabelRectTop = CGRectMake(backUIButton.frame.size.width,
                                              faceTitleImageTop.frame.origin.y + topTitleUiImage.size.height,
                                              viewWidth-backUIButton.frame.size.width*2,
                                              80);
    
    hintMsgUILabelTop = [[UILabel alloc] initWithFrame:hintMsgUILabelRectTop];
    [hintMsgUILabelTop setNumberOfLines:0];
    [hintMsgUILabelTop setLineBreakMode:NSLineBreakByWordWrapping];
    [hintMsgUILabelTop setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:hintMsgUILabelTop];
    //Adding hint label-End
    
    // Adding Second label
    CGRect titleMsgLabelRectTop = CGRectMake(backUIButton.frame.size.width,
                                             faceTitleImageTop.frame.origin.y + topTitleUiImage.size.height,
                                             viewWidth-backUIButton.frame.size.width*2,
                                             (viewHeight*10)/100);
    
    titleMsgUiLabelTop = [[UILabel alloc] initWithFrame:titleMsgLabelRectTop];
    [titleMsgUiLabelTop setNumberOfLines:0];
    [titleMsgUiLabelTop setLineBreakMode:NSLineBreakByWordWrapping];
    [titleMsgUiLabelTop setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleMsgUiLabelTop];
    //TOP -END
    
    //BOTTOM -START
    // bottom image
    // TODO Start
    UIImage *titleUiImageBottom;
//    if(![AppItSDK getFaceTitleImageOnTop] && ![AppItSDK getHideFacetitleImage]) {
    if(false) {
        titleUiImageBottom = _titleImageFace;
    }
    //TODO End
    int bottomPadding = 5;
//    if(self.camera == 0){//Back camera launched
//        bottomPadding = bottomPadding + 50;
//    }
    faceTitleImageBottom = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth/2) - (titleUiImageBottom.size.width/2),
                                                                         viewHeight - titleUiImageBottom.size.height - bottomPadding,
                                                                         titleUiImageBottom.size.width,
                                                                         titleUiImageBottom.size.height)];
    [self.view addSubview:faceTitleImageBottom];
    
    //powered by label
    NSString *poweredByCn = @"powered_by_idmission";
    CGSize poweredBySize = [NSLogUtils getUILabelSizeFromLabel:poweredByCn size:10];
    //    CGRect poweredByLabelRect = CGRectMake(0,
    //                                           viewHeight - 11,
    //                                           viewWidth,
    //                                           10);
    CGRect poweredByLabelRect = CGRectMake(viewWidth - poweredBySize.width - powerdByLabel_iphoneXPadd,
                                           viewHeight - 11,
                                           poweredBySize.width,
                                           10);
    
    UILabel *poweredByLabel = [[UILabel alloc] initWithFrame:poweredByLabelRect];
    [poweredByLabel setNumberOfLines:0];
    [poweredByLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [poweredByLabel setTextAlignment:NSTextAlignmentRight];
    [poweredByLabel setText:poweredByCn];
    [poweredByLabel setTextColor:[UIColor whiteColor]];
    [poweredByLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [self.view addSubview:poweredByLabel];
    
    //Feature Type Label -Start
    int bottomLabelHeight = (viewHeight*10)/100;
    CGRect titleMsgLabelRectBottom = CGRectMake(0,
                                                viewHeight - titleUiImageBottom.size.height- bottomPadding -bottomLabelHeight,
                                                viewWidth,
                                                bottomLabelHeight);
    titleUiLableBottom = [[UILabel alloc] initWithFrame:titleMsgLabelRectBottom];
    [titleUiLableBottom setNumberOfLines:0];
    [titleUiLableBottom setLineBreakMode:NSLineBreakByWordWrapping];
    [titleUiLableBottom setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleUiLableBottom];
    //Feature Type Label -End
    
    // Adding second Feature Type Label
    
    CGRect hintMsgUILabelRectBottom = CGRectMake(backUIButton.frame.size.width,
                                                 viewHeight - titleUiImageBottom.size.height - bottomPadding - 80,
                                                 viewWidth-backUIButton.frame.size.width*2,
                                                 80);
    
    hintMsgUILabelBottom = [[UILabel alloc] initWithFrame:hintMsgUILabelRectBottom];
    [hintMsgUILabelBottom setNumberOfLines:0];
    [hintMsgUILabelBottom setLineBreakMode:NSLineBreakByWordWrapping];
    [hintMsgUILabelBottom setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:hintMsgUILabelBottom];
    //BOTTOM -END
    
    [NSStringUtils setLabelStyle:titleMsgUiLabelTop];
    [NSStringUtils setLabelStyle:hintMsgUILabelTop];
    [NSStringUtils setLabelStyle:titleUiLableBottom];
    [NSStringUtils setLabelStyle:hintMsgUILabelBottom];
    
    /******** Customize UI -END  ********/
    
    if(_isFaceTitleOnTop) {
        fd_title_ui_label = titleMsgUiLabelTop;
    } else {
        fd_title_ui_label = titleUiLableBottom;
    }
    
    if(_isFaceHintMessageOnTop) {
        fd_hint_msg_ui_label = hintMsgUILabelTop;
    } else {
        fd_hint_msg_ui_label = hintMsgUILabelBottom;
    }
    
    if(true) {
        light_hint_ui_button = lightHintUIBtnTop;
        smile_hint_ui_button = smileHintUIBtnTop;
    } else {
        light_hint_ui_button = lightHintUIBtnBottom;
        smile_hint_ui_button = smileHintUIBtnBottom;
    }
    
    if(false) {
        face_title_ui_image_view = faceTitleImageTop;
    } else {
        face_title_ui_image_view = faceTitleImageBottom;
    }
    
    if(_hideFaceTitleMsgAlignment) {
        [fd_title_ui_label setHidden:YES];
    } else {
        [fd_title_ui_label setHidden:NO];
    }

    if(_hideFaceHintMsgAlignment) {
        [fd_hint_msg_ui_label setHidden:YES];
    } else {
        [fd_hint_msg_ui_label setHidden:NO];
    }
//
//    if([AppItSDK getHideFacehintIcon]) {
//        [light_hint_ui_button setHidden:YES];
//        [smile_hint_ui_button setHidden:YES];
//    } else {
//        [light_hint_ui_button setHidden:NO];
//        [smile_hint_ui_button setHidden:NO];
//    }
//
//    if([AppItSDK getHideFacetitleImage]) {
//        [face_title_ui_image_view setHidden:YES];
//    } else {
//        [face_title_ui_image_view setHidden:NO];
//    }
    
    if(isiPad) {
        [fd_hint_msg_ui_label setFont:[UIFont boldSystemFontOfSize:18]];
        [fd_title_ui_label setFont:[UIFont boldSystemFontOfSize:22]];
        [fd_hint_msg_ui_label setFont:[UIFont fontWithName:_hint_message_style size:fd_hint_msg_ui_label.font.pointSize]];
        [fd_hint_msg_ui_label setTextColor:[UIColor colorwithHexString:_hint_message_color alpha:[self getAlpha:_hint_message_color_alpha]]];
        [fd_title_ui_label setFont:[UIFont fontWithName:_title_message_style size:fd_title_ui_label.font.pointSize]];
        [fd_title_ui_label setTextColor:[UIColor colorwithHexString:_title_message_color alpha:[self getAlpha:_title_message_color_alpha]]];
    } else if(isiPhone4_4s_5_5c_5s){
        [fd_hint_msg_ui_label setFont:[UIFont boldSystemFontOfSize:16]];
        [fd_title_ui_label setFont:[UIFont boldSystemFontOfSize:20]];
        [fd_hint_msg_ui_label setFont:[UIFont fontWithName:_hint_message_style size:fd_hint_msg_ui_label.font.pointSize]];
        [fd_hint_msg_ui_label setTextColor:[UIColor colorwithHexString:_hint_message_color alpha:[self getAlpha:_hint_message_color_alpha]]];
        [fd_title_ui_label setFont:[UIFont fontWithName:_title_message_style size:fd_title_ui_label.font.pointSize]];
        [fd_title_ui_label setTextColor:[UIColor colorwithHexString:_title_message_color alpha:[self getAlpha:_title_message_color_alpha]]];
    } else {
        [fd_hint_msg_ui_label setFont:[UIFont boldSystemFontOfSize:17]];
        [fd_title_ui_label setFont:[UIFont boldSystemFontOfSize:21]];
        [fd_hint_msg_ui_label setFont:[UIFont fontWithName:_hint_message_style size:fd_hint_msg_ui_label.font.pointSize]];
        [fd_hint_msg_ui_label setTextColor:[UIColor colorwithHexString:_hint_message_color alpha:[self getAlpha:_hint_message_color_alpha]]];
        [fd_title_ui_label setFont:[UIFont fontWithName:_title_message_style size:fd_title_ui_label.font.pointSize]];
        [fd_title_ui_label setTextColor:[UIColor colorwithHexString:_title_message_color alpha:[self getAlpha:_title_message_color_alpha]]];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:_title_message_size]){
        if(![_title_message_style isEqualToString:@"Default"]){
            [fd_title_ui_label setFont: [UIFont fontWithName:_title_message_style size:[_title_message_size integerValue]]];
        }else{
            [fd_title_ui_label setFont:[UIFont systemFontOfSize:[_title_message_size integerValue]]];
        }
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:_hint_message_size]){
        // [fd_hint_msg_ui_label setFont: [UIFont fontWithName:_hint_message_style size:[[AppItSDK getTextSizeFace] integerValue]]];
        if(![_hint_message_style isEqualToString:@"Default"]){
            [fd_hint_msg_ui_label setFont: [UIFont fontWithName:_hint_message_style size:[_hint_message_size integerValue]]];
        }else{
            [fd_hint_msg_ui_label setFont:[UIFont systemFontOfSize:[_hint_message_size integerValue]]];
        }
    }
    
    //Hinding In Case of FireBaseFaceDetection
    [light_hint_ui_button setHidden:YES];
    [smile_hint_ui_button setHidden:YES];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopSession];
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _previewLayer.frame = _cameraView.frame;
}

- (IBAction)selectDetector:(id)sender {
}

- (IBAction)switchCamera:(id)sender {
    self.isUsingFrontCamera = !_isUsingFrontCamera;
    [self removeDetectionAnnotations];
    [self setUpCaptureSessionInput];
}

-(void)toggleCameraView{
    //    self.isUsingFrontCamera = !_isUsingFrontCamera;
    [self removeDetectionAnnotations];
    [self setUpCaptureSessionInput];
    if (self.isUsingFrontCamera) {
        //self.camera = 0;  //Back Camera Enable
        _isUsingFrontCamera = false;
        NSString *icon = [frameworkBundle pathForResource:@"front_camera_icon" ofType:@"png"];
        [switchCameraButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        //        [flashButton setHidden:false];
        //        [flashUIButton setHidden:false];
    } else
    {
        //  self.camera = 1;  //Front Camera Enable
        _isUsingFrontCamera = true;
        NSString *icon = [frameworkBundle pathForResource:@"back_camera_icon" ofType:@"png"];
        [switchCameraButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        //        [flashButton setHidden:true];
        //        [flashUIButton setHidden:true];
    }
    
    _numberOfFrames=0;
    _initialFrameCaptured=false;
    _goodFaceDetectionCounter=0;
    
    [self stopAnimatingTurnArrow];
}

-(bool)isFaceInsideOutline:(CGRect)face {
    
    int scaledFactor = 1;
    
    //Detected face coordinate
    float faceX = face.origin.x * 100/actualImageWidth;
    float faceY = face.origin.y * 100/actualImageHeight;
    float faceW = face.size.width * 100/actualImageWidth;
    float faceH = face.size.height * 100/actualImageHeight;
    float faceRight = faceX + faceW;
    float faceBottom = faceY + faceH;
    
    //Outline coordinate
    int outlineX = FD_X_START_POINT_ACCRD_TO_PADDING;
    int outlineY;
    if(isPaddingWithAspectRatio){
        outlineY = FD_Y_START_POINT_ACCRD_TO_PADDING;
    }else {
        outlineY = outlineX;
    }
    int outlineWidth = 100 - (outlineX * 2);
    int outlineHeight = 100 - (outlineY * 2);

    int outlineRight = outlineX + outlineWidth;
    int outlineBottom = outlineY + outlineHeight;
    
//    int outlineWidth_buffer_percentage = outlineWidth + DETECT_FACE_INSIDE_FACE_OUTLINE_WIDTH_PER /100;
//    int outlineHeight_buffer_percentage = outlineHeight * DETECT_FACE_INSIDE_FACE_OUTLINE_HEIGHT_PER /100;
    
    int outlineWidth_buffer_percentage = outlineX + DETECT_FACE_INSIDE_FACE_OUTLINE_WIDTH_PER;
    int outlineHeight_buffer_percentage = outlineY + DETECT_FACE_INSIDE_FACE_OUTLINE_HEIGHT_PER;
    
    if((faceX >= outlineX) && (faceY >= outlineY)                             //Detected face's TOP-LEFT should be inside outline
       //       && (faceRight < outlineRight) && (faceBottom < outlineBottom)    //Detected face's BOTTOM-RIGHT should be inside outline
       && (faceW <= outlineWidth) && (faceH <= outlineHeight)            //Detected face's HEIGHT-WIDTH should be less than outline HEIGHT-WIDTH
       && (faceX < (outlineX + outlineWidth_buffer_percentage) && (faceY < (outlineY + outlineHeight_buffer_percentage)))//Face Top-Right should be inside (outline starting point and indside 15% of outline width and height )
       && ((faceW > (outlineWidth - outlineWidth_buffer_percentage)) && (faceH > (outlineHeight - outlineHeight_buffer_percentage)))//Face bottom-right should be inside (outline end point and inside 15% of outline width and height )
       ){    //
        return true;
    }
    return false;
}

#pragma mark - On-Device Detection

- (void)detectFacesOnDeviceInImage:(FIRVisionImage *)image bgra:(cv::Mat &)bgraMat uiImage:(UIImage*)uiImage width:(CGFloat) width height:(CGFloat)height {

    NSError *error;
    NSArray<FIRVisionFace *> *faces = [faceDetector resultsInImage:image error:&error];
//    actualImageWidth = height;
//    actualImageHeight = width;

    if(actualImageHeight == 0 && actualImageWidth == 0){
        int viewHeight = self.view.bounds.size.height;
        int viewWidth = self.view.bounds.size.width;
        if(viewHeight > viewWidth){
            actualImageHeight = viewHeight;
            actualImageWidth = viewWidth;
        }else{
            actualImageHeight = viewWidth;
            actualImageWidth = viewHeight;
        }
    }
    
    if(_isFaceDetected){
        return;
    }
    
    if (error != nil) {
        NSLog(@"Failed to detect faces with error: %@", error.localizedDescription);
        return;
    }
    
    if (faces.count == 0) {

        dispatch_sync(dispatch_get_main_queue(), ^{
            
            _numberOfFrames = 0;
            [self stopAnimatingTurnArrow];
            [self resetResultCalculationValues];
            
            [self updatePreviewOverlayView];
            [self removeDetectionAnnotations];
        });
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self updatePreviewOverlayView];
        [self removeDetectionAnnotations];
    
        [NSLogUtils printLogInDebugMode:[NSString stringWithFormat: @"FACE : Face Count %lu", (unsigned long)[faces count]]];
        
        if([faces count] == 1){
            
            FIRVisionFace *face = faces[0];
            
            CGRect normalizedRect = CGRectMake(face.frame.origin.x / width,
                                               face.frame.origin.y / height,
                                               face.frame.size.width / width,
                                               face.frame.size.height / height);
            CGRect standardizedRect = CGRectStandardize([self->_previewLayer rectForMetadataOutputRectOfInterest:normalizedRect]);
            
            bool correctface = [self isFaceInsideOutline:standardizedRect];
            
//            [UIUtilities addRectangle:standardizedRect toView:self->_annotationOverlayView color:UIColor.greenColor];
            [self addContoursForFace:face width:width height:height isFaceInside:correctface standardizedRect:standardizedRect];
            
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
                [NSLogUtils printLogInDebugMode:@"FACE : low light"];
                [self updateStatus:subject_is_too_dark_fc_detect];
                [self updateStatusIcon:@"light_gray" smileIcon:@"smile_gray"];
            }else if(lowFocusDetected){
                [NSLogUtils printLogInDebugMode:@"FACE : low focus"];
                [self updateStatus:out_of_focus_fc_detect];
                [self updateStatusIcon:@"light_green" smileIcon:@"smile_gray"];
            }
            //        else if(_allComponentDetectionCounter < (allComponentDetectionCounterThreshold + 1)){
            //            [NSLogUtils printLogInDebugMode:@"FACE : all component not detected"];
            //            [self updateStatus:move_camera_closer_to_your_face];
            //            [self updateStatusIcon:@"light_green" smileIcon:@"smile_orange"];
            //        }
            
            if ((_continuousLowLightDetectedCounter > _maxLowLightDetectionCounter)
                || (_continuousFaceNotDetectedCounter > _maxFaceNotDetectedCounter)
                || (_continuosCameraMovementCounter > _maxCameraMovementCounter)
                || (_continuosFaceMovementCounter > _maxFaceMovementCounter)){
                [NSLogUtils printLogInDebugMode:@"FACE : reset all counter"];
                [self resetResultCalculationValues];
            }
            
            if(!lowLightDetected && !lowFocusDetected){
                
                float faceX = face.frame.origin.x;
                float faceY = face.frame.origin.y;
                float faceW = face.frame.size.width;
                float faceH = face.frame.size.height;
                
                float matWidth = bgraMat.cols;
                float matHeight = bgraMat.rows;
                
                if(!bgraMat.empty() && faceX>0 && faceY>0 && (faceX + faceW)<matWidth && (faceY + faceH)<matHeight){

                    cv::Mat bgraFaceMat = cv::Mat(bgraMat, cv::Rect(faceX, faceY, faceW, faceH)).clone();
                    
                    if (!bgraFaceMat.empty()) {
                        
                        cv::Mat facehsv;
                        cv::resize(bgraFaceMat, facehsv, cv::Size(), (double)1.0, (double)1.0, cv::INTER_LINEAR);
                        cv::cvtColor(facehsv, facehsv, cv::COLOR_BGR2HSV_FULL);
                        std::vector<cv::Mat> channelFace;
                        cv::split(facehsv, channelFace);
                        
                        int faceLight = -1, faceFocus = -1, faceGlare = -1;
                        
                        faceLight = [self getLightLevel:channelFace[2]];
                        faceFocus = [self getFocusScore:channelFace[2]];
                        faceFocus = faceFocus*1.5;
                        faceGlare = checkGlarePercentageFace(channelFace[2], faceLight, faceFocus);
                        
                        NSLog(@"Face Glare : %d ",faceGlare);
                        
                        if(faceLight==-1 || faceLight==0){
                            face = nil;
                        }
                        
                        if (faceLight < _light_threshold) {
                            [self updateStatus:subject_is_too_dark_fc_detect];
                            face = nil; //Do not process further
                        }
                        
                        if(faceGlare > _glare_threshold){
                            [self updateStatus:too_much_glare_face_capture];
                            face = nil; //Do not process further
                        }
                    }else{
                        face = nil; //Do not process further
                    }
                }else{
                    face = nil; //Do not process further
                }
                
                _continuousFaceNotDetectedCounter = 0;
                
                if(face){
                    CGPoint faceCenter = [self getFaceCenter:standardizedRect];
                    CGPoint nosePoint = [self getNosePoint:face width:width height:height];
                    
                    int diffXF = ((faceCenter.x - nosePoint.x)/standardizedRect.size.width)*100;
                    int diffYF = ((faceCenter.y - nosePoint.y)/standardizedRect.size.height)*100;
                    
                    int currentDiffX_abs = abs(diffXF);
                    int currentDiffY_abs = abs(diffYF);
                    if(!_initialFrameCaptured && currentDiffX_abs<10 && currentDiffY_abs<10 && correctface ){
                        [self updateStatus:look_straight];
                        
                        _numberOfFrames++;
                        
                        if(_numberOfFrames > 3){
                            _initialFrameCaptured = true;
                            _middleFrameTestResult = false;
                            _resultUiImage = uiImage;
                            _faceRect = CGRectMake(standardizedRect.origin.x, standardizedRect.origin.y, standardizedRect.size.width, standardizedRect.size.height);
                            
                            _initialDeltaX = diffXF;
                            _initialDeltaY = diffYF;
                            
                            _currentTest = [self generateRandomTest];
                            [self executeTestResetTimerTask];
                        }
                    }else if(_initialFrameCaptured){
                        
                        bool testResults = false;
                        if(!_middleFrameTestResult){
                            _middleFrameTestResult = [self checkMiddleFrameTestResult:diffXF diffY:diffYF];
                        }else{
                            testResults = [self checkTestResult:diffXF diffY:diffYF];
                        }
                        NSLog(@"FACE : Current Frame: testResults : %d ", testResults);
                        
                        if (testResults && _middleFrameTestResult) {
                            _goodFaceDetectionCounter++;
                            
                            if (_goodFaceDetectionCounter > 2) {
                                _isFaceDetected = true;
                                [self updateFaceDetectedColor];
                                [self stopAnimatingTurnArrow];
                                [self updateStatus:face_detected];
                                
                                //Maintain final result image
                                [self maintainFinalImages:_resultUiImage faceRect:_faceRect scaleFactor:1.0];
                                
                                NSString *light = [NSString stringWithFormat:@"%.d",lightScore];
                                NSString *focus = [NSString stringWithFormat:@"%.d",focusScore];
                                NSString *smilePercentage = [NSString stringWithFormat:@"Current Test : %@ DiffX: %d DiffY: %d", [self getCurrentTest:_currentTest], diffXF, diffYF];
                                NSString *operationTime=[ImageUtils getEndTime:startTime];
                                imageCaptureConfig=[MlKitFaceController getConfigDataJSON:light focus:focus smilePercentage:smilePercentage operationTime:operationTime];
                                
                                _responseStatus = @"0";
                                [self performSelectorOnMainThread:@selector(exitFromFaceDetectionScreen) withObject:self waitUntilDone:FALSE];
                            }
                        } else {
//                            LogUtils.printDebugLog(TAG, "FACE : Reset good image detected counter");
                            _goodFaceDetectionCounter = 0;
                        }
                    }else{
                        [self updateStatus:look_straight];
                    }
                }
            }else{
                _continuousFaceNotDetectedCounter++;
            }
        }else{
            _numberOfFrames = 0;
            [self stopAnimatingTurnArrow];
            [self resetResultCalculationValues];
        }
    });
}

//- (void)performBackgroundTask {
//    int currentTest = arc4random() %(4);
//    [self startTestResult:currentTest];
//}

#pragma mark - Private

- (void)setUpCaptureSessionOutput {
    dispatch_async(_sessionQueue, ^{
        [self->_captureSession beginConfiguration];
        // When performing latency tests to determine ideal capture settings,
        // run the app in 'release' mode to get accurate performance metrics
        self->_captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        output.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]};
        dispatch_queue_t outputQueue = dispatch_queue_create(videoDataOutputQueueLabel.UTF8String, nil);
        [output setSampleBufferDelegate:self queue:outputQueue];
        if ([self.captureSession canAddOutput:output]) {
            [self.captureSession addOutput:output];
            [self.captureSession commitConfiguration];
        } else {
            NSLog(@"%@", @"Failed to add capture session output.");
        }
    });
}

- (void)setUpCaptureSessionInput {
    dispatch_async(_sessionQueue, ^{
        AVCaptureDevicePosition cameraPosition = self.isUsingFrontCamera ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        AVCaptureDevice *device = [self captureDeviceForPosition:cameraPosition];
        if (device) {
            [self->_captureSession beginConfiguration];
            NSArray<AVCaptureInput *> *currentInputs = self.captureSession.inputs;
            for (AVCaptureInput *input in currentInputs) {
                [self.captureSession removeInput:input];
            }
            NSError *error;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (error) {
                NSLog(@"Failed to create capture device input: %@", error.localizedDescription);
                return;
            } else {
                if ([self.captureSession canAddInput:input]) {
                    [self.captureSession addInput:input];
                } else {
                    NSLog(@"%@", @"Failed to add capture session input.");
                }
            }
            [self.captureSession commitConfiguration];
        } else {
            NSLog(@"Failed to get capture device for camera position: %ld", cameraPosition);
        }
    });
}

- (void)startSession {
    dispatch_async(_sessionQueue, ^{
        [self->_captureSession startRunning];
    });
}

- (void)stopSession {
    dispatch_async(_sessionQueue, ^{
        [self->_captureSession stopRunning];
    });
}

- (void)setUpPreviewOverlayView {
    [_cameraView addSubview:_previewOverlayView];
    //    [NSLayoutConstraint activateConstraints:@[
    //                                              [_previewOverlayView.topAnchor constraintGreaterThanOrEqualToAnchor:_cameraView.topAnchor],
    //                                              [_previewOverlayView.centerYAnchor constraintEqualToAnchor:_cameraView.centerYAnchor],
    //                                              [_previewOverlayView.leadingAnchor constraintEqualToAnchor:_cameraView.leadingAnchor],
    //                                              [_previewOverlayView.trailingAnchor constraintEqualToAnchor:_cameraView.trailingAnchor],
    //                                              [_previewOverlayView.bottomAnchor constraintLessThanOrEqualToAnchor:_cameraView.bottomAnchor]
    //                                              ]];
}
- (void)setUpAnnotationOverlayView {
    [_cameraView addSubview:_annotationOverlayView];
//    [NSLayoutConstraint activateConstraints:@[
//                                              [_annotationOverlayView.topAnchor constraintEqualToAnchor:_cameraView.topAnchor],
//                                              [_annotationOverlayView.leadingAnchor constraintEqualToAnchor:_cameraView.leadingAnchor],
//                                              [_annotationOverlayView.trailingAnchor constraintEqualToAnchor:_cameraView.trailingAnchor],
//                                              [_annotationOverlayView.bottomAnchor constraintEqualToAnchor:_cameraView.bottomAnchor]
//                                              ]];
}

- (AVCaptureDevice *)captureDeviceForPosition:(AVCaptureDevicePosition)position  {
//    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
//    for (AVCaptureDevice *device in discoverySession.devices) {
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)removeDetectionAnnotations {
    for (UIView *annotationView in _annotationOverlayView.subviews) {
        [annotationView removeFromSuperview];
    }
}

- (void)updatePreviewOverlayView {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(_lastFrame);
    if (imageBuffer == nil) {
        return;
    }
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *context = [[CIContext alloc] initWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:ciImage.extent];
    if (cgImage == nil) {
        return;
    }
    UIImage *rotatedImage = [UIImage imageWithCGImage:cgImage scale:FIRconstantScale orientation:UIImageOrientationRight];
    
    CGImageRelease(cgImage);//Release it
    
    if (_isUsingFrontCamera) {
        CGImageRef rotatedCGImage = rotatedImage.CGImage;
        if (rotatedCGImage == nil) {
            return;
        }
        UIImage *mirroredImage = [UIImage imageWithCGImage:rotatedCGImage scale:FIRconstantScale orientation:UIImageOrientationLeftMirrored];
        _previewOverlayView.image = mirroredImage;
    } else {
        _previewOverlayView.image = rotatedImage;
    }
}

- (NSArray <NSValue *>*)convertedPointsFromPoints:(NSArray<NSValue *> *)points
                                            width:(CGFloat)width
                                           height:(CGFloat)height {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:points.count];
    for (NSValue *point in points) {
        CGPoint cgPointValue = point.CGPointValue;
        CGPoint normalizedPoint = CGPointMake(cgPointValue.x / width, cgPointValue.y / height);
        CGPoint cgPoint = [_previewLayer pointForCaptureDevicePointOfInterest:normalizedPoint];
        [result addObject: [NSValue valueWithCGPoint:cgPoint]];
    }
    return result;
}

- (CGPoint)normalizedPointFromVisionPoint:(FIRVisionPoint *)point
                                    width:(CGFloat)width
                                   height:(CGFloat)height {
    CGPoint cgPointValue = CGPointMake(point.x.floatValue, point.y.floatValue);
    CGPoint normalizedPoint = CGPointMake(cgPointValue.x / width, cgPointValue.y / height);
    CGPoint cgPoint = [_previewLayer pointForCaptureDevicePointOfInterest:normalizedPoint];
    return cgPoint;
}

- (void)drawPointOnFace:(CGPoint)point width:(CGFloat)width height:(CGFloat)height uiColor:(UIColor*)uiColor{
    
    [UIUtilities addCircleAtPoint:point
                           toView:self->_annotationOverlayView
                            color:uiColor
                           radius:FIRSmallDotRadius];
}

- (void)addContoursForFace:(FIRVisionFace *)face
                     width:(CGFloat)width
                    height:(CGFloat)height
              isFaceInside:(bool)isFaceInside
              standardizedRect:(CGRect)standardizedRect{
    
    UIColor *whiteColor = UIColor.whiteColor;
    UIColor *greenColor = UIColor.greenColor;
    UIColor *redColor = UIColor.redColor;
    
    UIColor *uiColor = redColor;
    if(isFaceInside){
        uiColor = whiteColor;
    }
    
    //Face Center
    CGPoint faceCenter = [self getFaceCenter:standardizedRect];
    [self drawPointOnFace:faceCenter width:width height:height uiColor:redColor];
    
    // Face
//    FIRVisionFaceContour *faceContour = [face contourOfType:FIRFaceContourTypeFace];
//    for (FIRVisionPoint *point in faceContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//
//    // Eyebrows
//    FIRVisionFaceContour *leftEyebrowTopContour = [face contourOfType:FIRFaceContourTypeLeftEyebrowTop];
//    for (FIRVisionPoint *point in leftEyebrowTopContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//    FIRVisionFaceContour *leftEyebrowBottomContour = [face contourOfType:FIRFaceContourTypeLeftEyebrowBottom];
//    for (FIRVisionPoint *point in leftEyebrowBottomContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//    FIRVisionFaceContour *rightEyebrowTopContour = [face contourOfType:FIRFaceContourTypeRightEyebrowTop];
//    for (FIRVisionPoint *point in rightEyebrowTopContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//    FIRVisionFaceContour *rightEyebrowBottomContour = [face contourOfType:FIRFaceContourTypeRightEyebrowBottom];
//    for (FIRVisionPoint *point in rightEyebrowBottomContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//
//    // Eyes
//    FIRVisionFaceContour *leftEyeContour = [face contourOfType:FIRFaceContourTypeLeftEye];
//    for (FIRVisionPoint *point in leftEyeContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//    FIRVisionFaceContour *rightEyeContour = [face contourOfType:FIRFaceContourTypeRightEye];
//    for (FIRVisionPoint *point in rightEyeContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//
//    // Lips
//    FIRVisionFaceContour *upperLipTopContour = [face contourOfType:FIRFaceContourTypeUpperLipTop];
//    for (FIRVisionPoint *point in upperLipTopContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//    FIRVisionFaceContour *upperLipBottomContour = [face contourOfType:FIRFaceContourTypeUpperLipBottom];
//    for (FIRVisionPoint *point in upperLipBottomContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//    FIRVisionFaceContour *lowerLipTopContour = [face contourOfType:FIRFaceContourTypeLowerLipTop];
//    for (FIRVisionPoint *point in lowerLipTopContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//    FIRVisionFaceContour *lowerLipBottomContour = [face contourOfType:FIRFaceContourTypeLowerLipBottom];
//    for (FIRVisionPoint *point in lowerLipBottomContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
//
//    // Nose -CENTER
//    FIRVisionFaceContour *noseBridgeContour = [face contourOfType:FIRFaceContourTypeNoseBridge];
//    NSArray<FIRVisionPoint *> *point = noseBridgeContour.points;
//    if([point count] > 1){
//        CGPoint cgPointTop = [self normalizedPointFromVisionPoint:point[0] width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPointTop
//                               toView:self->_annotationOverlayView
//                                color:whiteColor
//                               radius:FIRSmallDotRadius];
//        CGPoint cgPointBottom = [self normalizedPointFromVisionPoint:point[1] width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPointBottom
//                               toView:self->_annotationOverlayView
//                                color:greenColor
//                               radius:FIRSmallDotRadius];
//    }
//
//    //Nose -Bottom(three dot)
//    FIRVisionFaceContour *noseBottomContour = [face contourOfType:FIRFaceContourTypeNoseBottom];
//    for (FIRVisionPoint *point in noseBottomContour.points) {
//        CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
//        [UIUtilities addCircleAtPoint:cgPoint
//                               toView:self->_annotationOverlayView
//                                color:uiColor
//                               radius:FIRSmallDotRadius];
//    }
    
    NSMutableArray *low_face_contours_draw = [NSMutableArray arrayWithObjects:@0, @9, @18, @27, @69, @84, @112, nil];
    NSMutableArray *high_face_contours_draw = [NSMutableArray arrayWithObjects:@0, @9, @18, @27, @13, @23, @32, @5, @79, @84, @87, @63, @68, @71, @96, @112, @90, nil];
    NSMutableArray *remove_face_contours_draw = [NSMutableArray arrayWithObjects:@132, @131, nil];
    NSString *faceContours = faceContourValue;
    
    int i=0;
    FIRVisionFaceContour *faceContour = [face contourOfType:FIRFaceContourTypeAll];
    for (FIRVisionPoint *point in faceContour.points) {
        if ([faceContours isEqualToString:@"All"]){
            if(![remove_face_contours_draw containsObject:[NSNumber numberWithInt:i]]){
                CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
                [UIUtilities addCircleAtPoint:cgPoint
                                       toView:self->_annotationOverlayView
                                        color:uiColor
                                       radius:FIRSmallDotRadius];
            }
            
        }else if([faceContours isEqualToString:@"Low"]){
            if([low_face_contours_draw containsObject:[NSNumber numberWithInt:i]]){
                CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
                [UIUtilities addCircleAtPoint:cgPoint
                                       toView:self->_annotationOverlayView
                                        color:uiColor
                                       radius:FIRSmallDotRadius];
            }
        }else if([faceContours isEqualToString:@"Medium"]){
            if([high_face_contours_draw containsObject:[NSNumber numberWithInt:i]]){
                CGPoint cgPoint = [self normalizedPointFromVisionPoint:point width:width height:height];
                [UIUtilities addCircleAtPoint:cgPoint
                                       toView:self->_annotationOverlayView
                                        color:uiColor
                                       radius:FIRSmallDotRadius];
            }
        }
        i++;
    }
    
    // Nose -CENTER
    FIRVisionFaceContour *noseBridgeContour = [face contourOfType:FIRFaceContourTypeNoseBridge];
    NSArray<FIRVisionPoint *> *point = noseBridgeContour.points;
    if([point count] > 1){
        //            CGPoint cgPointTop = [self normalizedPointFromVisionPoint:point[0] width:width height:height];
        //            [UIUtilities addCircleAtPoint:cgPointTop
        //                                   toView:self->_annotationOverlayView
        //                                    color:whiteColor
        //                                   radius:FIRSmallDotRadius];
        CGPoint cgPointBottom = [self normalizedPointFromVisionPoint:point[1] width:width height:height];
        [UIUtilities addCircleAtPoint:cgPointBottom
                               toView:self->_annotationOverlayView
                                color:greenColor
                               radius:FIRSmallDotRadius];
    }
}

-(CGPoint)getFaceCenter:(CGRect)standardizedRect{
    float faceCenterX = standardizedRect.origin.x + standardizedRect.size.width/2;
    float faceCenterY = standardizedRect.origin.y + standardizedRect.size.height/2;
    
    CGPoint cgPoint = CGPointMake(faceCenterX, faceCenterY);
    return cgPoint;
}

-(CGPoint)getNosePoint:(FIRVisionFace *)face width:(CGFloat)width height:(CGFloat)height{
    CGPoint cgPoint;
    FIRVisionFaceContour *noseBridgeContour = [face contourOfType:FIRFaceContourTypeNoseBridge];
    NSArray<FIRVisionPoint *> *point = noseBridgeContour.points;
    if([point count] > 1){
        cgPoint = [self normalizedPointFromVisionPoint:point[1] width:width height:height];
    }
    return cgPoint;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (imageBuffer) {
        UIImage *actualImage = [ImageUtils UIImageFromSampleBuffer:sampleBuffer];
        
        _lastFrame = sampleBuffer;
        
        //Convert to Mat object
        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
        size_t bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
        size_t bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
        unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
        cv::Mat bgra = cv::Mat((int)bufferHeight,(int)bufferWidth,CV_8UC4,pixel);
        
        //Convert to FIRVision
        FIRVisionImage *visionImage = [[FIRVisionImage alloc] initWithBuffer:sampleBuffer];
        
        FIRVisionImageMetadata *metadata = [[FIRVisionImageMetadata alloc] init];
        UIImageOrientation orientation = [UIUtilities imageOrientationFromDevicePosition:_isUsingFrontCamera ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
        FIRVisionDetectorImageOrientation visionOrientation = [UIUtilities visionImageOrientationFromImageOrientation:orientation];
        metadata.orientation = visionOrientation;
        visionImage.metadata = metadata;
        CGFloat imageWidth = CVPixelBufferGetWidth(imageBuffer);
        CGFloat imageHeight = CVPixelBufferGetHeight(imageBuffer);
        switch (_currentDetector) {
            case DetectorOnDeviceFace:
                [self detectFacesOnDeviceInImage:visionImage bgra:bgra uiImage:actualImage width:imageWidth height:imageHeight];
                    break;
        }
    } else {
        NSLog(@"%@", @"Failed to get image buffer from sample buffer.");
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0 );
}

-(void)backPressed{
    //Setting response code 18 for back press
    _responseStatus = @"18";
    
  //  [self exitFromFaceDetectionScreen];
  //  [self updateResultObject:@"5" resultMessage:[StringLabels getLabelForKey:@"face_not_detected"]];
    if(nil != _delegate){
        //TODO Start
        [_delegate faceDetectionResponse:_resultDictionary instance:self];
        //Todo End
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)initializeLabels{
    light =  NSLocalizedString(@"light", @"");
    focus = NSLocalizedString(@"focus", @"");
    smile = NSLocalizedString(@"smile", @"");
    subject_is_too_dark_fc_detect = NSLocalizedString(@"subject_is_too_dark_fc_detect", @"");
    out_of_focus_fc_detect = NSLocalizedString(@"out_of_focus_fc_detect", @"");
    move_camera_closer_to_your_face = NSLocalizedString(@"move_camera_closer_to_your_face", @"");
    smile_please = NSLocalizedString(@"smile_please", @"");
    face_detected = NSLocalizedString(@"face_detected", @"");
    camera_movement_fc_detect = NSLocalizedString(@"camera_movement_fc_detect", @"");
    keep_face_steady = NSLocalizedString(@"keep_face_steady", @"");
    page_title_face_detection = NSLocalizedString(@"detecting_face", @"");
    look_straight = NSLocalizedString(@"look_straight", @"");
    turn_left = NSLocalizedString(@"turn_left", @"");
    turn_right = NSLocalizedString(@"turn_right", @"");
    move_up = NSLocalizedString(@"move_up", @"");
    move_down = NSLocalizedString(@"move_down", @"");
    too_much_glare_face_capture = NSLocalizedString(@"too_much_glare_face_capture", @"");
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

-(void)updateMessage:(int)lightScore focusScore:(int)focusScore smilePercentage:(double)smilePercentage cameraMovementPercentage:(double)cameraMovementPercentage faceMovementPercentage:(double)faceMovementPercentage facePercentage:(double)facePercentage frameSmilePercentage:(double)frameSmilePercentage{
    if(_isLabelVisible){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *label = [NSString stringWithFormat:@"Light: %d Focus: %d \r Camera Mov: %f Face Mov: %f \r Smile Diff: %f Face Per: %f \r Smile: %f", lightScore, focusScore, cameraMovementPercentage, faceMovementPercentage, smilePercentage, facePercentage, frameSmilePercentage];
            
            [thresholdLabel setText:label];
        });
    }
}

-(void)updateStatus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        //        if([AppItSDK getFaceHintMessageOnTop]) {
        //              [hintMsgUILabel setText:status];
        //        } else {
        //            [hintMsgUILabel1 setText:status];
        //        }
        [fd_hint_msg_ui_label setText:status];
        
    });
}
-(void)updateFaceDetectedColor{
    [faceOutlineOutsideUIImage setTintColor:[UIColor colorwithHexString:_detected_outside_face_outline_color alpha:detectedOutsideFaceOutlineColorTrans]];
    [faceOutlineUIImage setTintColor:[UIColor colorwithHexString:_detected_face_outline_color alpha:detectedFaceOutlineColorAlpha]];
}

-(void)updateStatusIcon:(NSString*)lightIcon smileIcon:(NSString*)smileIcon{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *light_icon = [frameworkBundle pathForResource:lightIcon ofType:@"png"];
        [light_hint_ui_button setImage:[UIImage imageNamed:light_icon] forState:UIControlStateNormal];
        
        NSString *smile_icon = [frameworkBundle pathForResource:smileIcon ofType:@"png"];
        [smile_hint_ui_button setImage:[UIImage imageNamed:smile_icon] forState:UIControlStateNormal];
        
    });
}

-(void)updateStatusIcon:(NSString*)lightIcon smileIcon:(NSString*)smileIcon detectedColor:(NSString*)detectedColor detectedColorAlpha:(float)detectedColorAlpha detectedOutsideFaceOutlineColor:(NSString*)detectedOutsideFaceOutlineColor dDetectedOutsideFaceOutlineColorTrans:(float)dDetectedOutsideFaceOutlineColorTrans {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *light_icon = [frameworkBundle pathForResource:lightIcon ofType:@"png"];
        [light_hint_ui_button setImage:[UIImage imageNamed:light_icon] forState:UIControlStateNormal];
        
        NSString *smile_icon = [frameworkBundle pathForResource:smileIcon ofType:@"png"];
        [smile_hint_ui_button setImage:[UIImage imageNamed:smile_icon] forState:UIControlStateNormal];
        
        [faceOutlineOutsideUIImage setTintColor:[UIColor colorwithHexString:detectedOutsideFaceOutlineColor alpha:dDetectedOutsideFaceOutlineColorTrans]];
        
        //Updated face outline icon with detected color
        [faceOutlineUIImage setTintColor:[UIColor colorwithHexString:detectedColor alpha:detectedColorAlpha]];
        NSString *faceOutlineIconPath = [frameworkBundle pathForResource:faceOutlineImage ofType:@"png"];
        UIImage *faceOutlineIcon = [[UIImage imageNamed:faceOutlineIconPath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [faceOutlineUIImage setImage:faceOutlineIcon];
        [self.view addSubview:faceOutlineUIImage];
    });
}

-(void)resetResultCalculationValues{
    //Counter
    _allComponentDetectionCounter = 0;
    _continuousFaceNotDetectedCounter = 0;
    _continuosCameraMovementCounter = 0;
    _continuosFaceMovementCounter = 0;
    
    //For result checking
//    _secondFrameFaceHeightPercentage = 0.0;
//    _secondFrameNoseMouthDifPercentage = 0.0;
//    _secondFrameNosePosition = 0.0;
//    
//    _resultFrameCaptured = false;
    
    _numberOfFrames = 0;
    _initialFrameCaptured = false;
}

-(bool)checkMiddleFrameTestResult:(int)diffX diffY:(int)diffY {
    float deltaX = diffX;
    float deltaY = diffY;
    bool result = false;
    
    float minPercent = 0.35f;
    float maxPercent = 0.7f;
    
    if (1 == _currentTest) {
        NSLog(@"FACE : checkMiddleFrameTestResult : LEFT X %f %d", deltaX, _initialDeltaX);
        //        if ((deltaX - _initialDeltaX) < -_leftDelta) {
        float left = (deltaX - _initialDeltaX);
        if (left > _leftDelta*minPercent && left < _leftDelta*maxPercent) {
            result = true;
        }
    } else if (2 == _currentTest) {
        NSLog(@"FACE : checkMiddleFrameTestResult : RIGHT X %f %d", deltaX, _initialDeltaX);
        //        if ((deltaX - _initialDeltaX) > _rightDelta) {
        float right = (deltaX - _initialDeltaX);
        if(right < 0){
            if (abs(right) > _rightDelta*minPercent && abs(right) < _rightDelta*maxPercent) {
                result = true;
            }
        }
    } else if (3 == _currentTest) {
        NSLog(@"FACE : checkMiddleFrameTestResult : UP Y %f %d", deltaY, _initialDeltaY);
        float up = (deltaY - _initialDeltaY);
        if (up > _upDelta*minPercent && up < _upDelta*maxPercent) {
            result = true;
        }
    } else if (4 == _currentTest) {
        NSLog(@"FACE : checkMiddleFrameTestResult : DOWN Y %f %d", deltaY, _initialDeltaY);
        float down = (deltaY - _initialDeltaY);
        if(down < 0){
            if (abs(down) > _downDelta*minPercent && abs(down) < _downDelta*maxPercent) {
                result = true;
            }
        }
    }
    
    return result;
}

-(bool)checkTestResult:(int)diffX diffY:(int)diffY {
    float deltaX = diffX;
    float deltaY = diffY;
    bool result = false;

    if (1 == _currentTest) {
        NSLog(@"FACE : checkTestResult : LEFT X %f %d", deltaX, _initialDeltaX);
//        if ((deltaX - _initialDeltaX) < -_leftDelta) {
        float left = (deltaX - _initialDeltaX);
        if (left > _leftDelta) {
            result = true;
        }
    } else if (2 == _currentTest) {
        NSLog(@"FACE : checkTestResult : RIGHT X %f %d", deltaX, _initialDeltaX);
//        if ((deltaX - _initialDeltaX) > _rightDelta) {
        float right = (deltaX - _initialDeltaX);
        if(right < 0){
            if (abs(right) > _rightDelta) {
                result = true;
            }
        }
    } else if (3 == _currentTest) {
        NSLog(@"FACE : checkTestResult : UP Y %f %d", deltaY, _initialDeltaY);
        float up = (deltaY - _initialDeltaY);
        if (up > _upDelta) {
            result = true;
        }
    } else if (4 == _currentTest) {
        NSLog(@"FACE : checkTestResult : DOWN Y %f %d", deltaY, _initialDeltaY);
        float down = (deltaY - _initialDeltaY);
        if(down < 0){
            if (abs(down) > _downDelta) {
                result = true;
            }
        }
    }
    
    return result;
}

-(int)generateRandomTest {
    int currentTest = arc4random() %(4);
    currentTest = currentTest + 1;
    if(_currentTest == currentTest){
        currentTest = arc4random() %(4);
        currentTest = currentTest + 1;
    }
    [self showTestStatus:currentTest];
    return currentTest;
}

-(void)executeTestResetTimerTask {
    testResetTimerTask = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(timerExecute) userInfo:nil repeats:NO];
}

-(void)timerExecute {
    _initialFrameCaptured = false;
    [self stopAnimatingTurnArrow];
}

-(void)showTestStatus:(int) currentTest {
    
    [leftArrow.layer removeAllAnimations];
    [rightArrow.layer removeAllAnimations];
    [topArrow.layer removeAllAnimations];
    [bottomArrow.layer removeAllAnimations];
    
    if(currentTest == 1) {
        if(_isUsingFrontCamera){
            [self updateStatus:turn_left];
        }else{
            [self updateStatus:turn_right];
        }
        
        [topArrow setHidden:YES];
        [bottomArrow setHidden:YES];
        [leftArrow setHidden:NO];
        [rightArrow setHidden:YES];
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            [UIView setAnimationRepeatCount:HUGE_VALF];
            leftArrow.frame = CGRectMake(leftArrow.frame.origin.x + 15, leftArrow.frame.origin.y, leftArrow.frame.size.width, leftArrow.frame.size.height);
        } completion:^(BOOL finished) {
            leftArrow.frame = CGRectMake(leftArrow.frame.origin.x - 15, leftArrow.frame.origin.y, leftArrow.frame.size.width, leftArrow.frame.size.height);
        }];
    } else if (currentTest == 2) {
        if(_isUsingFrontCamera){
            [self updateStatus:turn_right];
        }else{
            [self updateStatus:turn_left];
        }
        
        [topArrow setHidden:YES];
        [bottomArrow setHidden:YES];
        [leftArrow setHidden:YES];
        [rightArrow setHidden:NO];
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            [UIView setAnimationRepeatCount:HUGE_VALF];
            rightArrow.frame = CGRectMake(rightArrow.frame.origin.x - 15, rightArrow.frame.origin.y, rightArrow.frame.size.width, rightArrow.frame.size.height);
        } completion:^(BOOL finished) {
            rightArrow.frame = CGRectMake(rightArrow.frame.origin.x + 15, rightArrow.frame.origin.y, rightArrow.frame.size.width, rightArrow.frame.size.height);
        }];
    } else if (currentTest == 3) {
        [self updateStatus:move_up];
        
        [topArrow setHidden:NO];
        [bottomArrow setHidden:YES];
        [leftArrow setHidden:YES];
        [rightArrow setHidden:YES];
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            [UIView setAnimationRepeatCount:HUGE_VALF];
            topArrow.frame = CGRectMake(topArrow.frame.origin.x, topArrow.frame.origin.y + 15, topArrow.frame.size.width, topArrow.frame.size.height);
        } completion:^(BOOL finished) {
            topArrow.frame = CGRectMake(topArrow.frame.origin.x, topArrow.frame.origin.y - 15, topArrow.frame.size.width, topArrow.frame.size.height);
        }];
    } else if (currentTest == 4) {
        [self updateStatus:move_down];
        
        [topArrow setHidden:YES];
        [bottomArrow setHidden:NO];
        [leftArrow setHidden:YES];
        [rightArrow setHidden:YES];
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            [UIView setAnimationRepeatCount:HUGE_VALF];
            bottomArrow.frame = CGRectMake(bottomArrow.frame.origin.x, bottomArrow.frame.origin.y - 15, bottomArrow.frame.size.width, bottomArrow.frame.size.height);
        } completion:^(BOOL finished) {
            bottomArrow.frame = CGRectMake(bottomArrow.frame.origin.x, bottomArrow.frame.origin.y + 15, bottomArrow.frame.size.width, bottomArrow.frame.size.height);
        }];
    }
}

-(void)stopAnimatingTurnArrow {
    if([leftArrow isAnimating]){
        [leftArrow.layer removeAllAnimations];
    }
    if([rightArrow isAnimating]){
        [rightArrow.layer removeAllAnimations];
    }
    if([topArrow isAnimating]){
        [topArrow.layer removeAllAnimations];
    }
    if([bottomArrow isAnimating]){
        [bottomArrow.layer removeAllAnimations];
    }
    
    if(![leftArrow isHidden]){
        [leftArrow setHidden:YES];
    }
    if(![rightArrow isHidden]){
        [rightArrow setHidden:YES];
    }
    if(![topArrow isHidden]){
        [topArrow setHidden:YES];
    }
    if(![bottomArrow isHidden]){
        [bottomArrow setHidden:YES];
    }
}

-(void)maintainFinalImages:(UIImage*)resImage faceRect:(CGRect)faceRect scaleFactor:(int)scale_factor{
    if(!_isUsingFrontCamera){
        resImage = [ImageUtils rotatingUIImageByOrientation:resImage fromImageOrientation:UIImageOrientationRight];
    }else{
        resImage = [ImageUtils rotatingUIImageByOrientation:resImage fromImageOrientation:UIImageOrientationRightMirrored];
    }
    _respOrigionalImgData = [ImageUtils reduceImageSize:resImage imageSize:_image_size];
    
    cv::Mat resMat = [ImageUtils CVMatFromUIImage:resImage isGrayRequired:false];
    
    //faceRect coordinate are returned according to screen size
    double scaleFaceX = faceRect.origin.x * scale_factor;
    double scaleFaceY = faceRect.origin.y * scale_factor;
    double scaleFaceW = faceRect.size.width * scale_factor;
    double scaleFaceH = faceRect.size.height * scale_factor;
    
    //Calculating percentage of coordinate on screen size
    double scaleFaceXPer = scaleFaceX * 100/actualImageWidth;
    double scaleFaceYPer = scaleFaceY * 100/actualImageHeight;
    double scaleFaceWPer = scaleFaceW * 100/actualImageWidth;
    double scaleFaceHPer = scaleFaceH * 100/actualImageHeight;
    
    //Calculating points value on resMat where oval need to be drawn
    scaleFaceX = resMat.cols * scaleFaceXPer/100;
    scaleFaceY = resMat.rows * scaleFaceYPer/100;
    scaleFaceW = resMat.cols * scaleFaceWPer/100;
    scaleFaceH = resMat.rows * scaleFaceHPer/100;
    
    double xCenter = scaleFaceX + (scaleFaceW/2);
    double yCenter = scaleFaceY + (scaleFaceH/2);
    cv::Point center = cv::Point(xCenter, yCenter);
    cv::Size size = cv::Size(scaleFaceW * 0.6, scaleFaceH * 0.8);
    
    [self drawOval:resMat center:center size:size];
    ////    [self drawBlurredOval:resMat center:center size:size];
    //
    //    UIImage *ellipseImage = [ImageUtils UIImageFromCVMat:resMat convert_color:false];
    //    NSString *_respEllipseImgData = [ImageUtils reduceImageSize:ellipseImage imageSize:[AppItSDK getImageSize]];
    
    //TODO
    UIImage *ovalImage = [ImageUtils UIImageFromCVMat:resMat convert_color:false];
    NSString *_respOvalImageData = [ImageUtils reduceImageSize:ovalImage imageSize:_image_size];
    UIImage *ellipseImage = [self mergeImage:resImage];
    
    //Cropping image border little bit otherwise it is showing border on preview screen
    int w = ellipseImage.size.width * 0.01;
    int h = ellipseImage.size.height * 0.01;
    CGImage *ellipseCGImage = [ellipseImage CGImage];
    CGRect cropRect = CGRectMake(w, h, ellipseImage.size.width - w - w, ellipseImage.size.height -h -h);
    CGImageRef imageRef = CGImageCreateWithImageInRect(ellipseCGImage, cropRect);
    ellipseImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    //Cropping end
    
    _respEllipseImgData = [ImageUtils reduceImageSize:ellipseImage imageSize:_image_size];
}

-(void)drawOval:(cv::Mat&)rgba center: (cv::Point)center size:(cv::Size)size{
    if(size.height > -1 && size.width > -1){
        // Covering outside area of face with color
        cv::Mat blur = cv::Mat(rgba.size(), rgba.type());
        cv::rectangle(blur, cv::Point(0, 0), cv::Point(rgba.size().width, rgba.size().height), cv::Scalar(255, 255, 255), cv::FILLED);
        cv::Mat mask = cv::Mat::ones(rgba.size(), rgba.type());
        cv::bitwise_not(mask, mask);
        cv::ellipse(mask, center, size, 0, 0, 360, cv::Scalar(0, 0, 0), cv::FILLED, cv::FILLED, 0);
        blur.copyTo(rgba, mask);
    }
}

//-(UIImage*)mergeImage:(UIImage*)resImage{
//
//    //Result image size
//    CGSize resImageSize = [resImage size];
//
//    //Start image drawing
//    UIGraphicsBeginImageContext(resImageSize);
//
//    //Draw result image first
//    [resImage drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height) blendMode:kCGBlendModeNormal alpha:1.0f];
//
//    //Set outline border color and alpha
//    [[UIColor colorwithHexString:_outside_face_outline_color alpha:outsideFaceOutlineColorAlpha] setFill];
//
//    //Set outilne border image
//    [faceOutlineOutsideIcon drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height)];
//
//    //Set outline color and alpha
//    [[UIColor colorwithHexString:_detected_face_outline_color alpha:detectedFaceOutlineColorAlpha] setFill];
//
//    //Set outline image
//    [faceOutlineIcon drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height)];
//
//    //Create new image
//    UIImage *newResultImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    //End image drawing
//    UIGraphicsEndImageContext();
//
//    return newResultImage;
//}

-(UIImage*)mergeImage:(UIImage*)resImage{
    
    NSString *faceOutsideOutlineImage = @"face_outline_border_2732";
    NSString *faceOutlineImage = @"face_outline_2732";
    
    NSString *faceOutsideOutlinePath = [frameworkBundle pathForResource:faceOutsideOutlineImage ofType:@"png"];
    UIImage *faceOutsideOutline = [[UIImage imageNamed:faceOutsideOutlinePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    NSString *faceOutlineIconPath = [frameworkBundle pathForResource:faceOutlineImage ofType:@"png"];
    UIImage *faceOutline = [[UIImage imageNamed:faceOutlineIconPath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //Result image size
    CGSize resImageSize = [resImage size];
    
    //Start image drawing
    UIGraphicsBeginImageContext(resImageSize);
    
    //Draw result image first
    [resImage drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height) blendMode:kCGBlendModeNormal alpha:1.0f];
    
    //Set outline border color and alpha
    [[UIColor colorwithHexString:_outside_face_outline_color alpha:outsideFaceOutlineColorAlpha] setFill];
    
    //Set outilne border image
//    [faceOutlineOutsideIcon drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height)];
    [faceOutsideOutline drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height)];
    
    //Set outline color and alpha
    [[UIColor colorwithHexString:_detected_face_outline_color alpha:detectedFaceOutlineColorAlpha] setFill];
    
    //Set outline image
//    [faceOutlineIcon drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height)];
    [faceOutline drawInRect:CGRectMake(0, 0, resImageSize.width, resImageSize.height)];
    
    //Create new image
    UIImage *newResultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //End image drawing
    UIGraphicsEndImageContext();
    
    return newResultImage;
}

-(void)updateResultObject : (NSString*)resultCode resultMessage:(NSString*)resultMessage{
    [_resultDictionary setObject:resultCode forKey:@"StatusCode"];
    [_resultDictionary setObject:resultCode forKey:@"statusCode"];
    [_resultDictionary setObject:resultMessage forKey:@"statusMessage"];
}

-(void)updateResultObjectWithData : (NSString*)key resultMessage:(NSObject*)value{
    [_resultDictionary setObject:value forKey:key];
}

-(void)exitFromFaceDetectionScreen{
    
    [self resetResultCalculationValues];
    if([_responseStatus isEqualToString:@"0"]){

        if(_showPreviewScreen) {
            [self dismissViewControllerAnimated:NO completion:^{
                
                NSString *face = _respEllipseImgData;
                
                NSData* imageData = [[NSData alloc] initWithBase64EncodedString:face options:0];
                UIImage *actualImage = [UIImage imageWithData:imageData];

                FacePreviewViewController *previewController = [FacePreviewViewController new];
                previewController.preview_image = actualImage;
                previewController.delegate = _delegate;
                previewController.light_threshold = _light_threshold;
                previewController.focus_threshold = _focus_threshold;
                previewController.launch_front_camera = _launch_front_camera;
                previewController.smile_width_percentage_threshold = _smile_width_percentage_threshold;
                //TODO Start
                previewController.showPreviewScreen = _showPreviewScreen;
                previewController.face_outline_color = _face_outline_color;
                previewController.face_outline_color_alpha = _face_outline_color_alpha;
                previewController.detected_face_outline_color = _detected_face_outline_color;
                previewController.detected_face_outline_color_alpha = _detected_face_outline_color_alpha;
                previewController.outside_face_outline_color = _outside_face_outline_color;
                previewController.outside_face_outline_color_alpha = _outside_face_outline_color_alpha;
              //  previewController.titleImageFace = _titleImageFace;
                previewController.detected_outside_face_outline_color = _detected_outside_face_outline_color;
             previewController.detected_outside_face_outline_color_alpha = detectedOutsideFaceOutlineColorTrans;
                previewController.respOrigionalImgData = _respOrigionalImgData;
                previewController.respEllipseImgData = _respEllipseImgData;
                previewController.responseStatus = _responseStatus;
                previewController.allowBothCamera = _allowBothCamera;
                previewController.image_size = _image_size;
                previewController.isFaceTitleOnTop = _isFaceTitleOnTop;
                previewController.isFaceHintMessageOnTop = _isFaceHintMessageOnTop;
                previewController.glare_threshold = _glare_threshold;
                
                previewController.header_message_color = _title_message_color;
                previewController.header_message_color_alpha = _title_message_color_alpha;
                previewController.hint_message_color = _hint_message_color;
                previewController.hint_message_color_alpha = _hint_message_color_alpha;
                previewController.retry_button_color = _retry_button_color;
                previewController.retry_button_color_alpha = _retry_button_color_alpha;
                previewController.confirm_button_color = _confirm_button_color;
                previewController.confirm_button_color_alpha = _confirm_button_color_alpha;
                previewController.retry_button_border_color = _retry_button_border_color;
                previewController.retry_button_border_color_alpha = _retry_button_border_color_alpha;
                previewController.confirm_button_style = _confirm_button_style;
                previewController.confirm_button_style_alpha = _confirm_button_style_alpha;
                previewController.title_message_size = _title_message_size;
                previewController.hint_message_size = _hint_message_size;
                previewController.headerMsgStyle = _title_message_style;
                previewController.hintMsgStyle = _hint_message_style;
                previewController.title_message_color = _title_message_color;
                previewController.title_message_color_alpha = _title_message_color_alpha;
                previewController.hint_message_color = _hint_message_color;
                previewController.hint_message_color_alpha = _hint_message_color_alpha;
                previewController.back_button_color = _back_button_color;
                previewController.back_button_color_alpha = _back_button_color_alpha;
                //previewController.imageConfigDictionary=imageCaptureConfig;
                //TODO End
                //Call preview with caller app instance as we need to dismiss this view
//                [_delegate presentViewController:previewController animated:YES completion:nil];
                previewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [_delegate presentModalViewController:previewController animated:YES];
            }];
        }else {
            //TODO Start
//            [self updateResultObject:@"0" resultMessage:[StringLabels getLabelForKey:@"success_msg"]];
//            NSString *face = [AppItSDK getFaceImage];
//            NSString *croppedface = [AppItSDK getCroppedFaceImage];
//            NSString *oval = [AppItSDK getOvalFaceImage];
            //TODO End
//            NSString *face = @"", *croppedface = @"", *oval =@"";
//            if(nil != face){
//                [self updateResultObjectWithData:@"FACE" resultMessage:face];
//            }
//            if(nil != croppedface){
//                [self updateResultObjectWithData:@"PROCESSED_FACE" resultMessage:croppedface];
//            }
//            if(nil != oval){
//                [self updateResultObjectWithData:@"OVAL_FACE" resultMessage:oval];
//            }
           // [ResultData putImageConfigJSONValue:@"FACE" value:imageCaptureConfig];
            if(nil != _delegate){
                //TODO Start
                [_delegate faceDetectionResponse:_resultDictionary instance:self];
                //Todo End
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        //TODO Start
       // [self updateResultObject:@"5" resultMessage:[StringLabels getLabelForKey:@"face_not_detected"]];
        //TODO End
        if(nil != _delegate){
            //TODO Start
            [_delegate faceDetectionResponse:_resultDictionary instance:self];
            //Todo End
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

+(NSMutableDictionary *)getConfigDataJSON:(NSString*)light focus:(NSString*)focus smilePercentage:(NSString*)smilePercentage operationTime:(NSString*) operationTime{
    
    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    
    if(![NSStringUtils stringIsNilOrEmpty:light]){
        [nsDict setObject:light forKey:@"light"];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:focus]){
        [nsDict setObject:focus forKey:@"focus"];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:smilePercentage]){
        [nsDict setObject:smilePercentage forKey:@"smilePercentage"];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:operationTime]){
        [nsDict setObject:operationTime forKey:@"operationTime"];
    }
    return nsDict;
}

-(NSString*)getCurrentTest:(int)currentTest{
    if (1 == currentTest) {
        return @"Left";
    } else if (2 == currentTest) {
        return @"Right";
    } else if (3 == currentTest) {
        return @"Up";
    } else if (4 == currentTest) {
        return @"Down";
    }
    return @"";
}

double checkGlarePercentageFace(const cv::Mat &valueChannel, float light, float focus){
    
    cv::Mat glare;
    
    //    cv::Mat croppedMat = cv::Mat(valueChannel, roi);
    
    //    cv::threshold(croppedMat, glare, 245, 255, cv::THRESH_BINARY);
    //    cv::threshold(croppedMat, glare, 250, 255, cv::THRESH_BINARY);
    cv::threshold(valueChannel, glare, 250, 255, cv::THRESH_BINARY);
    std::vector<cv::Mat> contours;
    cv::Mat hierarchy;
    cv::findContours(glare, contours, hierarchy, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    
    double maxGlareArea = 0;
    
    for (int i = 0; i < contours.size(); i++) {
        double area = cv::contourArea(contours[i]);
        if(area>5){
            maxGlareArea += area;
        }
    }
    
    //    double imageTotalArea = roi.area();
    double imageTotalArea = valueChannel.cols*valueChannel.rows;
    
    double glarePercent = maxGlareArea*100/imageTotalArea;
    
    return glarePercent;
}

- (float)getAlpha:(int)transparency{
    if(transparency > 100){
        return 0;
    }
    
    double alp = transparency/100.0;
    double alpha = 1- alp;
    return (float)alpha;
}

@end
