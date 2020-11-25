//
//  OpenCvViewController.m
//  appit-ios
//
//  Created by Goran Rauker on 2/2/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import "AppDelegate.h"
#import "DocumentTemplateFactory.h"
#import "ImageUtils.h"
#import "OpenCvViewControllerAppit.h"
#import "ViewController.h"
#import "CommonUtils.h"
#import "NSStringUtils.h"
#import "UIColor+fromHex.h"

#include <atomic>
#include "BestOfDocumentMatcher.h"
#include "CardDetector.h"
#include "DataExtractor.h"
#include "Document.h"
#include "DocumentMatcher.h"
#include "FaceDetector.h"
#include "fileutil.h"
#include "ImageBuffer.h"
#include <opencv2/imgproc/imgproc.hpp>
#include "SecurityCheckComponent.h"
#include "SecurityCheckMatcher.h"
#include "TextExtractor.h"
#include <tesseract/baseapi.h>


//const float MinImageIntensity = 125;
//const float MinImageFocusScore = 10;
//const size_t ImagesToConsume = 3;
//const size_t ImagesToInsert = 4;

@interface OpenCvViewControllerAppit ()
- (void)setupAVCapture;
- (void)teardownAVCapture;
@end

@implementation OpenCvViewControllerAppit {

    std::shared_ptr<ImageBuffer> image_buffer;
    AVCaptureSession *session;
    CGRect rootViewRect;

    BestOfDocumentMatcher bestOf;
    std::shared_ptr<Document> document;
    std::shared_ptr<DataExtractor> data_extractor_0;
    std::shared_ptr<DataExtractor> data_extractor_1;
    std::shared_ptr<DataExtractor> data_extractor_2;
    std::string doc_name;
    
    NSThread *thread;
    NSThread *thread1;
    NSThread *thread2;
    
    std::atomic<float> image_intensity;
    std::atomic<float> image_focus_score;
    std::atomic<float> image_glare_score;
    std::atomic<size_t> num_images_processed;

    cv::Mat image_result;
    cv::Mat processed_image;
    cv::Mat face_image;
    
    BOOL isLandscapeMode;
    
    NSBundle * frameworkBundle;
    bool isiPhoneX;
    
    }

@synthesize launchedFromApp = _launchedFromApp;
@synthesize responseUrl = _responseUrl;
@synthesize currentTemplateLocation;


