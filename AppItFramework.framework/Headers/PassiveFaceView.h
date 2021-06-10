//
//  PassiveFaceView.h
//  AppItFramework
//
//  Created by Dipen Patel on 04/01/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassiveFaceView : UIView{
    
}

@property(readwrite) BOOL showOvalUI;
@property(readwrite) UIColor *backgroundColor;
@property(readwrite) UIColor *ovalColor;
@property(readwrite) float ovalBufferPercentage;
@property(readwrite) float ovalBufferPercentageHeight;

- (id)initWithFrame:(CGRect)frame backGroundColor:(UIColor *)backGroundColor backGroundColorAlpha:(CGFloat)backGroundColorAlpha;
@end

NS_ASSUME_NONNULL_END
