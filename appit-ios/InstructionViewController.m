//
//  InstructionViewController.m
//  appit-ios
//
//  Created by  on 16/04/18.
//  Copyright © 2018 IDMission. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()

@end

@implementation InstructionViewController{
    NSBundle * frameworkBundle;
    
    UIImageView *instruction_uiimageview;
    UILabel *instruction_text;
    UIButton *continue_button;
    
    NSString *id_instruction, *face_instruction, *fp_instruction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set language bundle according to given configuration
   // [[BundleLocalization sharedInstance] setLanguageForFramework:[AppItSDK getLanguage]];
    
    [self initializeLabels];
    
    //Load bundle
//    frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.AppItFramework"];
    
    frameworkBundle = [NSBundle mainBundle];
    
    // Do any additional setup after loading the view.
    int viewHeight = self.view.bounds.size.height;
    int viewWidth = self.view.bounds.size.width;
    //FIX FOR : If this view-controller is launched from landscape viewcontroller(caller VC)
    if(self.view.bounds.size.height < self.view.bounds.size.width){
        viewHeight = self.view.bounds.size.width;
        viewWidth = self.view.bounds.size.height;
    }
    
    //Background color
    float backgroundColorAlpha = [self getAlpha:_background_color_alpha];
    UIColor *background_ui_color = [UIColor colorwithHexString:_background_color alpha:backgroundColorAlpha];
    [self.view setBackgroundColor:background_ui_color];
    
    //Instruction image
    int img_height = (viewHeight * 70)/100;
    instruction_uiimageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, img_height)];
    [instruction_uiimageview setContentMode:UIViewContentModeScaleAspectFit];
    //    NSString *icon = [frameworkBundle pathForResource:@"front_camera_icon" ofType:@"png"];
    //    [instruction_uiimageview setImage:[UIImage imageNamed:icon]];
    [self.view addSubview:instruction_uiimageview];
    
    //Instruction text
    int instLabelPadding = 5;
    int instHeight = viewHeight - img_height;
    int instructionTextPadding = 0;
    bool isIphoneX = false;
    int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
    int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
    if(![_instruction_type isEqualToString:@"FP"] && ![_instruction_type isEqualToString:@"ID"]) {
        
        bool isIphone5 = false;
        
        switch (height) {
                
            case 960:
                //"iPhone 4 4s"
                isIphone5 = true;
                break;
            case 1136:
                //"iPhone 5 or 5S or 5C"
                isIphone5 = true;
                break;
            default:
                isIphone5 = false;
        }
        if(isIphone5) {
            instructionTextPadding = (viewHeight/100)*6;
        } else {
            instructionTextPadding = (viewHeight/100)*3;
        }
    }
    switch (height) {
        case 2436:
            //iPhone X, XS
            isIphoneX = true;
            break;
        case 2688:
            //iPhoneXMAx
            isIphoneX = true;
            break;
        case 1792:
            //iPhone XR
            isIphoneX = true;
            break;
        default:
            isIphoneX = false;
            break;
    }
    CGRect headerUILabelRect = CGRectMake(instLabelPadding, img_height - instructionTextPadding, viewWidth-instLabelPadding*2, instHeight);
    instruction_text = [[UILabel alloc] initWithFrame:headerUILabelRect];
    [instruction_text setTextColor:[UIColor whiteColor]];
    [instruction_text setNumberOfLines:0];
    [instruction_text setLineBreakMode:NSLineBreakByWordWrapping];
    [instruction_text setTextAlignment:NSTextAlignmentCenter];
    //[instruction_text setFont:[UIFont boldSystemFontOfSize:15]];
    [instruction_text setFont:[UIFont fontWithName:_instructionTextStyle size:20]];
    [instruction_text setTextColor:[UIColor colorwithHexString:_instruction_text_color alpha:[self getAlpha:_instruction_text_color_alpha]]];
    //    [instruction_text setText:NSLocalizedString(@"face_detection_instruction", @"")];
    [self.view addSubview:instruction_text];
    
    //Continue button
    int buttonHeight = 50;
    int buttonPadding = 10;
    int cornerRadius = 25;
    continue_button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect continue_button_rect;
    if(isIphoneX) {
        continue_button_rect = CGRectMake(buttonPadding, viewHeight-buttonHeight-buttonPadding - 10, viewWidth-buttonPadding*2, buttonHeight);
    } else {
        continue_button_rect = CGRectMake(buttonPadding, viewHeight-buttonHeight-buttonPadding, viewWidth-buttonPadding*2, buttonHeight);
    }
    [continue_button setFrame:continue_button_rect];
    // [continue_button setBackgroundColor:[UIColor whiteColor]];
    [continue_button setTitleColor:background_ui_color forState:UIControlStateNormal];
    [continue_button setTitle:NSLocalizedString(@"continue", @"") forState:UIControlStateNormal];
    [continue_button addTarget:self action:@selector(continue_pressed:) forControlEvents:UIControlEventTouchUpInside];
    [continue_button setBackgroundColor:[UIColor colorwithHexString:_continue_button_color alpha:[self getAlpha:_continue_button_color_alpha]]];
    [continue_button setFont:[UIFont fontWithName:_continueButtonStyle size:20]];
    [continue_button setTitleColor:[UIColor colorwithHexString:_continue_button_text_color alpha:[self getAlpha:_continue_button_text_color_alpha]] forState:UIControlStateNormal];
    continue_button.layer.cornerRadius = cornerRadius;
    [self.view addSubview:continue_button];
    
    //Set views
    if([_instruction_type isEqualToString:@"ID"]){
        if(_instruction_image != nil){
            [instruction_uiimageview setImage:_instruction_image];
        }else{
            NSString *icon = [frameworkBundle pathForResource:@"id_capture_instruction" ofType:@"png"];
            [instruction_uiimageview setImage:[UIImage imageNamed:icon]];
        }
        [instruction_text setText:id_instruction];
        if(![self stringIsNilOrEmpty:_instTextSize]){
            if(![_instructionTextStyle isEqualToString:@"Default"]){
                [instruction_text setFont: [UIFont fontWithName:_instructionTextStyle size:[_instTextSize integerValue]]];
            }else{
                [instruction_text setFont:[UIFont systemFontOfSize:[_instTextSize integerValue]]];
            }
        }
    }else if([_instruction_type isEqualToString:@"FACE"]){
//        if(_instruction_image != nil){
//            [instruction_uiimageview setImage:_instruction_image];
//        }else{
//            NSString *icon = [frameworkBundle pathForResource:@"face_detection_instruction" ofType:@"png"];
//            [instruction_uiimageview setImage:[UIImage imageNamed:icon]];
//        }
        UIImage *zeroImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_0" ofType:@"png"]];
        UIImage *firstImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_1" ofType:@"png"]];
        UIImage *secondImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_2" ofType:@"png"]];
        UIImage *thirdImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_3" ofType:@"png"]];
        UIImage *fourthImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_4" ofType:@"png"]];
        UIImage *fifthImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_5" ofType:@"png"]];
        UIImage *sixthImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_6" ofType:@"png"]];
        UIImage *seventhImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"instruction_7" ofType:@"png"]];
        
        NSArray *imageNames = [NSArray arrayWithObjects:zeroImage, firstImage,secondImage,thirdImage,fourthImage,fifthImage,sixthImage,seventhImage, nil];
        instruction_uiimageview.animationImages = imageNames;
        instruction_uiimageview.animationDuration = 5.0;
        [instruction_uiimageview startAnimating];
        [instruction_text setText:face_instruction];
        
        if(![self stringIsNilOrEmpty:_instTextSize]){
            if(![_instructionTextStyle isEqualToString:@"Default"]){
                [instruction_text setFont: [UIFont fontWithName:_instructionTextStyle size:[_instTextSize integerValue]]];
            }else{
                [instruction_text setFont:[UIFont systemFontOfSize:[_instTextSize integerValue]]];
            }
        }
    } else if([_instruction_type isEqualToString:@"FP"]) {
        UIImage *zeroImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_0" ofType:@"png"]];
        UIImage *firstImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_1" ofType:@"png"]];
        UIImage *secondImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_2" ofType:@"png"]];
        UIImage *thirdImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_3" ofType:@"png"]];
        UIImage *fourthImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_4" ofType:@"png"]];
        UIImage *fifthImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_5" ofType:@"png"]];
        UIImage *sixthImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_6" ofType:@"png"]];
        UIImage *seventhImage = [UIImage imageNamed:[frameworkBundle pathForResource:@"fp_instruction_7" ofType:@"png"]];
        
        NSArray *imageNames = [NSArray arrayWithObjects:zeroImage, firstImage,secondImage,thirdImage,fourthImage,fifthImage,sixthImage,seventhImage, nil];
        instruction_uiimageview.animationImages = imageNames;
        instruction_uiimageview.animationDuration = 5.0;
        [instruction_uiimageview startAnimating];
        
        [instruction_text setText:fp_instruction];
    }
}

