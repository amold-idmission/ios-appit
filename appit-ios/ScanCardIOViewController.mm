//
//  ScanCardIOViewController.m
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 13/04/16.
//  Copyright © 2016 IDMission. All rights reserved.
//

#import "ScanCardIOViewController.h"
#import "CardIO.h"
#import "ImageUtils.h"

@interface ScanCardIOViewController () <CardIOPaymentViewControllerDelegate>

@end

@implementation ScanCardIOViewController

@synthesize responseStatus = _responseStatus;
@synthesize responseCardImage = _responseCardImage;
@synthesize responseCardNumber = _responseCardNumber;
@synthesize responseCardType = _responseCardType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //(INFORM-5141)
    //This check is added for iPhone as in iPhone when user press cancel or done button on cardio screen ......viewWillAppear is called and due to that cardio screen is launched again.
    //For fixing this we are checking if fresh request is made for cardio or not as on pressing cancel or done button _responseStatus will be change and not be null
    if(_responseStatus == nil){
        [CardIOUtilities preload];
        [self startCardScan];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCardScan {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    scanViewController.collectExpiry = NO;
    scanViewController.collectCVV = NO;
    scanViewController.disableManualEntryButtons = YES;
    scanViewController.hideCardIOLogo = YES;
    scanViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //setting reponse status 0 for Success
    _responseStatus = @"0";
    _responseCardNumber = info.cardNumber;
    
    _responseCardType = [CardIOCreditCardInfo displayStringForCardType:info.cardType usingLanguageOrLocale:[[NSLocale currentLocale] localeIdentifier]];
    
    cv::Mat origionalImage =  [ImageUtils CVMatFromUIImage:info.cardImage isGrayRequired:false];
    cv::Mat mask = origionalImage(cv::Rect(0, origionalImage.rows/2, origionalImage.cols, origionalImage.rows/4));
    cv::GaussianBlur(mask, mask, cv::Size(31, 31), 55);
    
    UIImage *final = [ImageUtils UIImageFromCVMat:origionalImage];
    NSData *cardimage =  UIImageJPEGRepresentation(final, 0.9);
    
    _responseCardImage = [cardimage base64EncodedStringWithOptions:0];
    
    [self exitFromScanCardIOScreen];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //setting reponse status 18 for Cancel
    _responseStatus = @"18";
    _responseCardNumber = @"";
    _responseCardType = @"";
    _responseCardImage = @"";
    
    [self exitFromScanCardIOScreen];
}

-(void)exitFromScanCardIOScreen{
    [self performSegueWithIdentifier: @"ScanCardIOExitSegue" sender: self];
}

@end
