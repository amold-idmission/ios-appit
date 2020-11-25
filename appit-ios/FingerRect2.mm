//
//  FingerRect.m
//  appit-ios
//
//  Created by  on 09/11/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import "FingerRect2.h"

@implementation FingerRect2

-(double) getTopLeftX{
    return self.topLeftX;
}

-(double) getTopLeftY{
    return self.topLeftY;
}

-(double) getBottomRightX{
    return self.bottomRightX;
}

-(double) getBottomRightY{
    return self.bottomRightY;
}

-(std::vector<cv::Point>) getContourMain{
    return self.contourMain;
}

-(id) initWithTopLeftX: (double)topLeftX andTopLeftY: (double)topLeftY andBottomRightX: (double)bottomRightX andBottomRightY: (double)bottomRightY andContourMain: (std::vector<cv::Point>)contourMain{
    self = [super init];
    if(self){
        self.topLeftX = topLeftX;
        self.topLeftY = topLeftY;
        self.bottomRightX = bottomRightX;
        self.bottomRightY = bottomRightY;
        self.contourMain = contourMain;
    }
    return self;
}

@end

