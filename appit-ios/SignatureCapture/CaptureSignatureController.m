//
//  CaptureSignatureController.m
//  AppItFramework
//
//  Created by  on 08/06/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import "CaptureSignatureController.h"
#import "UIColor+fromHex.h"

@interface CaptureSignatureController ()

@end

static NSString *signatureCaptureImage = @"";
@implementation CaptureSignatureController
UviSignatureView *signatureView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _resultDictionary = [NSMutableDictionary new];
    signatureCaptureImage = @"";
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}

- (void)dealloc {

}


-(void)viewDidAppear:(BOOL)animated {
    [self initData];
}

-(void)viewWillDisappear:(BOOL)animated {
    if(nil != _delegate) {
        [_delegate captureSignatureResponse:_resultDictionary instance:self];
    }
}

-(void)initData {
    //    int viewHeight1 = self.view.bounds.size.height;
    //    int viewWidth2 = self.view.bounds.size.width;
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height;
    
    signatureView = [[UviSignatureView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [self.view addSubview:signatureView];
    
    UIButton *clearPad = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rectClearPad = CGRectMake(viewWidth/2 - 130, viewHeight - 60, 120, 50);
    [clearPad setFrame:rectClearPad];
    [clearPad setBackgroundColor:[UIColor grayColor]];
    [clearPad setTitle:@"ClearPad" forState:UIControlStateNormal];
    [clearPad addTarget:self action:@selector(clearPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearPad];
    
    UIButton *donePad = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rectDonePad = CGRectMake(viewWidth/2 + 10, viewHeight - 60, 120, 50);
    [donePad setFrame:rectDonePad];
    [donePad setBackgroundColor:[UIColor grayColor]];
    [donePad addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    [donePad setTitle:@"Done" forState:UIControlStateNormal];
    [self.view addSubview:donePad];
    
    NSBundle *frameworkBundle = [NSBundle mainBundle];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect backBtnRect = CGRectMake(viewWidth/100*2, viewHeight/100*2, 50, 50);
    [backButton setFrame:backBtnRect];
    NSString *back_icon = [frameworkBundle pathForResource:@"back_cancel_arrow" ofType:@"png"];
    UIImage *backImage = [[UIImage imageNamed:back_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTintColor:[UIColor colorwithHexString:@"0A0000" alpha:1.0]];
    [self.view addSubview:backButton];
}

-(void)backPressed:(UIButton*)button {
   // [self updateResultObject:@"" resultMessage:NSLocalizedString(@"empty_response_msg", @"")];
   // [self updateResultObjectWithData:@"signatureImage" resultMessage:@""];
    _defaultSignatureStringData = @"";
    _responseStatus = @"56";
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clearPressed:(UIButton*)button {
    [signatureView erase];
}

-(void)donePressed:(UIButton*)button {
    
    [signatureView captureSignature];
    if([signatureView isSignPathEmpty]) {
//        [self updateResultObject:@"" resultMessage:NSLocalizedString(@"empty_response_msg", @"")];
//        [self updateResultObjectWithData:@"signatureImage" resultMessage:@""];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Please Sign"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        
        [message show];
        
    } else {
        UIImage *captureSignatureImage = [signatureView signatureImage:CGPointMake(signatureView.frame.origin.x+10 , signatureView.frame.size.height-25) text:@""];
        
       // NSData *imageNSData = UIImageJPEGRepresentation(captureSignatureImage, 0.9);
        NSData *imageNSData = UIImagePNGRepresentation(captureSignatureImage);
        //    NSString *signatureImage = [imageNSData base64EncodedStringWithOptions:0];
//        signatureCaptureImage = [imageNSData base64EncodedStringWithOptions:0];
//        [self updateResultObject:@"0" resultMessage:NSLocalizedString(@"success_msg", @"")];
//        [self updateResultObjectWithData:@"signatureImage" resultMessage:signatureCaptureImage];
//
        _defaultSignatureStringData = [imageNSData base64EncodedStringWithOptions:0];
        _responseStatus = @"57";
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(void)updateResultObject : (NSString*)resultCode resultMessage:(NSString*)resultMessage{
    [_resultDictionary setObject:resultCode forKey:@"StatusCode"];
    [_resultDictionary setObject:resultCode forKey:@"statusCode"];
    [_resultDictionary setObject:resultMessage forKey:@"statusMessage"];
}

-(void)updateResultObjectWithData : (NSString*)key resultMessage:(NSObject*)value{
    [_resultDictionary setObject:value forKey:key];
}


+(void)setSignatureImage:(NSString*)signatureImageData {
    signatureCaptureImage = signatureImageData;
}


@end
