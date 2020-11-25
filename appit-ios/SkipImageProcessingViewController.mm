//
//  SkipImageProcessingViewController.m
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 10/04/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import "ImageUtils.h"
#import "SkipImageProcessingViewController.h"
#include "CardDetector.h"
#import "NSLogUtils.h"
#import "UIColor+fromHex.h"
#import "SnippetCaptureController.h"
#import "SnippetData.h"
#import "ImagePreviewViewController.h"

@interface SkipImageProcessingViewController ()

- (void)setupAVCapture;
- (void)teardownAVCapture;

@property int frameCount;

@end

@implementation SkipImageProcessingViewController{
    AVCaptureSession *session;
    
    CGRect rootViewRect;
    
    std::atomic<float> image_intensity;
    std::atomic<float> image_focus_score;
    std::atomic<float> image_glare_score;
    
    UILabel *intensityAndFocusTVPortrait;
    NSString *light, *focus, *glare, *subject_is_too_dark_img_capture, *out_of_focus_img_capture, *too_much_glare_img_capture, *align_document_img_capture, *page_title_image_capture;
    
    NSBundle * frameworkBundle;
    float idOutlineColorAlpha, idOutlineOutsideColorAlpha,detectedIdOutlineColorAlpha;
    bool isiPhoneX;
    
    UILabel *title_textview, *hint_msg_textview;
    int powerdByLabel_iphoneXPadd;
    UILabel *header_textview_1, *header_textview_2;
    UILabel *center_textview_1, *center_textview_2;
    UILabel *footer_textview_1, *footer_textview_2;
    UIImageView *header_title_image, *center_title_image, *footer_title_image;
    UIImageView *title_imageview;
    cv::Mat bestFocusMat;
    cv::Rect bestFocusMatBox;
    int documentNotDetected;
    int startTime;
    int isQuadFocusedCounter;
    int bestFocus;
    NSMutableDictionary *imageCaptureConfig;
    id imagePrevInst;
    
}

-(void)dealloc {
    std::cout << "dealloc" << std::endl;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //Setting default value.
//        _MinImageIntensity = 70;
//        _MinImageFocusScore = 15;
        _imageHeight = 400;
        _imageWidth = 600;
        _enable_glare_detection = true;
//        _glare_percentage_threshold = 2;
//        _enable_capture_button = false;//Enable after given time only
//        _enable_capture_button_time = 10;
        _resultDictionary = [NSMutableDictionary new];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //startTime=[LanguageUtils getStartTime];
    powerdByLabel_iphoneXPadd = 0;
    isiPhoneX = false;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        
        switch (height) {
            case 2436:
                //"iPhone X"
                isiPhoneX = true;
                powerdByLabel_iphoneXPadd = 25;
                break;
            case 2688:
                //iPhoneXMAx
                isiPhoneX = true;
                powerdByLabel_iphoneXPadd = 25;
                break;
            case 1792:
                isiPhoneX = true;
                powerdByLabel_iphoneXPadd = 25;
                break;
            default:
                printf("unknown");
        }
    }
    
    //    //Set language bundle according to given configuration
    //    [[BundleLocalization sharedInstance] setLanguageForFramework:[AppItSDK getLanguage]];
    //    [self initializeLabels];
    page_title_image_capture = NSLocalizedString(@"capturing_identification", commen@"");
    //    frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.AppItFramework"];
    //
    //    _MinImageIntensity = [AppItSDK getMinimumLightThreshold];
    //    _MinImageFocusScore = [AppItSDK getMinimumFocusThreshold];
    //    _imageHeight = [AppItSDK getImageHeight];
    //    _imageWidth = [AppItSDK getImageWidth];
    //    _enable_glare_detection = true;
    //    _glare_percentage_threshold = [AppItSDK getGlarePercentageThreshold];
    //    //    _enable_capture_button = false;//Enable after given time only
    //    _enable_capture_button_time = [AppItSDK getEnableCaptureButtonTime];
    //    _id_outline_color = [AppItSDK getIdOutlineColor];
    //    _id_outline_color_alpha = [AppItSDK getIdOutlineColorAlpha];
    //    _id_outline_outside_color = [AppItSDK getIdOutsideOutlineColor];
    //    _id_outline_outside_color_alpha = [AppItSDK getIdOutsideOutlineAlpha];
    //    _detected_id_outline_color = [AppItSDK getDetectedIdOutLineColor];
    //    _detected_id_outline_color_alpha = [AppItSDK getDetectedIdOutlineAlpha];
    //    _title_message_style=[AppItSDK getTextFontStyle];
    //    _hint_message_style=[AppItSDK getTextFontStyle];
    //
    //    _title_message_color=[AppItSDK getTextColor];
    //    _title_message_color_alpha=[AppItSDK getTextColorAlpha];
    //    _hint_message_color=[AppItSDK getTextColor];
    //    _hint_message_color_alpha=[AppItSDK getTextColorAlpha];
    //
    //    _back_button_color=[AppItSDK getBackButtonColor];
    //    _back_button_color_alpha=[AppItSDK getBackButtonColorAlpha];
    //    float back_button_color_alpha_float = [AppItSDK getAlpha:_back_button_color_alpha];
    //
    //    if(_MinImageIntensity == 0){
    //        _MinImageIntensity = 60;
    //    }
    //
    //    if(_MinImageFocusScore == 0){
    //        _MinImageFocusScore = 20;
    //    }
    //
    //    if(_imageHeight == 0){
    //        _imageHeight = 830;
    //    }
    //
    //    if(_imageWidth == 0){
    //        _imageWidth = 1170;
    //    }
    //
    //    if(_glare_percentage_threshold == 0){
    //        _glare_percentage_threshold = 2;
    //    }
    //
    //    if(_enable_capture_button_time == 0){
    //        _enable_capture_button_time = 15;
    //    }
    //
    //    idOutlineColorAlpha = [AppItSDK getAlpha:_id_outline_color_alpha];
    //    idOutlineOutsideColorAlpha = [AppItSDK getAlpha:_id_outline_outside_color_alpha];
    //    detectedIdOutlineColorAlpha = [AppItSDK getAlpha:_detected_id_outline_color_alpha];
    
    frameworkBundle = [NSBundle mainBundle];
    
    float back_button_color_alpha_float = [self getAlpha:_back_button_color_alpha];
    
    if(_MinImageIntensity == 0){
        _MinImageIntensity = 60;
    }
    
    if(_MinImageFocusScore == 0){
        _MinImageFocusScore = 20;
    }
    
    if(_imageHeight == 0){
        _imageHeight = 830;
    }
    
    if(_imageWidth == 0){
        _imageWidth = 1170;
    }
    
    if(_glare_percentage_threshold == 0){
        _glare_percentage_threshold = 2;
    }
    
    if(_enable_capture_button_time == 0){
        _enable_capture_button_time = 15;
    }
    
    idOutlineColorAlpha = [self getAlpha:_id_outline_color_alpha];
    idOutlineOutsideColorAlpha = [self getAlpha:_id_outline_outside_color_alpha];
    detectedIdOutlineColorAlpha = [self getAlpha:_detected_id_outline_color_alpha];
    
    if(nil != _id_Capture_BorderType && [@"THIN" isEqualToString:_id_Capture_BorderType]) {
        targetRectangle.line_width = 5.0f;
    } else {
        targetRectangle.line_width = 10.0f;
    }
    
    targetRectangle.id_outline_color = _id_outline_color;
    targetRectangle.id_outline_color_alpha = idOutlineColorAlpha;
    targetRectangle.id_outline_outside_color = _id_outline_outside_color;
    targetRectangle.id_outline_outside_alpha = idOutlineOutsideColorAlpha;
    targetRectangle.detected_id_outline_color = _detected_id_outline_color;
    targetRectangle.detected_id_outline_color_alpha = detectedIdOutlineColorAlpha;
    targetRectangle.detected_id_outline_outside_color = _detected_id_outline_outside_color;
    targetRectangle.detected_id_outline_outside_alpha = [self getAlpha:_detected_id_outline_outside_color_alpha];
    targetRectangle.is_debuggable = false;

    //textView.textAlignment = NSTextAlignmentCenter;
    documentNameLabel.text = @"";
    intensityAndFocusTextView.text = @"";
    intensityAndFocusTVPortrait.text = @"";
    
    backPortraitButton.hidden=YES;
    rotateLandscapeButton.hidden=YES;
    rotatePortraitButton.hidden=YES;
    
    if(_enable_capture_button){
        [self enableButton];
    }else{
        [captureButton setHidden:true];
        [NSTimer scheduledTimerWithTimeInterval:_enable_capture_button_time
                                         target:self
                                       selector:@selector(enableButton)
                                       userInfo:nil
                                        repeats:NO];
    }
    
    //Adding UILabel for displaying Intensity,Focus in portrait mode-Start
    int viewHeight = self.view.bounds.size.height; //Height & Width are according to portrait mode
    int viewWidth = self.view.bounds.size.width;
    //FIX FOR : If this view-controller is launched from landscape viewcontroller(caller VC)
    if(self.view.bounds.size.height < self.view.bounds.size.width){
        viewHeight = self.view.bounds.size.width;
        viewWidth = self.view.bounds.size.height;
    }
    
    //Adding PORTRAIT back button programatically and hiding PORTRAIT Back button from storeyboard -Start
    //    CGRect backButtonRect = CGRectMake(0, viewWidth-50, 50, 50);
    int backPadding = 10;
    if(isiPhoneX){
        backPadding = backPadding + 15;
    }
    CGRect backButtonRect = CGRectMake(backPadding, viewWidth-50 - 10, 50, 50);
