//
//  ScoredLine.h
//  AppItFramework
//
//  Created by Dipen Patel on 23/08/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#include <opencv2/opencv.hpp>
#include <vector>
#include <algorithm>
using namespace std;
using namespace cv;


@interface ScoredLine : NSObject{
    
}

@property (assign) int score;
@property (assign) cv::Point pt1, pt2;
@property (assign) int thickness;

-(ScoredLine*)multiply:(double)factor;
-(ScoredLine*)div:(double)factor;
-(void)initScoredLine:(cv::Point)pta ptb:(cv::Point)ptb thickness:(int)thickness;

@end
