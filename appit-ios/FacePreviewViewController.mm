//
//  FacePreviewViewController.m
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 07/09/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import "FacePreviewViewController.h"
#import "ImageUtils.h"
#import "MlKitFaceController.h"
#import "NSStringUtils.h"


@interface FacePreviewViewController ()

@end

@implementation FacePreviewViewController{
    int powerdByLabel_iphoneXPadd;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _resultDictionary = [NSMutableDictionary new];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _resultDictionary = [NSMutableDictionary new];
    powerdByLabel_iphoneXPadd = 0;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        
        switch (height) {
                
            case 2436:
                //"iPhone 4 4s"
                powerdByLabel_iphoneXPadd = 15;
                break;
            case 2688:
                //iPhoneXMAx
                powerdByLabel_iphoneXPadd = 15;
                break;
            case 1792:
                //iPhone XR
                powerdByLabel_iphoneXPadd = 15;
                break;
        }
    }
    
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
    NSString *retryIcon = [frameworkBundle pathForResource:@"retry" ofType:@"png"];
    NSString *confirmIcon = [frameworkBundle pathForResource:@"confirm" ofType:@"png"];
    
    float faceBorderAlpha = [self getAlpha:_outside_face_outline_color_alpha];
    float faceOutlineAlpha = [self getAlpha:_face_outline_color_alpha];
//    _headerMsgStyle = @"Default";
//    _hintMsgStyle = @"Default";
    
    //Setting Default Color and Alpha
