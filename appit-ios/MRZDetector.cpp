//
//  MRZDetector.cpp
//  appit-ios
//
//  Created by Goran Rauker on 3/9/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#include "Historgram.h"
#include "MRZDetector.h"
#include <opencv2/features2d.hpp>
#include "zxingwrapper.h"

#define DEBUG_MRZ_DETECTOR false
#if DEBUG_MRZ_DETECTOR
#define SHOW_MRZ_LINES false
#define SHOW_BLACK_IMAGE false
#define SHOW_THRESHOLDED_SNIPPET true
#define WAIT_KEY 0
#endif

cv::Mat MRZDetector::detect(const cv::Mat &gray, const LetterSize &letter_width, const LetterSize &letter_height, float offset) {
    cv::Mat mrz;
    // progressively decrease the feature threshold ....
    for (int threshold = 30; threshold > 10; threshold -= 5) {

        mLines.clear();
        mMrzLetters.clear();

        mMrzVertices.clear();

        mYOffset = (int) (gray.rows * offset);
        cv::Mat roi = cv::Mat(gray, cv::Rect(0, mYOffset, gray.cols, gray.rows - mYOffset));

        auto fast = cv::FastFeatureDetector::create(threshold,true);
        std::vector<cv::KeyPoint> keyPoints;
        fast->detect(roi, keyPoints);
        if (keyPoints.size() < 50) {
            std::cout << "only found " << keyPoints.size() << " keypoings - exiting..." << std::endl;
            continue;
        }

        // # create a black image that has the same shape as the input image
        cv::Mat black = cv::Mat::zeros(gray.rows - mYOffset, gray.cols,CV_8UC1);

        // # fill in the black image with the keypoints
        
        for (auto kp : keyPoints) {
            black.at<uchar>(kp.pt.y, kp.pt.x) = 255;
        }

        // dilate the keypoints to form better lines
        cv::Mat element = cv::getStructuringElement(cv::MORPH_ELLIPSE, cv::Size(5, 5));
        cv::dilate(black, black, element);

        // # use the hough line transform to locate lines in the image
        std::vector<cv::Vec2f> lines;
        cv::HoughLines(black, lines, 1, M_PI / 180, 100);
        
#if SHOW_BLACK_IMAGE
        cv::imshow("black", black);
        cv::waitKey(WAIT_KEY);
#endif
        
        auto distinct = filterLines(lines, 89.5 * M_PI / 180.0, 90.5 * M_PI / 180.0, mYOffset);
        mLines = distinct;
//std::cout << "filtered lines " << distinct.size() << std::endl;
        // if we didn't find any lines we don't have anything to do ...
        if (distinct.size() < 2) {
            std::cout << "not enough lines " << distinct.size() << std::endl;
            continue;
        }

#if SHOW_MRZ_LINES
        cv::Mat canvas;
        gray.copyTo(canvas);
        for ( auto line : mLines) {
            cv::line(canvas, cv::Point(0,line), cv::Point(canvas.cols,line), cv::Scalar(255,0,0));
        }
        cv::imshow("MRZ lines", canvas );
        cv::waitKey(WAIT_KEY);
#endif
        
//        Log.d("", "Detector searching " + mLines.size() + " lines");
        //std::cout << "Detector searching " << mLines.size() << std::endl;
        
        // # the MRZ lines are separated by approximately 4% of the image height
        int ys = 0, ye = mMrzLines - 1;
        bool keepSearching = true;
        while (ye < mLines.size() && keepSearching && mMrzLines >= 2) {

//            Log.d("", "Looking at lines " + ys + "," + ye);
            //std::cout << "Looking at lines " << ys << "," << ye << std::endl;
            int ymin;
            int ymax;
            if (mMrzLines == 2){
                 ymin = fmax(mYOffset, (int) (distinct[ye] * .92));
                 ymax = fmin((int) (distinct[ys] * 1.08), gray.rows);
            }else{
                ymin = (int) (distinct[ye] * .86);//fmax(mYOffset, (int) (distinct[ye] * .76));
                 ymax = fmin((int) (distinct[ys] * 1.14), gray.rows);
            }

            cv::Rect searchRoi(0, ymin, gray.cols, ymax - ymin);
            if(croppedMrz){
                //Do not crop image as it is already cropped mrz image
                mrz = cleanupBackground(gray, cv::THRESH_BINARY);
            }else{
                mrz = cleanupBackground(cv::Mat(gray, searchRoi), cv::THRESH_BINARY);
            }

           // write_image(mrz);

            /**
             Commented below two line while supporting "Chile Back" id for three line mrz.
             After executing adaptiveThreshold we were getting very fade image.
             **/
//            cv::Mat thresh;
//            cv::adaptiveThreshold(cv::Mat(gray, searchRoi), thresh, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 21, 21);
            
            cv::Mat thresh = mrz.clone();
#if SHOW_THRESHOLDED_SNIPPET
            cv::imshow("mrz", mrz  );
            cv::imshow("adaptive", thresh);
            //write_image(thresh);
//            cv::waitKey(WAIT_KEY);
#endif
        
//            keepSearching = !validateMrz(thresh, ymin, letter_width, letter_height);
            keepSearching = !validateMrz(thresh, 0, letter_width, letter_height);
            
            if (!keepSearching)
                return thresh;

            ys++;
            ye++;
        }
    }

    
    std::cout << "Detector finished" << std::endl;
    return cv::Mat();
    //return mrz;
}

