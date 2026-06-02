//
//  UIColor+fromHex.h
//  AppItFramework
//
//  Created by  on 11/01/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor (fromHex)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