-(void)dealloc {
    std::cout << "dealloc" << std::endl;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // everything depends on the document, so let's make sure we have one loaded.
    //bestOf.documents.push_back([DocumentTemplateFactory create_colorado_id]);
    //bestOf.documents.push_back([DocumentTemplateFactory create_ozo]);
    //bestOf.documents.push_back([DocumentTemplateFactory create_temp_passport]);
    
    //iterate home/doc directory to read templates
    
    isiPhoneX = false;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        
        switch (height) {
            case 2436:
                //"iPhone X"
                isiPhoneX = true;
                break;
            default:
                printf("unknown");
        }
    }
    
    frameworkBundle = [NSBundle mainBundle];
    
    targetRectangle.line_width = 10.0f;
    
    targetRectangle.id_outline_color = _id_outline_color;
    targetRectangle.id_outline_color_alpha = _id_outline_color_alpha;
    targetRectangle.id_outline_outside_color = _id_outline_outside_color;
    targetRectangle.id_outline_outside_alpha = _id_outline_outside_color_alpha;
    targetRectangle.detected_id_outline_color = _detected_id_outline_color;
    targetRectangle.detected_id_outline_color_alpha = _detected_id_outline_color_alpha;
    targetRectangle.detected_id_outline_outside_color = _detected_id_outline_outside_color;
    targetRectangle.detected_id_outline_outside_alpha = _detected_id_outline_outside_color_alpha;
    
    [backPortraitButton setTintColor:[UIColor colorwithHexString:_id_outline_color alpha:_id_outline_color_alpha]];
    
    [backButton setTintColor:[UIColor colorwithHexString:_id_outline_color alpha:_id_outline_color_alpha]];
    
    
    NSString* templateDirPath = currentTemplateLocation;
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:templateDirPath error:Nil];
    NSArray* xmlFiles = [dirs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.xml'"]];
    NSString* templateFilePath = @"";
    NSArray* templateIdArray = [_template_ids componentsSeparatedByString:@","];
    int templateIDCount = [templateIdArray count];
    
    if(templateIDCount == 1 && [CommonUtils isEmpty:templateIdArray[0]]){
        templateIDCount = 0;
    }
    
    if (templateIDCount > 0) {
        for (NSString* templateId in templateIdArray) {
            for (NSString *xmlFileName in xmlFiles) {
                NSString* templateIdFileName = [NSString stringWithFormat:@"%@%@", templateId,@".xml"];
                if ([templateIdFileName isEqualToString:xmlFileName]) {
                    templateFilePath = [NSString stringWithFormat:@"%@%@%@", templateDirPath, @"/",xmlFileName];
                    bestOf.documents.push_back([DocumentTemplateFactory load_document_template:templateFilePath]);
                    break;
                }
            }
        }
    }else {
        for (NSString *xmlFileName in xmlFiles) {
            templateFilePath = [NSString stringWithFormat:@"%@%@%@", templateDirPath, @"/",xmlFileName];
            bestOf.documents.push_back([DocumentTemplateFactory load_document_template:templateFilePath]);
        }
    }
    
  //MA
    //templateFilePath = [NSString stringWithFormat:@"%@%@%@", templateDirPath, @"/",@"290.xml"];
    document = [DocumentTemplateFactory load_document_template:templateFilePath];
//    while (document == nil) {
//        NSLog(@"Document not loaded. Loading again.");
//        document = [DocumentTemplateFactory load_document_template:templateFilePath];
//    }

//    if(nil == document && _launchedFromApp){
//        [self exitFromImageProcessingScreen:@"101"];//Template not found
//    }
    
    if(document == nil){ //Handling null pointer exception
        document = std::unique_ptr<Document>(new Document());
        document->_template_size = cv::Size(1170, 830);
        
        [self performSelectorOnMainThread:@selector(unwind_to_uiwebview_back) withObject:self waitUntilDone:FALSE];
    }
    
    if (templateIDCount == 1) {
        doc_name = document->name();
        [documentNameLabel setText:[NSString stringWithUTF8String:doc_name.c_str()] ];
    }

    /*if ([[NSFileManager defaultManager] fileExistsAtPath:_path_to_xml_template])
    {
        NSLog(@"File exists in BUNDLE");
    }
    else
    {
        NSLog(@"File not found");
    }*/
    
    // this is used by the AV capture, so make sure it is up and available ...
    image_buffer = std::shared_ptr<ImageBuffer>(new ImageBuffer(_ImagesToInsert));
    [self setupAVCapture]; // do after ImageBuffer creation
    
    CALayer *rootLayer = [baseView layer];
    rootViewRect = [rootLayer bounds];
    
    image_result = cv::Mat(5,5,CV_8UC3);

    textView.textAlignment = NSTextAlignmentCenter;
    
    //[self setup_data_extractors];
    [self initialize_threads];
    
    isLandscapeMode = YES;
    backPortraitButton.hidden=YES;
    rotateLandscapeButton.hidden=YES;
    if(_single_high_res_snapshot_mode == true){
        rotatePortraitButton.hidden=NO;
    }else{
        rotatePortraitButton.hidden=YES;
    }
    
    if(_single_high_res_snapshot_mode == true){
        if(_enable_capture_button){
            [self enableButton];
        }else{
            [captureButton setHidden:true];
            [NSTimer scheduledTimerWithTimeInterval:_enable_capture_button_time
                                             target:self
                                           selector:@selector(enableButton)
                                           userInfo:nil
                                            repeats:NO];
        }
    }else{
        [captureButton setHidden:true];
    }
    
    //Setting text_view style -Start
    [NSStringUtils setLabelStyle:documentNameLabel];
    [NSStringUtils setLabelStyle:textView];
    [NSStringUtils setLabelStyle:intensityAndFocusTextView];
    //Setting text_view style -End
}

-(void)enableButton{
    [captureButton setHidden:false];
    [textView setHidden:true];
}