std::vector<cv::Mat> MRZDetector::extractMrzRegions(const cv::Mat &rgb, bool sharpen_output) {

    std::vector<cv::Mat> regions;
    
    if (mMrzVertices.empty())
        return regions;
    
    for (auto verticies : mMrzVertices) {
        
        auto box = std::shared_ptr<cv::Point2f>(new cv::Point2f[4]);
        cv::RotatedRect rect = cv::minAreaRect(verticies);
        rect.points(box.get());
        
        // rect.boundingRect().
        int width = rect.boundingRect().width;
        width = (width / 2) * 2 == width ? width : width + 1;
        
        int height = rect.boundingRect().height;
        height = (height / 2) * 2 == height ? height : height + 1;
        
        std::vector<cv::Point2f> dst = {
            cv::Point(0, 0),
            cv::Point(width, 0),
            cv::Point(width, height),
            cv::Point(0, height) };
        cv::Mat H = cv::findHomography(verticies, dst);
        
        cv::Mat mrz;
        cv::warpPerspective(rgb, mrz, H, cv::Size(width, height), cv::INTER_NEAREST, cv::BORDER_CONSTANT,
                            cv::Scalar(255, 255, 255));
        
        // deblur the mrz region
        if (sharpen_output) {
            cv::Mat tmp;
            cv::GaussianBlur(mrz, tmp, cv::Size(15, 15), 5);
            cv::addWeighted(mrz, 1.5, tmp, -0.5, 0, mrz);
        }
        
        regions.push_back(mrz);
    }
    std::cout << " Region Size :  " << regions.size() << std::endl;

    return regions;
}

cv::Mat MRZDetector::cleanupBackground(const cv::Mat &im, int mode) {
    cv::Mat bw;
    im.copyTo(bw);
    
    cv::Scalar mean, stddev;
    
    cv::meanStdDev(bw, mean, stddev);
    cv::threshold(bw, bw, mean[0] - stddev[0]*1.1, 255, mode);
    return bw;
}

