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
@property(nonatomic) NSString *instruction_type;
@property(nonatomic) UIImage *instruction_image;
@property(nonatomic) bool isPassiveFaceDetection;

@end