//    backPortraitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backPortraitButton addTarget:self action:@selector(backPressedPortrait:) forControlEvents:UIControlEventTouchUpInside];
    NSString *icon = [frameworkBundle pathForResource:@"back_cancel_arrow_portrait" ofType:@"png"];
    UIImage *backImagePortrait = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backPortraitButton setImage:backImagePortrait forState:UIControlStateNormal];
    //    [backButtonPortrait setTintColor:[UIColor colorwithHexString:_id_outline_color alpha:idOutlineColorAlpha]];
    [backPortraitButton setTintColor:[self colorwithHexString:_back_button_color alpha:back_button_color_alpha_float]];
    [backPortraitButton setFrame:backButtonRect];
    
    //[self.view addSubview:backPortraitButton];
    //Adding PORTRAIT back button programatically and hiding PORTRAIT Back button from storeyboard -End
    
    [backButton setTintColor:[self colorwithHexString:_back_button_color alpha:back_button_color_alpha_float]];
    
    if(_capture_in_portrait_mode){
        [backButton setHidden:true];
        [backPortraitButton setHidden:false];
        //Rotated textView to properly display it in portrait mode
        textView.transform = CGAffineTransformMakeRotation(270.0 * M_PI / 180.0);
    }else{
        [backButton setHidden:false];
        [backPortraitButton setHidden:true];
    }
    
    //Set up camera
    [self setupAVCapture];
    
    CALayer *rootLayer = [baseView layer];
    rootViewRect = [rootLayer bounds];
    
    float textViewPortraitX = viewHeight/2.0 + viewHeight/5 -10;
    float textViewPortraitY = viewWidth/2.0;
    float textViewPortraitW = 300;
    float textViewPortraitH = 30.0;
    
    CGRect someRect = CGRectMake(textViewPortraitX, textViewPortraitY, textViewPortraitW, textViewPortraitH);
    intensityAndFocusTVPortrait = [[UILabel alloc] initWithFrame:someRect];
    [intensityAndFocusTVPortrait setTextAlignment:NSTextAlignmentCenter];
    intensityAndFocusTVPortrait.transform = CGAffineTransformMakeRotation(270.0 * M_PI / 180.0);
    [self.view addSubview:intensityAndFocusTVPortrait];
    
    //Adding UILabel for displaying Intensity,Focus in portrait mode-End
    //Adding word wrap properties to textView -Start
    [textView setNumberOfLines:0];
    [textView setLineBreakMode:NSLineBreakByWordWrapping];
    [textView setTextAlignment:NSTextAlignmentCenter];
    //Adding word wrap properties to textView -End
    
    //Update text style-Start
    [NSStringUtils setLabelStyle:intensityAndFocusTVPortrait];
    [NSStringUtils setLabelStyle:intensityAndFocusTextView];
    //[NSStringUtils setLabelStyle:textView];
    //Update text style-End
    [self init_customize_ui_view];
    
    //Check for ImageSnippetCapture
    _isImageSnippetCapture = @"N";
    if([_imageProcDataDic objectForKey:@"imageSnippetPresentFlag"]) {
        _isImageSnippetCapture = [_imageProcDataDic objectForKey:@"imageSnippetPresentFlag"];
    }
    
    [intensityAndFocusTextView setHidden:true];
    [intensityAndFocusTVPortrait setHidden:true];
    
}

