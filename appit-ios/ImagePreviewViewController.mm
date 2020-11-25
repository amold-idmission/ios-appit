//
//  ImagePreviewViewController.m
//  AppItFramework
//
//  Created by idmission solutions pvt ltd  on 08/05/17.
//  Copyright © 2017 idmission solutions pvt ltd . All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "ImageUtils.h"
#import "NSStringUtils.h"
#import "SkipImageProcessingViewController.h"

@interface ImagePreviewViewController ()

@end
int counter = 0;
@implementation ImagePreviewViewController{
    int powerdByLabel_iphoneXPadd;
    
    NSString *header, *message;
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
    //Revert back to default application bundle
    
    //Calling exit code only when _resultDictionary contain some value

//    if ([_resultDictionary count] > 0) {
//        if(_confirm){
//            if(nil != _delegate){
//                if([_imageType isEqualToString:@"POA_IMAGE"]){
//                    [_delegate proofOfAddressDetectionResponse:_resultDictionary];
//                }else if([_imageType isEqualToString:@"BANK_STATEMENT"]){
//                    [_delegate bankStatementDetectionResponse:_resultDictionary];
//                }else if([_imageType isEqualToString:@"BIRTH_CERTIFICATE"]){
//                    [_delegate birthCertificateDetectionResponse:_resultDictionary];
//                }else if([_imageType isEqualToString:@"GENERIC_DOCUMENT"]) {
//                    [_delegate genericDocumentResponse:_resultDictionary];
//                }else{
//                    [_delegate captureImageResponse:_resultDictionary];
//                }
//            }
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _resultDictionary = [NSMutableDictionary new];
    counter = 0;
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
                //iphone XR
                powerdByLabel_iphoneXPadd = 15;
                break;
        }
    }
    
    //Set language bundle according to given configuration
    [self initializeLabels];
    
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
    NSString *retryIcon = [frameworkBundle pathForResource:@"retry" ofType:@"png"];
    NSString *confirmIcon = [frameworkBundle pathForResource:@"confirm" ofType:@"png"];
    
    //NSString *outlineColor = [AppItSDK getIdOutlineColor];
    //int outline_alpha = [AppItSDK getIdOutlineColorAlpha];
    float outlineAlpha = [self getAlpha:_id_outline_color_alpha];
    //NSString *borderColor = [AppItSDK getIdOutsideOutlineColor];
    //int border_alpha = [AppItSDK getIdOutsideOutlineAlpha];
    float borderAlpha = [self getAlpha:_id_outside_outline_color_alpha];
   
//    _headerMsgStyle = [AppItSDK getHeaderTextFontStyle];
//    _header_Size = [AppItSDK getHeaderTextSize];
//    _text_Size = [AppItSDK getTextSize];
//    _hintMsgStyle = [AppItSDK getTextFontStyle];
    
//    _header_message_color = [AppItSDK getHeaderTextColor];
//    _header_message_color_alpha = [AppItSDK getAlpha:[AppItSDK getHeaderTextColorAlpha]];
//    _hint_message_color = [AppItSDK getTextColor];
//    _hint_message_color_alpha = [AppItSDK getAlpha:[AppItSDK getTextColorAlpha]];
    
//    _retry_button_color=[AppItSDK getRetryButtonColor];
//    _retry_button_color_alpha=[AppItSDK getAlpha:[AppItSDK getRetryButtonColorAlpha]];
//    _confirm_button_color=[AppItSDK getConfirmButtonColor];
//    _confirm_button_color_alpha=[AppItSDK getAlpha:[AppItSDK getConfirmButtonColorAlpha]];
    
//    _retry_button_border=[AppItSDK getRetryButtonBorderColor];
//    _retry_button_border_alpha=[AppItSDK getRetryButtonBorderColorAlpha];
//    _confirm_button_style=[AppItSDK getConfirmButtonStyle];
//    _confirm_button_style_alpha=[AppItSDK getConfirmButtonStyleAlpha];
    
    //Adding image preview view
