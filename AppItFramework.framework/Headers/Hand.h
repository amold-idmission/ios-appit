//
//  Hand.h
//  AppItFramework
//
//  Created by Dipen Patel on 23/07/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Finger.h"

@interface Hand : NSObject{
    
}

@property (nonatomic, strong) NSMutableArray<Finger *> *fingers;
@property (nonatomic, strong) NSMutableArray *minTipThreshold;
@property (nonatomic, strong) NSMutableArray *maxTipthresholds;
@property (nonatomic, strong) NSMutableArray *checkFingers;
@property (nonatomic) cv::Size imageSize;
@property (nonatomic) int minY;
@property (nonatomic) int maxY;
@property (nonatomic) cv::Mat binhand;

-(void)initHand;
-(float)detect:(cv::Mat)frameMat relrect:(cv::Rect)relrect;
-(float)detect:(cv::Mat)frameMat scalefactor:(float)scalefactor dofast:(bool)dofast relrect:(cv::Rect)relrect;
-(Hand*)getModelHand:(cv::Mat)src;

@end
