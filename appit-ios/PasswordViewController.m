//
//  PasswordViewController.m
//  TestMenu
//
//  Created by idmission solutions pvt ltd  on 20/10/16.
//  Copyright © 2016 IDMission Solution PVT LTD. All rights reserved.
//

#import "PasswordViewController.h"
#import "ChangeURLViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController
@synthesize password;
@synthesize currentURL;

- (void)viewDidLoad {
    [super viewDidLoad];
        NSLog(@"Password View Controller did load");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showChangeURLSegue"]){
        ChangeURLViewController *controller = (ChangeURLViewController *)segue.destinationViewController;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        controller.currentURL = currentURL;
    }
}


- (IBAction)passwordOKButtonClicked:(id)sender {
    NSString *passwordText = password.text;
    NSString *currentPassword = [Settings getCurrentPassword];
    
    if ([passwordText isEqualToString:@""]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter password"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
    }else if ([passwordText isEqualToString:currentPassword]){
        [self performSegueWithIdentifier:@"showChangeURLSegue" sender:self];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password is incorrect"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];

    }
}

- (IBAction)paaswordCancelButtonClicked:(id)sender {
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
