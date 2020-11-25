//
//  FingerDetectionViewController.m
//  appit-ios
//
//  Created by  on 09/11/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import "FingerDetectionViewController2.h"
#import "FingerRect2.h"
#import "ImageUtils.h"
#import "NSStringUtils.h"
#import "NSLogUtils.h"
#import "FingerPreviewViewController.h"

@interface FingerDetectionViewController2 ()

@property cv::Mat matCameraFrame;

@property int good_frames_threshold, frameResize, frameResizeCapture;
@property int camera_width, camera_height, goodFrames;
@property BOOL debug_mode, takePictureCalled, find_only, leftHandCaptured, rightHandCaptured, currentHandLeft, checkHand, fingerTipDetectionStarted , hasCameraPermission;

@end

@implementation FingerDetectionViewController2{
    UIImage *snapShot1, *snapShot2, *snapShot3, *snapShot4;
    UILabel *focusMsgUILabel, *handMsgUILabel;
    NSMutableArray *fingers, *fingerTips;
    NSString *completeFocusB, *babyFocusA, *ringFocusA, *indexFocusA, *middleFocusA;
    int powerdByLabel_iphoneXPadd;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    powerdByLabel_iphoneXPadd = 0;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        switch (height) {
            case 2436:
                //"iPhone X"
                powerdByLabel_iphoneXPadd = 25;
                break;
            case 2688:
                //iPhoneXMAx
                powerdByLabel_iphoneXPadd = 25;
                break;
            case 1792:
                powerdByLabel_iphoneXPadd = 25;
                break;
            default:
                printf("unknown");
        }
    }
    [self initVariables];
    
    //Back Camera
    self.camera=0;
    self.torchOn=true;
    self.captureGrayscale = YES;
    self.qualityPreset = AVCaptureSessionPresetMedium;
    
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
    NSString *backCancelIcon = [frameworkBundle pathForResource:@"back_cancel_arrow" ofType:@"png"];
    
    int viewHeight = self.view.bounds.size.height;
    int viewWidth = self.view.bounds.size.width;
    
    //powered by label
    NSString *poweredByCn = @"powered_by_idmission";
    CGSize poweredBySize = [NSLogUtils getUILabelSizeFromLabel:poweredByCn size:10];
    //        CGRect poweredByLabelRect = CGRectMake(0,
    //                                               viewHeight - 11,
    //                                               viewWidth,
    //                                               10);
    CGRect poweredByLabelRect = CGRectMake(viewWidth - poweredBySize.width - powerdByLabel_iphoneXPadd,
                                           viewHeight - 11,
                                           poweredBySize.width,
                                           10);
    UILabel *poweredByLabel = [[UILabel alloc] initWithFrame:poweredByLabelRect];
    [poweredByLabel setNumberOfLines:0];
    [poweredByLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [poweredByLabel setTextAlignment:NSTextAlignmentRight];
    [poweredByLabel setText:poweredByCn];
    [poweredByLabel setTextColor:[UIColor whiteColor]];
    [poweredByLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [self.view addSubview:poweredByLabel];
    
    UIButton *backCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backCancelButton setImage:[UIImage imageNamed:backCancelIcon] forState:UIControlStateNormal];
    [backCancelButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:255]];
    [backCancelButton addTarget:self action:@selector(back_cancel:) forControlEvents:UIControlEventTouchUpInside];
    backCancelButton.frame = CGRectMake(0, 0, 50, 50);
    [self.view addSubview:backCancelButton];
    
    //Adding hint label-Start
    CGRect handMsgUILabelRect = CGRectMake(viewWidth/2 - 100/2, 0 , 100, 20);
    handMsgUILabel = [[UILabel alloc] initWithFrame:handMsgUILabelRect];
    [handMsgUILabel setNumberOfLines:0];
    [handMsgUILabel setLineBreakMode:NSLineBreakByWordWrapping];
    [handMsgUILabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:handMsgUILabel];
    
    CGRect focusMsgUILabelRect = CGRectMake(10, 55 ,viewWidth-20,50);
    focusMsgUILabel = [[UILabel alloc] initWithFrame:focusMsgUILabelRect];
    [focusMsgUILabel setNumberOfLines:0];
    [focusMsgUILabel setLineBreakMode:NSLineBreakByWordWrapping];
    [focusMsgUILabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:focusMsgUILabel];
    //Adding hint label-End
    
    //Update text style-Start
    [NSStringUtils setLabelStyle:handMsgUILabel];
    [NSStringUtils setLabelStyle:focusMsgUILabel];
    
}

