//
//  PasswordViewController.h
//  TestMenu
//
//  Created by idmission solutions pvt ltd  on 20/10/16.
//  Copyright © 2016 IDMission Solution PVT LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "NSStringUtils.h"

@interface PasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)passwordOKButtonClicked:(id)sender;
- (IBAction)paaswordCancelButtonClicked:(id)sender;
@property(nonatomic) NSString *currentURL;

@end
