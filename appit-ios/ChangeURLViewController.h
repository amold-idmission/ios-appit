//
//  ChangeURLViewController.h
//  TestMenu
//
//  Created by idmission solutions pvt ltd  on 20/10/16.
//  Copyright © 2016 IDMission Solution PVT LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeURLViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *changeURLText;
- (IBAction)changeURLOKButtonClicked:(id)sender;
- (IBAction)changeURLCancelButtonClicked:(id)sender;
- (IBAction)changePasswordButtonClicked:(id)sender;

@property(nonatomic) NSString *currentURL;
@property(nonatomic) NSString *changedPassword;

//TextFields of UIAlertController
@property (strong, nonatomic) UITextField *oldpassAlertTextField;
@property (strong, nonatomic) UITextField *newpassAlertTextField;
@property (strong, nonatomic) UITextField *confirmpassAlertTextField;
//Ok Action button of UIAlertController
@property (strong, nonatomic) UIAlertAction *okActionButton;

@end
