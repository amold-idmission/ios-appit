//
//  HistogramBump.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__HistogramBump__
#define __appit_ios__HistogramBump__

#include <opencv2/opencv.hpp>
#include <vector>

class HistogramBump {
public:
    int start = -1;
    int stop = -1;
    double accumulator = 0;
    
    //    public SummaryStatistics statsXPosition = new SummaryStatistics();
    //    public SummaryStatistics statsYPosition = new SummaryStatistics();
    //    public SummaryStatistics statsWidth = new SummaryStatistics();
    //    public SummaryStatistics statsHeight = new SummaryStatistics();
    
    std::vector<cv::Rect> letters;
    
    void addLetter(cv::Rect r) {
        
        letters.push_back(r);
        
        //        statsXPosition.addValue(r.x);
        //        statsYPosition.addValue(r.y);
        //        statsWidth.addValue(r.width);
        //        statsHeight.addValue(r.height);
    }
    
    bool operator<(const HistogramBump &other) const {
        return this->accumulator < other.accumulator;
    }

    double average_letter_height() const {
        double height(0);
        for (auto letter : letters) {
            height += letter.height;
        }
        return height / letters.size();
    }
};

#endif /* defined(__appit_ios__HistogramBump__) */
