//
//  SecurityFeatureMatcher.h
//  appit-ios
//
//  Created by Goran Rauker on 3/5/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__SecurityFeatureMatcher__
#define __appit_ios__SecurityFeatureMatcher__

#include "TemplateMatcher.h"

class SecurityCheckMatcher : public TemplateMatcher {
public:

    int mMatchedFeatures = 0;
    bool match(const cv::Mat& template_image, const cv::Mat &im);
};


#endif /* defined(__appit_ios__SecurityFeatureMatcher__) */
