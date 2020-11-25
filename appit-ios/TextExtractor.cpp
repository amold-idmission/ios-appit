//
//  TextExtractor.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/4/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include <cmath>
#include "Historgram.h"
#include "Letters.h"
#include "TextExtractor.h"

//ExtractedText TextExtractor::extract(const cv::Mat &im, TextComponent &text, bool reconstruct) {
//    
//    cv::Mat colorSnippet(im, text.roi().toRect());
//    
//    // deblur the image snippet
//    cv::Mat tmp;
//    cv::GaussianBlur(colorSnippet, tmp, cv::Size(15, 15), 5);
//    cv::addWeighted(colorSnippet, 1.5, tmp, -0.5, 0, colorSnippet);
//
//    auto bw(extract_text(colorSnippet,text,reconstruct));
//    
//    if (bw.first.empty())
//        return ExtractedText();
//    
//    cv::Mat reconstructed, cropped;
//    cv::resize(bw.first, reconstructed, cv::Size(), .33, .33, cv::INTER_CUBIC);
//    cv::resize(bw.second, cropped, cv::Size(), .33, .33, cv::INTER_CUBIC);
//    
//    return ExtractedText(text.name(), "", reconstructed, cropped);
//}

std::vector<std::pair<cv::Mat,cv::Mat>> TextExtractor::extract_text(const cv::Mat &colorSnippet, TextComponent &text) {
    
    cv::Mat blurred;
    cv::GaussianBlur(colorSnippet.clone(), blurred, cv::Size(3, 3), 0);
    
    std::vector<cv::Mat> split;
    cv::split(blurred, split);
    
    std::vector<std::pair<cv::Mat,cv::Mat>> values;
    
    for (cv::Mat gray : split) {
        for (int threshold = 0; threshold < 286; threshold += 26) {
            auto extracted = findText(colorSnippet, gray, text, threshold);
            if (extracted.first.empty() == false) {
                values.push_back(extracted);
                threshold = 300; // pop out of this loop
            }
        }
    }
    
    return values;
}

std::pair<cv::Mat,cv::Mat> TextExtractor::findText(const cv::Mat &colorSnippet, const cv::Mat &gray, TextComponent &text, int threshold) {
    
    cv::Mat bin;
    int mode = 0;
    
    if (threshold == 0) {
        cv::Canny(gray, bin, 0, 50, 5, true);
        
        cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5));
        cv::dilate(bin, bin, element);
        mode = cv::RETR_EXTERNAL;
    } else if (threshold < 255) {
        cv::threshold(gray, bin, threshold, 255, cv::THRESH_BINARY_INV);
        mode = cv::RETR_EXTERNAL;
    } else if (threshold == 260) {
        cv::cvtColor(colorSnippet, bin, cv::COLOR_BGR2GRAY);
        cv::GaussianBlur(bin, bin, cv::Size(3, 3), 1.1);
        cv::adaptiveThreshold(bin, bin, 255, 1, 1, 3, 5);
        cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5));
        cv::dilate(bin, bin, element);
        mode = cv::RETR_EXTERNAL;
    } else {
        cv::cvtColor(colorSnippet, bin, cv::COLOR_BGR2GRAY);
        cv::Scalar mean, std_dev;
        cv::meanStdDev(colorSnippet, mean, std_dev);
        cv::threshold(bin, bin, mean[0] - std_dev[0], 255, cv::THRESH_BINARY);
        mode = cv::RETR_LIST;
    }
    
    std::vector<cv::Mat> contours;
    cv::Mat hierarchy;
    cv::findContours(bin, contours, hierarchy, mode, cv::CHAIN_APPROX_SIMPLE);
    
    Letters letters;
    Histogram hist(bin.rows);
    
    for (int i = 0; i < contours.size(); i++) {
        cv::Rect br = cv::boundingRect(contours[i]);
        
        if (!text.isBoundingRectCorrectSizeForLetter(br))
            continue;
        
        letters.add(Letter(cv::Rect(br.x, br.y, br.width, br.height)));
        
        // increment the row histogram for the center of each found letter
        float ypos = br.y + br.height / 2.0f;
        
        int index = fmin(std::round(ypos), colorSnippet.rows);
        hist.increment(index);
    }
    
    if (letters.size() < 3)
        return std::make_pair(cv::Mat(),cv::Mat());
    
    hist.convolve(7);
    
    std::vector<HistogramBump> bumps = hist.findDistinct();
    std::sort(bumps.begin(), bumps.end());
    std::reverse(bumps.begin(), bumps.end());
    
    if (bumps.size() < 1)
        return std::make_pair(cv::Mat(),cv::Mat());
    
    // filter out letters that are not in those bumps by sorting them into the proper bumps
    HistogramBump &bump = bumps[0];
    for (Letter r : letters) {
        double y = (2 * r.rect.y + r.rect.height) / 2.0;
        if (y >= bump.start && y <= bump.stop) {
            bump.addLetter(r.rect);
        }
    }
    
    double ah = bump.average_letter_height();
    cv::Mat tmp = cv::Mat(colorSnippet,
                          cv::Rect(cv::Point(0, fmax(bump.start - ah / 2, 0)),
                                   cv::Point(colorSnippet.cols, fmin(bump.stop + ah / 2, colorSnippet.rows))));

    
    // the resolution of the image is increased as the
    // number of lines increases
    double sf = std::max(1.0, 150.0 / tmp.rows);
    cv::resize(tmp, tmp, cv::Size(), sf, sf, cv::INTER_CUBIC);
    
    // blur the background so that like colors/features are non-distinct
    cv::GaussianBlur(tmp, tmp, cv::Size(9, 9), 0);

    // threshold each color channel separately and recombine the image
    std::vector<cv::Mat> bgr;
    cv::split(tmp, bgr);
    
    for (auto c : bgr) {
        cv::Scalar mean, std;
        cv::meanStdDev(c, mean, std);
        cv::threshold(c, c, mean[0] - std[0], 255, cv::THRESH_BINARY);
    }
    
    cv::merge(bgr, tmp);
    bgr.clear();

    cv::cvtColor(tmp, tmp, cv::COLOR_BGR2GRAY);

    // erode, dilate to remove any noise (speckle)
    cv::Mat element = cv::getStructuringElement(cv::MORPH_CROSS, cv::Size(3,3));