- (void)setupAVCapture
{
    NSError *error = nil;
    
    session = [AVCaptureSession new];

    if (UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPhone){
        session.sessionPreset = AVCaptureSessionPresetHigh;
    }else if(UI_USER_INTERFACE_IDIOM () == UIUserInterfaceIdiomPad){
        session.sessionPreset = AVCaptureSessionPresetPhoto;
    }else{
        NSLog(@"setupAVCapture : Unable to set sessionPreset");
    }
    
    // Select a video device, make an input
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device lockForConfiguration:&error];
    
    if([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    
    [device unlockForConfiguration];
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    // add the input to the session
    if ( [session canAddInput:deviceInput] ){
        [session addInput:deviceInput];
    }
    
    
    // Make a video data output
    videoDataOutput = [AVCaptureVideoDataOutput new];
    
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES]; // discard if the data output queue is blocked (as we process the still image)
    
    // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
    // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
    // see the header doc for setSampleBufferDelegate:queue: for more information
    videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ( [session canAddOutput:videoDataOutput] ){
        [session addOutput:videoDataOutput];
    }
    
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    
    CALayer *rootLayer = [previewView layer];
    [rootLayer addSublayer:previewLayer];
    [session startRunning];
}

// clean up capture setup
- (void)teardownAVCapture
{
    [session removeOutput:videoDataOutput];
    [session stopRunning];
    [previewLayer removeFromSuperlayer];
}

-(void)initialize_threads {
    
    thread = [[NSThread alloc]
              initWithTarget:self
              selector:@selector(image_consumer:)
              object:[NSNumber numberWithInt:0]];
    [thread start];
    
    thread1 = [[NSThread alloc]
               initWithTarget:self
               selector:@selector(image_consumer:)
               object:[NSNumber numberWithInt:1]];
    [thread1 start];

    thread2 = [[NSThread alloc]
               initWithTarget:self
               selector:@selector(image_consumer:)
               object:[NSNumber numberWithInt:2]];
    [thread2 start];
}

-(void)setup_data_extractors {
    
    // use the tess data path that was setup from the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    tesseract::TessBaseAPI *tesseract0 = (tesseract::TessBaseAPI *)[appDelegate tesseract0];
    tesseract::TessBaseAPI *tesseract1 = (tesseract::TessBaseAPI *)[appDelegate tesseract1];
    tesseract::TessBaseAPI *tesseract2 = (tesseract::TessBaseAPI *)[appDelegate tesseract2];
    
    NSString *tess_data_path = appDelegate.tess_data_path;
    
    num_images_processed = 0;
    
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"lbpcascade_frontalface" ofType:@"xml" inDirectory:@"/opencvdata"];
    
    
    data_extractor_0 = std::shared_ptr<DataExtractor>(new DataExtractor(*document,
                                                                        *tesseract0,
                                                                        [faceCascadePath UTF8String],
                                                                        num_images_processed,
                                                                        [tess_data_path UTF8String],
                                                                        _ImagesToConsume));
    
    data_extractor_1 = std::shared_ptr<DataExtractor>(new DataExtractor(*document,
                                                                        *tesseract1,
                                                                        [faceCascadePath UTF8String],
                                                                        num_images_processed,
                                                                        [tess_data_path UTF8String],
                                                                        _ImagesToConsume));

    data_extractor_2 = std::shared_ptr<DataExtractor>(new DataExtractor(*document,
                                                                        *tesseract2,
                                                                        [faceCascadePath UTF8String],
                                                                        num_images_processed,
                                                                        [tess_data_path UTF8String],
                                                                        _ImagesToConsume));

}