-(void)init_customize_ui_view {
    UIImage *title_ui_image;
    //    if(![AppItSDK getHideIDCapturetitleImg]){
    //        title_ui_image = [AppItSDK getIdCaptureTitleImage];
    //    }
    
    int viewHeight = self.view.bounds.size.height; //Height & Width are according to portrait mode
    int viewWidth = self.view.bounds.size.width;
    //FIX FOR : If this view-controller is launched from landscape viewcontroller(caller VC)
    if(self.view.bounds.size.height < self.view.bounds.size.width){
        viewHeight = self.view.bounds.size.width;
        viewWidth = self.view.bounds.size.height;
    }
    /********Adding HEADER Textview & Image -START********/
    int hTxtHeight = 50;
    
    //Title and Hint RECT
    int hHeight80 = 70*viewHeight/100;
    
    //Title-image RECT
    CGRect headerImageRect = CGRectMake(viewHeight/2 - title_ui_image.size.width/2,
                                        2,
                                        title_ui_image.size.width,
                                        title_ui_image.size.height);
    
    CGRect headerTextViewRect = CGRectMake((viewHeight - hHeight80)/2,
                                           headerImageRect.origin.y + headerImageRect.size.height,
                                           hHeight80,
                                           hTxtHeight);
    
    if(_capture_in_portrait_mode) {
        hTxtHeight = 80;
        int hImgTopPadding = 5;
        if(isiPhoneX){
            hImgTopPadding = 35;
        }
        
        headerImageRect = CGRectMake(0-title_ui_image.size.width/2 + headerImageRect.size.height/2 + hImgTopPadding,
                                     viewWidth/2-title_ui_image.size.height/2,
                                     title_ui_image.size.width,
                                     title_ui_image.size.height);
        
        int hTxtWidth = 80*viewWidth/100;
        int hTxtTopPadding = hImgTopPadding + headerImageRect.size.height + hTxtHeight/2;
        
        //Actual UI is rendering in landscape mode
        headerTextViewRect = CGRectMake(0-hTxtWidth/2 + hTxtTopPadding,
                                        viewWidth/2-hTxtHeight/2,
                                        hTxtWidth,
                                        hTxtHeight);
    }
    
    //    UILabel *header_textview_1 = [[UILabel alloc] initWithFrame:headerTextViewRect];
    //    //    [header_textview_1 setBackgroundColor:[UIColor redColor]]; //Uncomment it to visualize actual rectangle size
    //    [self.view addSubview:header_textview_1];
    //
    //    title_textview = header_textview_1;
    //
    //    if(_capture_in_portrait_mode) {
    //         title_textview.transform = CGAffineTransformMakeRotation(270.0 * M_PI / 180.0);
    //    }
    //
    //    //Adding word wrap properties and style to textView -Start
    //    [NSStringUtils setLabelStyle:title_textview];
    //    [title_textview setNumberOfLines:0];
    //    [title_textview setLineBreakMode:NSLineBreakByWordWrapping];
    //    [title_textview setTextAlignment:NSTextAlignmentCenter];
    //    [title_textview setFont:[UIFont boldSystemFontOfSize:22]];
    //
    //    NSString *textdata = NSLocalizedString(@"capturing_identification", @"");
    //    [title_textview setText:textdata];
    
    header_title_image = [[UIImageView alloc] initWithFrame:headerImageRect];
    [self.view addSubview:header_title_image];
    
    header_textview_1 = [[UILabel alloc] initWithFrame:headerTextViewRect];
    //    [header_textview_1 setBackgroundColor:[UIColor redColor]]; //Uncomment it to visualize actual rectangle size
    [self.view addSubview:header_textview_1];
    
    header_textview_2 = [[UILabel alloc] initWithFrame:headerTextViewRect];
    [self.view addSubview:header_textview_2];
    
    /********Adding HEADER Textview & Image -END********/
    
    
    /********Adding CENTER Textview & Image -START********/
    
    //Title-image RECT
    CGRect centerImageRect = CGRectMake(viewHeight/2 - title_ui_image.size.width/2,
                                        viewWidth/2 - title_ui_image.size.height/2,
                                        title_ui_image.size.width,
                                        title_ui_image.size.height);
    
    int cTxtHeight = 100;
    int cWidth = 80*viewWidth/100;
    
    //Title and Hint RECT
    CGRect centerTextViewRect = CGRectMake(viewHeight/2 - cWidth/2,
                                           viewWidth/2-cTxtHeight/2 + centerImageRect.size.height,
                                           cWidth,
                                           cTxtHeight);
    
    if(_capture_in_portrait_mode){
        centerTextViewRect = CGRectMake(centerTextViewRect.origin.x + centerImageRect.size.height,
                                        centerTextViewRect.origin.y - centerImageRect.size.height,
                                        centerTextViewRect.size.width,
                                        centerTextViewRect.size.height);
    }
    
    center_title_image = [[UIImageView alloc] initWithFrame:centerImageRect];
    [self.view addSubview:center_title_image];
    
    center_textview_1 = [[UILabel alloc] initWithFrame:centerTextViewRect];
    [self.view addSubview:center_textview_1];
    
    center_textview_2 = [[UILabel alloc] initWithFrame:centerTextViewRect];
    [self.view addSubview:center_textview_2];
    
    /********Adding CENTER Textview & Image -END********/
    
    
    /********Adding BOTTOM Textview & Image -START********/
    
    //Title-image RECT
    CGRect footerImageRect = CGRectMake(viewHeight/2 - title_ui_image.size.width/2,
                                        viewWidth - title_ui_image.size.height,
                                        title_ui_image.size.width,
                                        title_ui_image.size.height);
    
    int fTxtHeight = 80;
    int fWidth = 80*viewWidth/100;
    
    CGRect footerTextViewRect = CGRectMake(viewHeight/2-fWidth/2,
                                           viewWidth-footerImageRect.size.height-fTxtHeight,
                                           fWidth,
                                           fTxtHeight);
    if(_capture_in_portrait_mode){
        fTxtHeight = 80;
        
        int captureButtonPadding = 85;
        int fBottomPadding = captureButtonPadding + title_ui_image.size.height/2;
        
        footerImageRect = CGRectMake(viewHeight - title_ui_image.size.width/2 - fBottomPadding,
                                     viewWidth/2 - title_ui_image.size.height/2,
                                     title_ui_image.size.width,
                                     title_ui_image.size.height);
        
        fBottomPadding = 65;
        fBottomPadding  = fBottomPadding + fTxtHeight;
        
        footerTextViewRect = CGRectMake(viewHeight - fWidth/2-fBottomPadding, viewWidth/2-fTxtHeight/2, fWidth, fTxtHeight);
    }
    
    //id capture changes
    //powered by label
    if(_capture_in_portrait_mode) {
        // NSString *poweredByCn = [StringLabels getLabelForKey:@"powered_by_idmission"];
        NSString *poweredByCn = @"powered_by_idmission";
        CGSize poweredBySize = [NSLogUtils getUILabelSizeFromLabel:poweredByCn size:10];
        // CGRect poweredByLabelRectPortrait = CGRectMake(viewHeight - fWidth/2 - 9, viewWidth/2-fTxtHeight/2 + 3 , fWidth, 9);
        CGRect poweredByLabelRectPortrait = CGRectMake(viewHeight - fWidth/2 - 9, viewWidth/2-fTxtHeight/2 + 3 + powerdByLabel_iphoneXPadd , fWidth, 9);
        UILabel *poweredByLabelPortrait = [[UILabel alloc] initWithFrame:poweredByLabelRectPortrait];
        [poweredByLabelPortrait setNumberOfLines:0];
        [poweredByLabelPortrait setLineBreakMode:NSLineBreakByWordWrapping];
        [poweredByLabelPortrait setTextAlignment:NSTextAlignmentRight];
        // [poweredByLabelPortrait setText:[StringLabels getLabelForKey:@"powered_by_idmission"]];
        [poweredByLabelPortrait setText:@"powered_by_idmission"];
        [poweredByLabelPortrait setTextColor:[UIColor whiteColor]];
        [poweredByLabelPortrait setFont:[UIFont boldSystemFontOfSize:10]];
        [self.view addSubview:poweredByLabelPortrait];
        poweredByLabelPortrait.transform = CGAffineTransformMakeRotation(270.0 * M_PI / 180.0);
    } else {
        //NSString *poweredByCn = [StringLabels getLabelForKey:@"powered_by_idmission"];
        NSString *poweredByCn = @"powered_by_idmission";
        CGSize poweredBySize = [NSLogUtils getUILabelSizeFromLabel:poweredByCn size:10];
        //        CGRect poweredByLabelRectLandscape = CGRectMake(0, viewWidth-11, viewHeight, 10);
        CGRect poweredByLabelRectLandscape = CGRectMake(viewHeight - poweredBySize.width - powerdByLabel_iphoneXPadd, viewWidth-11, poweredBySize.width, 10);
        
        UILabel *poweredByLabelLandscape = [[UILabel alloc] initWithFrame:poweredByLabelRectLandscape];
        [poweredByLabelLandscape setNumberOfLines:0];
        [poweredByLabelLandscape setLineBreakMode:NSLineBreakByWordWrapping];
        [poweredByLabelLandscape setTextAlignment:NSTextAlignmentRight];
        [poweredByLabelLandscape setText:@"powered_by_idmission"];
        [poweredByLabelLandscape setTextColor:[UIColor whiteColor]];
        [poweredByLabelLandscape setFont:[UIFont boldSystemFontOfSize:10]];
        [self.view addSubview:poweredByLabelLandscape];
    }
    
    footer_title_image = [[UIImageView alloc] initWithFrame:footerImageRect];
    [self.view addSubview:footer_title_image];
    
    footer_textview_1 = [[UILabel alloc] initWithFrame:footerTextViewRect];
    [self.view addSubview:footer_textview_1];
    
    footer_textview_2 = [[UILabel alloc] initWithFrame:footerTextViewRect];
    [self.view addSubview:footer_textview_2];
    
    /********Adding BOTTOM Textview & Image -END********/
//    title_textview = header_textview_1;
//    hint_msg_textview = center_textview_2;
    title_imageview = footer_title_image;

    /********Intialize view position according to configuration -START********/
    
    NSString *TOP = @"TOP", *CENTER = @"CENTER", *BOTTOM = @"BOTTOM";
    if(!_hideIdCaptureTitle){
        if([[_id_Capture_Title_Align uppercaseString] isEqualToString:TOP]){
            title_textview = header_textview_1;
        }else if([[_id_Capture_Title_Align uppercaseString] isEqualToString:CENTER]){
            title_textview = center_textview_1;
        }else if([[_id_Capture_Title_Align uppercaseString] isEqualToString:BOTTOM]){
            title_textview = footer_textview_1;
        }
    }else{
        [title_textview setHidden:true];
    }
    
    if(!_hideIdCaptureHintMessage){
        if([[_id_Capture_Hint_Align uppercaseString] isEqualToString:TOP]){
            hint_msg_textview = header_textview_2;
        }else if([[_id_Capture_Hint_Align uppercaseString] isEqualToString:CENTER]){
            hint_msg_textview = center_textview_2;
        }else if([[_id_Capture_Hint_Align uppercaseString] isEqualToString:BOTTOM]){
            hint_msg_textview = footer_textview_2;
        }
    }else{
        [hint_msg_textview setHidden:true];
    }
    
    
    //    NSString *TOP = @"TOP", *CENTER = @"CENTER", *BOTTOM = @"BOTTOM";
    //    if(![AppItSDK getHideIDCaptureTitle]){
    //        if([[[AppItSDK getIdCaptureTitleAlignment] uppercaseString] isEqualToString:TOP]){
    //            title_textview = header_textview_1;
    //        }else if([[[AppItSDK getIdCaptureTitleAlignment] uppercaseString] isEqualToString:CENTER]){
    //            title_textview = center_textview_1;
    //        }else if([[[AppItSDK getIdCaptureTitleAlignment] uppercaseString] isEqualToString:BOTTOM]){
    //            title_textview = footer_textview_1;
    //        }
    //    }else{
    //        [title_textview setHidden:true];
    //    }
    //
    //    if(![AppItSDK getHideIDCapturehintMsg]){
    //        if([[[AppItSDK getIdCaptureHintMsgAlignment] uppercaseString] isEqualToString:TOP]){
    //            hint_msg_textview = header_textview_2;
    //        }else if([[[AppItSDK getIdCaptureHintMsgAlignment] uppercaseString] isEqualToString:CENTER]){
    //            hint_msg_textview = center_textview_2;
    //        }else if([[[AppItSDK getIdCaptureHintMsgAlignment] uppercaseString] isEqualToString:BOTTOM]){
    //            hint_msg_textview = footer_textview_2;
    //        }
    //    }else{
    //        [hint_msg_textview setHidden:true];
    //    }
    //
    //    if(![AppItSDK getHideIDCapturetitleImg]){
    //        if([[[AppItSDK getIdCaptureTitleImgAlignment] uppercaseString] isEqualToString:TOP]){
    //            title_imageview = header_title_image;
    //        }else if([[[AppItSDK getIdCaptureTitleImgAlignment] uppercaseString] isEqualToString:CENTER]){
    //            title_imageview = center_title_image;
    //        }else if([[[AppItSDK getIdCaptureTitleImgAlignment] uppercaseString] isEqualToString:BOTTOM]){
    //            title_imageview = footer_title_image;
    //        }
    //    }else{
    //        [title_imageview setHidden:true];
    //    }
    
    /********Intialize view position according to configuration -END********/
    
    //Rotate views if portrait mode -Start
    if(_capture_in_portrait_mode){
        title_textview.transform = CGAffineTransformMakeRotation(270.0 * M_PI / 180.0);
        hint_msg_textview.transform = CGAffineTransformMakeRotation(270.0 * M_PI / 180.0);
        title_imageview.transform = CGAffineTransformMakeRotation(270.0 * M_PI / 180.0);
    }
    //Rotate views if portrait mode -End
    
    //Adding word wrap properties and style to textView -Start
    [NSStringUtils setLabelStyle:title_textview];
    [title_textview setNumberOfLines:0];
    [title_textview setLineBreakMode:NSLineBreakByWordWrapping];
    [title_textview setTextAlignment:NSTextAlignmentCenter];
    [title_textview setFont:[UIFont boldSystemFontOfSize:22]];
    
    [NSStringUtils setLabelStyle:hint_msg_textview];
    [hint_msg_textview setNumberOfLines:0];
    [hint_msg_textview setLineBreakMode:NSLineBreakByWordWrapping];
    [hint_msg_textview setTextAlignment:NSTextAlignmentCenter];
    [hint_msg_textview setFont:[UIFont boldSystemFontOfSize:18]];
    [hint_msg_textview setFont:[UIFont fontWithName:_hint_message_style size:title_textview.font.pointSize]];
    [hint_msg_textview setTextColor:[UIColor colorwithHexString:_hint_message_color alpha:[self getAlpha:_hint_message_color_alpha]]];
    //Adding word wrap properties and style to textView -End
    
    //Set label text, lable image and assing hint-text-view
    [title_textview setText:page_title_image_capture];
    [title_imageview setImage:title_ui_image];
    //[title_textview setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [title_textview setFont:[UIFont fontWithName:_title_message_style size:title_textview.font.pointSize]];
    [title_textview setTextColor:[UIColor colorwithHexString:_title_message_color alpha:[self getAlpha:_title_message_color_alpha]]];
    
    textView = hint_msg_textview;
    
    if(![NSStringUtils stringIsNilOrEmpty:_text_font_size]){
        //[hint_msg_textview setFont: [UIFont fontWithName:_hint_message_style size:[_text_font_size integerValue]]];
        if(![_hint_message_style isEqualToString:@"Default"]){
            [hint_msg_textview setFont: [UIFont fontWithName:_hint_message_style size:[_text_font_size integerValue]]];
        }else{
            [hint_msg_textview setFont:[UIFont systemFontOfSize:[_text_font_size integerValue]]];
        }
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:_header_font_size]){
        // [title_textview setFont: [UIFont fontWithName:_title_message_style size:[_header_font_size integerValue]]];
        if(![_title_message_style isEqualToString:@"Default"]){
            [title_textview setFont: [UIFont fontWithName:_title_message_style size:[_header_font_size integerValue]]];
        }else{
            [title_textview setFont:[UIFont systemFontOfSize:[_header_font_size integerValue]]];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated{
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self teardownAVCapture];
}

-(void)enableButton{
    [captureButton setHidden:false];
    //[textView setHidden:true];
}


- (void)setupAVCapture
{
    NSError *error = nil;
    
    session = [AVCaptureSession new];
    
    if (UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPhone){
        session.sessionPreset = AVCaptureSessionPresetHigh;
    }else if(UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPad){
        session.sessionPreset = AVCaptureSessionPresetPhoto;
    }else{
        [NSLogUtils printLogInDebugMode:@"setupAVCapture : Unable to set sessionPreset"];
    }
    
    // Select a video device, make an input
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device lockForConfiguration:&error];
    
    if([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    
    [device unlockForConfiguration];
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    // add the input to the session
    if ( [session canAddInput:deviceInput] ){
        [session addInput:deviceInput];
    }
    
    
    // Make a video data output
    videoDataOutput = [AVCaptureVideoDataOutput new];
    
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
    
    // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
    // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
    // see the header doc for setSampleBufferDelegate:queue: for more information
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ( [session canAddOutput:videoDataOutput] ){
        [session addOutput:videoDataOutput];
    }
    
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
    /*
     * Initializing blank _videoPreviewLayer as we are going to display
     * updated Mat from 'captureOutput' method on preview screen
     */
    //Uncomment below line if actual frame need to be drawn on preview screen
//    //    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
//    //    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
//    previewLayer= [[AVCaptureVideoPreviewLayer alloc]init];
//    [previewLayer setFrame:self.view.bounds];
//    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    //    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    //    previewLayer= [[AVCaptureVideoPreviewLayer alloc]init];
    [previewLayer setFrame:self.view.bounds];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self.frameCount=0;
    
    CALayer *rootLayer = [previewView layer];
    [rootLayer addSublayer:previewLayer];
    [session startRunning];
}

// clean up capture setup
- (void)teardownAVCapture
{
    [session removeOutput:videoDataOutput];
    [session stopRunning];
    [previewLayer removeFromSuperlayer];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    CALayer *rootLayer = [baseView layer];
    rootViewRect = [rootLayer bounds];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:rootViewRect];
    
    float aspectRatio = [self aspect_ratio:_imageWidth height:_imageHeight];
    
    // recalculate the roi for the change in the rootViewRect
    targetRectangle.roi = [self getSearchRoiForWidth:rootViewRect.size.width height:rootViewRect.size.height aspectRatio:aspectRatio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    self.frameCount++;
    //NSLog(@"frameCount increment");
    
    if(self.frameCount>10){
        //NSLog(@"frameCount process");
        if(sampleBuffer){
            CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
            CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
            
            size_t bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
            size_t bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
            unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
            //put buffer in open cv, no memory copied
            cv::Mat bgra = cv::Mat((int)bufferHeight,(int)bufferWidth,CV_8UC4,pixel);
            
            @synchronized(self) {
                if(!bgra.empty()){
                    cv::Mat resultMat = bgra.clone();
                    
                    float aspectRatio = [self aspect_ratio:_imageWidth height:_imageHeight];
                    
                    // determines the ROI that the image needs to be found in (controlled by AspectRatio)
                    CGRect roi = [self getSearchRoiForWidth: bgra.cols height:bgra.rows aspectRatio: aspectRatio];
                    
                    // check requirements from CardDetector
                    cv::Rect roiRect = cv::Rect(roi.origin.x, roi.origin.y, roi.size.width, roi.size.height);
                    
                                        if(_enable_capture_button){
                                            if(_capturedImagePressed){
                                                _capturedImagePressed = false;
                                                if(!resultMat.empty()){
                                                    cv::Mat im = cv::Mat(resultMat, roiRect).clone();
                                                    //Releasing mat
                                                    resultMat.release();
                    
//                                                    NSString *operationTime=[NSStringUtils getEndTime:startTime];
//                                                    imageCaptureConfig=[ImagePreviewViewController getConfigDataJSON:nil focus:nil glare:nil isAutoCapture:@"N" operationTime:operationTime];
                    
                                                    [self exitWithResultSuccess:im];
                                                }
                                            }
                                            return;
                                        }
                    //For test
                    //        cv::rectangle(bgra, cv::Point(roiRect.tl().x, roiRect.tl().y), cv::Point(roiRect.br().x, roiRect.br().y), cv::Scalar(255, 255, 0), 2);
                    
                    double scale_factor = 4.0;
                    
                    cv::Mat hsv;
                    cv::resize(bgra, hsv, cv::Size(), 1/scale_factor, 1/scale_factor, cv::INTER_LINEAR);
                    cv::cvtColor(hsv, hsv, cv::COLOR_BGR2HSV_FULL);
                    
                    double sfx = 1.0*bgra.cols/hsv.cols;
                    double sfy = 1.0*bgra.rows/hsv.rows;
                    
                    std::vector<cv::Mat> channels;
                    cv::split(hsv, channels);
                    //Releasing mat
                    hsv.release();
                    
                    image_intensity = cv::mean(channels[2])[0]; // detect intensity                                   -Full Size
                   // image_focus_score = focus_score_for_image(channels[2]); // check to see if image is in focus
                    //                    image_focus_score = focus_score_for_image(channels[2]); // check to see if image is in focus    -Full Size
                    //Multipying focus with 1.5
                    image_focus_score = image_focus_score*1.5;
                    
                    //We have scalled actual image with given 'scale_factor' so we need to scale roi as well
                    cv::Rect resizeRoi = cvRect(roiRect.x/scale_factor, roiRect.y/scale_factor,
                                                roiRect.width/scale_factor, roiRect.height/scale_factor);
                    //Crop the search roi
                    cv::Mat croppedMat = cv::Mat(channels[2], resizeRoi);
                    
                    //                    image_focus_score = focus_score_for_image(channels[2]); // check to see if image is in focus    -FUll Image
                    image_focus_score = focus_score_for_image(croppedMat); // check to see if image is in focus    -Cropped Image
                    image_focus_score = image_focus_score*1.5;
                    image_glare_score = checkGlarePercentage(croppedMat, image_intensity, image_focus_score);   //  -Cropped Image
                    
                    croppedMat.release();
                    
                    bool lowLightDetected=false, lowFocusDetected=false, glareDetected=false;
                    if(image_intensity < _MinImageIntensity){
                        lowLightDetected = true;
                    }
                    if(image_focus_score < _MinImageFocusScore){
                        lowFocusDetected = true;
                    }
                    if(image_glare_score > _glare_percentage_threshold){
                        glareDetected = true;
                    }
                    
                    if(lowLightDetected || lowFocusDetected || glareDetected){
                        //Do Nothing
                    }else{
                        std::vector<cv::Scalar> scalerList = getScalerList();
                        
                        //Remove previously added rectangle
                        [targetRectangle.rects removeAllObjects];
                        //Remove the previous error
                        targetRectangle.tl_error = false;
                        targetRectangle.tr_error = false;
                        targetRectangle.bl_error = false;
                        targetRectangle.br_error = false;
                        
                        for (int channelCount=0; channelCount<3; channelCount++) {
                            
                            //                cv::Rect box = find_rect_1d(channels[channelCount], sfx, sfy);
                            cv::Rect box = find_rect_1d_new(channels[channelCount], sfx, sfy, roiRect);
                            
                            if(box.area() > 0){
                                cv::rectangle(bgra, cv::Point(box.tl().x, box.tl().y),
                                              cv::Point(box.br().x, box.br().y), scalerList[channelCount], 2);
                                
                                //Detected rect percentage in mat(bgra)
                                int xPerInMat = box.tl().x * 100/bgra.cols;
                                int yPerInMat = box.tl().y * 100/bgra.rows;
                                int wPerInMat = box.width * 100/bgra.cols;
                                int hPerInMat = box.height * 100/bgra.rows;
                                
                                //UI Width and Height
                                int w = targetRectangle.bounds.size.width;
                                int h = targetRectangle.bounds.size.height;
                                
                                //Detected rect coordinate in UI
                                int xPerInUI = xPerInMat * w/100;
                                int yPerInUI = yPerInMat * h/100;
                                int wPerInUI = wPerInMat * w/100;
                                int hPerInUI = hPerInMat * h/100;
                                
                                CGRect rect = CGRectMake( xPerInUI, yPerInUI, wPerInUI, hPerInUI);
                                [targetRectangle.rects addObject:[NSValue valueWithCGRect:rect]];
                            }
                            
                            bool documentDetected = is_rect_a_document_rectangle(roiRect, box);
                            
                            if(documentDetected){
                                documentNotDetected = 0;
                                
                                bool isFocused = [self isFocusedMat:resultMat.clone() roi:box light:image_intensity focus:image_focus_score glare:image_glare_score previewMat:bgra searchroi:roiRect];
                                if(isFocused){
                                    isQuadFocusedCounter++;
                                }else{
                                    isQuadFocusedCounter = 0;
                                }
                                
                                if(bestFocusMat.empty()){
                                    bestFocusMat = resultMat.clone();
                                    bestFocusMatBox = box;
                                    bestFocus = image_focus_score;
                                }else if(image_focus_score > bestFocus){
                                    bestFocusMat = resultMat.clone();
                                    bestFocusMatBox = box;
                                    bestFocus = image_focus_score;
                                }
                            }else{
                                documentNotDetected++;
                            }
                            
                            if(documentNotDetected > 2){
                                isQuadFocusedCounter = 0;
                                bestFocusMat.release();
                            }
                            //                            if(documentDetected){
                            if(documentDetected && isQuadFocusedCounter > 3){
                                //Update result frame with best focused frame
                                resultMat = bestFocusMat;
                                box = bestFocusMatBox;
                                
                                /*
                                 * Adding buffer while cropping image
                                 */
                                double x1Buf = box.tl().x - (box.width * 0.1);
                                if(x1Buf < 0){
                                    x1Buf = 0;
                                }
                                double y1Buf = box.tl().y - (box.height * 0.05);
                                if(y1Buf < 0){
                                    y1Buf = 0;
                                }
                                double x2Buf = box.br().x + (box.width * 0.1);
                                if(x2Buf > resultMat.cols){
                                    x2Buf = resultMat.cols;
                                }
                                double y2Buf = box.br().y + (box.height * 0.05);
                                if(y2Buf > resultMat.rows){
                                    y2Buf = resultMat.rows;
                                }
                                //Updating cropping rectangle with buffered values
                                box = cv::Rect(cv::Point(x1Buf, y1Buf), cv::Point(x2Buf, y2Buf));
                                
                                //For displaying complete green rectangle
                                targetRectangle.has_document = documentDetected;
                                [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:TRUE];
                                
                                cv::Mat im = cv::Mat(resultMat, box).clone();
                                //Releasing mat
                                resultMat.release();
                                
                                //                                NSString *light = [NSString stringWithFormat:@"%.2f",image_intensity.load()];
                                //                                NSString *focus = [NSString stringWithFormat:@"%.2f",image_focus_score.load()];
                                //                                NSString *glare = [NSString stringWithFormat:@"%.0f",image_glare_score.load()];
                                //                                NSString *operationTime=[LanguageUtils getEndTime:startTime];
                                //                                imageCaptureConfig=[ImagePreviewViewController getConfigDataJSON:light focus:focus glare:glare isAutoCapture:@"Y" operationTime:operationTime];
                                
                                
                                [self exitWithResultSuccess:im];
                                
                                break;
                            }
                        }
                    }
                    
                    [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:TRUE];
                    
                    if(_capturedImagePressed){
                        _capturedImagePressed = false;
                        if(!resultMat.empty()){
                            cv::Mat im = cv::Mat(resultMat, roiRect).clone();
                            //Releasing mat
                            resultMat.release();
                            
                            //                            NSString *operationTime=[LanguageUtils getEndTime:startTime];
                            //                            imageCaptureConfig=[ImagePreviewViewController getConfigDataJSON:nil focus:nil glare:nil isAutoCapture:@"N" operationTime:operationTime];
                            //
                            [self exitWithResultSuccess:im];
                        }
                    }
                    
                    //Drawing updated Mat image on preview layer
                    //                    CGImageRef imageRef = [ImageUtils CGImageFromCVMat:bgra];
                    //                    //Releasing mat
                    bgra.release();
                    resultMat.release();
                    //                    dispatch_sync(dispatch_get_main_queue(), ^{
                    //                        previewLayer.contents = (__bridge id)imageRef;
                    //                    });
                    //                    CGImageRelease(imageRef);
                }
            }
            
            // release pixel buffer
            CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
        }
    }
}

-(void) updateUI {
    
    NSString *light = NSLocalizedString(@"light", @"");
    NSString *focus = NSLocalizedString(@"focus", @"");
    NSString *glare = NSLocalizedString(@"glare", @"");
    
    if(_enable_glare_detection){
        if(_capture_in_portrait_mode){
            [intensityAndFocusTVPortrait setText:[NSString stringWithFormat:@"%@: %.0f %@: %.0f %@: %.0f",light, image_intensity.load(), focus, image_focus_score.load(), glare, image_glare_score.load()] ];
        }else{
            [intensityAndFocusTextView setText:[NSString stringWithFormat:@"%@: %.0f %@: %.0f %@: %.0f",light, image_intensity.load(), focus, image_focus_score.load(), glare, image_glare_score.load()] ];
        }
    }else{
        if(_capture_in_portrait_mode){
            [intensityAndFocusTVPortrait setText:[NSString stringWithFormat:@"%@: %.0f %@: %.0f", light, image_intensity.load(), focus, image_focus_score.load()] ];
        }else{
            [intensityAndFocusTextView setText:[NSString stringWithFormat:@"%@: %.0f %@: %.0f", light, image_intensity.load(), focus, image_focus_score.load()] ];
        }
        
    }
    
    bool errorMsgDisplayed = false;
    if(image_intensity < _MinImageIntensity){
        [textView setText:NSLocalizedString(@"low_light_msg", @"")];
        errorMsgDisplayed = true;
    }
    if(image_focus_score < _MinImageFocusScore && !errorMsgDisplayed){
        [textView setText:NSLocalizedString(@"out_of_focus", @"")];
        errorMsgDisplayed = true;
    }
    if(_enable_glare_detection){
        if(image_glare_score > _glare_percentage_threshold && !errorMsgDisplayed){
            [textView setText:NSLocalizedString(@"glare_msg", @"")];
            errorMsgDisplayed = true;
        }
    }
    if(!errorMsgDisplayed){
        [textView setText:NSLocalizedString(@"align_document_msg", @"")];
    }
    
    [targetRectangle setNeedsDisplay];
}

-(float) aspect_ratio:(float)width height:(float)height {
    return 1.0f * width/height;
}

-(CGRect) getSearchRoiForWidth:(float)w height:(float)h aspectRatio:(float)ratio {
    
    return [self getSearchRoiForWidth:w height:h aspectRatio:ratio heightFromWidth:true];
}

-(CGRect) getSearchRoiForWidth:(float)w height:(float)h aspectRatio:(float)ratio heightFromWidth:(bool)heightFromWidth {
    
    double width;
    double height;
    
    if (heightFromWidth) {
        //        width = w * .85;
        //        height = width / ratio;
        width = w * .93;
        height = width / ratio;
    } else {
        //        height = h;
        //        width = h * ratio;
        height = h*0.93;
        width = h * ratio;
    }
    CGPoint tl = CGPointMake((w - width) / 2.0, (h - height) / 2.0);
    CGPoint br = CGPointMake(tl.x + width, tl.y + height);
    
    if (tl.y < 0)
        return [self getSearchRoiForWidth:w height:h aspectRatio:ratio heightFromWidth:false];
    
    return CGRectMake(tl.x, tl.y, br.x-tl.x, br.y-tl.y);
}

-(void)unwind_to_uiwebview {
    
    [self performSegueWithIdentifier: @"Unwind To UIWebView" sender: self];
    
}

- (IBAction)rotatePortrait:(id)sender {
    
    backButton.hidden=YES;
    rotatePortraitButton.hidden=YES;
    
    backPortraitButton.hidden=NO;
    rotateLandscapeButton.hidden=NO;
    
    NSString* templateDirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* templateFilePath = [NSString stringWithFormat:@"%@%@%@", templateDirPath, @"/",@"high_rotate.xml"];
    [self updateViewConstraints];
}

- (IBAction)rotateLandscape:(id)sender {
    
    backPortraitButton.hidden=YES;
    rotateLandscapeButton.hidden=YES;
    
    backButton.hidden=NO;
    rotatePortraitButton.hidden=NO;
    
    NSString* templateDirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* templateFilePath = [NSString stringWithFormat:@"%@%@%@", templateDirPath, @"/",@"high.xml"];
    [self updateViewConstraints];
    
}

- (IBAction)backPressedLandscape:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backPressedPortrait:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)captureImage:(id)sender {
    _capturedImagePressed = YES;
}

float focus_score_from_full_mat(const cv::Mat &image, float scale_factor) {
    cv::Mat hsv;
    cv::resize(image, hsv, cv::Size(), 1/scale_factor, 1/scale_factor, cv::INTER_LINEAR);
    cv::cvtColor(hsv, hsv, cv::COLOR_BGR2HSV_FULL);
    
    std::vector<cv::Mat> channels;
    cv::split(hsv, channels);
    //Releasing mat
    hsv.release();
    
    float foc = focus_score_for_image(channels[2]);
    return foc;
}

float focus_score_for_image(const cv::Mat &image) {
    
    assert(image.channels() == 1);
    assert(image.depth() == CV_8U);
    
    cv::Mat sobel_image;
    cv::Sobel(image, sobel_image, CV_16S, 1, 1);
    
    //    cv::Mat r = cv::abs(sobel_image);
    cv::Mat r;
    cv::absdiff(sobel_image, cv::Scalar(0), r);
    cv::Scalar meanScalar,devScalar;
    
    cv::meanStdDev(r, meanScalar, devScalar);
    return devScalar[0];
}

double checkGlarePercentageInFullMat(const cv::Mat &image, float scale_factor, float light, float focus){
    
    cv::Mat hsv;
    cv::resize(image, hsv, cv::Size(), 1/scale_factor, 1/scale_factor, cv::INTER_LINEAR);
    cv::cvtColor(hsv, hsv, cv::COLOR_BGR2HSV_FULL);
    
    std::vector<cv::Mat> channels;
    cv::split(hsv, channels);
    //Releasing mat
    hsv.release();
    
    double glarePercentage = checkGlarePercentage(channels[2], light, focus);
    
    return glarePercentage;
    
}

//double checkGlarePercentage(const cv::Mat &valueChannel, const cv::Rect &roi){
//
//    cv::Mat glare;
//
//    cv::Mat croppedMat = cv::Mat(valueChannel, roi);
//
//    //    cv::threshold(croppedMat, glare, 245, 255, cv::THRESH_BINARY);
//    cv::threshold(croppedMat, glare, 250, 255, cv::THRESH_BINARY);
//    std::vector<cv::Mat> contours;
//    cv::Mat hierarchy;
//    cv::findContours(glare, contours, hierarchy, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
//
//    double maxGlareArea = 0;
//
//    for (int i = 0; i < contours.size(); i++) {
//        double area = cv::contourArea(contours[i]);
//        if(area>5){
//            maxGlareArea += area;
//        }
//    }
//
//    double imageTotalArea = roi.area();
//
//    double glarePercent = maxGlareArea*100/imageTotalArea;
//
//    return glarePercent;
//}

//OLD
double checkGlarePercentage(const cv::Mat &valueChannel, float light, float focus){
    
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

cv::Rect find_rect_1d(const cv::Mat &im, double sfx, double sfy) {
    
    int height = im.rows;;
    int width = im.cols;
    
    const int cols_len = width - 1;
    double* cols = new double[cols_len];
    
    const int rows_len = height - 1;
    double* rows = new double[rows_len];
    
    for (int c = 0; c < width - 1; c++) {
        cols[c] = std::abs(cv::mean(cv::Mat(im, cv::Rect(c, 0, 1, height))).val[0] - cv::mean(cv::Mat(im, cv::Rect(c + 1, 0, 1, height))).val[0]);
    }
    
    for (int r = 0; r < height - 1; r++) {
        rows[r] = std::abs(cv::mean(cv::Mat(im, cv::Rect(0, r, width, 1))).val[0] - cv::mean(cv::Mat(im, cv::Rect(0, r + 1, width, 1))).val[0]);
    }
    
    int left = -1, right = -1, top = -1, bottom = -1;
    
    for (int c = 0; c < cols_len; c++){
        //        if (cols[c] > 5) {
        //            left = c;
        //            break;
        //        }
        if (cols[c] > 9) {
            left = c;
            break;
        } else if (left != -1 && cols[c] > 5) {
            left = c;
        }
    }
    
    for (int c = cols_len - 1; c >= 0; c--){
        //        if (cols[c] > 5) {
        //            right = c;
        //            break;
        //        }
        if (cols[c] > 9) {
            right = c;
            break;
        } else if (right != -1 && cols[c] > 5) {
            right = c;
        }
    }
    
    for (int r = 0; r < rows_len; r++){
        //        if (rows[r] > 5) {
        //            top = r;
        //            break;
        //        }
        if (rows[r] >9){
            top = r;
            break;
        }else if (top != -1 && rows[r] >5){
            top = r;
        }
    }
    
    for (int r = rows_len - 1; r >= 0; r--){
        //        if (rows[r] > 5) {
        //            bottom = r;
        //            break;
        //        }
        if (rows[r] >9){
            bottom = r;
            break;
        }else if (bottom != -1 && rows[r] >5){
            bottom = r;
        }
    }
    
    delete [] cols;
    delete [] rows;
    
    if (left == -1 || right == -1 || top == -1 || bottom == -1)
        return cv::Rect();
    
    
    return cv::Rect(cv::Point(left * sfx, top * sfy),
                    cv::Point(right * sfx, bottom * sfy));
}

cv::Rect find_rect_1d_new(const cv::Mat &im, double sfx, double sfy, const cv::Rect searchRoi) {
    
    //    int height = (int)((searchRoi.height/sfy)*1.4);//im.height();
    //    int width = (int)((searchRoi.width/sfx)*1.4);//im.width();
    
    //    int x = (int)(searchRoi.tl().x/sfx)-(int)(width*0.2);
    //    int y = (int)(searchRoi.tl().y/sfy)-(int)(height*0.2);
    
    int height = (int)((searchRoi.height/sfy)*1.3);//im.height();
    int width = (int)((searchRoi.width/sfx)*1.3);//im.width();
    
    int x = (int)(searchRoi.tl().x/sfx)-(int)(width*0.1);
    int y = (int)(searchRoi.tl().y/sfy)-(int)(height*0.1);
    
    if(x<0){
        x=0;
    }
    if(y<0){
        y=0;
    }
    
    if(height>im.rows-y){
        height = im.rows-y;
    }
    if(width>im.cols-x){
        width = im.cols-x;
    }
    
    
    const int cols_len = width - 1;
    double* cols = new double[cols_len];
    
    const int rows_len = height - 1;
    double* rows = new double[rows_len];
    
    for (int c = 0; c < width - 1; c++) {
        cols[c] = std::abs(cv::mean(cv::Mat(im, cv::Rect(c+x, y, 1, height))).val[0]
                           - cv::mean(cv::Mat(im, cv::Rect(c +x + 1, y, 1, height))).val[0]);
    }
    
    for (int r = 0; r < height - 1; r++) {
        rows[r] = std::abs(cv::mean(cv::Mat(im, cv::Rect(x, r+y, width, 1))).val[0]
                           - cv::mean(cv::Mat(im, cv::Rect(x, r +y + 1, width, 1))).val[0]);
    }
    
    int left = -1, right = -1, top = -1, bottom = -1;
    
    for (int c = 0; c < cols_len; c++){
        if (cols[c] > 9) {
            left = c + x;
            break;
        } else if (left != -1 && cols[c] > 5) {
            left = c + x;
        }
    }
    
    for (int c = cols_len - 1; c >= 0; c--){
        if (cols[c] > 9) {
            right = c + x;
            break;
        } else if (right != -1 && cols[c] > 5) {
            right = c + x;
        }
    }
    
    for (int r = 0; r < rows_len; r++){
        if (rows[r] >9){
            top = r + y;
            break;
        }else if (top != -1 && rows[r] >5){
            top = r + y;
        }
    }
    
    for (int r = rows_len - 1; r >= 0; r--){
        if (rows[r] >9){
            bottom = r + y;
            break;
        }else if (bottom != -1 && rows[r] >5){
            bottom = r + y;
        }
    }
    
    delete [] cols;
    delete [] rows;
    
    if (left == -1 || right == -1 || top == -1 || bottom == -1)
        return cv::Rect();
    
    //    left=left-(int)((right-left)*.01);
    //    top=top-(int)((bottom-top)*.01);
    //    right=right+(int)((right-left)*.01);
    //    bottom=bottom+(int)((bottom-top)*.01);
    
    
    return cv::Rect(cv::Point(left * sfx, top * sfy),
                    cv::Point(right * sfx, bottom * sfy));
}

std::vector<cv::Scalar> getScalerList(){
    std::vector<cv::Scalar> scaler;
    scaler.push_back(cv::Scalar(255, 0, 0));
    scaler.push_back(cv::Scalar(0, 255, 0));
//    scaler.push_back(cv::Scalar(0, 0, 255));
    scaler.push_back(cv::Scalar(255, 255, 0));
    return scaler;
}

bool is_rect_a_document_rectangle(const cv::Rect& searchRoi, const cv::Rect &r) {
    
    double percent = 0.20;
    //    double buffer = 0.03;//0.01
    double buffer = 0.01;
    
    if (r.area() <= 0)
        return false;
    else if (r.x < searchRoi.x-searchRoi.width*buffer || r.x > searchRoi.x + searchRoi.width * percent) // left
        return false;
    else if (r.br().x > searchRoi.br().x + searchRoi.width*buffer || r.br().x < searchRoi.br().x - searchRoi.width * percent) // right
        return false;
    else if (r.br().y > searchRoi.br().y + searchRoi.height*buffer || r.br().y < searchRoi.br().y - searchRoi.height * percent) // bottom
        return false;
    else if (r.y < searchRoi.y- searchRoi.height*buffer || r.y > searchRoi.y + searchRoi.height * percent) { // top
        return false;
    }
    
    return true;
}
-(bool)isFocusedMat:(cv::Mat)mat roi:(cv::Rect)roi light:(float)light focus:(float)focus glare:(float)glare previewMat:(cv::Mat)previewMat searchroi:(cv::Rect)searchroi{
    //    UIImage *actual =  [ImageUtils UIImageFromCVMat:mat convert_color:true];
    
    //Quadrant of preview
    //    cv::Rect tlRectPreview = cv::Rect(searchroi.x, searchroi.y, searchroi.width/2, searchroi.height/2);
    //    cv::Rect trRectPreview = cv::Rect(searchroi.x + searchroi.width/2, searchroi.y, searchroi.width/2, searchroi.height/2);
    //    cv::Rect brRectPreview = cv::Rect(searchroi.x + searchroi.width/2, searchroi.y + searchroi.height/2, searchroi.width/2, searchroi.height/2);
    //    cv::Rect blRectPreview = cv::Rect(searchroi.x, searchroi.y + searchroi.height/2, searchroi.width/2, searchroi.height/2);
    
    //Crop detected image
    cv::Mat cropped =  cv::Mat(mat, roi).clone();
    mat.release();
    
    //Quadrant of detected image
    cv::Rect tlRect = cv::Rect(0, 0, cropped.cols/2, cropped.rows/2);
    cv::Rect trRect = cv::Rect(cropped.cols/2, 0, cropped.cols/2, cropped.rows/2);
    cv::Rect brRect = cv::Rect(cropped.cols/2, cropped.rows/2, cropped.cols/2, cropped.rows/2);
    cv::Rect blRect = cv::Rect(0, cropped.rows/2, cropped.cols/2, cropped.rows/2);
    
    //Cropped Quadrant image
    cv::Mat rgbtl = cv::Mat(cropped, tlRect);
    cv::Mat rgbtr = cv::Mat(cropped, trRect);
    cv::Mat rgbbr = cv::Mat(cropped, brRect);
    cv::Mat rgbbl = cv::Mat(cropped, blRect);
    
    float scale_factor = 2.0;
    
    //    float tl = focus_score_from_full_mat(rgbtl, scale_factor);
    //    float bl = focus_score_from_full_mat(rgbbl, scale_factor);
    //    float tr = focus_score_from_full_mat(rgbtr, scale_factor);
    //    float br = focus_score_from_full_mat(rgbbr, scale_factor);
    
    //    UIImage *ui = [ImageUtils UIImageFromCVMat:rgbtl convert_color:true];
    
    float tl = focus_score_from_full_mat(rgbtl, scale_factor)*2.0;
    float bl = focus_score_from_full_mat(rgbbl, scale_factor)*2.0;
    float tr = focus_score_from_full_mat(rgbtr, scale_factor)*2.0;
    float br = focus_score_from_full_mat(rgbbr, scale_factor)*2.0;
    
    double tlGlare = checkGlarePercentageInFullMat(rgbtl, scale_factor, light, focus);
    double blGlare = checkGlarePercentageInFullMat(rgbbl, scale_factor, light, focus);
    double trGlare = checkGlarePercentageInFullMat(rgbtr, scale_factor, light, focus);
    double brGlare = checkGlarePercentageInFullMat(rgbbr, scale_factor, light, focus);
    
    NSLog(@"isFocusedMat FOCUS ::: tl : %f  bl : %f tr : %f br : %f focus : %f", tl, bl, tr, br, focus);
    NSLog(@"isFocusedMat GLARE ::: tl : %f  bl : %f tr : %f br : %f glare : %f", tlGlare, blGlare, trGlare, brGlare, glare);
    
    cropped.release();
    rgbtl.release();
    rgbtr.release();
    rgbbr.release();
    rgbbl.release();
    
    //    cv::Scalar scaler = cv::Scalar(0, 0, 255);
    
    bool tlError = false, blError = false, trError = false, brError = false;
    
    int focusCount = 0;
    if(tl > _MinImageFocusScore){
        focusCount++;
    }else {
        tlError = true;
        //        cv::rectangle(previewMat, tlRectPreview, scaler, 10);
    }
    if(bl > _MinImageFocusScore){
        focusCount++;
    }else {
        blError = true;
        //        cv::rectangle(previewMat, blRectPreview, scaler, 10);
    }
    if(tr > _MinImageFocusScore){
        focusCount++;
    }else {
        trError = true;
        //        cv::rectangle(previewMat, trRectPreview, scaler, 10);
    }
    if(br > _MinImageFocusScore){
        focusCount++;
    }else {
        brError = true;
        //        cv::rectangle(previewMat, brRectPreview, scaler, 10);
    }
    
    int glareCount = 0;
    if(tlGlare < _glare_percentage_threshold){
        glareCount++;
    }else {
        tlError = true;
        //        cv::rectangle(previewMat, tlRectPreview, scaler, 10);
    }
    if(blGlare < _glare_percentage_threshold){
        glareCount++;
    }else {
        blError = true;
        //        cv::rectangle(previewMat, blRectPreview, scaler, 10);
    }
    if(trGlare < _glare_percentage_threshold){
        glareCount++;
    }else {
        trError = true;
        //        cv::rectangle(previewMat, trRectPreview, scaler, 10);
    }
    if(brGlare < _glare_percentage_threshold){
        glareCount++;
    }else {
        brError = true;
        //        cv::rectangle(previewMat, brRectPreview, scaler, 10);
    }
    
    targetRectangle.tl_error = tlError;
    targetRectangle.tr_error = trError;
    targetRectangle.bl_error = blError;
    targetRectangle.br_error = brError;
    
    targetRectangle.tl_focus = (int)tl;
    targetRectangle.tr_focus = (int)tr;
    targetRectangle.bl_focus = (int)bl;
    targetRectangle.br_focus = (int)br;
    
    targetRectangle.tl_glare = (int)tlGlare;
    targetRectangle.tr_glare = (int)trGlare;
    targetRectangle.bl_glare = (int)blGlare;
    targetRectangle.br_glare = (int)brGlare;
    
    //    if([AppItSDK isDebugEnable]){
    //        if(tlError){
    //            std::string tlVal = "Focus: "+std::to_string((int)tl)+" Glare: "+std::to_string((int)tlGlare);
    //            [self drawText:tlVal point:cv::Point(tlRectPreview.x, tlRectPreview.y + tlRectPreview.height/2) mat:previewMat];
    //        }
    //
    //        if(blError){
    //            std::string blVal = "Focus: "+std::to_string((int)bl)+" Glare: "+std::to_string((int)blGlare);
    //            [self drawText:blVal point:cv::Point(blRectPreview.x, blRectPreview.y + blRectPreview.height/2) mat:previewMat];
    //        }
    //
    //        if(trError){
    //            std::string trVal = "Focus: "+std::to_string((int)tr)+" Glare: "+std::to_string((int)trGlare);
    //            [self drawText:trVal point:cv::Point(trRectPreview.x, trRectPreview.y + trRectPreview.height/2) mat:previewMat];
    //        }
    //
    //        if(brError){
    //            std::string brVal = "Focus: "+std::to_string((int)br)+" Glare: "+std::to_string((int)brGlare);
    //            [self drawText:brVal point:cv::Point(brRectPreview.x, brRectPreview.y + brRectPreview.height/2) mat:previewMat];
    //        }
    //    }
    
    bool glareDetected = false, outOfFocusDetected = false;
    
    if(glareCount >= 4){
        NSLog(@"isFocusedMat ::: QUAD CORRECT GLARE");
    }else {
        glareDetected = true;
    }
    if(focusCount >= 3){
        NSLog(@"isFocusedMat ::: QUAD CORRECT FOCUS");
    }else {
        outOfFocusDetected = true;
    }
    
    return (!glareDetected && !outOfFocusDetected);
}

-(void)drawText:(cv::String)text point:(cv::Point)point mat:(cv::Mat)mat{
    cv::Scalar scaler = cv::Scalar(0, 0, 255);
    cv::putText(mat,
                text,
                point, // Coordinates
                cv::FONT_HERSHEY_COMPLEX_SMALL, // Font
                3.0, // Scale. 2.0 = 2x bigger
                scaler, // BGR Color
                5);
}

-(void)exitWithResultSuccess:(cv::Mat)mat{
    
    NSLog(@"::::: exitWithResultSuccess :::::");
    
    //Stop currently running session before launching preview screen
    //Otherwise it will run in background....and we need to start it again if user press retry button
    [session stopRunning];
    
    UIImage *actualImage = [ImageUtils UIImageFromCVMat:mat convert_color:true];
    //Releasing mat
    mat.release();
    
    if(_capture_in_portrait_mode){
        actualImage = [ImageUtils rotatingUIImageByOrientation:actualImage fromImageOrientation:UIImageOrientationRight];
    }
    
    _resultImage = actualImage;
    
    if([_imageProcDataDic objectForKey:@"imageSnippetPresentFlag"] && [@"Y" isEqualToString:[_imageProcDataDic objectForKey:@"imageSnippetPresentFlag"]]) {
    
        dispatch_async(dispatch_get_main_queue(), ^{
           //self.view.hidden = YES;
            //[self.view setBackgroundColor:[UIColor whiteColor]];
            NSArray *viewsToRemove = [self.view subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
            [self.view setBackgroundColor:[UIColor whiteColor]];
        });
        NSMutableArray *snippetArrayList = [[NSMutableArray alloc] init];
        SnippetCaptureController *controller = [SnippetCaptureController new];
        controller.delegate = self;
        controller.actualImage = _resultImage;
        controller.view.backgroundColor = [UIColor whiteColor];
        NSMutableDictionary *snippetDict = [_imageProcDataDic objectForKey:@"imageSnippetConfig"];
        NSArray *snippetArray  = [snippetDict objectForKey:@"ImageSnippetReverseMapping"];
        NSMutableArray *snippetNameArray = [ [NSMutableArray alloc] init];
        
        for(int i = 0; i < [snippetArray count]; i++)  {
            NSMutableDictionary *objectDictionary = [snippetArray objectAtIndex:i];
            NSString *responseFormFieldKey = [objectDictionary objectForKey:@"ResponseFormFieldKey"];
            NSString *snippetName = [objectDictionary objectForKey:@"SnippetName"];
            NSString *isMandatory = [objectDictionary objectForKey:@"IsMandatory"];
            
            if([@"Y" isEqualToString:isMandatory]) {
                snippetName = [snippetName stringByAppendingString:@"*"];
            }
            SnippetData *snippetData = [[SnippetData alloc] initWithSnippet:snippetName responseformfieldkey:responseFormFieldKey ismandatory:isMandatory];
            
            [snippetArrayList addObject:snippetData];
            [snippetNameArray addObject:snippetName];
        }
        
        controller.snippetNameArray = snippetNameArray;
        controller.snippetCaptureList = snippetArrayList;
        controller.isDocumentImageProcessing = true;
        dispatch_sync(dispatch_get_main_queue(), ^{
            controller.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:controller animated:YES completion:nil];
        });
    } else {
        
        bool showPreviewScreen = true;
        if(showPreviewScreen) {
            ImagePreviewViewController *previewController = [ImagePreviewViewController new];
            previewController.preview_image = actualImage;
            previewController.delegate = _delegate;
            previewController.delegate2 = self;
            previewController.imageType = _imageType;
            previewController.genericFieldName = nil;
            previewController.id_outline_color = _id_outline_color;
            previewController.id_outline_color_alpha = _id_outline_color_alpha;
            previewController.id_outside_outline_color = _id_outline_outside_color;
            previewController.id_outside_outline_color_alpha = _id_outline_outside_color_alpha;
            previewController.headerMsgStyle = _title_message_style;
            previewController.header_Size = _header_font_size;
            previewController.text_Size = _text_font_size;
            previewController.hintMsgStyle = _hint_message_style;
            previewController.header_message_color = _title_message_color;
            previewController.header_message_color_alpha = _title_message_color_alpha;
            previewController.hint_message_color = _hint_message_color;
            previewController.hint_message_color_alpha = _hint_message_color_alpha;
            
            previewController.retry_button_color = _retry_button_color;
            previewController.retry_button_color_alpha = _retry_button_color_alpha;
            previewController.confirm_button_color = _confirm_button_color;
            previewController.confirm_button_color_alpha = _confirm_button_color_alpha;
            previewController.retry_button_border = _retry_button_border_color;
            previewController.retry_button_border_alpha = _retry_button_border_color_alpha;
            previewController.confirm_button_style = _confirm_button_style_color;
            previewController.confirm_button_style_alpha = _confirm_button_border_style_alpha;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *viewsToRemove = [self.view subviews];
                for (UIView *v in viewsToRemove) {
                    [v removeFromSuperview];
                }
                //[self.view setBackgroundColor:[UIColor clearColor]];
                [self.view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9]];
                //self.modalPresentationStyle = UIModalPresentationCurrentContext;
                //view.isOpaque = false
                //self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                previewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:previewController animated:NO completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self performSelectorOnMainThread:@selector(unwind_to_uiwebview) withObject:self waitUntilDone:FALSE];
                [session stopRunning];//For avoiding black screen after image capture
            });
        }
        
    }
    
}

