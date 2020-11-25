//
//  FingerRect2.h
//  appit-ios
//
//  Created by  on 09/11/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import<Foundation/Foundation.h>
#include <opencv2/opencv.hpp>

@interface FingerRect2 : NSObject

@property (assign) double topLeftX, topLeftY, bottomRightX, bottomRightY;
@property (assign) std::vector<cv::Point> contourMain;

-(double) getTopLeftX;
-(double) getTopLeftY;
-(double) getBottomRightX;
-(double) getBottomRightY;
-(std::vector<cv::Point>) getContourMain;

-(id) initWithTopLeftX: (double)topLeftX andTopLeftY: (double)topLeftY andBottomRightX: (double)bottomRightX andBottomRightY: (double)bottomRightY andContourMain: (std::vector<cv::Point>)contourMain;

@end

