//
//  LetterSize.h
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__LetterSize__
#define __appit_ios__LetterSize__

class LetterSize {
public:
    LetterSize() {}
    
    LetterSize(int min, int max) {
        this->min = min;
        this->max = max;
    }
    
        bool isValid() const {
        return min > -1 && max > -1 ;
    }
    
    int min = -1;
    int max = -1;
    
};

#endif /* defined(__appit_ios__LetterSize__) */
