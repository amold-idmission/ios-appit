//
//  InstructionViewController.h
//  appit-ios
//
//  Created by  on 16/04/18.
//  Copyright © 2018 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+fromHex.h"

@protocol faceInstructionScreenResponse <NSObject>
@required
-(void)faceInstructionScreenResponse : (id)instance;
@end

@protocol idInstructionScreenResponse <NSObject>
@required
-(void)idInstructionScreenResponse : (id)instance;
@end

@protocol fingerInstructionResponse <NSObject>
@required
-(void)fingerInstructionResponse : (id)instance;
@end

@interface InstructionViewController : UIViewController {
    
}

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSString *instruction_type;
@property(nonatomic) NSString *background_color;
@property(nonatomic) int background_color_alpha;
@property(nonatomic) UIImage *instruction_image;
@property(nonatomic) NSString *imageType;
@property (nonatomic, retain) NSString *instructionTextStyle;
@property (nonatomic, retain) NSString *continueButtonStyle;
@property (nonatomic, retain) NSString *instruction_text_color;
@property(nonatomic, assign) int instruction_text_color_alpha;
@property (nonatomic, retain) NSString *continue_button_color;
@property(nonatomic, assign) int continue_button_color_alpha;
@property (nonatomic, retain) NSString *continue_button_text_color;
@property(nonatomic, assign) int continue_button_text_color_alpha;
@property(nonatomic) NSString *instTextSize;
@end