- (void)image_consumer:(NSNumber*)identifier
{
    long this_identifier = [identifier integerValue];
    std::shared_ptr<DataExtractor> extractor;
//    if ( this_identifier == 0 && data_extractor_0 != nil ) extractor = data_extractor_0;
//    else if (this_identifier == 1 && data_extractor_1 != nil) extractor = data_extractor_1;
//    else if (this_identifier == 2 && data_extractor_2 != nil) extractor = data_extractor_2;
    
    NSThread *this_thread;
    if (this_identifier == 0) this_thread = thread;
    else if (this_identifier == 1) this_thread = thread1;
    else this_thread = thread2;
    
    // stop the thread if we are finished consuming
    while (!this_thread.isCancelled && num_images_processed < _ImagesToConsume && (extractor ==nil || !extractor->is_complete()) && image_buffer->consumed < _ImagesToInsert ) {

        auto image_data(image_buffer->next_image());
        
        if (image_data.first.empty() ) {
            usleep(100);
            continue;
        }
        
        if (extractor == nil) {
            [self setup_data_extractors];
            if ( this_identifier == 0 ) extractor = data_extractor_0;
            else if (this_identifier == 1 ) extractor = data_extractor_1;
            else extractor = data_extractor_2;
        }
        
        extractor->extract(image_data.first, image_data.second);
        //image_result = extractor->warped;
        processed_image = extractor->warped;
        if(processed_image.type() == 0){
            processed_image = image_result;
        }
        NSLog(@"Consumed: %d, Provided: %d, Processed: %d", (int)image_buffer->consumed.load(), (int)image_buffer->inserted.load(), (int)num_images_processed.load());
    }

    NSLog(@"The consumer thread (%ld) has finished", this_identifier);

    if (this_identifier == 0) thread = nil;
    else if (this_identifier == 1) thread1 = nil;
    else thread2 = nil;

    if (thread == nil && thread1 == nil && thread2 == nil){
        // notify the ui ...
        [self performSelectorOnMainThread:@selector(unwindToUIWebViewIfFinished) withObject:self waitUntilDone:FALSE];
    }
}

