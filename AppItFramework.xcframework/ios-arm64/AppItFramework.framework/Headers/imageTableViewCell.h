//
//  imageTableViewCell.h
//  AppItFramework
//
//  Created by Amol Deshmukh on 17/07/23.
//  Copyright © 2023 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface imageTableViewCell : UITableViewCell

@property(weak, nonatomic)IBOutlet UILabel *primaryModel_Label;
@property(weak, nonatomic)IBOutlet UILabel *primaryModelInputImage_Label;
@property(weak, nonatomic)IBOutlet UIImageView *primaryModelInput_ImageView1;
@property(weak, nonatomic)IBOutlet UIImageView *primaryModelInput_ImageView2;
@property(weak, nonatomic)IBOutlet UILabel *primaryModelOriginalImage_Label;
@property(weak, nonatomic)IBOutlet UIImageView *primaryModelOriginalImageView;
@property(weak, nonatomic)IBOutlet UILabel *primaryModelCroppedImage_Label;
@property(weak, nonatomic)IBOutlet UIImageView *primaryModelCroppedImageView;
@property(weak, nonatomic)IBOutlet UILabel *primaryModelDetails_Label;

@property(weak, nonatomic)IBOutlet UIStackView *secondaryModel_StackView;
@property(weak, nonatomic)IBOutlet UILabel *secondaryModel_Label;
@property(weak, nonatomic)IBOutlet UILabel *secondaryModelInputImage_Label;
@property(weak, nonatomic)IBOutlet UIImageView *secondaryModelInput_ImageView1;
@property(weak, nonatomic)IBOutlet UIImageView *secondaryModelInput_ImageView2;
@property(weak, nonatomic)IBOutlet UILabel *secondaryModelDetails_Label;

@end

NS_ASSUME_NONNULL_END
