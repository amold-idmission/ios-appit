//
//  MRZDataAndAngleClass.h
//  AppItFramework
//
//  Created by Sanket Garde on 30/09/20.
//  Copyright © 2020 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRZDataAndAngleClass : NSObject

@property(nonatomic) float angle;

@property(nonatomic) NSString *appendedString;

-(id)initWithData:(NSString *)appended_string angle_data:(float)angle_data;

-(float) getAngle;

-(NSString *) getAppendedString;

@end

NS_ASSUME_NONNULL_END