-(void)unwindToUIWebViewIfFinished{
    if (thread == nil && thread1 == nil && thread2 == nil){
        if(_launchedFromApp){
            [self exitFromImageProcessingScreen:@"0"];//Success code
        }else{
            [self performSegueWithIdentifier: @"Unwind To UIWebView" sender: self];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self teardownAVCapture];
    
    if (thread != nullptr)
        [thread cancel];
    
    if (thread1 != nullptr)
        [thread1 cancel];
    
    if (thread2 != nullptr)
        [thread2 cancel];
    
    image_buffer->clear();
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    CALayer *rootLayer = [baseView layer];
    rootViewRect = [rootLayer bounds];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:rootViewRect];

    // recalculate the roi for the change in the rootViewRect
    targetRectangle.roi = [self getSearchRoiForWidth:rootViewRect.size.width height:rootViewRect.size.height aspectRatio:document->aspect_ratio()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIImage *)snap {
    @synchronized(self) {
        document->draw_security_feature(document, processed_image);
        
        UIImage *image = [ImageUtils UIImageFromCVMat:processed_image convert_color:true];
        
        if(!isLandscapeMode){
            image = [ImageUtils rotatingUIImageByOrientation:image fromImageOrientation:UIImageOrientationRight];
        }
        return image;
    }
}

-(UIImage *)get_input_image {
    @synchronized(self) {
        
        UIImage *inputimage = [ImageUtils UIImageFromCVMat:image_result convert_color:true];
        
        if(!isLandscapeMode){
            inputimage = [ImageUtils rotatingUIImageByOrientation:inputimage fromImageOrientation:UIImageOrientationRight];
        }
        
        return inputimage;
    }
}

-(UIImage *)get_face_image {
    @synchronized(self) {
        //return [NSString stringWithUTF8String:document->get_face_image().c_str()];
        return [ImageUtils UIImageFromCVMat:document->get_face_image() convert_color:true];
    }
}


-(UIImage *)get_barcode_image {
    @synchronized(self) {
        return [ImageUtils UIImageFromCVMat:document->get_barcode_image() convert_color:true];
    }
}


-(UIImage *)get_mrz_image {
    @synchronized(self) {
        return [ImageUtils UIImageFromCVMat:document->get_mrz_image() convert_color:true];
    }
}

-(UIImage *)get_matched_template {
    @synchronized(self) {
        return [ImageUtils UIImageFromCVMat:document->_template_image convert_color:true];
    }
}

-(NSString*)summary_with_br_instead_of_new_line:(bool)br_instead_of_new_line {
    @synchronized(self) {
        if (data_extractor_0 == nullptr)
            return @"";
        
        return [NSString stringWithUTF8String:data_extractor_0->summary(br_instead_of_new_line).c_str()];
    }
}


-(NSString*)xml {
    @synchronized(self) {
        return [NSString stringWithUTF8String:document->to_xml().c_str()];
    }
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // we are done consuming data so get out quick
    if (image_buffer->inserted >= _ImagesToInsert){
//        [self setup_data_extractors];
//        [self initialize_threads];
        return;
    }
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    
    size_t bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
    size_t bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    cv::Mat bgra = cv::Mat((int)bufferHeight,(int)bufferWidth,CV_8UC4,pixel); //put buffer in open cv, no memory copied

    // the following is simply figuring out what part of the incoming Mat is shown on the screen
    auto ww = rootViewRect.size.width, wh = rootViewRect.size.height; // window width x height
    auto iw = bgra.cols, ih =bgra.rows; // Mat width x height
    auto sf = ww / iw; // scaling to fill aspect ratio
    
    auto /*iwp = iw * sf,*/ ihp = std::round(ih * sf); // width x height of the scaled image on the screen
    auto y0p = (ihp-wh) / 2.0f;
    auto y0 = y0p / sf; // offsets from top of image for screen image and incoming
    
    // produce image for the consumer thread ...
    if ( y0 >= 0 ) {
        
        @synchronized(self) {
            
            // crop out the image based on the overlay rectangle
            cv::Mat cropped( cv::Mat(bgra,cv::Rect(0,y0,iw,ih-2*y0)) );
            
            // determines the ROI that the image needs to be found in (controlled by AspectRatio)
            CGRect roi = [self getSearchRoiForWidth: cropped.cols height:cropped.rows aspectRatio: document->aspect_ratio()];
            
            // check requirements from CardDetector
            cv::Rect roiRect = cv::Rect(roi.origin.x,roi.origin.y,roi.size.width,roi.size.height);
            
            CardDetector d(cropped,4,_MinImageIntensity,_MinImageFocusScore, _enable_glare_detection, _glare_percentage_threshold, roiRect);
            
            image_intensity = d.intensity;
            image_focus_score = d.focus;
            image_glare_score = d.glare;
            
            if (d.focus > _MinImageFocusScore && doc_name.empty()) {
                auto doc = bestOf.findmatch(bgra, 4.0f);
                if (doc != nullptr) {
                    doc_name = doc->name();
                    document = doc;
                }
            }
            
            auto document_rect = d.get_document_rectangle(roiRect, isLandscapeMode);
            bool card_detected = (image_intensity > _MinImageIntensity && image_focus_score > _MinImageFocusScore && document_rect.area() > 0);
            
            if(_enable_glare_detection && image_glare_score>_glare_percentage_threshold){
                card_detected = false;
            }
            
            //If capture button is enable then disable auto-capture-feature and capture image only when user press capture button
            if(![captureButton isHidden]){
                if(_capturedImagePressed){
                    card_detected = true;
                }else{
                    card_detected = false;
                }
            }
            
            targetRectangle.has_document = card_detected;
            
            if (card_detected) {
                
                if (_single_high_res_snapshot_mode == true) {
                    image_result = bgra.clone();
//                    processed_image = cv::Mat(image_result,document_rect).clone();
                    processed_image = cv::Mat(image_result,roiRect).clone();
                    [self performSelectorOnMainThread:@selector(unwind_to_uiwebview) withObject:self waitUntilDone:FALSE];
                }
                else if (image_buffer->inserted < _ImagesToInsert) {
                    if(_capturedImagePressed){
                        image_buffer->set_image(cropped, roiRect);
                        image_result = cv::Mat(cropped, roiRect).clone();
                    }else{
                        image_buffer->set_image(cropped, document_rect);
                        image_result = cv::Mat(cropped,document_rect).clone();
                    }
                }

                 _capturedImagePressed = NO;
            }
            
            [targetRectangle.rects removeAllObjects];
            if([captureButton isHidden]){ //Disable rectangle drawing when capture button is enable
                for (auto r : d.potential_rois){
                    [targetRectangle.rects addObject:[NSValue valueWithCGRect:CGRectMake(r.x*sf, r.y*sf, r.width*sf, r.height*sf)] ];
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------
    // update UI
    [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:TRUE];
    
    // release pixel buffer
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
}

-(void) updateUI {
    
    // Once we have captured an ID - start to make changes to the UI
    if (image_buffer->inserted > 0) {
    
        [textView setText:(image_buffer->inserted < _ImagesToInsert ? @"Hold it steady." : @"")];
        //@"Processing - Please wait."
        
        [progressView setHidden:(image_buffer->inserted < _ImagesToInsert ? false : true)];
        [progressView setProgress:1.0f* image_buffer->inserted / (_ImagesToInsert-1)];
        
        if (activityIndicator.isAnimating == false && image_buffer->inserted >= _ImagesToInsert) {
            [activityIndicator startAnimating];
            [activityIndicator setHidden:YES];
            targetRectangle.draw_target_rectangle = false;
            [backButton setHidden:YES];
            [documentNameLabel setHidden:YES];
            [textView setHidden:YES];
            [intensityAndFocusTextView setHidden:YES];
            [captureButton setHidden:YES];
            [self updateProgessBarUI];

            // stop the capture session - save the cpu for processing
            if (session.isRunning)
                [session stopRunning];
        }
    }
    
    if(_enable_glare_detection){
        [intensityAndFocusTextView setText:[NSString stringWithFormat:@"Intensity: %.0f Focus: %.0f Glare: %.0f", image_intensity.load(), image_focus_score.load(), image_glare_score.load()] ];
    }else{
        [intensityAndFocusTextView setText:[NSString stringWithFormat:@"Intensity: %.0f Focus: %.0f", image_intensity.load(), image_focus_score.load()] ];
    }
    
    
    bool errorMsgDisplayed = false;
    if(image_intensity < _MinImageIntensity){
        [textView setText:@"It's too dark to take a good image. Find a place with better lighting"];
        errorMsgDisplayed = true;
    }
    if(image_focus_score < _MinImageFocusScore && !errorMsgDisplayed){
        [textView setText:@"Tap screen to focus or move camera closer/away"];
        errorMsgDisplayed = true;
    }
    if(_enable_glare_detection){
        if(image_glare_score > _glare_percentage_threshold && !errorMsgDisplayed){
            [textView setText:@"Too much light, move document away from direct light"];
            errorMsgDisplayed = true;
        }
    }
    if(!errorMsgDisplayed){
        [textView setText:@"Align document inside the green corners and wait, we'll take the photo for you"];
    }
    
    NSString *documentName =  [NSString stringWithUTF8String:doc_name.c_str()];
    if (documentName == nil || [documentName isEqualToString:@""]) {
       documentName = @"Searching for ID...";
    }
    [documentNameLabel setText:documentName ];
    [targetRectangle setNeedsDisplay];
}

-(void) updateProgessBarUI {

}

-(CGRect) getSearchRoiForWidth:(float)w height:(float)h aspectRatio:(float)ratio {

    return [self getSearchRoiForWidth:w height:h aspectRatio:ratio heightFromWidth:true];
}

-(CGRect) getSearchRoiForWidth:(float)w height:(float)h aspectRatio:(float)ratio heightFromWidth:(bool)heightFromWidth {
    
    double width;
    double height;
    
    if (heightFromWidth) {
        width = w * .85;
        height = width / ratio;
    } else {
        height = h;
        width = h * ratio;
    }
    CGPoint tl = CGPointMake((w - width) / 2.0, (h - height) / 2.0);
    CGPoint br = CGPointMake(tl.x + width, tl.y + height);
    
    if (tl.y < 0)
        return [self getSearchRoiForWidth:w height:h aspectRatio:ratio heightFromWidth:false];
    
    return CGRectMake(tl.x, tl.y, br.x-tl.x, br.y-tl.y);
}

-(void)unwind_to_uiwebview {
    if(_launchedFromApp){
        [self exitFromImageProcessingScreen:@"0"];//Success code
    }else{
        [self performSegueWithIdentifier: @"Unwind To UIWebView" sender: self];
    }
}

-(void)unwind_to_uiwebview_back {
    [self performSegueWithIdentifier: @"Unwind To UIWebView Back" sender: self];
}

- (IBAction)rotatePortrait:(id)sender {
    
    isLandscapeMode = NO;
    
    backButton.hidden=YES;
    rotatePortraitButton.hidden=YES;
    
    backPortraitButton.hidden=NO;
    rotateLandscapeButton.hidden=NO;
    
    NSString* templateDirPath = currentTemplateLocation;
    NSString* templateFilePath = [NSString stringWithFormat:@"%@%@%@", templateDirPath, @"/",@"high_rotate.xml"];
    bestOf.documents.clear();
    bestOf.documents.push_back([DocumentTemplateFactory load_document_template:templateFilePath]);
    document = [DocumentTemplateFactory load_document_template:templateFilePath];
    [self updateViewConstraints];
}

- (IBAction)rotateLandscape:(id)sender {
    
    isLandscapeMode = YES;
    
    backPortraitButton.hidden=YES;
    rotateLandscapeButton.hidden=YES;
    
    backButton.hidden=NO;
    rotatePortraitButton.hidden=NO;
    
    NSString* templateDirPath = currentTemplateLocation;
    NSString* templateFilePath = [NSString stringWithFormat:@"%@%@%@", templateDirPath, @"/",@"high.xml"];
    bestOf.documents.clear();
    bestOf.documents.push_back([DocumentTemplateFactory load_document_template:templateFilePath]);
    document = [DocumentTemplateFactory load_document_template:templateFilePath];
    [self updateViewConstraints];
    
}

- (IBAction)backPressedLandscape:(id)sender {
    if(_launchedFromApp){
        [self exitFromImageProcessingScreen:@"18"];//Back pressed code
    }
}

- (IBAction)backPressedPortrait:(id)sender {
    if(_launchedFromApp){
        [self exitFromImageProcessingScreen:@"18"];//Back pressed code
    }
}

- (IBAction)captureImage:(id)sender {
    _capturedImagePressed = YES;
    _ImagesToConsume = _ImagesToInsert = 1;
}

-(void)exitFromImageProcessingScreen:(NSString*)exitType{
    
    NSMutableDictionary *ocrResp = [NSMutableDictionary new];
    
    if([exitType isEqualToString:@"0"]){//Success code
        
        if(_single_high_res_snapshot_mode){
        
        }else{
            //Response xml data
            NSString *xml = [self xml];
            
            //Response image data
            UIImage* processedImage = [self snap];
            UIImage* actualFaceImage = [self get_face_image];
            UIImage* actualInputImage = [self get_input_image];
            UIImage* matchedTemplateImage = [self get_matched_template];
            
            
            
            [ocrResp setObject:@"0" forKey:@"Status"];
            if(nil != xml)
                [ocrResp setObject:xml forKey:@"ResponseXML"];

            if(nil != processedImage){
                NSData *image =  UIImageJPEGRepresentation(processedImage, 0.9);
                NSString *imageStr = [image base64EncodedStringWithOptions:0];
                [ocrResp setObject:imageStr forKey:@"ProcessedImage"];
            }
            
            
            if(nil != actualFaceImage){
                NSData *image =  UIImageJPEGRepresentation(actualFaceImage, 0.9);
                NSString *imagestr = [image base64EncodedStringWithOptions:0];
                [ocrResp setObject:imagestr forKey:@"FaceImage"];
            }

            if(nil != actualInputImage){
                NSData *image =  UIImageJPEGRepresentation(actualInputImage, 0.9);
                NSString *imagestr = [image base64EncodedStringWithOptions:0];
                [ocrResp setObject:imagestr forKey:@"InputImage"];
            }
            
            if(nil != matchedTemplateImage){
                NSData *image =  UIImageJPEGRepresentation(matchedTemplateImage, 0.9);
                NSString *imagestr = [image base64EncodedStringWithOptions:0];
                [ocrResp setObject:imagestr forKey:@"TemplateImage"];
            }
        }
    }else if ([exitType isEqualToString:@"18"]){//Back pressed code
        [ocrResp setObject:@"18" forKey:@"Status"];
    }else if ([exitType isEqualToString:@"101"]){//Template not found
        [ocrResp setObject:@"101" forKey:@"Status"];
        [ocrResp setObject:@"Template Not Found!" forKey:@"Message"];
    }
    
    NSError * err;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:ocrResp options:NSJSONWritingPrettyPrinted error:&err];
    NSString * myString = [jsonData base64EncodedStringWithOptions:0];
    
    [_responseUrl appendString:@"&requestParam="];
    [_responseUrl appendString:myString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_responseUrl]];
    
    [self exitFromApp];
}

-(void)exitFromApp{
    //home button press programmatically
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    
    //wait 2 seconds while app is going background
    [NSThread sleepForTimeInterval:2.0];
    
    //exit app when app is in background
    exit(0);
}

@end