//    int width = self.view.frame.size.width;
//    int height = self.view.frame.size.height;
    
    int width = self.view.frame.size.height;
    int height = self.view.frame.size.width;
    //FIX FOR : If this view-controller is launched from landscape viewcontroller(caller VC)
    if(self.view.bounds.size.height < self.view.bounds.size.width){
        height = self.view.bounds.size.height;
        width = self.view.bounds.size.width;
    }
    //Setting view's background color
//    [self.view setBackgroundColor:[UIColor darkGrayColor]];
//    [self.view setBackgroundColor:[UIColor colorWithRed:48/255.f green:48/255.f blue:48/255.f alpha:1]];
    [self.view setBackgroundColor:[self colorwithHexString:_id_outside_outline_color alpha:borderAlpha]];
    
    //Adding header message
    CGRect headerUILabelRect = CGRectMake(1 , 0 + powerdByLabel_iphoneXPadd , height - 2, 60);
    UILabel *headerMsgUILabel = [[UILabel alloc] initWithFrame:headerUILabelRect];
    [headerMsgUILabel setText:header];
    headerMsgUILabel.textAlignment=NSTextAlignmentCenter;
    [headerMsgUILabel setFont:[UIFont boldSystemFontOfSize:20]];
//    [headerMsgUILabel setBackgroundColor:[UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:1]];
//    [headerMsgUILabel setBackgroundColor:[UIColor colorwithHexString:borderColor alpha:borderAlpha]];
    [headerMsgUILabel setTextColor:[UIColor whiteColor]];
    [headerMsgUILabel setFont:[UIFont fontWithName:_headerMsgStyle size:20]];
    [headerMsgUILabel setTextColor:[self colorwithHexString:_header_message_color alpha:[self getAlpha:_header_message_color_alpha]]];
    [self.view addSubview:headerMsgUILabel];
    
    //Adding retry button
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *retryButtonImage = [[UIImage imageNamed:retryIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [retryButton setImage:retryButtonImage forState:UIControlStateNormal];
   // [retryButton setTintColor:[UIColor colorwithHexString:outlineColor alpha:outlineAlpha]];
    [retryButton setTintColor:[self colorwithHexString:_retry_button_color alpha:[self getAlpha:_retry_button_color_alpha]]];
//    [retryButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:255]];
    [retryButton addTarget:self action:@selector(retry_capture:) forControlEvents:UIControlEventTouchUpInside];
    if(powerdByLabel_iphoneXPadd == 15) {
        retryButton.frame = CGRectMake(15, width-50-7-10, (height/2)-20, 50);
    } else {
        retryButton.frame = CGRectMake(15, width-50-7, (height/2)-20, 50); //2 is padding
    }
        
    [[retryButton layer] setBorderWidth:1.0f];
    [[retryButton layer] setCornerRadius:4.0f];
    retryButton.contentEdgeInsets = UIEdgeInsetsMake(10, 55, 10, 55);
    [[retryButton layer] setBorderColor:[self colorwithHexString:_retry_button_border alpha:[self getAlpha:_retry_button_border_alpha]].CGColor];
    [retryButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:retryButton];
    
    //Adding confirm button
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *confirmButtonImage = [[UIImage imageNamed:confirmIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [confirmButton setImage:confirmButtonImage forState:UIControlStateNormal];
//    [confirmButton setTintColor:[UIColor colorwithHexString:outlineColor alpha:outlineAlpha]];
    [confirmButton setTintColor:[self colorwithHexString:_confirm_button_color alpha:[self getAlpha:_confirm_button_color_alpha]]];
    [[confirmButton layer] setCornerRadius:4.0f];
    confirmButton.contentEdgeInsets = UIEdgeInsetsMake(10, 55, 10, 55);
    confirmButton.backgroundColor=[self colorwithHexString:_confirm_button_style alpha:[self getAlpha:_confirm_button_style_alpha]];
//    [confirmButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:1]];
    [confirmButton addTarget:self action:@selector(confirm_image:) forControlEvents:UIControlEventTouchUpInside];
    if(powerdByLabel_iphoneXPadd == 15) {
        confirmButton.frame = CGRectMake((height/2)+10, width-50-7-10, (height/2)-20, 50); //2 is padding
    } else {
        confirmButton.frame = CGRectMake((height/2)+10, width-50-7, (height/2)-20, 50); //2 is padding
    }
    [confirmButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:confirmButton];
    
    //Adding message
    CGRect hintMsgUILabelRect = CGRectMake(5, width-125, height - 10, 65);
    UILabel *hintMsgUILabel = [[UILabel alloc] initWithFrame:hintMsgUILabelRect];
    [hintMsgUILabel setNumberOfLines:0];
    [hintMsgUILabel setLineBreakMode:NSLineBreakByWordWrapping];
    [hintMsgUILabel setTextAlignment:NSTextAlignmentCenter];
    [hintMsgUILabel setText:message];
    [hintMsgUILabel setFont:[UIFont boldSystemFontOfSize:16]];
    [hintMsgUILabel setTextColor:[UIColor whiteColor]];
    [hintMsgUILabel setFont:[UIFont fontWithName:_hintMsgStyle size:20]];
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
    
    if(![NSStringUtils stringIsNilOrEmpty:_header_Size]){
        if(![_headerMsgStyle isEqualToString:@"Default"]){
            [headerMsgUILabel setFont: [UIFont fontWithName:_headerMsgStyle size:[_header_Size integerValue]]];
        }else{
            [headerMsgUILabel setFont:[UIFont systemFontOfSize:[_header_Size integerValue]]];
        }
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:_text_Size]){
        if(![_hintMsgStyle isEqualToString:@"Default"]){
            [hintMsgUILabel setFont: [UIFont fontWithName:_hintMsgStyle size:[_text_Size integerValue]]];
        }else{
            [hintMsgUILabel setFont:[UIFont systemFontOfSize:[_text_Size integerValue]]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)retry_capture:(id)sender {
    _confirm = false;
    [self dismissViewControllerAnimated:NO completion:^{
        
        //Call image capture feature again with previously set parameter
        //[ImagePreviewViewController retryCapture:_delegate captureType:_imageType];
        SkipImageProcessingViewController *ctrl = (SkipImageProcessingViewController *)_delegate2;
        ctrl.isFomResume = true;
        [ctrl exitFromSkipImagProcessingRetryButton];
//[_delegate idInstructionScreenResponse:self];
    }];
}

+(void)retryCapture:(id)delegate captureType:(NSString*)captureType{
    
}

- (void)confirm_image:(id)sender {
    _confirm = true;
//    [self dismissViewControllerAnimated:YES completion:^{}];
    [self confirmCapture:_preview_image];
}

-(void)confirmCapture:(UIImage*)responseImage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
   //     [self dismissViewControllerAnimated:NO completion:^{
            SkipImageProcessingViewController *ctrl = (SkipImageProcessingViewController *)_delegate2;
            ctrl.isFomResume = false;
            [ctrl exitFromSkipImagProcessingConfirmButton:self];
   //     }];
   // [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)updateResultObject : (NSString*)resultCode resultMessage:(NSString*)resultMessage{
    [_resultDictionary setObject:resultCode forKey:@"StatusCode"];
    [_resultDictionary setObject:resultCode forKey:@"statusCode"];
    [_resultDictionary setObject:resultMessage forKey:@"statusMessage"];
}

-(void)updateResultObjectWithData : (NSString*)key resultMessage:(NSObject*)value{
    [_resultDictionary setObject:value forKey:key];
}

+(NSMutableDictionary *)getConfigDataJSON:(NSString*)light focus:(NSString*)focus glare:(NSString*)glare isAutoCapture:(NSString*)isAutoCapture operationTime:(NSString*) operationTime{
    
    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    
    if(![NSStringUtils stringIsNilOrEmpty:light]){
        [nsDict setObject:light forKey:@"light"];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:focus]){
        [nsDict setObject:focus forKey:@"focus"];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:glare]){
        [nsDict setObject:glare forKey:@"glare"];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:isAutoCapture]){
        [nsDict setObject:isAutoCapture forKey:@"isAutoCapture"];
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:operationTime]){
        [nsDict setObject:operationTime forKey:@"operationTime"];
    }
    return nsDict;
}

-(void)initializeLabels{
    header = NSLocalizedString(@"id_capture_preview_header", @"");
    message = NSLocalizedString(@"id_capture_preview_message", @"");
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



