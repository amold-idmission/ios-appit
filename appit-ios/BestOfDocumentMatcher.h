//
//  BestOfDocumentMatcher.h
//  appit-ios
//
//  Created by Goran Rauker on 3/11/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#ifndef __appit_ios__BestOfDocumentMatcher__
#define __appit_ios__BestOfDocumentMatcher__

#include "Document.h"
#include "DocumentMatcher.h"

class BestOfDocumentMatcher : protected DocumentMatcher {
public:
    
    std::shared_ptr<Document> findmatch(const cv::Mat &im, float sf);
    std::vector<std::shared_ptr<Document>> documents;
};

#endif /* defined(__appit_ios__BestOfDocumentMatcher__) */
