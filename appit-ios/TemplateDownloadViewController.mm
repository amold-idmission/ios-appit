//
//  TemplateDownloadViewController.m
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 19/11/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import "TemplateDownloadViewController.h"
#import "IDServerInterface.h"

@interface TemplateDownloadViewController()

@end

@implementation TemplateDownloadViewController

@synthesize merchantId = _merchantId;
@synthesize loginId = _loginId;
@synthesize password = _password;

@synthesize launchedFromApp = _launchedFromApp;
@synthesize responseUrl = _responseUrl;

IDServerInterface *idServerInterface;
NSTimer *timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateProgessBarUI];
}

-(void) updateProgessBarUI {
    
}

-(void) downloadTemplates {
    idServerInterface = [IDServerInterface alloc];
    [idServerInterface getTemplateIdsFromServer:_merchantId loginId:_loginId password:_password];
    
 

}

-(void) checkDownloadStatus {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkDownloadStatusTimer) userInfo:nil repeats:YES];
}

-(void) checkDownloadStatusTimer {
        if([idServerInterface getTemplateDownloadStatus] == 2){
            [timer invalidate];
            timer = nil;

            [self exitFromTemplateDownloadScreen:@"Result"];
        }
}

-(void)exitFromTemplateDownloadScreen:(NSString*)exitType{
    
    NSMutableDictionary *templateDownloadResponse = [NSMutableDictionary new];
    
    if([exitType isEqualToString:@"Result"]){
        [templateDownloadResponse setObject:@"0" forKey:@"Status"];
    }else if ([exitType isEqualToString:@"Back"]){
        [templateDownloadResponse setObject:@"18" forKey:@"Status"];
    }
    
    NSError * err;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:templateDownloadResponse options:NSJSONWritingPrettyPrinted error:&err];
    NSString * templateDownloadResponseString = [jsonData base64EncodedStringWithOptions:0];
    
    [_responseUrl appendString:@"&requestParam="];
    [_responseUrl appendString:templateDownloadResponseString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_responseUrl]];
    
    [self exitFromApp];
}

-(void)exitFromApp{
    //home button press programmatically
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    
    //wait 2 seconds while app is going background
    [NSThread sleepForTimeInterval:2.0];
    
    //exit app when app is in background
    exit(0);
}

@end