- (void)back_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(nil != _delegate){
        [_delegate fingerDetectionResponse:_resultDictionary];
    }
}

- (void)initVariables
{
    if(0==_focus_threshold){
        _focus_threshold = 20;
    }
    
    if(![NSStringUtils stringIsNilOrEmpty:_good_frames]){
        _good_frames_threshold = [_good_frames intValue];
    }else{
        _good_frames_threshold = 7;
    }
    
    if(_init){
        _init=false;
        _resultDictionary = [NSMutableDictionary new];
        _leftHandCaptured=false;
        _rightHandCaptured=false;
    }
    
    _frameResize=8;
    _frameResizeCapture=2;
    _camera_width = 0;
    _camera_height = 0;
    _goodFrames=0;
    _debug_mode = false;
    _takePictureCalled=false;
    _find_only=false;
    _currentHandLeft=true;
    _checkHand=false;
    _fingerTipDetectionStarted = false;
    _hasCameraPermission = false;
    completeFocusB=@"0";
    babyFocusA=@"0";
    ringFocusA=@"0";
    indexFocusA=@"0";
    middleFocusA=@"0";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)processFrame:(cv::Mat &)bgraMat videoRect:(CGRect)rect videoOrientation:(AVCaptureVideoOrientation)videOrientation actualImage:(UIImage*)actualImage
{
    videOrientation = AVCaptureVideoOrientationPortrait;
    cv::transpose(bgraMat, bgraMat);
    cv::flip(bgraMat, bgraMat, 1);
    
    if(!_takePictureCalled){
        _matCameraFrame = bgraMat.clone();
        
        cv::Mat smallMat;
        
        _frameResize = bgraMat.rows/480;
        cv::resize(bgraMat, smallMat, cv::Size(bgraMat.cols/_frameResize, bgraMat.rows/_frameResize));
        
        cv::Mat smallMatClone = smallMat.clone();
        int focus = [self getFocusScore:smallMat]*1.2;
        completeFocusB = @(focus).stringValue;
        NSString *good_frames_string = @(_goodFrames).stringValue;
        
        [self updateFocus:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",
                           @"Focus: ", ([NSStringUtils stringIsNilOrEmpty: completeFocusB]) ? @"0" : completeFocusB,
                           @" Index: ", ([NSStringUtils stringIsNilOrEmpty: indexFocusA]) ? @"0" : indexFocusA,
                           @" Middle: ", ([NSStringUtils stringIsNilOrEmpty: middleFocusA]) ? @"0" : middleFocusA,
                           @" Ring: ", ([NSStringUtils stringIsNilOrEmpty: ringFocusA]) ? @"0" : ringFocusA,
                           @" Baby: ", ([NSStringUtils stringIsNilOrEmpty: babyFocusA]) ? @"0" : babyFocusA,
                           @" Good Frames: ", ([NSStringUtils stringIsNilOrEmpty: good_frames_string]) ? @"0" : good_frames_string]];
        
        if(focus>_focus_threshold){
            
            cv::Mat greySmallMat;
            cv::cvtColor(smallMatClone, greySmallMat, cv::COLOR_BGR2GRAY);
            
            cv::GaussianBlur(greySmallMat, greySmallMat, cv::Size(11, 11), 0);
            cv::adaptiveThreshold(greySmallMat, greySmallMat, 255, cv::ADAPTIVE_THRESH_MEAN_C,
                                  cv::THRESH_BINARY, 11, 1);
            
            _checkHand=false;
            fingers = [[NSMutableArray alloc] init];
            fingerTips = [[NSMutableArray alloc] init];
            
            //TODO
            int finger_width = greySmallMat.cols;
            int max_finger_width = greySmallMat.cols*0.9;
            int min_finger_width = greySmallMat.cols*0.3;
            int finger_height = greySmallMat.rows;
            int max_finger_height = (int)(finger_height/4);
            int min_finger_height = (int)(finger_height/12);
            
            std::vector<std::vector<cv::Point>> contours;
            cv::Mat hierarchy;
            cv::findContours(greySmallMat, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_NONE);
            if (contours.size()>0) {
                for(std::vector<cv::Point> cnt : contours){
                    double area = cv::contourArea(cnt);
                    if(area>(min_finger_height*min_finger_width)){
                        cv::Rect r =boundingRect(cnt);
                        if(!(r.tl().x<5 && r.tl().y<5 && r.br().x>greySmallMat.cols*0.9 && r.br().y>max_finger_height)){
                            
                            if(((r.br().y-r.tl().y)<max_finger_height) && ((r.br().y-r.tl().y)>min_finger_height)
                               && ((r.br().x-r.tl().x)>min_finger_width)&& ((r.br().x-r.tl().x)<max_finger_width)) {
                                
                                if (!_checkHand) {
                                    if (finger_width-r.br().x<5 && r.tl().x < finger_width*0.95) {
                                        _currentHandLeft = false;
                                        _checkHand = true;
                                    } else if (r.tl().x<5 && r.br().x > finger_width*0.05) {
                                        _currentHandLeft = true;
                                        _checkHand = true;
                                    }
                                }
                                
                                std::vector<cv::Point> cntA;
                                for(cv::Point pt : cnt){
                                    cv::Point ptA = cv::Point(pt.x*_frameResize, pt.y*_frameResize);
                                    cntA.push_back(ptA);
                                }
                                
                                FingerRect2 *fr = [[FingerRect2 alloc] initWithTopLeftX: r.tl().x * _frameResize andTopLeftY: r.tl().y * _frameResize andBottomRightX: r.br().x * _frameResize andBottomRightY: r.br().y * _frameResize andContourMain: cntA];
                                
                                [fingers addObject: fr];
                            }
                        }
                    }
                }
            }
            
            [self updateHand:[NSString stringWithFormat:@"%@", (_currentHandLeft) ? @"LEFT" : @"RIGHT"]];
            
            NSMutableArray *sortedFingersSize = [[NSMutableArray alloc] init];
            NSMutableArray *sortedFingersSize2;
            if([fingers count]>4){
                sortedFingersSize = [fingers sortedArrayUsingComparator:^NSComparisonResult(FingerRect2 *obj1, FingerRect2 *obj2) {
                    double area1 = (obj1.bottomRightX - obj1.topLeftX) * (obj1.bottomRightY - obj1.topLeftY);
                    double area2 = (obj2.bottomRightX - obj2.topLeftX) * (obj2.bottomRightY - obj2.topLeftY);
                    if (area1 > area2) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    
                    if (area1 < area2) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                sortedFingersSize2 = [[NSMutableArray alloc]initWithArray:sortedFingersSize];
                int numOfObjectsToRemove = [sortedFingersSize2 count] - 4;
                [sortedFingersSize2 removeObjectsInRange:NSMakeRange(4, numOfObjectsToRemove)];
            }
            
            if([sortedFingersSize2 count]==4){
                fingers = [[NSMutableArray alloc]initWithArray:sortedFingersSize2];
            }
            
            NSMutableArray *sortedFingersLocation = [fingers sortedArrayUsingComparator:^NSComparisonResult(FingerRect2 *obj1, FingerRect2 *obj2) {
                double topLeftX1 = obj1.topLeftY;
                double topLeftX2 = obj2.topLeftY;
                if (topLeftX1 > topLeftX2) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if (topLeftX1 < topLeftX2) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            
            if([sortedFingersLocation count]==4) {
                int smallestFocusScore=999;
                cv::Point tl_tip, br_tip;
                for (int i = 0; i < [sortedFingersLocation count]; i++) {
                    FingerRect2 *fr = [sortedFingersLocation objectAtIndex: i];
                    cv::Point tl = cv::Point([fr getTopLeftX], [fr getTopLeftY]);
                    cv::Point br = cv::Point([fr getBottomRightX], [fr getBottomRightY]);
                    
                    double fingerRectWidth = br.y - tl.y,
                    percentFingerRectWidth = fingerRectWidth*0.15;
                    
                    if(_currentHandLeft){
                        double tl_br_x = br.x - fingerRectWidth - percentFingerRectWidth;
                        if(tl_br_x<0){
                            tl_br_x = 0;
                        }
                        
                        double br_br_x = br.x + (fingerRectWidth * 0.1);
                        if(br_br_x>bgraMat.cols){
                            tl_br_x = bgraMat.cols;
                        }
                        
                        tl_tip = cv::Point(tl_br_x, tl.y); //TOD0 <0 then 0
                        br_tip = cv::Point(br_br_x, br.y);
                    }else{
                        double tl_tl_x = tl.x - (fingerRectWidth * 0.1);
                        if(tl_tl_x<0){
                            tl_tl_x = 0;
                        }
                        
                        double br_tl_x = tl.x + fingerRectWidth + percentFingerRectWidth;
                        if(br_tl_x>bgraMat.cols){
                            br_tl_x = bgraMat.cols;
                        }
                        
                        tl_tip = cv::Point(tl_tl_x, tl.y);
                        br_tip = cv::Point(tl.x + fingerRectWidth + percentFingerRectWidth, br.y);
                    }
                    
                    FingerRect2 *ffr = [[FingerRect2 alloc] initWithTopLeftX: tl_tip.x andTopLeftY: tl_tip.y andBottomRightX: br_tip.x andBottomRightY: br_tip.y andContourMain: [fr getContourMain]];
                    [fingerTips addObject: ffr];
                    
                    int focusScore = 0;
                    @try {
                        cv::Point tl_tip_small = cv::Point(tl_tip.x/_frameResize, tl_tip.y/_frameResize);
                        cv::Point br_tip_small = cv::Point(br_tip.x/_frameResize, br_tip.y/_frameResize);
                        cv::Rect rect = cv::Rect(tl_tip_small, br_tip_small);
                        bool is_inside = (rect & cv::Rect(0, 0, smallMatClone.cols, smallMatClone.rows)) == rect;
                        if(is_inside){
                            cv::Mat fingerMatToCheck = cv::Mat(smallMatClone, rect);
                            focusScore = [self getFocusScore:fingerMatToCheck];
                        }
                    }@catch(NSException *exception){
                        NSLog(@"%@", exception.reason);
                        focusScore = 0;
                    }
                    
                    if (i == 0) {
                        indexFocusA=@(focusScore).stringValue;
                    } else if (i == 1) {
                        middleFocusA=@(focusScore).stringValue;
                    } else if (i == 2) {
                        ringFocusA=@(focusScore).stringValue;
                    } else if (i == 3) {
                        babyFocusA=@(focusScore).stringValue;
                    }
                    
                    if(smallestFocusScore==999 || focusScore<smallestFocusScore){
                        smallestFocusScore=focusScore;
                    }
                    
                    good_frames_string = @(_goodFrames).stringValue;
                    [self updateFocus:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",
                                       @"Focus: ", ([NSStringUtils stringIsNilOrEmpty: completeFocusB]) ? @"0" : completeFocusB,
                                       @" Index: ", ([NSStringUtils stringIsNilOrEmpty: indexFocusA]) ? @"0" : indexFocusA,
                                       @" Middle: ", ([NSStringUtils stringIsNilOrEmpty: middleFocusA]) ? @"0" : middleFocusA,
                                       @" Ring: ", ([NSStringUtils stringIsNilOrEmpty: ringFocusA]) ? @"0" : ringFocusA,
                                       @" Baby: ", ([NSStringUtils stringIsNilOrEmpty: babyFocusA]) ? @"0" : babyFocusA,
                                       @" Good Frames: ", ([NSStringUtils stringIsNilOrEmpty: good_frames_string]) ? @"0" : good_frames_string]];
                    
                    if(focusScore>_focus_threshold){
                        cv::rectangle(bgraMat, cv::Point(tl_tip.x, tl_tip.y), cv::Point(br_tip.x, br_tip.y), cv::Scalar(255, 255, 255), cv::LINE_AA);
                    }
                }
                
                if(smallestFocusScore>_focus_threshold){
                    _goodFrames++;
                    if(_goodFrames==_good_frames_threshold){
                        _takePictureCalled = true;
                        [self captureFingerprint];
                        [self performSelectorOnMainThread:@selector(exitFromFingerDetectionScreen) withObject:self waitUntilDone:FALSE];
                    }else{
                        [NSThread sleepForTimeInterval:.2];
                    }
                }else{
                    _goodFrames = 0;
                }
            }else{
                _goodFrames = 0;
            }
            
        }else{
            _goodFrames = 0;
        }
    }
    
}

-(void)exitFromFingerDetectionScreen{
    [self dismissViewControllerAnimated:NO completion:^{
        FingerPreviewViewController *previewController = [FingerPreviewViewController new];
        previewController.preview_image_1 = snapShot1;
        previewController.preview_image_2 = snapShot2;
        previewController.preview_image_3 = snapShot3;
        previewController.preview_image_4 = snapShot4;
        previewController.resultDictionary = _resultDictionary;
        previewController.delegate = _delegate;
        previewController.focus_threshold = _focus_threshold;
        previewController.leftHandCaptured = _leftHandCaptured;
        previewController.rightHandCaptured = _rightHandCaptured;
        previewController.currentHandLeft = _currentHandLeft;
        
        //Call preview with caller app instance as we need to dismiss this view
        previewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [_delegate presentViewController:previewController animated:YES completion:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    if(nil != _delegate){
    //        [_delegate fingerDetectionResponse:fingerprints];
    //    }
}

-(void)captureFingerprint{
    if(_currentHandLeft){
        _leftHandCaptured=true;
        [_resultDictionary removeObjectForKey:@"LIFINGER"];
        [_resultDictionary removeObjectForKey:@"LMFINGER"];
        [_resultDictionary removeObjectForKey:@"LRFINGER"];
        [_resultDictionary removeObjectForKey:@"LLFINGER"];
    }else{
        [_resultDictionary removeObjectForKey:@"RIFINGER"];
        [_resultDictionary removeObjectForKey:@"RMFINGER"];
        [_resultDictionary removeObjectForKey:@"RRFINGER"];
        [_resultDictionary removeObjectForKey:@"RLFINGER"];
    }
    //    UIImage *fingerprintImage000 = [ImageUtils UIImageFromCVMat:_matCameraFrame convert_color:true];
    for (int i = 0; i < [fingerTips count]; i++) {
        FingerRect2 *fr = [fingerTips objectAtIndex: i];
        
        cv::Mat mask = cv::Mat::zeros(_matCameraFrame.size(), CV_8UC1);
        
        std::vector<std::vector<cv::Point>> contourList;
        contourList.push_back([fr getContourMain]);
//        drawContours(mask, contourList, 0, cv::Scalar(255), CV_FILLED);
        drawContours(mask, contourList, 0, cv::Scalar(255), -1);
        
        //         UIImage *fingerprintImage001 = [ImageUtils UIImageFromCVMat:mask convert_color:false];
        
        cv::Mat masked = cv::Mat();
        _matCameraFrame.copyTo(masked, mask);
        
        //        UIImage *fingerprintImage0 = [ImageUtils UIImageFromCVMat:masked convert_color:true];
        
        cv::Point tl_tip = cv::Point([fr getTopLeftX], [fr getTopLeftY]);
        cv::Point br_tip = cv::Point([fr getBottomRightX], [fr getBottomRightY]);
        cv::Rect roi = cv::Rect(tl_tip, br_tip);
        cv::Mat fingerTipMatCropped = cv::Mat(masked, roi);
        
        //        UIImage *fingerprintImage03 = [ImageUtils UIImageFromCVMat:fingerTipMatCropped convert_color:true];
        
        cv::Mat flippedMat = cv::Mat(cv::Size(fingerTipMatCropped.cols, fingerTipMatCropped.rows), CV_8UC1);
        cv::flip(fingerTipMatCropped, flippedMat, 1);
        
        UIImage *fingerprintImage01 = [ImageUtils UIImageFromCVMat:flippedMat convert_color:true];
        
        cv::Mat inverseColourMat = cv::Mat();
        cv::bitwise_not(flippedMat, inverseColourMat);
        
        //UIImage *fingerprintImage02 = [ImageUtils UIImageFromCVMat:inverseColourMat convert_color:true];
        
        cv::Mat sharpenedMat = inverseColourMat.clone();//[self sharpenMat:fingerTipMatCropped];
        //        cv::Mat sharpenedMat = [self sharpenMat:inverseColourMat];
        //UIImage *fingerprintImage044 = [ImageUtils UIImageFromCVMat:sharpenedMat convert_color:false];
        
        cv::Mat greyMat = cv::Mat();
        cv::cvtColor(sharpenedMat, greyMat, cv::COLOR_RGBA2GRAY);
        
        //UIImage *fingerprintImage04 = [ImageUtils UIImageFromCVMat:greyMat convert_color:false];
        
        cv::Mat fingerTipMatProcessed = cv::Mat();
        cv::adaptiveThreshold(greyMat, fingerTipMatProcessed, 255, cv::ADAPTIVE_THRESH_MEAN_C,
                              cv::THRESH_BINARY, 15, 1);
        
        //UIImage *fingerprintImage05 = [ImageUtils UIImageFromCVMat:fingerTipMatProcessed convert_color:false];
        
        cv::transpose(fingerTipMatProcessed, fingerTipMatProcessed);
        if(_currentHandLeft){
            cv::flip(fingerTipMatProcessed, fingerTipMatProcessed, 1);
        }else{
            cv::flip(fingerTipMatProcessed, fingerTipMatProcessed, 0);
        }
        
        cv::Mat resizedMat = fingerTipMatProcessed.clone();
        double width = fingerTipMatProcessed.cols;
        double height = fingerTipMatProcessed.rows;
        if(height<510){
            double aspectRatio = 550/height;
            cv::resize(fingerTipMatProcessed, resizedMat, cv::Size(width*aspectRatio, 550));
        }
        
        UIImage *fingerprintImage = [ImageUtils UIImageFromCVMat:resizedMat convert_color:false];
        NSData *imageData = UIImageJPEGRepresentation(fingerprintImage, 0.9);
        NSString *base64 = [imageData base64EncodedStringWithOptions:0];
        
        if(_currentHandLeft){
            _leftHandCaptured=true;
            if(i==0){
                snapShot1 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"LIFINGER"];
            }else if(i==1){
                snapShot2 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"LMFINGER"];
            }else if(i==2){
                snapShot3 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"LRFINGER"];
            }else if(i==3){
                snapShot4 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"LLFINGER"];
            }
        }else{
            _rightHandCaptured=true;
            if(i==0){
                snapShot1 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"RIFINGER"];
            }else if(i==1){
                snapShot2 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"RMFINGER"];
            }else if(i==2){
                snapShot3 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"RRFINGER"];
            }else if(i==3){
                snapShot4 = fingerprintImage;
                [_resultDictionary setObject:base64  forKey:@"RLFINGER"];
            }
        }
    }
    
}

