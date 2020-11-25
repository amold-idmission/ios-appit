//
//  ImageBuffer
//  appit-ios
//
//  Created by Goran Rauker on 2/25/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__ImageBuffer__
#define __appit_ios__ImageBuffer__

#include <atomic>
#include <opencv2/opencv.hpp>
#include <mutex>
#include <queue>

class ImageBuffer {
public:
    const int MaxQueueSize;
    ImageBuffer(int queue_size);
    void clear();
    void set_image(const cv::Mat &im, const cv::Rect &roi);
    std::pair<cv::Mat,cv::Rect> next_image();
    
    std::atomic<size_t> inserted, consumed;
    
protected:
    
    std::queue<std::pair<cv::Mat,cv::Rect>> queue;
    std::mutex mutex;
};

#endif /* defined(__appit_ios__ImageBuffer__) */
