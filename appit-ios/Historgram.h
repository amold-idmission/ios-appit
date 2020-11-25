//
//  Historgram.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__Historgram__
#define __appit_ios__Historgram__

#include "HistogramBump.h"
#include <memory>
#include <vector>

class Histogram {
public:
    std::shared_ptr<int> hist = nullptr;
    size_t length = 0;
    
    Histogram(int bins) {
        length = bins;
        hist = std::shared_ptr<int>(new int[bins], []( int *p ) { delete[] p; } );
    }
    
    void convolve(int kernelLength) {
        
        std::shared_ptr<int> filtered = std::shared_ptr<int>(new int[length], []( int *p ) { delete[] p; } );
        int border = kernelLength / 2;
        for (int i = border; i < length - border; i++) {
            
            int sum = 0;
            for (int j = -border; j <= border; j++) {
                sum += hist.get()[i + j];
            }
            filtered.get()[i] = sum;
        }
        hist = filtered;
    }
    
    void print(){
        for (int i = 0; i < (int)length - 1; i++) {
            std::cout << hist.get()[i];
        }
    }
    
    std::vector<HistogramBump> findDistinct() {

        bool isZero = true;
        std::vector<HistogramBump> bumps;
        
        bumps.push_back(HistogramBump());
        for (int i = 0; i < (int)length - 1; i++) {
            if (hist.get()[i] != 0 && hist.get()[i + 1] != 0) {
                
                HistogramBump &bump = *bumps.rbegin();
                if (bump.start == -1)
                    bump.start = i;
                
                bump.accumulator += hist.get()[i];
                isZero = false;
                continue;
            }
            
            // we were zero, so set the last index of the bump and make a new
            // one in the bumps vector
            if (isZero == false) {
                HistogramBump &bump = *bumps.rbegin();
                
                bump.stop = i;
                bumps.push_back(HistogramBump());
            }
            
            isZero = true;
        }
        //std::cout << "bumps.size before erase : " << bumps.size() << std::endl;
        for (int i = (int)bumps.size() - 1; i >= 0; i--) {
            if (bumps[i].accumulator < 40 || bumps[i].stop == -1 || (bumps[i].stop-bumps[i].start) < 5 )
                bumps.erase(bumps.begin()+i);
        }
        //std::cout << "bumps.size after erase : " << bumps.size() << std::endl;
        return bumps;
    }
    
    void increment(int index) {
        hist.get()[index] += 1;
    }
};
#endif /* defined(__appit_ios__Historgram__) */
