//
//  UIViewController_TemplateDownloadViewController.h
//  appit-ios
//
//  Created by idmission solutions pvt ltd  on 19/11/15.
//  Copyright © 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateDownloadViewController : UIViewController {

}

@property(nonatomic, strong) NSString *merchantId;
@property(nonatomic, strong) NSString *loginId;
@property(nonatomic, strong) NSString *password;

//interapp communication
@property(nonatomic, assign) BOOL launchedFromApp;
@property(nonatomic, retain) NSMutableString *responseUrl;

-(void) downloadTemplates;
-(void) checkDownloadStatus;
@end
