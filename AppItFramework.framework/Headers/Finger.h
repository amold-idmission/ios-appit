//
//  Finger.h
//  AppItFramework
//
//  Created by Dipen Patel on 22/07/19.
//  Copyright © 2019 idmission solutions pvt ltd . All rights reserved.
//

#import <Foundation/Foundation.h>
#include <opencv2/opencv.hpp>
#include <vector>
#include <algorithm>
using namespace std;
using namespace cv;

@interface Finger : NSObject{
    
}

@property (assign) std::vector<cv::Point> leftEdge;
@property (assign) std::vector<cv::Point> rightEdge;
@property (assign) std::vector<cv::Point> tip;

-(void)clearEdges;
-(void)addTipPoint:(cv::Point)pt;
-(void)addEdgePoint:(bool)isRightEdge pt:(cv::Point)pt;
-(std::vector<cv::Point>)getLeftEdge;
-(std::vector<cv::Point>)getRightEdge;
-(std::vector<cv::Point>)getTip;
-(Finger*)getModelFinger:(cv::Mat)src;

@end
