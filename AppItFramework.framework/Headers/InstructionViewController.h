//
//  InstructionViewController.h
//  AppItFramework
//
//  Created by  on 11/04/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonImporter.h"

@interface InstructionViewController : UIViewController

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSString *imageType;
//@property(nonatomic) NSString *showcaseEmailIdToPass;
@property(nonatomic) NSString *instruction_type;
@property(nonatomic) NSString *background_color;
@property(nonatomic) int background_color_alpha;
@property(nonatomic) UIImage *instruction_image;
@property(nonatomic, retain) NSString *instructionTextStyle;
@property(nonatomic, retain) NSString *continueButtonStyle;
@property(nonatomic, retain) NSString *instruction_text_color;
@property(nonatomic, assign) int instruction_text_color_alpha;
@property(nonatomic, retain) NSString *continue_button_color;
@property(nonatomic, assign) int continue_button_color_alpha;
@property(nonatomic, retain) NSString *continue_button_text_color;
@property(nonatomic, assign) int continue_button_text_color_alpha;
@property(nonatomic) bool isPassiveFaceDetection;

@end