-(void)continue_pressed:(id)sender{
    NSLog(@"");
    [self dismissViewControllerAnimated:NO completion:^{
        if([_instruction_type isEqualToString:@"ID"]){
            //[ImagePreviewViewController retryCapture:_delegate captureType:_imageType];
            [_delegate idInstructionScreenResponse:self];
        }else if([_instruction_type isEqualToString:@"FACE"]){
            //[FacePreviewViewController retryCapture:_delegate];
            [_delegate faceInstructionScreenResponse:self];
        } else if([_instruction_type isEqualToString:@"FP"]) {
            [_delegate fingerInstructionResponse:self];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    //Revert back to default application bundle
//    [[BundleLocalization sharedInstance] setLanguageForFramework:@"DefaultBundle"];
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)initializeLabels{
    
//    if(![NSStringUtils stringIsNilOrEmpty:[AppItSDK getLabelForKey:@"id_capture_instruction"]]){
//        id_instruction = [AppItSDK getLabelForKey:@"id_capture_instruction"];
//    }else{
        id_instruction = NSLocalizedString(@"id_capture_instruction", @"");
//    }
    
//    if(![NSStringUtils stringIsNilOrEmpty:[AppItSDK getLabelForKey:@"face_detection_instruction"]]){
//        face_instruction = [AppItSDK getLabelForKey:@"face_detection_instruction"];
//    }else{
        face_instruction = NSLocalizedString(@"face_detection_instruction", @"");
//    }
//        fp_instruction = NSLocalizedString(@"fp_capture_instruction", @"");
    fp_instruction = @"";
}

- (float)getAlpha:(int)transparency{
    if(transparency > 100){
        return 0;
    }
    
    double alp = transparency/100.0;
    double alpha = 1- alp;
    return (float)alpha;
}

-(BOOL)stringIsNilOrEmpty:(NSString*)nsString {
    if(nsString == nil){
        return true;
    }
    
    NSString *trimmed = [nsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmed.length == 0){
        return true;
    }
    return false;
}


@end