bool MRZDetector::validateMrz(const cv::Mat &gray, int yoffset, const LetterSize &letter_width, const LetterSize &letter_height) {
    cv::Mat im;
    //write_image(gray);
    cv::threshold(gray, im, 250, 255, cv::THRESH_BINARY_INV);
    //write_image(im);
    std::vector<cv::Mat> contours;
    cv::Mat hierarchy;
    cv::findContours(im, contours, hierarchy, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    
    Histogram hist(im.rows);
    mMrzLetters.clear();
    mLine0Letters.clear();
    mLine1Letters .clear();
    mLine1aLetters.clear();

//    cv::Mat color;
//    cv::cvtColor(im,color,cv::COLOR_GRAY2BGR);
    
    for (int i = 0; i < contours.size(); i++) {
        cv::Rect br = cv::boundingRect(contours[i]);
        
        if (br.width > letter_width.max || br.width < letter_width.min || br.height > letter_height.max || br.height < letter_height.min){
            //cv::rectangle(color, br, cv::Scalar(0,255,0));
            continue;
        }
        //cv::rectangle(color, br, cv::Scalar(0,0,255));
        //MA Commented above code and added below code same as A-AppIt
        /*if (br.width > gray.cols * .5 || br.width < gray.cols * 0.01 || br.height > gray.rows * .5
            || br.height < gray.rows * .05)
            continue;*/
        /*MA if (br.width > gray.cols * .5 || br.height > gray.rows * .5
            || br.height < gray.rows * .1)
            continue;*/
        
       // cv::drawContours(color, contours, i, cv::Scalar(255,0,0));
        
// MA       float xpos = (2 * br.x + br.width) / 2.0f;
// MA       float ypos = (2 * br.y + br.height) / 2.0f;
        
         mMrzLetters.add(Letter(cv::Rect(br.x, br.y + yoffset, br.width, br.height)));
        //MA mMrzLetters.add(Letter(cv::Rect(xpos, ypos, br.width, br.height)));
        
        float ypos = (2 * br.y + br.height) / 2.0f;
        int index = fmin(std::round(ypos), im.rows);
        //MA int index = std::round(ypos);
        //std::cout << "index : " << index << std::endl;
        if (index < hist.length)
            hist.increment(index);
    }
    
//    cv::imshow("color", color);
//    cv::waitKey();
   // write_image(color);

    // smooth out the the histogram and find the unique areas in it
    hist.convolve(11);
   //hist.print();
    std::vector<HistogramBump> bumps = hist.findDistinct();
    
    // ********************************************************************
    // do we have the same number of distinct histogram areas as lines that
    // we are searching for?
    std::cout << "MRz letters size : " << mMrzLetters.size() << std::endl;
    //Make mrz validation process lenient(easy) by skipping bumpscheck only if croppedMrz flag is true
//    bool bumpsCheck = (croppedMrz ? false : bumps.size() != mMrzLines);
    bool bumpsCheck = (croppedMrz ? false : false);//Temp changes
    if (bumpsCheck) {
        std::cout << "MRZDetector::validateMrz : (1) bumps didn't equal lines " << bumps.size() << ", " << mMrzLines << std::endl;
        //write_image(im);
        //write_image(gray);
        return false;
    }else{
        std::cout << "MRZDetector::validateMrz : (1)-PASS bumps equal " << bumps.size() << ", " << mMrzLines << std::endl;
    }
    
    //std::cout << "bumps greater or equal lines " << bumps.size() << ", " << mMrzLines-1 << std::endl;
    
    // sort out the letters between the two (or three) lines
    int line0 = (bumps[0].stop + bumps[1].start) / 2 + yoffset;
    int line1a = mMrzLines == 3 ? (bumps[1].stop + bumps[2].start) / 2 + yoffset : -10000;
    
    for (Letter letter : mMrzLetters) {
        
        if (letter.rect.y < line0) {
            mLine0Letters.add(letter);
        } else if (mMrzLines == 3 && letter.center.y > line0 && letter.center.y < line1a)
            mLine1aLetters.add(letter);
        else {
            mLine1Letters.add(letter);
        }
    }
    
    // ********************************************************************
    // do we have about the same number of letters per line
    if (!lineRatiosOkay()) {
        std::cout << "MRZDetector::validateMrz : (2) line ratio (1) is bad" << std::endl;
        return false;
    }else{
        std::cout << "MRZDetector::validateMrz : (2)-PASS line ratio (1) is FINE" << std::endl;
    }
    
    // ********************************************************************
    // do we have at least 50 (75 for 3 mrz lines) characters
    if ((mLine0Letters.size() + mLine1Letters.size() + mLine1aLetters.size()) < 25 * mMrzLines) {
        std::cout << "MRZDetector::validateMrz : (3) wrong number of characters" << std::endl;
        return false;
    }else{
        std::cout << "MRZDetector::validateMrz : (3)-PASS number of characters is FINE" << std::endl;
    }
    // filter out any found letters that are too far away from the fitted line
    mLine0Letters = mLine0Letters.filterByLineDeviation(4.0);
    mLine1Letters = mLine1Letters.filterByLineDeviation(4.0);
    mLine1aLetters = mLine1aLetters.filterByLineDeviation(4.0);
    
    // ********************************************************************
    // make sure the filtered lines have about the same number of
    // characters.
    // This has some slop built into it so that we don't exclude fakes
    if (!lineRatiosOkay()){
        std::cout << "MRZDetector::validateMrz : (4) line ratio (2) is bad" << std::endl;
        return false;
    }else{
        std::cout << "MRZDetector::validateMrz : (4)-PASS line ratio (2) is FINE" << std::endl;
    }

    
    // find the bounds of letters to crop and rotate the MRZ data
    double l0aw = mLine0Letters.average_width(), l0ah = mLine0Letters.average_height();
    double l1aw = mLine1Letters.average_width(), l1ah = mLine1Letters.average_height();

    cv::Point tl = mLine0Letters.left_letter_center_point();
    cv::Point tr = mLine0Letters.right_letter_center_point();
    cv::Point bl = mLine1Letters.left_letter_center_point();
    cv::Point br = mLine1Letters.right_letter_center_point();
    
    // increase the length of the lines ...
    if (tr.x > br.x) {
        br = cv::Point(tr.x, mLine1Letters.solve_for_y(mLine1Letters.fit_line_through_centers(),tr.x));
    } else {
        tr = cv::Point(br.x, mLine0Letters.solve_for_y(mLine0Letters.fit_line_through_centers(),br.x));
    }
    
    if (tl.x < bl.x) {
        bl = cv::Point(tl.x, mLine1Letters.solve_for_y(mLine1Letters.fit_line_through_centers(),tl.x));
    } else {
        tl = cv::Point(bl.x, mLine0Letters.solve_for_y(mLine0Letters.fit_line_through_centers(), bl.x));
    }
    
    double percentHeight = 1.80;
    double percentWidth = 1.5;
    
    // top line
    mMrzVertices.push_back( {
        cv::Point(tl.x - l0aw * percentWidth, tl.y - l0ah * percentHeight),
        cv::Point(tr.x + l0aw * percentWidth, tr.y - l0ah * percentHeight),
        cv::Point(tr.x + l0aw * percentWidth, tr.y + l0ah * percentHeight),
        cv::Point(tl.x - l0aw * percentWidth, tl.y + l0ah * percentHeight) } );
    
    /*MA // middle line
    if(mLine1aLetters.size()>0 && mMrzLines==3){
        
        cv::Point ml = mLine1aLetters.left_letter_center_point();
        cv::Point mr = mLine1aLetters.right_letter_center_point();
        
        mMrzVertices.push_back( {
            cv::Point(ml.x - l1aw * percentWidth, ml.y - l1ah * percentHeight),
            cv::Point(mr.x + l0aw * percentWidth, mr.y - l1ah * percentHeight),
            cv::Point(mr.x + l1aw * percentWidth, mr.y + l1ah * percentHeight),
            cv::Point(ml.x - l1aw * percentWidth, ml.y + l1ah * percentHeight) } );
    }*/
    
    // middle line (if it is required)
    if (mMrzLines == 3) {
        
        double average_height = mLine1aLetters.average_height();
        
        mMrzVertices.push_back( {
            cv::Point(bl.x - l1aw * percentWidth, mLine1aLetters.left_letter_center_point().y - average_height * 1.25),
            cv::Point(br.x + l0aw * percentWidth, mLine1aLetters.left_letter_center_point().y - average_height * 1.25),
            cv::Point(br.x + l1aw * percentWidth, mLine1aLetters.left_letter_center_point().y + average_height * 1.25),
            cv::Point(bl.x - l1aw * percentWidth, mLine1aLetters.left_letter_center_point().y + average_height * 1.25) } );
    }


    // bottom line
    mMrzVertices.push_back( {
        
        cv::Point(bl.x - l1aw * percentWidth, bl.y - l1ah * percentHeight),
        cv::Point(br.x + l0aw * percentWidth, br.y - l1ah * percentHeight),
        cv::Point(br.x + l1aw * percentWidth, br.y + l1ah * percentHeight),
        cv::Point(bl.x - l1aw * percentWidth, bl.y + l1ah * percentHeight) } );

//    // OLD pulling out a region for all of the lines
//    //		mMrzVertices = new MatOfPoint2f(new Point(tl.x - l0aw * percentWidth, tl.y - l0ah * percentHeight), new Point(tr.x + l0aw
//    //				* percentWidth, tr.y - l0ah * percentHeight), new Point(br.x + l1aw * percentWidth, br.y + l1ah * percentHeight),
//    //				new Point(bl.x - l1aw * percentWidth, bl.y + l1ah * percentHeight));
    
    return true;
}

bool MRZDetector::lineRatiosOkay() {

    double ratio = 1.0 * mLine0Letters.size() / mLine1Letters.size();
    ratio = ratio <= 1.0 ? ratio : 1. / ratio;
    std::cout << "line0 and line1 ratio : "<< ratio << std::endl;
    if (ratio < 0.50)
        return false;
    
    ratio = 1.0 * mLine1aLetters.size() / mLine1Letters.size();
    ratio = ratio <= 1.0 ? ratio : 1. / ratio;
    std::cout << "line1 and line1a ratio : "<< ratio << std::endl;
    if (mMrzLines == 3 && ratio < 0.50)
        return false;
    
    return true;
}

std::vector<int> MRZDetector::filterLines(const std::vector<cv::Vec2f> &lines, double minAngle, double maxAngle, int yoffset){

    std::vector<int> filtered;
    
    for (auto rhoTheta : lines) {
        
        double rho = rhoTheta[0];
        double theta = rhoTheta[1];
        
        if (fabs(theta) > maxAngle || fabs(theta) < minAngle)
            continue;
        
        double a = cos(theta);
        double b = sin(theta);
        
        double y0 = b * rho;
        
        double y1 = (int) (y0 + 500 * (a)) + yoffset;
        double y2 = (int) (y0 - 1000 * (a)) + yoffset;
        
        filtered.push_back((int) ((y1 + y2) / 2.0));
    }
    
    // sort the lines in descending order
    std::sort(filtered.begin(), filtered.end());
    std::reverse(filtered.begin(), filtered.end());
    
    // the idea is to combine lines that are not too different from their
    // neighbor
    std::vector<int> distinct;
    
    for (int y : filtered) {
        if (distinct.size() == 0) {
            distinct.push_back(y);
        } else {
            if (std::fabs(*distinct.rbegin() - y) <= 20) { // TODO was 30 - can we use a percentage?
                int avg = (int) ((y + *distinct.rbegin()) / 2.0);
                distinct[distinct.size() - 1] = avg;
            } else
                distinct.push_back(y);
        }
    }
    
    return distinct;
}

void MRZDetector::setNumMrzLines(int lines){
    if (lines >= 2){
        mMrzLines = lines;
    }
}