-(void) exitFromSkipImagProcessingConfirmButton:(id)instance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(unwind_to_uiwebview) withObject:self waitUntilDone:FALSE];
        [session stopRunning];//For avoiding black screen after image capture
        imagePrevInst = instance;
        [self performSelector:@selector(lanunchOnResume) withObject:self afterDelay:0.5];
    });
}

-(void) exitFromSkipImagProcessingRetryButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(unwind_to_uiwebview) withObject:self waitUntilDone:FALSE];
        [session stopRunning];//For avoiding black screen after image capture
    });
}

-(void)lanunchOnResume {
    ImagePreviewViewController *ctrl = (ImagePreviewViewController *)imagePrevInst;
    [ctrl dismissViewControllerAnimated:YES completion:nil];
}

-(void) exitFromSkipImagProcessing:(NSMutableDictionary *)finalSnippetDict {
    _finalResultDictionary = finalSnippetDict;
    dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelectorOnMainThread:@selector(unwind_to_uiwebview) withObject:self waitUntilDone:FALSE];
                [session stopRunning];//For avoiding black screen after image capture
            });
}

-(float)getAlpha:(int)transparency{
    if(transparency > 100){
        return 0;
    }
    
    double alp = transparency/100.0;
    double alpha = 1- alp;
    return (float)alpha;
}

- (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

@end
