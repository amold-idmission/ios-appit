//
//  ImageBuffer
//  appit-ios
//
//  Created by Goran Rauker on 2/25/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "ImageBuffer.h"

ImageBuffer::ImageBuffer(int queue_size) : MaxQueueSize(queue_size), inserted(0), consumed(0)
{}

void ImageBuffer::clear() {
    std::lock_guard<std::mutex> lock(mutex);
    while (!queue.empty())
        queue.pop();
}

void ImageBuffer::set_image(const cv::Mat &im, const cv::Rect &roi) {
    std::lock_guard<std::mutex> lock(mutex);
    
    if (queue.size() < MaxQueueSize) {
        queue.push(std::make_pair(im.clone(),roi));
        inserted++;
    }
}

std::pair<cv::Mat,cv::Rect> ImageBuffer::next_image() {

    std::lock_guard<std::mutex> lock(mutex);
    if (queue.empty())
        return std::make_pair(cv::Mat(),cv::Rect());
    
    consumed++;
    
    auto pair = queue.front();
    queue.pop();
    
    return pair;
}