//    cv::erode(tmp,tmp,element);
    cv::dilate(tmp, tmp, element);

    // clean up any pixels that aren't overly bright
    cv::threshold(tmp, tmp, 50, 255, cv::THRESH_BINARY);
    
    // now clean the top and bottom of the image
    tmp = cleanTopBottom(tmp);
    
    if (tmp.empty())
        return std::make_pair(cv::Mat(),cv::Mat());
   
    
    // ------------------------------------------------------------------------
    // filter out contours that aren't the correct letter size ...

    cv::Mat inv;
    cv::threshold(tmp, inv, 125, 255, cv::THRESH_BINARY_INV);
    
    contours.clear();
    hierarchy = cv::Mat();
    
    cv::findContours(inv, contours, hierarchy, mode, cv::CHAIN_APPROX_SIMPLE);
    
    letters.clear();
    for (int i = 0; i < contours.size(); i++) {
        cv::Rect br = cv::boundingRect(contours[i]);

        if (br.width < (int)(text.letterWidth().min * sf) || br.height < (int)(text.letterHeight().min * sf) )
            continue;
        
        letters.add(Letter(br, cv::Mat(tmp, br)));
    }
    
    if (letters.empty()) //  || letters.size() < .5*44)
        return std::make_pair(cv::Mat(),cv::Mat());
    
    // ------------------------------------------------------------------------
    // reconstructs the image
    std::sort(letters.begin(), letters.end());
    
    // remove any duplicates after sorting ...
    auto last = std::unique(letters.begin(), letters.end());
    letters.erase(last, letters.end());
    letters.remove_slope_and_xoffset();
    
    int height = (int) ceil(letters.get_max_height());
    int width = (int) letters[letters.size() - 1].rect.br().x;
    
    cv::Mat reconstructed = cv::Mat(cv::Size(width, height), tmp.type());
    reconstructed.setTo(cv::Scalar(255, 255, 255));
    try {
        for (Letter &l : letters) {
            l.image.copyTo(cv::Mat(reconstructed, l.rect));
        }
    } catch(cv::Exception &) {
        return std::make_pair(cv::Mat(),cv::Mat());
    }

    cv::Mat border = cv::Mat();
    int top = (int) (0.1 * reconstructed.rows), bottom = (int) (0.1 * reconstructed.rows);
    int left = (int) (0.1 * reconstructed.cols), right = (int) (0.1 * reconstructed.cols);
    cv::copyMakeBorder(reconstructed, border, top, bottom, left, right, cv::BORDER_CONSTANT, cv::Scalar(255, 255,255,255));
    
    // ------------------------------------------------------------------------
    // returns reconstructed and cropped image
    int x1 = (int) (letters[letters.size()-1].center.x + letters.average_width() * 2.5);
    return std::make_pair(border, cv::Mat(tmp, cv::Rect(0, 0, fmin(tmp.cols, x1), tmp.rows)) );
}

cv::Mat TextExtractor::cleanTopBottom(const cv::Mat &orig) {
    
    // Pick a high threshold level since these images will have high contrast
    cv::Mat bw = orig.clone();
    cv::Canny(bw, bw, 200, 200 * 2);
    
    // form the histogram
    Histogram hist(bw.rows);
    for (int i = 0; i < bw.rows; i++) {
        
        hist.hist.get()[i] = (int) cv::sum(cv::Mat(bw, cv::Rect(0, i, bw.cols, 1))).val[0];
    }
    
    int y0 = 0, y1 = bw.rows;
    
    // starting from the center look down/up for non zero parts of data
    for (int y = bw.rows / 2; y >= 0; y--) {
        if (hist.hist.get()[y] == 0) {
            y0 = y;
            break;
        }
    }
    
    for (int y = bw.rows / 2; y < bw.rows; y++) {
        if (hist.hist.get()[y] == 0) {
            y1 = y;
            break;
        }
    }
    
    return cv::Mat(orig, cv::Rect(0, y0, bw.cols, y1 - y0));
}

