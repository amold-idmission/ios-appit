//
//  ChangeURLViewController.m
//  TestMenu
//
//  Created by idmission solutions pvt ltd  on 20/10/16.
//  Copyright © 2016 IDMission Solution PVT LTD. All rights reserved.
//

#import "ChangeURLViewController.h"
#import "ViewController.h"
#import "NSStringUtils.h"
#import "Settings.h"

@interface ChangeURLViewController ()

@end

@implementation ChangeURLViewController
@synthesize changeURLText;
@synthesize currentURL;
@synthesize changedPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    changeURLText.text = currentURL;
    [self.changeURLText becomeFirstResponder];
    [self.changeURLText textRangeFromPosition:self.changeURLText.endOfDocument toPosition:self.changeURLText.beginningOfDocument];
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
    if([segue.identifier isEqualToString:@"changeURLSegue"]){
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        NSString *url = [changeURLText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [Settings setCurrentURL:url];
        currentURL = url;
        if(![NSStringUtils stringIsNilOrEmpty:changedPassword]){
            [Settings setCurrentPassword:changedPassword];
        }
    }
}

- (IBAction)changeURLOKButtonClicked:(id)sender {
    NSString *url = changeURLText.text;
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([self isValidURL:url]){
        [self performSegueWithIdentifier:@"changeURLSegue" sender:self];
    }
}

- (IBAction)changeURLCancelButtonClicked:(id)sender {
    //[[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    //[self dismissViewControllerAnimated:NO completion:nil];
    currentURL = changeURLText.text;
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)changePasswordButtonClicked:(id)sender {
    
    [self showChangePasswordPopup:nil newPassword:nil retypePassword:nil];
}

-(BOOL)isValidURL:(NSString*)url{
    NSString *error = nil;
    
    NSURL *nsurl = [NSURL URLWithString:url];
    
    if(nsurl == nil || nsurl.absoluteString.length==0){
        error = @"Please enter URL";
    }else{
        NSString *scheme = nsurl.scheme;
        NSString *host = nsurl.host;
        NSString *extention = nsurl.host.pathExtension;
        NSString *path = nsurl.path;
        
        if(scheme==nil || scheme.length==0 || ![[scheme lowercaseString] containsString:@"http"]){
            error = @"Please enter correct URL";
        }else if(host==nil || host.length==0){
            error = @"Please enter correct URL";
        }
    }
    
    if(error != nil){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return false;
    }else{
        return true;
    }
}

-(void)showChangePasswordPopup:(NSString*)currentPassword newPassword:(NSString*)newPassword retypePassword:(NSString*)retypePassword{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Change Password"
                                          message:@"Please enter below details."
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    //Adding UITextField for entering password
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter old password";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = TRUE;
        if(currentPassword){
            textField.text = currentPassword;
        }
        [textField addTarget:self action:@selector(alertTextFieldValueChanged:)  forControlEvents:UIControlEventEditingChanged];
        _oldpassAlertTextField = textField;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter new password";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = TRUE;
        if(newPassword){
            textField.text = newPassword;
        }
        [textField addTarget:self action:@selector(alertTextFieldValueChanged:)  forControlEvents:UIControlEventEditingChanged];
        _newpassAlertTextField = textField;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Confirm new password";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = TRUE;
        if(retypePassword){
            textField.text = retypePassword;
        }
        [textField addTarget:self action:@selector(alertTextFieldValueChanged:)  forControlEvents:UIControlEventEditingChanged];
        _confirmpassAlertTextField = textField;
    }];
    
    
    //Adding action button
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){
                                                             NSLog(@"Password cancelled");
                                                             changedPassword = nil;
                                                         }];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         NSArray<UITextField *> *textFields = alertController.textFields;
                                                         
                                                         UITextField *oldPassword = [textFields objectAtIndex:0];
                                                         UITextField *newPassword = [textFields objectAtIndex:1];
                                                         UITextField *confirmPassword = [textFields objectAtIndex:2];
                                                         
                                                         BOOL valid = [self validateChangePassword:oldPassword.text newPassword:newPassword.text retypePassword:confirmPassword.text];
                                                         if(valid){
                                                             changedPassword = newPassword.text;
                                                             NSLog(@"Validated password succesfully");
                                                         }else{
                                                             changedPassword = nil;
                                                             NSLog(@"Password not valid");
                                                         }
                                                     }];
    _okActionButton = actionOk;
    [alertController addAction:actionCancel];
    [alertController addAction:actionOk];
    [actionOk setEnabled:false];
//    [alertController.actions lastObject].enabled = NO;
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showErrorPopUp:(NSString*)currentPassword newPassword:(NSString*)newPassword retypePassword:(NSString*)retypePassword errorMessage:(NSString*)errorMessage{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                                            message:errorMessage
                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *errorOk = [UIAlertAction actionWithTitle:@"Ok"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        [self showChangePasswordPopup:currentPassword newPassword:newPassword retypePassword:retypePassword];
                                                    }];
    [alertController addAction:errorOk];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:NO completion:nil];
}

-(BOOL)validateChangePassword:(NSString*)currentPassword newPassword:(NSString*)newPassword retypePassword:(NSString*)retypePassword{

    NSString *error = nil;
    if([NSStringUtils stringIsNilOrEmpty:currentPassword] || [NSStringUtils stringIsNilOrEmpty:newPassword] || [NSStringUtils stringIsNilOrEmpty:retypePassword]){
        error = @"Please fill all the details.";
    }else if(![[Settings getCurrentPassword] isEqualToString:currentPassword]){
        error = @"Please enter correct old password.";
    }else if([newPassword length]<4 || [newPassword length]>6){
        error = @"Password must be between 4 and 6 characters.";
    }else if(![newPassword isEqualToString:retypePassword]){
        error = @"New password not matched.";
    }
    
    if(error == nil){
        return true;
    }else{
        [self showErrorPopUp:currentPassword newPassword:newPassword retypePassword:retypePassword errorMessage:error];
        return false;
    }
}

- (void)alertTextFieldValueChanged:(UITextField *)sender {
    
    if(![NSStringUtils stringIsNilOrEmpty:[_oldpassAlertTextField text]]
       && ![NSStringUtils stringIsNilOrEmpty:[_newpassAlertTextField text]]
       && ![NSStringUtils stringIsNilOrEmpty:[_confirmpassAlertTextField text]]){
        [_okActionButton setEnabled:TRUE];
    }else{
        if([_okActionButton isEnabled]){
            [_okActionButton setEnabled:FALSE];
        }
    }
}

@end