//    _header_message_color = @"FFFFFF";
//    _header_message_color_alpha = 1;
//    _hint_message_color = @"FFFFFF";
//    _hint_message_color_alpha = 1;
//
//    _retry_button_color = @"FEAD36";
//    _retry_button_color_alpha = 1;
//    _confirm_button_color = @"FEAD36";
//    _confirm_button_color_alpha = 1;
    
    //Adding image preview view
    //    int width = self.view.frame.size.width;
    //    int height = self.view.frame.size.height;
    
    int width = self.view.frame.size.height;
    int height = self.view.frame.size.width;
    
    //Setting view's background color
    //    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //[self.view setBackgroundColor:[UIColor colorWithRed:48/255.f green:48/255.f blue:48/255.f alpha:1]];
    [self.view setBackgroundColor:[self colorwithHexString:_outside_face_outline_color alpha:faceBorderAlpha]];
    
    //Adding header message
    CGRect headerUILabelRect = CGRectMake(1, 0 + powerdByLabel_iphoneXPadd, height - 2, 60);
    UILabel *headerMsgUILabel = [[UILabel alloc] initWithFrame:headerUILabelRect];
    //[headerMsgUILabel setText:NSLocalizedString(@"check_readability", @"")];
    [headerMsgUILabel setFont:[UIFont boldSystemFontOfSize:20]];
    //[headerMsgUILabel setBackgroundColor:[UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:1]];
    //[headerMsgUILabel setTextColor:[UIColor whiteColor]];
    headerMsgUILabel.textAlignment=NSTextAlignmentCenter;
    [headerMsgUILabel setText:NSLocalizedString(@"face_capture_preview_header",@"")];
    [headerMsgUILabel setFont:[UIFont fontWithName:_headerMsgStyle size:20]];
    [headerMsgUILabel setTextColor:[self colorwithHexString:_header_message_color alpha:[self getAlpha:_header_message_color_alpha]]];
    [self.view addSubview:headerMsgUILabel];
    
    //Adding retry button
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *retryButtonImage = [[UIImage imageNamed:retryIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [retryButton setImage:retryButtonImage forState:UIControlStateNormal];
    [retryButton setTintColor:[self colorwithHexString:_face_outline_color alpha:_face_outline_color_alpha]];
   // [retryButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:255]];
    [retryButton addTarget:self action:@selector(retry_capture:) forControlEvents:UIControlEventTouchUpInside];
    [retryButton setTintColor:[self colorwithHexString:_retry_button_color alpha:[self getAlpha:_retry_button_color_alpha]]];
    if(powerdByLabel_iphoneXPadd == 15) {
        retryButton.frame = CGRectMake(15, width-50-7-10, (height/2)-20, 50); //2 is padding
    } else {
        retryButton.frame = CGRectMake(15, width-50-7, (height/2)-20, 50); //2 is padding
    }
    [[retryButton layer] setBorderWidth:1.0f];
    [[retryButton layer] setCornerRadius:4.0f];
    retryButton.contentEdgeInsets = UIEdgeInsetsMake(10, 55, 10, 55);
    [[retryButton layer] setBorderColor:[self colorwithHexString:_retry_button_border_color alpha:[self getAlpha:_retry_button_border_color_alpha]].CGColor];
    [retryButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:retryButton];
    
    //Adding confirm button
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *confirmButtonImage = [[UIImage imageNamed:confirmIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [confirmButton setImage:confirmButtonImage forState:UIControlStateNormal];
    //[confirmButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:1]];
    [confirmButton setTintColor:[self colorwithHexString:_confirm_button_color alpha:[self getAlpha:_confirm_button_color_alpha]]];
    [[confirmButton layer] setCornerRadius:4.0f];
    confirmButton.contentEdgeInsets = UIEdgeInsetsMake(10, 55, 10, 55);
    confirmButton.backgroundColor=[self colorwithHexString:_confirm_button_style alpha:[self getAlpha:_confirm_button_style_alpha]];
    [confirmButton addTarget:self action:@selector(confirm_image:) forControlEvents:UIControlEventTouchUpInside];
    if(powerdByLabel_iphoneXPadd == 15) {
        confirmButton.frame = CGRectMake((height/2)+10, width-50-7-10, (height/2)-20, 50); //2 is padding
    } else {
        confirmButton.frame = CGRectMake((height/2)+10, width-50-7, (height/2)-20, 50); //2 is padding
    }
    [confirmButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:confirmButton];
    
    //Adding message
    CGRect hintMsgUILabelRect = CGRectMake(5, width-132 , height - 10, 65);
    UILabel *hintMsgUILabel = [[UILabel alloc] initWithFrame:hintMsgUILabelRect];
    [hintMsgUILabel setNumberOfLines:0];
    [hintMsgUILabel setLineBreakMode:NSLineBreakByWordWrapping];
    [hintMsgUILabel setTextAlignment:NSTextAlignmentCenter];
    [hintMsgUILabel setText:NSLocalizedString(@"face_image_preview_msg", @"")];
    //    [hintMsgUILabel setFont:[UIFont boldSystemFontOfSize:16]];
    [hintMsgUILabel setFont:[UIFont fontWithName:_hintMsgStyle size:20]];
    //[hintMsgUILabel setTextColor:[UIColor whiteColor]];
    [hintMsgUILabel setTextColor:[self colorwithHexString:_hint_message_color alpha:[self getAlpha:_hint_message_color_alpha]]];
    [self.view addSubview:hintMsgUILabel];
    
    //Adding preview image
    //    @synchronized (self){
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65+5, height, width-130 - 60)]; //5 is padding
    //if(nil!=_preview_image){
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = _preview_image;
    [self.view addSubview:imgView];
    //}
    //    }
    if(![NSStringUtils stringIsNilOrEmpty:_title_message_size]){
        //        [headerMsgUILabel setFont: [UIFont fontWithName:_headerMsgStyle size:[[AppItSDK getHeaderTextSizeFace] integerValue]]];
        if(![_headerMsgStyle isEqualToString:@"Default"]){
            [headerMsgUILabel setFont: [UIFont fontWithName:_headerMsgStyle size:[_title_message_size integerValue]]];
        }else{
            [headerMsgUILabel setFont:[UIFont systemFontOfSize:[_title_message_size integerValue]]];
        }
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:_hint_message_size]){
        //   [hintMsgUILabel setFont: [UIFont fontWithName:_hintMsgStyle size:[[AppItSDK getTextSizeFace] integerValue]]];
        if(![_hintMsgStyle isEqualToString:@"Default"]){
            [hintMsgUILabel setFont: [UIFont fontWithName:_hintMsgStyle size:[_hint_message_size integerValue]]];
        }else{
            [hintMsgUILabel setFont:[UIFont systemFontOfSize:[_hint_message_size integerValue]]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)retry_capture:(id)sender {
    _confirm = false;
    [self dismissViewControllerAnimated:NO completion:^{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:MlKitFaceController.class]];
        
        MlKitFaceController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"MlKitFaceController"];
        
        controller.light_threshold = _light_threshold;
        controller.focus_threshold = _focus_threshold;
        controller.launch_front_camera = _launch_front_camera;
        controller.allowBothCamera = _allowBothCamera;
        controller.isFaceTitleOnTop = _isFaceTitleOnTop;
        controller.isFaceHintMessageOnTop = _isFaceHintMessageOnTop;
        controller.showPreviewScreen = _showPreviewScreen;
        controller.smile_width_percentage_threshold = _smile_width_percentage_threshold;
        controller.image_size = _image_size;
        controller.delegate = _delegate;
        controller.face_outline_color = _face_outline_color;
        controller.face_outline_color_alpha = _face_outline_color_alpha;
        controller.detected_face_outline_color = _detected_face_outline_color;
        controller.detected_face_outline_color_alpha = _detected_face_outline_color_alpha;
        controller.outside_face_outline_color = _outside_face_outline_color;
        controller.outside_face_outline_color_alpha = _outside_face_outline_color_alpha;
        controller.detected_outside_face_outline_color = _detected_outside_face_outline_color;
        controller.detected_outside_face_outline_color_alpha = _detected_outside_face_outline_color_alpha;
        controller.glare_threshold = _glare_threshold;
        
        controller.retry_button_border_color = _retry_button_border_color;
        controller.retry_button_border_color_alpha = _retry_button_border_color_alpha;
        controller.confirm_button_style = _confirm_button_style;
        controller.confirm_button_style_alpha = _confirm_button_style_alpha;
        controller.retry_button_color = _retry_button_color;
        controller.retry_button_color_alpha = _retry_button_color_alpha;
        controller.confirm_button_color = _confirm_button_color;
        controller.confirm_button_color_alpha = _confirm_button_color_alpha;
        
        controller.title_message_style = _headerMsgStyle;
        controller.hint_message_style = _hintMsgStyle;
        controller.title_message_size = _title_message_size;
        controller.hint_message_size = _hint_message_size;
        
        controller.title_message_color = _title_message_color;
        controller.title_message_color_alpha = _title_message_color_alpha;
        controller.hint_message_color = _hint_message_color;
        controller.hint_message_color_alpha = _hint_message_color_alpha;
        controller.back_button_color = _back_button_color;
        controller.back_button_color_alpha = _back_button_color_alpha;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [_delegate presentModalViewController:controller animated:YES];
    }];
}

- (void)confirm_image:(id)sender {
    _confirm = true;
    if(nil != _delegate){
        [_delegate faceDetectionResponse:_resultDictionary instance:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateResultObject : (NSString*)resultCode resultMessage:(NSString*)resultMessage{
    [_resultDictionary setObject:resultCode forKey:@"StatusCode"];
    [_resultDictionary setObject:resultCode forKey:@"statusCode"];
    [_resultDictionary setObject:resultMessage forKey:@"statusMessage"];
}

-(void)updateResultObjectWithData : (NSString*)key resultMessage:(NSObject*)value{
    [_resultDictionary setObject:value forKey:key];
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