-(void)updateFocus:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        [focusMsgUILabel setText:status];
    });
}

-(void)updateHand:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        [handMsgUILabel setText:status];
    });
}

- (cv::Mat)sharpenMat:(cv::Mat)im{
    cv::Mat kernel = cv::Mat::zeros(cv::Size(9, 9), CV_32FC1);
    kernel.at<cv::Vec3b>(4,4)[0] = 2.0f;
    //    kernel.put (4, 4, float { 2.0f });
    
    cv::Mat boxfilter = cv::Mat::ones(cv::Size(9, 9), CV_32FC1);
    cv::divide(1/81.0, boxfilter, boxfilter);
    cv::subtract(kernel, boxfilter, kernel);
    
    cv::Mat colorMat2 = cv::Mat();
    @try {
        cv::filter2D(im, colorMat2, -1, kernel);
    }@catch(NSException *e){
        colorMat2 = im;
    }
    
    return colorMat2;
}

- (int)getFocusScore:(cv::Mat)im{
    cv::Mat resizedMat;
    cv::Mat hsv;
    std::vector<cv::Mat> channels;
    
    cv::resize(im, resizedMat, cv::Size(), 0.25, 0.25, cv::INTER_LINEAR);
    im.release();
    cv::cvtColor(resizedMat, hsv, cv::COLOR_RGB2HSV_FULL);
    resizedMat.release();
    cv::split(hsv, channels);
    hsv.release();
    int focusScore = [self getFocusScoreFromChannel:channels[2]];
    return focusScore;
}

-(int)getFocusScoreFromChannel:(cv::Mat&)channel{
    assert(channel.channels() == 1);
    assert(channel.depth() == CV_8U);
    
    cv::Mat sobel_image;
    cv::Sobel(channel, sobel_image, CV_16S, 1, 1);
    
    //    cv::Mat r = cv::abs(sobel_image);
    cv::Mat r;
    cv::absdiff(sobel_image, cv::Scalar(0), r);
    cv::Scalar meanScalar,devScalar;
    
    cv::meanStdDev(r, meanScalar, devScalar);
    return devScalar[0];
}

@end
