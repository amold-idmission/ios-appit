//
//  Letters.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__Letters__
#define __appit_ios__Letters__

#include <opencv2/opencv.hpp>
#include "Letter.h"
#include <vector>

class Letters : public std::vector<Letter> {
public:

    void add(const Letter &letter) {
        this->push_back(letter);
        this->centers.push_back(letter.center);
        
        if (letter.center.x < x_min)
            x_min = letter.center.x;
        if (letter.center.x > x_max)
            x_max = letter.center.x;
    }
    
    double average_height() const {
        double height(0);
        for (auto l : *this) {
            height += l.rect.height;
        }
        return height / this->size();
    }

    double average_width() const {
        double width(0);
        for (auto l : *this) {
            width += l.rect.width;
        }
        return width / this->size();
    }
    
    void clear() {
        this->std::vector<Letter>::clear();
        centers.clear();
        x_min = 1E6;
        x_max = -1E6;
    }
    
    double get_max_height() const {
        double height(0);
        for (auto l : *this) {
            if (l.rect.height > height)
                height = l.rect.height;
        }
        return height;
    }
    
    cv::Point left_letter_center_point() const {
        return cv::Point(x_min,solve_for_y(fit_line_through_centers(),x_min));
    }

    cv::Point right_letter_center_point() const {
        return cv::Point(x_max,solve_for_y(fit_line_through_centers(),x_max));
    }
    
    void remove_slope_and_xoffset() {
        Letters vector;
        int xoffset = (int) this->operator[](0).rect.x;
        for (auto &l : *this) {
            Letter copy = Letter(cv::Rect(l.rect.x-xoffset,0, l.rect.width, l.rect.height),l.image);
            vector.add(copy);
        }
        *this = vector;
    }
    
    cv::Vec4f fit_line_through_centers() const {
        cv::Vec4f line;
        cv::fitLine(centers,line,cv::DIST_L2,0,0.01,0.01);
        return line;
    }
    
    double solve_for_y(const cv::Vec4f &line, double x) const{

        double M = line[1] / line[0];
        double B = -M*line[2] + line[3];

        return M*x+B;
    }
    
    Letters filterByLineDeviation(double factor) {

        if (this->empty())
            return *this;
        
        auto line( fit_line_through_centers());
        
        Letters filtered;
        double avgHd4 = average_height() / factor;
        
        for (Letter l: *this) {
            if ( fabs(solve_for_y(line,l.center.x) - l.center.y) < avgHd4 )
                filtered.add(l);
        }
        return filtered;
    }
    
    std::vector<cv::Point> centers;
    double x_min = 1E6, x_max = -1E6;
    
protected:
    void push_back(const Letter& x) {
        this->std::vector<Letter>::push_back(x);
    }
};

#endif /* defined(__appit_ios__Letters__) */
