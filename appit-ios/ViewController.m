//
//  ViewController.m
//  appit-ios
//
//  Created by Goran Rauker on 1/29/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import "AppDelegate.h"
//#import "OpenCvViewControllerAppit.h"
#import "ViewController.h"
#import "IDServerInterface.h"
#import "OpenCVUtils.h"
//#import "FaceDetectionViewController.h"
//#import "FaceDetectionNewViewController.h"
//#import "FingerDetectionViewController2.h"
//#import "FingerPreviewViewController.h"
//#import "ScanCardIOViewController.h"
//#import "VoiceRecorder.h"
//#import "VideoRecorderViewController.h"
//#import "SkipImageProcessingViewController.h"
#import "NSData+GZIP.h"
#import "UIView+Toast.h"
#import "PasswordViewController.h"
#import "NS_String_Utils.h"
#import <sys/utsname.h>
//#import "BarcodeViewController.h"
//#import "InstructionViewController.h"
//#import "CaptureSignatureController.h"
//#import "MlKitFaceController.h"
//#import "FacePreviewViewController.h"
//#import "SnippetCaptureController.h"
//#import "SnippetData.h"
#import <AppItFramework/AppItSDK.h>

#define TEMPLATES_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/templates"]

@interface ViewController ()
@end

@implementation ViewController {
    NSString *path_to_xml_template;
    NSString *operation;
    NSString *processedImage;
    NSString *faceImage;
    NSString *inputImage;
    NSString *matchedTemplate;
    NSDictionary *requestParamJson;
    NSMutableDictionary *imageProcessingData;
    BOOL callbackExecuted;
    VoiceRecorder *voiceRecorder;
    IDServerInterface *idServerInterface;
    NSInteger templateDownloadStatus;
    NSString *urlRelode;
    UILabel  *recordingTimeLabel, *recordingLabel;
    // BOOL recordingStarted = NULL ;
    NSMutableDictionary *snippetDictionary, *psgfKeyValueSnippetDictionary;
    NSString *isImageSnippetCapture;
    NSMutableDictionary *barcodeDataDictionary, *mrzDataDictionary;
    BOOL videoCallbackExecuted;
    WKWebView *pdf_webView;
    NSString *content_file_name;
    UIDocumentInteractionController *documentInteractionController;
}
@synthesize optionsButton;
@synthesize currentTemplateLocation;
@synthesize videoPreviewLayer = _videoPreviewLayer;
bool isMinimized = false;
BOOL fullScreen = true;
bool isMute = false;
NSString* recordingStarted = @"nil";
UIButton *playPauseVideo;
UIButton *muteUnmuteBtn;
UIButton *recordingButton;
UIButton *toogleCamera;
UIButton *expandVideo, *backUIButton;
NSString *base64Encoded;
bool isBackPressed;
int videoRecSeconds = 0;
double divideInSecond = 0.0;
int numberOfPart = 0;
int videoChunkSize = 0;
int startChunkPosition = 0;
int recordingDuration = 0;
UIProgressView *progressView;
UITextView *labelScrolledData;
NSTimer *myTimer;
static int count = 0, minute = 0;
static bool first_launch = false;
static bool idfaceshowInstruction = true;

- (void)viewDidLoad {
    
    //ADDED MA
    [super viewDidLoad];
    [AppItSDK setIsSDKForAppIT:true];
    [self setupWebView];
    [self reloadURL];
//    self.webView.delegate = self;
    
    self.navigationItem.hidesBackButton = YES;
    //[self initViews];
    first_launch = true;
    isBackPressed = false;
    
    isImageSnippetCapture = @"N";
}

- (void)setupWebView {
    self.webView = [[WKWebView alloc] initWithFrame: CGRectZero
                                      configuration: [self setJS]];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.configuration.preferences.javaScriptEnabled = YES;
    [self.view addSubview: self.webView];
    [self setConstraints: self.webView];
}

-(void) setConstraints:(WKWebView *)webView {
    
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *trailing =[NSLayoutConstraint
    constraintWithItem:webView
    attribute:NSLayoutAttributeTrailing
    relatedBy:NSLayoutRelationEqual
    toItem:self.view
    attribute:NSLayoutAttributeTrailing
    multiplier:1.0f
    constant:0.f];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
    constraintWithItem:webView
    attribute:NSLayoutAttributeLeading
    relatedBy:NSLayoutRelationEqual
    toItem:self.view
    attribute:NSLayoutAttributeLeading
    multiplier:1.0f
    constant:0.f];
    
    NSLayoutConstraint *bottom =[NSLayoutConstraint
    constraintWithItem:webView
    attribute:NSLayoutAttributeBottom
    relatedBy:NSLayoutRelationEqual
    toItem:self.view
    attribute:NSLayoutAttributeBottom
    multiplier:1.0f
    constant:0.f];

    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    
    [self.view addConstraint:trailing];
    [self.view addConstraint:leading];
    [self.view addConstraint:top];
    [self.view addConstraint:bottom];
    
}

- (WKWebViewConfiguration *)setJS {
    NSString *jsString = @"";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource: jsString
                                                      injectionTime: WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:YES];
    WKUserContentController *wkUController = [WKUserContentController new];
    [wkUController addUserScript: userScript];
    // Set a key to determine JS
    
    WKWebViewConfiguration *wkWebConfig = [WKWebViewConfiguration new];
    wkWebConfig.userContentController = wkUController;
    wkWebConfig.allowsInlineMediaPlayback = YES;
    wkWebConfig.mediaTypesRequiringUserActionForPlayback = NO;
    wkWebConfig.allowsPictureInPictureMediaPlayback = NO;
    [wkWebConfig.userContentController
    addScriptMessageHandler:self name:@"callbackHandler"];
    wkWebConfig.preferences.javaScriptEnabled = YES;
    
    return wkWebConfig;
}

- (void)changeLanguage{
    NSString * languageLocal = [[NSLocale preferredLanguages] firstObject];
    NSString * language = [[languageLocal componentsSeparatedByString:@"-"]
                           objectAtIndex:0];
    //    // [StringLabels initializeCurrentLabels:@"es"];
    //    if ([language isEqualToString:@"es"]){
    //        language = @"es";
    //    }else {
    //        language = @"en";
    //    }
    [StringLabels initializeCurrentLabels:language];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    // best call super just in case
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // will execute before rotation
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // will execute during rotation
        
    } completion:^(id  _Nonnull context) {
        // will execute after rotation
        if(self.view.bounds.size.height > self.view.bounds.size.width){
            NSLog(@"Portrait");
            //[self addFooter];
        }else{
            NSLog(@"Landscape");
        }
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    [self changeLanguage];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    
    //For disabling autozooming and scalling(pinch-zoom)
    _webView.scrollView.maximumZoomScale = 1.0;
    _webView.scrollView.minimumZoomScale = 1.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// JS execution (triggered at any time from the app side)
- (void)triggerJS:(NSString *)jsString webView:(WKWebView *)webView {
    [webView evaluateJavaScript:jsString
              completionHandler:^(NSString *result, NSError *error){
                  if (error != nil) {
                      NSLog(@"Error during JS execution：%@", error.localizedDescription);
                      return;
                  }
                  NSLog(@"Output result：%@", result);
              }];
}

#pragma mark - WKNavigationDelegate Methods
/// Allow specified element to display preview
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"about:blank"]) {
        NSLog(@"about:blank called...");
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ( [navigationAction.request.URL.scheme isEqualToString: @"idmission" ]) {
        
        NSString *requestParam = @"";
        
        //        NSLog(@"Host : %@", request.URL.host);
        
        NSURLComponents *components = [NSURLComponents componentsWithString:navigationAction.request.URL.absoluteString];
        for(NSURLQueryItem *item in components.queryItems)
        {
            NSLog(@"Parameter : name= %@", item.name);
            //            NSLog(@"Parameter : name= %@ value= %@", item.name, item.value);
            if([item.name isEqualToString: @"requestParam"]){
                requestParam = item.value;
                break;
            }
        }
        
        if([components.queryItems count] == 0){
            NSLog(@"Using HOST value");
            requestParam = navigationAction.request.URL.host;
        }
        
        //request url from Inform is econded json string. Decode and convert it to json.
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:requestParam options:0];
        
        NSError *jsonError;
        requestParamJson = [NSJSONSerialization JSONObjectWithData:decodedData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
        operation = [requestParamJson objectForKey:@"operation"];
        NSLog(@"%@", [NSString stringWithFormat:@"%@", operation]);
        
        if ([operation isEqualToString: @"imageProc"] ) {
            idfaceshowInstruction = true;
            [self restrictRotation_toMaskAll:YES];
            [self prepare_data_for_image_proc];
        } else if ([operation isEqualToString: @"imageProcResult"] ) {
            [self handle_opencv_result_callback];
        } else if ([operation isEqualToString: @"templateDownload"] ) {
            
            [self download_templates];
        }else if ([operation isEqualToString: @"scanFingerprint"] ) {
            idfaceshowInstruction = true;
            [self prepare_data_for_fingerprint];
        }else if ([operation isEqualToString: @"cancelScan"] ) {
            
        } else if ([operation isEqualToString: @"imageSnippetCapture"] ) {
            [self restrictRotation_toMaskAll:YES];
            [self prepare_data_for_snippet_capture];
        } else if ([operation isEqualToString: @"faceDetection"] ) {
            idfaceshowInstruction = true;
            [self prepare_data_for_face_detection];
        }else if ([operation isEqualToString:@"scanBarcode"]) {
            // [self prepare_data_for_barcodeScan];
            [self checkCameraPermission];
        }else if ([operation isEqualToString:@"signaturecapture"]) {
            [self restrictRotation_toMaskAll:YES];
            [AppItSDK captureSignature:self];
        }else if ([operation isEqualToString: @"startVoiceRecording"] ) {
            // voiceRecorder = [VoiceRecorder alloc];
            // voiceRecorder.delegate = self;
            NSMutableDictionary *voiceRecordingConfig = [[self getVoiceRecordingConfigData] mutableCopy];
            
            // [voiceRecorder startRecording:voiceRecordingConfig];
            [AppItSDK startVoiceRecording:self voiceRecordingConfig:voiceRecordingConfig];
            
        }else if ([operation isEqualToString: @"stopVoiceRecording"] ) {
            // [voiceRecorder stopRecording];
            // NSLog(@"Need to add pause");
            [AppItSDK stopVoiceRecording];
        }else if ([operation isEqualToString: @"cardIO"] ) {
            [AppItSDK detectCard:self];
        }else if ([operation isEqualToString: @"getAppitVersion"] ) {
            [self handle_appit_version_callback];
        }else if([operation isEqualToString:@"thirdPartyResult"]) {
            [self prepare_data_for_third_party_response_result];
        }else if([operation isEqualToString:@"getSpecification"]) {
            [self handle_get_spectification_callback];
        }else if([operation isEqualToString:@"downloadXslt"]) {
            NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
            NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
            
            NSDictionary *xsltDownloadDataDictionary = [dataToAppit objectForKey:@"xsltDownload"];

            NSMutableDictionary *downloadXSLTDictionary = [[NSMutableDictionary alloc] init];
            [downloadXSLTDictionary setObject:[xsltDownloadDataDictionary objectForKey:@"IDServerUrl"] forKey:@"url"];
            [downloadXSLTDictionary setObject:[xsltDownloadDataDictionary objectForKey:@"loginId"]  forKey:@"login_ID"];
            [downloadXSLTDictionary setObject:[xsltDownloadDataDictionary objectForKey:@"password"] forKey:@"password"];
            [downloadXSLTDictionary setObject:[xsltDownloadDataDictionary objectForKey:@"merchantId"] forKey:@"merchant_id"];
            [downloadXSLTDictionary setObject:[xsltDownloadDataDictionary objectForKey:@"applicationCode"] forKey:@"appCode"];
            
            [AppItSDK downloadXslt:self downloadCredentials:downloadXSLTDictionary];
        }else if([operation isEqualToString:@"videoRecording"]) {
            NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
            NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
            NSDictionary* videoRecordingDictionary = [dataToAppit objectForKey:@"videoRecording"];
            NSString* videoRecordingRequestType = [videoRecordingDictionary objectForKey:@"RequestType"];
            isBackPressed = false;
            if(![videoRecordingRequestType isEqualToString:@"Polling"]) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                {
                    [[UIDevice currentDevice] setValue:
                     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                                forKey:@"orientation"];
                }
                if(first_launch) {
                    //  [self initViews];
                    first_launch = false;
                }
                count=0;
                minute=0;
                
                videoRecSeconds = 0;
                divideInSecond = 0.0;
                numberOfPart = 0;
                videoChunkSize = 0;
                startChunkPosition = 0;
                fullScreen = true;
                recordingStarted = @"nil";
                NSString* recordingStringDuration = [videoRecordingDictionary objectForKey:@"duration"];
                recordingDuration = [recordingStringDuration integerValue];
                NSString *textOnVideoScreen;
                if([videoRecordingDictionary objectForKey:@"textOnVideoScreen"]) {
                    //                    [labelScrolledData setText:[videoRecordingDictionary objectForKey:@"textOnVideoScreen"]];
                    textOnVideoScreen = [videoRecordingDictionary objectForKey:@"textOnVideoScreen"];
                } else {
                    //  [labelScrolledData setText:@""];
                    textOnVideoScreen = @"";
                }
                //                [self refreshVideoRecordingScreen];
                //                [self initVideoCameraSession];
                //                [self restrictRotation:YES];
                
                NSString *showVideoFeedback = [videoRecordingDictionary objectForKey:@"showVideoFeedback"];
                BOOL enableBgVideoRecording = [@"N" isEqualToString:showVideoFeedback];
                
                videoCallbackExecuted = false;
//                [AppItSDK startVideoRecording:self recordingTime:recordingDuration additionalDictionary:nil textDatatoScrolled:textOnVideoScreen];
                [AppItSDK startVideoRecording:self recordingTime:recordingDuration additionalDictionary:nil textDatatoScrolled:textOnVideoScreen isEnableBgVideoRecording:enableBgVideoRecording];
            } else {
                NSMutableDictionary *config = [self build_common_return_data];
                NSMutableDictionary *result = [NSMutableDictionary new];
                NSString* chunkBase64 = @"";
                int endChunkPosition = startChunkPosition + videoChunkSize;
                
                if(endChunkPosition >= base64Encoded.length) {
                    long fullLength = base64Encoded.length;
                    chunkBase64 = [base64Encoded substringWithRange:NSMakeRange(startChunkPosition,base64Encoded.length - startChunkPosition)];
                    [result setObject:@"FINISH" forKey:@"FileStatus"];
                }else {
                    long fullLength = base64Encoded.length;
                    chunkBase64 = [base64Encoded substringWithRange:NSMakeRange(startChunkPosition, endChunkPosition - startChunkPosition)];
                    [result setObject:@"PENDING" forKey:@"FileStatus"];
                }
                startChunkPosition = endChunkPosition;
                [config setObject:@"51" forKey:@"status"];
                [result setObject:chunkBase64 forKey:@"VideoData"];
                [config setObject:[self get_json_string:result] forKey:@"dataFromAppit"];
                
                NSString *encodedJsonString = [self get_encoded_json_string:config];
                
                [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
            }
        }else if([operation isEqualToString:@"startVideoConference"]) {
            NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
            NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
            
            NSDictionary *videoConferencingDataDictionary = [dataToAppit objectForKey:@"videoConference"];

            [self checkCameraPermission_videoConference:videoConferencingDataDictionary];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([navigationAction.request.URL.scheme isEqualToString: @"tel" ] || [navigationAction.request.URL.scheme.lowercaseString isEqualToString: @"mailto" ]) {
        
        if([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
             decisionHandler(WKNavigationActionPolicyAllow);
        }
        
    } else {
        
        NSString *extensionOfPath = navigationAction.request.URL.pathExtension;
        if(![NS_String_Utils stringIsNilOrEmpty:extensionOfPath] && [@"pdf" isEqualToString:extensionOfPath]) {
            [self.webView setHidden:YES];
            [self setUpWebViewForPDF:navigationAction.request.URL.absoluteString];
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
//    webView.scalesPageToFit = YES;

   webView.contentMode = UIViewContentModeScaleAspectFit;

}

//-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
//{
//
//    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
//    CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
//    SecTrustSetExceptions(serverTrust, exceptions);
//    CFRelease(exceptions);
//
//    completionHandler(NSURLSessionAuthChallengeUseCredential,
//                      [NSURLCredential credentialForTrust:serverTrust]);
//
//}

// Start reading
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    NSLog(@"Start reading");
}

// Read complete
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"Read complete");
//    [self triggerJS:@"document.body.innerHTML" webView:webView];
    
//    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (int)webView.frame.size.width]];
//    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (int)webView.frame.size.width] completionHandler:nil];
    
    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";

    [webView evaluateJavaScript:[NSString stringWithFormat:javascript, (int)webView.frame.size.width] completionHandler:nil];
    
    
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
    webView.scrollView.delegate = self;
    [webView.scrollView setShowsHorizontalScrollIndicator:NO];
    webView.scrollView.bounces = NO;
    //For disabling autozooming and scalling(pinch-zoom)
    webView.scrollView.maximumZoomScale = 1.0;
    webView.scrollView.minimumZoomScale = 1.0;
}

// Read failure
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"Read failure");
}

// Connection Failed
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    NSLog(@"Error code：%ld", (long)error.code);
}

-(void)startProgress {
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        count++;
        if(count <=recordingDuration) {
            progressView.progress =(float)count/recordingDuration;
            if(count==60){ //second
                minute++;
                count = 0;
            }
            NSString *time = [[NSString alloc]
                              initWithFormat:@"%02d:%02d",minute,count];
            recordingTimeLabel.text = time;
        } else {
            [myTimer invalidate];
            myTimer = nil;
        }
    }];
}

-(void)initViews {
    int height = self.view.frame.size.height;
    int width = self.view.frame.size.width;
    int centerX = width/2;
    int centerY = height/2;
    int buttonWidhHeight = 100;
    int progressPadding = 40;
    if(height <= 623) {
        buttonWidhHeight = 50;
        progressPadding = 20;
    }
    int padding = 10;
    int botPadding = 0;
    
    UIView *scrollView = [self view];
    
    //Mute UnMute Video Button
    muteUnmuteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [muteUnmuteBtn setFrame:CGRectMake(padding, height-buttonWidhHeight - botPadding, buttonWidhHeight, buttonWidhHeight)];
    [muteUnmuteBtn addTarget:self action:@selector(mute_unmute_video:) forControlEvents:UIControlEventTouchUpInside];
    [muteUnmuteBtn setImage:[UIImage imageNamed:@"unmute_rec.png"] forState:UIControlStateNormal];
    [scrollView addSubview:muteUnmuteBtn];
    
    //Play Pause Button
    playPauseVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [playPauseVideo setFrame:CGRectMake(width-buttonWidhHeight-padding, height-buttonWidhHeight - botPadding, buttonWidhHeight, buttonWidhHeight)];
    [playPauseVideo addTarget:self action:@selector(play_pause_video:) forControlEvents:UIControlEventTouchUpInside];
    [playPauseVideo setImage:[UIImage imageNamed:@"done_rec.png"] forState:UIControlStateNormal];
    [scrollView addSubview:playPauseVideo];
    
    //Progress Bar
    // UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(0,height-buttonWidhHeight - botPadding - progressPadding,width,buttonWidhHeight);
    [scrollView addSubview:progressView];
    //    [progressView setProgress:0.0];
    progressView.trackTintColor = [UIColor blueColor];
    progressView.progressTintColor = [UIColor whiteColor];
    progressView.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    
    //Scrolled label to be shown
    labelScrolledData = [[UITextView alloc] init];
    labelScrolledData.frame = CGRectMake(0,progressView.frame.origin.y - 60 , self.view.frame.size.width, 60);
    [labelScrolledData setFont:[UIFont fontWithName:@"Arial" size:18]];
    [labelScrolledData setScrollEnabled:YES];
    [labelScrolledData setUserInteractionEnabled:YES];
    [labelScrolledData setBackgroundColor:[UIColor clearColor]];
    [labelScrolledData setTextAlignment:NSTextAlignmentCenter];
    [labelScrolledData setTextColor:[UIColor whiteColor]];
    [self.view addSubview:labelScrolledData];
    
    //recording timer label
    recordingLabel = [[UILabel alloc] init];
    [recordingLabel setFrame: CGRectMake(0,height-(buttonWidhHeight+55) - botPadding - progressPadding,width,buttonWidhHeight)];
    [recordingLabel setText:@"Recording"];
    [recordingLabel setTextColor:[UIColor whiteColor]];
    [recordingLabel setTextAlignment:NSTextAlignmentCenter];
    [recordingLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:recordingLabel];
    
    recordingTimeLabel = [[UILabel alloc] init];
    [recordingTimeLabel setFrame: CGRectMake(0,height-(buttonWidhHeight+30) - botPadding - progressPadding,width,buttonWidhHeight)];
    [recordingTimeLabel setFont:[UIFont systemFontOfSize:25]];
    [recordingTimeLabel setText:@"00:00"];
    [recordingTimeLabel setTextColor:[UIColor whiteColor]];
    [recordingTimeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [recordingTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:recordingTimeLabel];
    
    
    //Start Stop Button
    recordingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordingButton setFrame:CGRectMake(centerX-(buttonWidhHeight/2), height-buttonWidhHeight - botPadding, buttonWidhHeight, buttonWidhHeight)];
    [recordingButton addTarget:self action:@selector(start_stop_recording:) forControlEvents:UIControlEventTouchUpInside];
    [recordingButton setImage:[UIImage imageNamed:@"start_recording.png"] forState:UIControlStateNormal];
    [scrollView addSubview:recordingButton];
    
    //Toggle Camera Button
    toogleCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [toogleCamera setFrame:CGRectMake(width-buttonWidhHeight-padding, height-buttonWidhHeight - botPadding, buttonWidhHeight, buttonWidhHeight)];
    [toogleCamera addTarget:self action:@selector(toggle_camera:) forControlEvents:UIControlEventTouchUpInside];
    [toogleCamera setImage:[UIImage imageNamed:@"front_cam.png"] forState:UIControlStateNormal];
    [scrollView addSubview:toogleCamera];
    
    //Video View Expand
    expandVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [expandVideo setFrame:CGRectMake(width-padding-buttonWidhHeight, padding, buttonWidhHeight, buttonWidhHeight)];
    [expandVideo addTarget:self action:@selector(expand_video:) forControlEvents:UIControlEventTouchUpInside];
    [expandVideo setImage:[UIImage imageNamed:@"minimize.png"] forState:UIControlStateNormal];
    [scrollView addSubview:expandVideo];
    
    //Adding BACK button -Start
    backUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect backButtonRect = CGRectMake(10, 10 , 50, 50);
    [backUIButton setFrame:backButtonRect];
    [backUIButton setImage:[UIImage imageNamed:@"back_cancel_arrow.png"] forState:UIControlStateNormal];
    
    [backUIButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:backUIButton];
    
    [playPauseVideo setHidden:YES];
    [recordingButton setHidden:YES];
    [toogleCamera setHidden:YES];
    [expandVideo setHidden:YES];
    [backUIButton setHidden:YES];
    [muteUnmuteBtn setHidden:YES];
    [progressView setHidden:YES];
    [labelScrolledData setHidden:YES];
}

-(void)play_pause_video:(UIButton*)button{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [playPauseVideo setHidden:YES];
    [recordingButton setHidden:YES];
    [toogleCamera setHidden:YES];
    [muteUnmuteBtn setHidden:YES];
    [expandVideo setHidden:YES];
    [backUIButton setHidden:YES];
    [labelScrolledData setHidden:YES];
    [_webView setHidden:NO];
    [recordingTimeLabel setHidden:YES];
    [recordingLabel setHidden:YES];
    [playerViewController.player pause];
    [self destroyVideoCameraSession];
    [toogleCamera setImage:[UIImage imageNamed:@"front_cam.png"] forState:UIControlStateNormal];
    isMute = false;
    [muteUnmuteBtn setImage:[UIImage imageNamed:@"unmute_rec.png"] forState:UIControlStateNormal];
    
    [self restrictRotation_toMaskAll:YES];
    
    NSMutableDictionary *config = [self build_common_return_data];
    [config setObject:@"42" forKey:@"status"];
    
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    divideInSecond = 10.0;
    numberOfPart = ceil(videoRecSeconds/divideInSecond);
    videoChunkSize = ceil(base64Encoded.length/numberOfPart);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02d:%02d",0, 0];
    recordingTimeLabel.text = time;
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
    
}

-(void)mute_unmute_video:(UIButton*)button {
    if(!isMute) {
        isMute = true;
        [muteUnmuteBtn setImage:[UIImage imageNamed:@"mute_rec.png"] forState:UIControlStateNormal];
    }else {
        isMute = false;
        [muteUnmuteBtn setImage:[UIImage imageNamed:@"unmute_rec.png"] forState:UIControlStateNormal];
    }
}

-(void)start_stop_recording:(UIButton*)button {
    
    [playerViewController.view removeFromSuperview];
    BOOL recording = [self toggleVideoRecording];
    if(recording){
        [recordingButton setImage:[UIImage imageNamed:@"stop_recording.png"] forState:UIControlStateNormal];
        recordingStarted = @"true";
        [self refreshVideoRecordingScreen];
    }else{
        [recordingButton setImage:[UIImage imageNamed:@"start_recording.png"] forState:UIControlStateNormal];
        recordingStarted = @"false";
        [self refreshVideoRecordingScreen];
    }
    
}

-(void)toggle_camera:(UIButton*)button{
    [playerViewController.view removeFromSuperview];
    BOOL isBackCamera = [self toggleCameraPosition];
    if(isBackCamera){
        [toogleCamera setImage:[UIImage imageNamed:@"front_cam.png"] forState:UIControlStateNormal];
    }else{
        [toogleCamera setImage:[UIImage imageNamed:@"back_cam.png"] forState:UIControlStateNormal];
    }
}

-(void)backPressed:(UIButton*)button{
    NSLog(@"Back Pressed");
    if(recordingInProgress) {
        NSLog(@"STOP RECORDING");
        recordingInProgress = NO;
        [movieFileOutput stopRecording];
        [myTimer invalidate];
    }
    count=0;
    minute=0;
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%02d:%02d",0, 0];
    recordingTimeLabel.text = time;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    isBackPressed = true;
    [playPauseVideo setHidden:YES];
    [labelScrolledData setHidden:YES];
    [recordingButton setHidden:YES];
    [toogleCamera setHidden:YES];
    [muteUnmuteBtn setHidden:YES];
    [expandVideo setHidden:YES];
    [backUIButton setHidden:YES];
    [_webView setHidden:NO];
    [progressView setProgress:0.0];
    [progressView setHidden:YES];
    [playerViewController.player pause];
    [recordingTimeLabel setHidden:YES];
    [recordingLabel setHidden:YES];
    [self destroyVideoCameraSession];
    [toogleCamera setImage:[UIImage imageNamed:@"front_cam.png"] forState:UIControlStateNormal];
    isMute = false;
    [muteUnmuteBtn setImage:[UIImage imageNamed:@"unmute_rec.png"] forState:UIControlStateNormal];
    
    [self restrictRotation_toMaskAll:YES];
    
    NSMutableDictionary *config = [self build_common_return_data];
    [config setObject:@"41" forKey:@"status"];
    
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //    divideInSecond = 10.0;
    //    numberOfPart = ceil(videoRecSeconds/divideInSecond);
    //    videoChunkSize = ceil(base64Encoded.length/numberOfPart);
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

-(void)expand_video:(UIButton*)button{
    NSLog(@"expand_video");
    CGRect layerRect = [[[self view] layer] bounds];
    if(!isMinimized) {
        
        isMinimized = true;
        int x = layerRect.size.width*65/100;
        int y = 0;
        int w = layerRect.size.width-x;
        int h = layerRect.size.height*35/100;
        //TODO
        layerRect = CGRectMake(x, y, w, h);
        
        [_videoPreviewLayer setBounds:layerRect];
        [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                    CGRectGetMidY(layerRect))];
        if(nil != playerViewController) {
            playerViewController.view.frame = CGRectMake(x,y,w,h);
            [self.view bringSubviewToFront:recordingButton];
        }
        
        [_webView setHidden:NO];
        [self.view sendSubviewToBack:_webView];
        
        float height = _videoPreviewLayer.bounds.size.height;
        float width = _videoPreviewLayer.bounds.size.width;
        int screenHeight = self.view.frame.size.height;
        int centerX = width/2;
        int buttonWidhHeight = 100;
        int progressPadding = 40;
        if(screenHeight <= 623) {
            buttonWidhHeight = 50;
            progressPadding = 20;
        }
        [recordingButton setFrame:CGRectMake(_videoPreviewLayer.bounds.origin.x + centerX-(buttonWidhHeight/2), height-buttonWidhHeight, buttonWidhHeight, buttonWidhHeight)];
        
        [progressView setFrame:CGRectMake(_videoPreviewLayer.bounds.origin.x + 2, height-buttonWidhHeight - progressPadding, width, buttonWidhHeight)];
        fullScreen = false;
        [self refreshVideoRecordingScreen];
        [expandVideo setImage:[UIImage imageNamed:@"maximize.png"] forState:UIControlStateNormal];
        
    } else {
        isMinimized = false;
        [_videoPreviewLayer setBounds:layerRect];
        [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                    CGRectGetMidY(layerRect))];
        if(nil != playerViewController) {
            int x = 50;
            int y = 110;
            if(layerRect.size.height <= 623) {
                x = 25;
                y = 60;
            }
            playerViewController.view.frame = CGRectMake(x,y,self.view.frame.size.width-x-x,self.view.frame.size.height-y-y);
        }
        [_webView setHidden:YES];
        float navigationheight = self.navigationController.navigationBar.frame.size.height;
        int height = self.view.frame.size.height;
        int width = self.view.frame.size.width;
        int centerX = width/2;
        int centerY = height/2;
        int buttonWidhHeight = 100;
        int progressPadding = 40;
        if(height <= 623) {
            buttonWidhHeight = 50;
            progressPadding = 20;
        }
        int padding = 10;
        int botPadding = 0;
        
        [recordingButton setFrame:CGRectMake(centerX-(buttonWidhHeight/2), height-buttonWidhHeight - botPadding, buttonWidhHeight, buttonWidhHeight)];
        
        [progressView setFrame:CGRectMake(0, height-buttonWidhHeight - botPadding - progressPadding, width, buttonWidhHeight)];
        
        fullScreen = true;
        [self refreshVideoRecordingScreen];
        [expandVideo setImage:[UIImage imageNamed:@"minimize.png"] forState:UIControlStateNormal];
    }
}

-(BOOL)toggleVideoRecording{
    
    if (!recordingInProgress){
        
        NSLog(@"START RECORDING");
        [progressView setProgress:0.0];
        recordingInProgress = YES;
        
        //Create temporary URL to record to
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
        
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath]){
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO){
                //Error - handle if requried
            }
        }
        
        //Start recording
        [movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        count = 0;
        minute=0;
        [self startProgress];
        
    }else{
        NSLog(@"STOP RECORDING");
        recordingInProgress = NO;
        [movieFileOutput stopRecording];
        [myTimer invalidate];
    }
    return recordingInProgress;
}

- (BOOL)toggleCameraPosition{
    
    BOOL isBackCamera = YES;
    //Only do if device has multiple cameras
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1){
        NSLog(@"Toggle camera");
        NSError *error;
        //AVCaptureDeviceInput *videoInput = [self videoInput];
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInputDevice device] position];
        if (position == AVCaptureDevicePositionBack){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&error];
            isBackCamera = NO;
        }else if (position == AVCaptureDevicePositionFront){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack] error:&error];
            isBackCamera = YES;
        }
        
        if (newVideoInput != nil){
            [captureSession beginConfiguration];//We can now change the inputs and output configuration.  Use commitConfiguration to end
            [captureSession removeInput:videoInputDevice];
            if ([captureSession canAddInput:newVideoInput]){
                [captureSession addInput:newVideoInput];
                videoInputDevice = newVideoInput;
            }else{
                [captureSession addInput:videoInputDevice];
            }
            
            [captureSession commitConfiguration];
        }
    }
    return isBackCamera;
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if ([device position] == position){
            return device;
        }
    }
    return nil;
}

-(void)downloadXsltResultResponse : (NSMutableDictionary*) result {
    NSLog(@"Download XSLT Response");
}

-(void)videoRecordingResponse:(NSMutableDictionary*) result {
    NSLog(@"Video Recording Response");
    
    if(result.count == 0){
        return;
    }
    
    if(!videoCallbackExecuted){
        videoCallbackExecuted = true;
        
        NSMutableDictionary *config = [self build_common_return_data];
        
        if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
            
            [config setObject:@"42" forKey:@"status"];
            
            NSString *encodedJsonString = [self get_encoded_json_string:config];
            videoRecSeconds = [AppItSDK getVideoRecordingInSec];
            
            NSData *videoData = [NSData dataWithContentsOfURL:[result objectForKey:@"VIDEO_DATA"] options: 0 error:nil];
            
            base64Encoded = [videoData base64EncodedStringWithOptions:0];
            
            divideInSecond = 10.0;
            numberOfPart = ceil(videoRecSeconds/divideInSecond);
            videoChunkSize = ceil(base64Encoded.length/numberOfPart);
            
            NSString *time = [[NSString alloc]
                              initWithFormat:@"%02d:%02d",0, 0];
            
            [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
        } else {
            
            count=0;
            minute=0;
            
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            isBackPressed = true;
            
            isMute = false;
            
            NSMutableDictionary *config = [self build_common_return_data];
            [config setObject:@"41" forKey:@"status"];
            
            NSString *encodedJsonString = [self get_encoded_json_string:config];
            
            //call inform
            [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
        }
    }
}

-(void) prepare_data_for_third_party_response_result {
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    
    NSMutableString *responseResultThirdParty = [NSMutableString stringWithString:@"thirdparty://"];
    
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *percentEncodedString = [dataToAppitString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    [responseResultThirdParty appendString:@"?response="];
    [responseResultThirdParty appendString:[NSString stringWithFormat:@"%@",percentEncodedString]];
    
    NSURL* invokeAppitURL = [NSURL URLWithString:responseResultThirdParty];
    if([[UIApplication sharedApplication]canOpenURL:invokeAppitURL]) {
        [Settings setCurrentURL:urlRelode];
        [[UIApplication sharedApplication]openURL:invokeAppitURL];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Cant Open Third Party  Application "]
                                                       delegate:self cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void) prepare_data_for_image_proc{
    int mAlpha = 1;
    
    
    NSString *dFontStyle = @"Default", *hintMessageColor = @"606060", *instContinueButtonColor = @"FFFFFF", *instContinueButtonTextColor = @"487D95", *hintMessageSize = @"", *instructionTextColor = @"FFFFFF";
    
    int hintMessageColorAlpha = mAlpha, instContinueButtonAlpha = mAlpha, instContinueButtonTextAlpha = mAlpha, dOutsideFaceOutlineColorAlpha =mAlpha;
    
    NSMutableDictionary *uiDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *nonUIDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *dOutsideFaceOutlineColor = @"487D95";
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
    NSArray *imageProcessingArray = [dataToAppit objectForKey:@"imageProcessing"];
    imageProcessingData = [imageProcessingArray objectAtIndex:0];
    
    NSString *highResolutionImageMode = [imageProcessingData objectForKey:@"HighResolutionImageMode"];
    
    if([@"Y" isEqualToString:highResolutionImageMode]) {
        
        if([imageProcessingData objectForKey:@"instructionButtonColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonColor"] forKey:@"id_instruction_button_color"];
        }
        
        if([imageProcessingData objectForKey:@"instructionButtonColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonColorAlpha"] forKey:@"id_instruction_button_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"instructionButtonTXTColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonTXTColor"] forKey:@"id_instruction_button_txt_color"];
        }
        
        if([imageProcessingData objectForKey:@"instructionButtonTXTColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonTXTColorAlpha"] forKey:@"id_instruction_button_txt_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"EnableCaptureButton"]) {
            if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"EnableCaptureButton"]]) {
                [nonUIDictionary setObject:@"Y" forKey:@"id_capture_enable"];
            } else {
                [nonUIDictionary setObject:@"N" forKey:@"id_capture_enable"];
            }
        } else {
            [nonUIDictionary setObject:@"N" forKey:@"id_capture_enable"];
        }
        
        if([imageProcessingData objectForKey:@"ShowInstructionScreen"]) {
            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"ShowInstructionScreen"] forKey:@"id_show_instruction"];
        }
        
        if([imageProcessingData objectForKey:@"OCRMinimumLightThreshold"]) {
            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"OCRMinimumLightThreshold"] forKey:@"id_light_threshold"];
        }
        
        if([imageProcessingData objectForKey:@"MinFocusScoreThreshold"]) {
            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"MinFocusScoreThreshold"] forKey:@"id_min_focus_threshold"];
        }
        
        if([imageProcessingData objectForKey:@"GlarePercentageThreshold"]) {
            NSString *glarePercentageThreshold = [imageProcessingData objectForKey:@"GlarePercentageThreshold"];
            if([NS_String_Utils stringIsNilOrEmpty:glarePercentageThreshold]) {
                [nonUIDictionary setObject:@"" forKey:@"id_glare_percentage"];
            }  else {
                [nonUIDictionary setObject:[imageProcessingData objectForKey:@"GlarePercentageThreshold"] forKey:@"id_glare_percentage"];
            }
        }
        
        if([imageProcessingData objectForKey:@"EnableCaptureButtonTime"]) {
            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"EnableCaptureButtonTime"] forKey:@"id_enable_capture_button_time"];
        }
        
        if([imageProcessingData objectForKey:@"CapturePortrait"]) {
            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"CapturePortrait"] forKey:@"id_capture_portrait"];
        }
        
        if([imageProcessingData objectForKey:@"HighResolutionImageHeight"]) {
//           [nonUIDictionary setObject:[imageProcessingData objectForKey:@"HighResolutionImageHeight"] forKey:@"id_image_height"];
            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"HighResolutionImageHeight"] forKey:@"id_image_width"];
//             [nonUIDictionary setObject:@"1170" forKey:@"id_image_height"];
        }
        
        if([imageProcessingData objectForKey:@"HighResolutionImageWidth"]) {
//            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"HighResolutionImageWidth"] forKey:@"id_image_width"];
            [nonUIDictionary setObject:[imageProcessingData objectForKey:@"HighResolutionImageWidth"] forKey:@"id_image_height"];
//            [nonUIDictionary setObject:@"800" forKey:@"id_image_width"];
        }
        
        NSString *dIdOutlineColor = @"FFFFFF", *dDetectedIdOutlineColor = @"6EB24C", *dOutsideIdOutlineColor = @"FFFFFF",*dDetectedPOAOutlineColor = @"6EB24C",*dDetectedOutsideIdOutlineColor = @"FFFFFF",*titleMessageStyle = @"Normal", *hintMessageStyle = @"Normal" ,*titleMessageColor = @"FFFFFF", *backButtonColor = @"FEAD36", *titleTextFontSize=@"", *hintTextFontSize=@"", *idCaptureBorderType = @"Thick", *retryButtonColor = @"606060", *confirmButtonColor = @"606060", *retryButtonBordorColor = @"FFFFFF", *confirmButtonStyleColor = @"FFFFFF";
        
        NSString *idOutlineColor = dIdOutlineColor, *detectedidoutlinecolor = dDetectedIdOutlineColor, *idOutsideOutlineColor = dOutsideIdOutlineColor;
        
        int idOutlineColorAlpha = mAlpha,detectedidoutlinetransparency = mAlpha, idOutsideOutlineColorAlpha = mAlpha,titleMessageColorAlpha = mAlpha,backButtonColorAlpha = mAlpha, confirmButtonColorAlpha = mAlpha, retryButtonColorAlpha = mAlpha, retryButtonBorderColorAlpha = mAlpha, confirmButtonStyleColorAlpha = mAlpha;
    
        if([imageProcessingData objectForKey:@"IdOutlineColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"IdOutlineColor"] forKey:@"id_outline_color"];
        } else {
            [uiDictionary setObject:idOutlineColor forKey:@"id_outline_color"];
        }
        
        if([imageProcessingData objectForKey:@"idOutlineColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"idOutlineColorAlpha"] forKey:@"id_outline_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_outline_color_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"ColorOutsideOutline"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"ColorOutsideOutline"] forKey:@"id_outside_outline_color"];
        } else {
            [uiDictionary setObject:idOutsideOutlineColor forKey:@"id_outside_outline_color"];
        }
        
        if([imageProcessingData objectForKey:@"idOutsideOutlineColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"idOutsideOutlineColorAlpha"] forKey:@"id_outside_outline_color_aplha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_outside_outline_color_aplha"];
        }
        
        if([imageProcessingData objectForKey:@"DetectedIdOutlineColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"DetectedIdOutlineColor"] forKey:@"id_detected_id_outline_color"];
        } else {
            [uiDictionary setObject:dDetectedIdOutlineColor forKey:@"id_detected_id_outline_color"];
        }
        
        if([imageProcessingData objectForKey:@"detectedIdOutlineColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"detectedIdOutlineColorAlpha"] forKey:@"id_detected_id_outline_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_detected_id_outline_color_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"DetectedColorOutsideOutline"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"DetectedColorOutsideOutline"] forKey:@"id_detected_id_outside_outline_color"];
        } else {
            [uiDictionary setObject:dDetectedOutsideIdOutlineColor forKey:@"id_detected_id_outside_outline_color"];
        }
        
        if([imageProcessingData objectForKey:@"detectedIdOutsideOutlineColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"detectedIdOutsideOutlineColorAlpha"] forKey:@"id_detected_id_outside_outline_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_detected_id_outside_outline_color_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"headerStyleIOS"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"headerStyleIOS"] forKey:@"id_header_text_style"];
        } else {
            [uiDictionary setObject:titleMessageStyle forKey:@"id_header_text_style"];
        }
        
        if([imageProcessingData objectForKey:@"styleIOS"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"styleIOS"] forKey:@"id_label_text_style"];
        } else {
            [uiDictionary setObject:hintMessageStyle forKey:@"id_label_text_style"];
        }
        
        if([imageProcessingData objectForKey:@"headerTextLabelColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"headerTextLabelColor"] forKey:@"id_header_text_label_color"];
        } else {
            [uiDictionary setObject:titleMessageColor forKey:@"id_header_text_label_color"];
        }

        if([imageProcessingData objectForKey:@"headerTextLabelAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"headerTextLabelAlpha"] forKey:@"id_header_text_label_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_header_text_label_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"textLabelColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelColor"] forKey:@"id_label_text_color"];
        } else {
            [uiDictionary setObject:hintMessageColor forKey:@"id_label_text_color"];
        }
        
        if([imageProcessingData objectForKey:@"textLabelAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelAlpha"] forKey:@"id_label_text_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_label_text_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"backButtonColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"backButtonColor"] forKey:@"id_back_button_color"];
        } else {
            [uiDictionary setObject:backButtonColor forKey:@"id_back_button_color"];
        }
        
        if([imageProcessingData objectForKey:@"backButtonColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"backButtonColorAlpha"] forKey:@"id_back_button_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_back_button_color_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"headerTextLabelSize"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"headerTextLabelSize"] forKey:@"id_header_text_label_size"];
        } else {
            [uiDictionary setObject:titleTextFontSize forKey:@"id_header_text_label_size"];
        }
        
        if([imageProcessingData objectForKey:@"textLabelSize"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelSize"] forKey:@"id_label_text_size"];
        } else {
            [uiDictionary setObject:titleTextFontSize forKey:@"id_label_text_size"];
        }
        
        if([imageProcessingData objectForKey:@"idCaptureBorder"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"idCaptureBorder"] forKey:@"id_capture_border_style"];
        } else {
            [uiDictionary setObject:idCaptureBorderType forKey:@"id_capture_border_style"];
        }
        
        if([imageProcessingData objectForKey:@"IdAlignmentValue"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"IdAlignmentValue"] forKey:@"id_title_label_alignment"];
        } else {
            [uiDictionary setObject:@"Top" forKey:@"id_title_label_alignment"];
        }
        
        if([imageProcessingData objectForKey:@"IdHintMessageAlignmentValue"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"IdHintMessageAlignmentValue"] forKey:@"id_hint_message_alignment"];
        } else {
            [uiDictionary setObject:@"Center" forKey:@"id_hint_message_alignment"];
        }
        
        if([imageProcessingData objectForKey:@"IdTitleAlignment"]) {
            if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"IdTitleAlignment"]]) {
                [uiDictionary setObject:@"N" forKey:@"id_hide_id_title_label"];
            } else {
                [uiDictionary setObject:@"Y" forKey:@"id_hide_id_title_label"];
            }
        } else {
            [uiDictionary setObject:@"N" forKey:@"id_hide_id_title_label"];
        }
        
        if([imageProcessingData objectForKey:@"IdHintMessageAlignment"]) {
            if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"IdHintMessageAlignment"]]) {
                [uiDictionary setObject:@"N" forKey:@"id_hide_id_hint_message"];
            } else {
                [uiDictionary setObject:@"Y" forKey:@"id_hide_id_hint_message"];
            }
        } else {
            [uiDictionary setObject:@"N" forKey:@"id_hide_id_hint_message"];
        }
        
        if([imageProcessingData objectForKey:@"confirmButtonColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonColor"] forKey:@"id_confirm_button_color"];
        } else {
            [uiDictionary setObject:confirmButtonColor forKey:@"id_confirm_button_color"];
        }
        
        if([imageProcessingData objectForKey:@"confirmButtonColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonColorAlpha"] forKey:@"id_confirm_button_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_confirm_button_color_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"retryButtonColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonColor"] forKey:@"id_retry_button_color"];
        } else {
            [uiDictionary setObject:retryButtonColor forKey:@"id_retry_button_color"];
        }
        
        if([imageProcessingData objectForKey:@"retryButtonColorAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonColorAlpha"] forKey:@"id_retry_button_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_retry_button_color_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"retryButtonBorderColor"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonBorderColor"] forKey:@"id_retry_button_border_color"];
        } else {
            [uiDictionary setObject:retryButtonBordorColor forKey:@"id_retry_button_border_color"];
        }
        
        if([imageProcessingData objectForKey:@"retryButtonColorBorderAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonColorBorderAlpha"] forKey:@"id_retry_button_border_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_retry_button_border_color_alpha"];
        }
        
        if([imageProcessingData objectForKey:@"confirmButtonStyle"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonStyle"] forKey:@"id_confirm_button_background_color"];
        } else {
            [uiDictionary setObject:confirmButtonStyleColor forKey:@"id_confirm_button_background_color"];
        }
        
        if([imageProcessingData objectForKey:@"confirmButtonStyleAlpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonStyleAlpha"] forKey:@"id_confirm_button_background_color_alpha"];
        } else {
            [uiDictionary setObject:@"1" forKey:@"id_confirm_button_background_color_alpha"];
        }
        
        //IdCaptureBackGroundColor
        if([imageProcessingData objectForKey:@"id_capture_background_color"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_capture_background_color"] forKey:@"id_capture_background_color"];
        }
        
        if([imageProcessingData objectForKey:@"id_capture_background_color_alpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_capture_background_color_alpha"] forKey:@"id_capture_background_color_alpha"];
        }
        
        // IdCapture Success message color
        if([imageProcessingData objectForKey:@"id_capture_success_message_color"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_capture_success_message_color"] forKey:@"id_capture_success_message_color"];
        }
        
        if([imageProcessingData objectForKey:@"id_capture_success_message_color_alpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_capture_success_message_color_alpha"] forKey:@"id_capture_success_message_color_alpha"];
        }
        
        //IdCapture Button Color
        if([imageProcessingData objectForKey:@"id_capture_button_color"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_capture_button_color"] forKey:@"id_capture_button_color"];
        }
        
        if([imageProcessingData objectForKey:@"id_capture_button_alpha"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_capture_button_alpha"] forKey:@"id_capture_button_alpha"];
        }
        
        //ShadowColor
        if([imageProcessingData objectForKey:@"id_enable_label_shadow"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_enable_label_shadow"] forKey:@"id_enable_label_shadow"];
        }
        
        if([imageProcessingData objectForKey:@"id_label_shadow_enable"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_label_shadow_enable"] forKey:@"id_enable_label_shadow"];
        }
        
        //Disable Drawing Rect
        if([imageProcessingData objectForKey:@"id_disable_rectangle_drawing"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_disable_rectangle_drawing"] forKey:@"id_disable_rectangle_drawing"];
        }
        
        //Inst Img resource id
        if([imageProcessingData objectForKey:@"id_instruction_img_resource_id"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_instruction_img_resource_id"] forKey:@"id_instruction_img_resource_id"];
        }
        
        // Image edge threshold
        if([imageProcessingData objectForKey:@"id_image_edgethresh"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_image_edgethresh"] forKey:@"id_image_edgethresh"];
        }
        
        //Barcode Scan limi
        if([imageProcessingData objectForKey:@"barcode_scan_max_limit"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"barcode_scan_max_limit"] forKey:@"barcode_scan_max_limit"];
        }
        
        //MRZ Scan Limit
        if([imageProcessingData objectForKey:@"mrz_scan_max_limit"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"mrz_scan_max_limit"] forKey:@"mrz_scan_max_limit"];
        }
        
        //MRZ and Barcode Scan limit
        if([imageProcessingData objectForKey:@"mrz_and_barcode_scan_max_limit"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"mrz_and_barcode_scan_max_limit"] forKey:@"mrz_and_barcode_scan_max_limit"];
        }
        
        //Id focus score
        if([imageProcessingData objectForKey:@"id_focus_score"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_focus_score"] forKey:@"id_focus_score"];
        }
        
        // Id Saturation score
        if([imageProcessingData objectForKey:@"id_saturation_score"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_saturation_score"] forKey:@"id_saturation_score"];
        }
        
        // Id Zoom score
        if([imageProcessingData objectForKey:@"id_zoom_score"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_zoom_score"] forKey:@"id_zoom_score"];
        }
        
        // Title image bitmap
        if([imageProcessingData objectForKey:@"id_title_img_bitmap_base64"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_title_img_bitmap_base64"] forKey:@"id_title_img_bitmap_base64"];
        }
        
        // Id Open Camera
        if([imageProcessingData objectForKey:@"id_open_camera"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_open_camera"] forKey:@"id_open_camera"];
        }
        
        //Generic Document Field name
        if([imageProcessingData objectForKey:@"id_generic_doc_fieldname"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_generic_doc_fieldname"] forKey:@"id_generic_doc_fieldname"];
        }
        
        //label Text Type
        if([imageProcessingData objectForKey:@"id_label_text_type"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_label_text_type"] forKey:@"id_label_text_type"];
        }
        
        //Header Text Type
        if([imageProcessingData objectForKey:@"id_header_text_type"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_header_text_type"] forKey:@"id_header_text_type"];
        }
        
        //Title Image Alignment
        if([imageProcessingData objectForKey:@"id_title_image_alignment"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_title_image_alignment"] forKey:@"id_title_image_alignment"];
        }
        
        //Hide Title Image
        if([imageProcessingData objectForKey:@"id_hide_id_title_image"]) {
            [uiDictionary setObject:[imageProcessingData objectForKey:@"id_hide_id_title_image"] forKey:@"id_hide_id_title_image"];
        }
        
        /* Need to check
         id_label_text_type
         "id_header_text_type": "Default",
         "id_title_image_alignment": "Bottom",
         "id_hide_id_title_image": "N",*/
        
        if([imageProcessingData objectForKey:@"imageSnippetPresentFlag"] && [@"Y" isEqualToString:[imageProcessingData objectForKey:@"imageSnippetPresentFlag"]]) {
            
            NSMutableDictionary *snippetConfig = [[NSMutableDictionary alloc] init];
            
            NSMutableDictionary *snippetDict = [[NSMutableDictionary alloc] init];
            
            snippetConfig = [imageProcessingData objectForKey:@"imageSnippetConfig"];
            NSArray *snippetArray  = [snippetConfig objectForKey:@"ImageSnippetReverseMapping"];
            NSMutableArray *snippetNameArray = [ [NSMutableArray alloc] init];
            
            psgfKeyValueSnippetDictionary = [[NSMutableDictionary alloc] init];
            
            for(int i = 0; i < [snippetArray count]; i++)  {
                NSMutableDictionary *objectDictionary = [snippetArray objectAtIndex:i];
                NSString *responseFormFieldKey = [objectDictionary objectForKey:@"ResponseFormFieldKey"];
                NSString *snippetName = [objectDictionary objectForKey:@"SnippetName"];
                NSString *isMandatory = [objectDictionary objectForKey:@"IsMandatory"];
                
                if([@"Y" isEqualToString:isMandatory]) {
                    snippetName = [snippetName stringByAppendingString:@"*"];
                }
                [snippetDict setObject:snippetName forKey:snippetName];
                [psgfKeyValueSnippetDictionary setObject:responseFormFieldKey forKey:snippetName];
            }
            
            
            NSMutableDictionary *selfieCapDic = [[NSMutableDictionary alloc] init];
            [selfieCapDic setObject:uiDictionary forKey:@"snippet_capture"];
            [AppItSDK customizeUserInterface:selfieCapDic];
            
            [AppItSDK snippetCapture:self additionalDictionary:nil uiConfigDictionary:nonUIDictionary snippetFieldsDictionary:snippetDict isIdCaptureCall:true];
            
        } else {
            
            NSMutableDictionary *selfieCapDic = [[NSMutableDictionary alloc] init];
//            [selfieCapDic setObject:uiDictionary forKey:@"id_capture_back"];
            NSString *docSide = [imageProcessingData objectForKey:@"documentSide"];
            NSString *country = [imageProcessingData objectForKey:@"country"];
            NSString *state = [imageProcessingData objectForKey:@"state"];
            NSString *IDType = [imageProcessingData objectForKey:@"idType"];
            
            if(![NS_String_Utils stringIsNilOrEmpty:country]){
                [nonUIDictionary setObject:country forKey:@"country_code"];
            }
            
            if(![NS_String_Utils stringIsNilOrEmpty:state]){
                [nonUIDictionary setObject:state forKey:@"state_code"];
            }
            
            if(![NS_String_Utils stringIsNilOrEmpty:IDType]){
                [nonUIDictionary setObject:IDType forKey:@"id_type"];
            }
            
            if([[docSide uppercaseString] isEqualToString:[@"ID_BACK" uppercaseString]]) {
                
                [selfieCapDic setObject:uiDictionary forKey:@"id_capture_back"];
                [AppItSDK customizeUserInterface:selfieCapDic];
                [AppItSDK captureBackImage:self additionalDictionary:nil uiConfigDictionary:nonUIDictionary];
                
            } else {
                [selfieCapDic setObject:uiDictionary forKey:@"id_capture_front"];
                [AppItSDK customizeUserInterface:selfieCapDic];
                [AppItSDK captureFrontImage:self additionalDictionary:nil uiConfigDictionary:nonUIDictionary];
            }
            
            

            
        }
        
    } else {
        callbackExecuted = false;
        [self performSegueWithIdentifier:@"showOpenCvSeque" sender:self];
    }
}

-(void) prepare_data_for_fingerprint{
    
    int mAlpha = 1;
    
    NSString *dOutsideFaceOutlineColor = @"487D95", *dFontStyle=@"Default", *hintMessageColor = @"FFFFFF", *hintMessageSize = @"", *instContinueButtonColor = @"FFFFFF", *instContinueButtonTextColor = @"487D95";
    
    int hintMessageColorAlpha = mAlpha, instContinueButtonAlpha = mAlpha, instContinueButtonTextAlpha = mAlpha;
    
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    imageProcessingData = [NSMutableDictionary dictionary];
    NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
    NSArray *imageProcessingArray = [dataToAppit objectForKey:@"scanFingerprint"];
    imageProcessingData = [imageProcessingArray objectAtIndex:0];
    NSString *imageProcessingArray2 = [imageProcessingData objectForKey:@"FocusThreshold"];
    
    NSMutableDictionary *uiDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *nonUIDictionary = [[NSMutableDictionary alloc] init];
    
    if([imageProcessingData objectForKey:@"styleIOS"]){
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"styleIOS"] forKey:@"cfc_label_text_style"];
    }
    
    if([imageProcessingData objectForKey:@"textLabelColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelColor"] forKey:@"cfc_label_text_color"];
    }
    
    if([imageProcessingData objectForKey:@"textLabelAlpha"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelAlpha"] forKey:@"cfc_label_text_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"instructionButtonColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonColor"] forKey:@"cfc_instruction_button_color"];
    }
    
    if([imageProcessingData objectForKey:@"instructionButtonColorAlpha"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonColorAlpha"] forKey:@"cfc_instruction_button_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"instructionButtonTXTColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonTXTColor"] forKey:@"cfc_instruction_button_txt_color"];
    }
    
    if([imageProcessingData objectForKey:@"instructionButtonTXTColorAlpha"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonTXTColorAlpha"] forKey:@"cfc_instruction_button_txt_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"showInstruction"]) {
        
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"showInstruction"] forKey:@"cfc_show_instruction_screen"];
    }
    
    NSMutableDictionary *fingCapDict = [[NSMutableDictionary alloc] init];
    [fingCapDict setObject:uiDictionary forKey:@"camera_finger_capture"];
    [AppItSDK customizeUserInterface:fingCapDict];
    
    [AppItSDK captureFourFingerprint:self cameraFingerCaptureConfig:nonUIDictionary];
    
    //   // if(idfaceshowInstruction) {
    //    if(![NS_String_Utils stringIsNilOrEmpty:[imageProcessingData objectForKey:@"showInstruction"]] && [@"Y" isEqualToString:[imageProcessingData objectForKey:@"showInstruction"]] && idfaceshowInstruction) {
    //
    //
    //        // Text Size is similar to HintMEssageSize
    //        if([imageProcessingData objectForKey:@"HintMessageSize"]) {
    //            hintMessageSize = [imageProcessingData objectForKey:@"HintMessageSize"];
    //        }
    //
    //        if([imageProcessingData objectForKey:@"OutsideColorOfFaceOutline"]) {
    //            dOutsideFaceOutlineColor = [imageProcessingData objectForKey:@"OutsideColorOfFaceOutline"];
    //        }
    //
    //        InstructionViewController *controller = [InstructionViewController new];
    //        controller.delegate = self;
    //        controller.instruction_type = @"FP";
    //        controller.background_color = dOutsideFaceOutlineColor;
    //        controller.background_color_alpha = mAlpha;
    //        controller.instruction_image = nil;
    //        controller.imageType = @"";
    //        controller.instructionTextStyle = dFontStyle;
    //        controller.continueButtonStyle = dFontStyle;
    //        controller.instruction_text_color = hintMessageColor;
    //        controller.instruction_text_color_alpha = hintMessageColorAlpha;
    //        controller.continue_button_color = instContinueButtonColor;
    //        controller.continue_button_color_alpha = instContinueButtonAlpha;
    //        controller.continue_button_text_color = instContinueButtonTextColor;
    //        controller.continue_button_text_color_alpha = instContinueButtonTextAlpha;
    //        controller.instTextSize = hintMessageSize;
    //        [self presentViewController:controller animated:YES completion:nil];
    //    } else {
    //        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        FingerDetectionViewController2 *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FingerDetectionViewController2"];
    //        vc.delegate = self;
    //        vc.focus_threshold = [imageProcessingArray2 intValue];
    //        vc.init = true;
    //        [self presentModalViewController:vc animated:YES];
    //    }
}

-(void) checkCameraPermission {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) { // authorized
        NSLog(@"camera authorized");
        [AppItSDK scanBarcode:self];
    }
    else if(status == AVAuthorizationStatusDenied){ // denied
        if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                // Will get here on both iOS 7 & 8 even though camera permissions weren't required
                // until iOS 8. So for iOS 7 permission will always be granted.
                
                NSLog(@"DENIED");
                
                if (granted) {
                    // Permission has been granted. Use dispatch_async for any UI updating
                    // code because this block may be executed in a thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AppItSDK scanBarcode:self];
                    });
                } else {
                    NSLog(@"Not Authorized");
                    // Permission has been denied.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
                            if (canOpenSettings)
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        });
                    });
                }
            }];
        }
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
            if (canOpenSettings)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        });
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                NSLog(@"camera authorized");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AppItSDK scanBarcode:self];
                });
            }
        }];
    }
}

-(void) prepare_data_for_barcodeScan {
    BarcodeViewController *controller = [[BarcodeViewController alloc] init];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:controller animated:YES];
}

- (void) prepare_data_for_snippet_capture {
    
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
    NSArray *imageProcessingArray = [dataToAppit objectForKey:@"imageProcessing"];
    imageProcessingData = [imageProcessingArray objectAtIndex:0];
    
    NSMutableArray *snippetArrayList = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *snippetDict = [imageProcessingData objectForKey:@"imageSnippetConfig"];
    NSArray *snippetArray  = [requestParamJson objectForKey:@"snippetMappingList"];
    NSString *imageData = [requestParamJson objectForKey:@"capturedImageData"];
    
    NSURL *url = [NSURL URLWithString:imageData];
    NSData *imageNSData = [NSData dataWithContentsOfURL:url];
    UIImage *snippetImage = [UIImage imageWithData:imageNSData];
    
    NSMutableArray *snippetNameArray = [ [NSMutableArray alloc] init];
    
    NSMutableDictionary *snippetNameDictionary = [[NSMutableDictionary alloc] init];
    
    psgfKeyValueSnippetDictionary = [[NSMutableDictionary alloc] init];
    
    for(int i = 0; i < [snippetArray count]; i++)  {
        NSMutableDictionary *objectDictionary = [snippetArray objectAtIndex:i];
        NSString *responseFormFieldKey = [objectDictionary objectForKey:@"ResponseFormFieldKey"];
        NSString *snippetName = [objectDictionary objectForKey:@"SnippetName"];
        NSString *isMandatory = [objectDictionary objectForKey:@"IsMandatory"];
        if([@"Y" isEqualToString:isMandatory]) {
            snippetName = [snippetName stringByAppendingString:@"*"];
        }
        
        [snippetNameDictionary setObject:snippetName forKey:snippetName];
        
        [psgfKeyValueSnippetDictionary setObject:responseFormFieldKey forKey:snippetName];
    }
    
    NSData *imageSnippetData = UIImagePNGRepresentation(snippetImage);
    NSString *snippetStringImage =  [imageSnippetData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *setSnippetImage = [[NSMutableDictionary alloc] init];
    
    //    [setSnippetImage setObject:imageData forKey:@"SNIPPET"];
    [setSnippetImage setObject:snippetStringImage forKey:@"SNIPPET"];
    
    [AppItSDK setImages:setSnippetImage];
    
    [AppItSDK snippetCapture:self additionalDictionary:nil uiConfigDictionary:nil snippetFieldsDictionary:snippetNameDictionary isIdCaptureCall:false];
}

-(void) prepare_data_for_signatureCapture {
    CaptureSignatureController *controller = [[CaptureSignatureController alloc] init];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:controller animated:YES];
}

-(void) prepare_data_for_face_detection{
    
    int mAlpha = 1, dOutsideFaceOutlineColorAlpha = 1;
    
    NSString *dFaceOutlineColor = @"FFAD36", *dDetectedFaceOutlineColor = @"6EB24C", *dOutsideFaceOutlineColor = @"FFFFFF",*dDetectedOutsideFaceOutlineColor = @"FFFFFF", *dHeaderFontStyle=@"Default", *dFontStyle=@"Default", *titleMessageColor = @"FFFFFF", *hintMessageColor = @"FFFFFF", *backButtonColor= @"FEAD36", *titleMessageSize = @"", *hintMessageSize = @"", *instContinueButtonColor = @"FFFFFF", *instContinueButtonTextColor = @"487D95", *retryButtonColor = @"606060", *confirmButtonColor = @"606060", *retryButtonBorderColor = @"FFFFFF", *confirmButtonBackgroundColor = @"FFFFFF", *defaultFaceContour = @"Zero", *defaultPassiveFaceCapture = @"Y", *defaultManualCaptureEnable = @"Y", *defaultManualCaptureTime = @"60", *defaultManualCaptureButtonRetryCount = @"2";
    
    int faceoutlinetransparency = mAlpha, detectedfaceoutlinetransparency = mAlpha, outsideoutlinetransparency = mAlpha,detectedoutsideoutlinetransparency = mAlpha, titleMessageColorAlpha = mAlpha, hintMessageColorAlpha = mAlpha, backButtonColorAlpha = mAlpha, instContinueButtonAlpha = mAlpha, instContinueButtonTextAlpha = mAlpha, retryButtonAlpha = mAlpha,
    confirmButtonAlpha = mAlpha, retryButtonBorderAlpha = mAlpha, confirmButtonBackgroundAlpha = mAlpha;
    
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    
    if([dataToAppitString containsString:@"APPIT"]){
        
        NSArray *dataArray = [dataToAppitString componentsSeparatedByString:@"APPIT"];
        dataToAppitString = [dataArray objectAtIndex:7];
    }
    
    imageProcessingData = [NSMutableDictionary dictionary];
    
    NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
    NSArray *imageProcessingArray = [dataToAppit objectForKey:@"faceDetection"];
    imageProcessingData = [imageProcessingArray objectAtIndex:0];
    
    NSMutableDictionary *uiDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *nonUIDictionary = [[NSMutableDictionary alloc] init];
    
    if([imageProcessingData objectForKey:@"instructionButtonColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonColor"] forKey:@"fd_instruction_button_color"];
    }
    
    if([imageProcessingData objectForKey:@"instructionButtonColorAlpha"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonColorAlpha"] forKey:@"fd_instruction_button_alpha"];
        
    }
    
    if([imageProcessingData objectForKey:@"instructionButtonTXTColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonTXTColor"] forKey:@"fd_instruction_button_txt_color"];
        
    }
    
    if([imageProcessingData objectForKey:@"instructionButtonTXTColorAlpha"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"instructionButtonTXTColorAlpha"] forKey:@"fd_instruction_button_txt_alpha"];
        
    }
    
    if([imageProcessingData objectForKey:@"ShowInstructionScreen"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"ShowInstructionScreen"] forKey:@"fd_show_instruction_screen"];
    }
    
    NSString *faceoutlinecolor = dFaceOutlineColor, *detectedfaceoutlinecolor = dDetectedFaceOutlineColor, *outsideoutlinecolor = dOutsideFaceOutlineColor;
    
    BOOL isFaceTitleOnTop = false , isFaceHintMessageOnTop = true;
    
    if([imageProcessingData objectForKey:@"MinLightThreshold"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"MinLightThreshold"] forKey:@"fd_light_threshold"];
    }
    
    if([imageProcessingData objectForKey:@"FocusThreshold"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"FocusThreshold"] forKey:@"fd_focus_threshold"];
    }
    
    NSString *cameraType = [[imageProcessingData objectForKey:@"CameraType"] uppercaseString];
    
    if([cameraType isEqualToString:@"FRONT"]) {
        
        [nonUIDictionary setObject:@"Y" forKey:@"fd_launch_front_camera"];
        [nonUIDictionary setObject:@"N" forKey:@"fd_toggle_camera"];
        
    } else if([cameraType isEqualToString:@"BOTH"]) {
        
        [nonUIDictionary setObject:@"Y" forKey:@"fd_toggle_camera"];
        
        if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"LaunchFrontCamera"]]) {
            [nonUIDictionary setObject:@"Y" forKey:@"fd_launch_front_camera"];
        } else {
            [nonUIDictionary setObject:@"N" forKey:@"fd_launch_front_camera"];
        }
    } else if([cameraType isEqualToString:@"BOTHDEFAULTBACK"]) {
        [nonUIDictionary setObject:@"N" forKey:@"fd_launch_front_camera"];
        [nonUIDictionary setObject:@"Y" forKey:@"fd_toggle_camera"];
    } else if([cameraType isEqualToString:@"BOTHDEFAULTFRONT"]) {
        [nonUIDictionary setObject:@"Y" forKey:@"fd_launch_front_camera"];
        [nonUIDictionary setObject:@"Y" forKey:@"fd_toggle_camera"];
    } else {
        
        [nonUIDictionary setObject:@"N" forKey:@"fd_launch_front_camera"];
        [nonUIDictionary setObject:@"N" forKey:@"fd_toggle_camera"];
    }
    
    if([imageProcessingData objectForKey:@"FaceTitleAlignment"]) {
        if([@"top" isEqualToString:[imageProcessingData objectForKey:@"FaceTitleAlignment"]]) {
            [uiDictionary setObject:@"Y" forKey:@"fd_face_title_label_on_top"];
        } else {
            [uiDictionary setObject:@"N" forKey:@"fd_face_title_label_on_top"];
        }
    } else {
        [uiDictionary setObject:@"N" forKey:@"fd_face_title_label_on_top"];
    }
    
    if([imageProcessingData objectForKey:@"FaceHintMessageAlignment"]) {
        if([@"top" isEqualToString:[imageProcessingData objectForKey:@"FaceHintMessageAlignment"]]) {
            [uiDictionary setObject:@"Y" forKey:@"fd_face_hint_message_on_top"];
        } else {
            [uiDictionary setObject:@"N" forKey:@"fd_face_hint_message_on_top"];
        }
    } else {
        [uiDictionary setObject:@"Y" forKey:@"fd_face_hint_message_on_top"];
    }
    
    //Always need to show preview screen in case ok FaceDetection
    if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"ShowPreviewScreen"]]) {
        [nonUIDictionary setObject:@"Y" forKey:@"fd_show_preview_screen"];
    } else {
        [nonUIDictionary setObject:@"Y" forKey:@"fd_show_preview_screen"];
    }
    
    //***
    //TitleMessageStyle
    if([imageProcessingData objectForKey:@"headerStyleIOS"]) // headerStyle
    {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"headerStyleIOS"] forKey:@"fd_header_text_style"];
        
    }
    
    if([imageProcessingData objectForKey:@"headerTextLabelColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"headerTextLabelColor"] forKey:@"fd_header_text_label_color"];
    }

    if([imageProcessingData objectForKey:@"headerTextLabelAlpha"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"headerTextLabelAlpha"] forKey:@"fd_header_text_label_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"headerTextLabelSize"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"headerTextLabelSize"] forKey:@"fd_header_text_label_size"];
    }
    
    //HintMessageStyle
    if([imageProcessingData objectForKey:@"styleIOS"]) //style
    {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"styleIOS"] forKey:@"fd_label_text_style"];
    }
    
    if([imageProcessingData objectForKey:@"textLabelColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelColor"] forKey:@"fd_label_text_color"];
    }
    
    if([imageProcessingData objectForKey:@"textLabelAlpha"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelAlpha"] forKey:@"fd_label_text_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"textLabelSize"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"textLabelSize"] forKey:@"fd_label_text_size"];
    }
    
    //BackButtonColor-Alpha
    if([imageProcessingData objectForKey:@"backButtonColor"]) {
        
        [uiDictionary setObject:[imageProcessingData objectForKey:@"backButtonColor"] forKey:@"fd_back_button_color"];
    }
    
    if([imageProcessingData objectForKey:@"backButtonColorAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"backButtonColorAlpha"] forKey:@"fd_back_button_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"FaceDetectionThreshold"]) {
       [nonUIDictionary setObject:[imageProcessingData objectForKey:@"FaceDetectionThreshold"] forKey:@"fd_detection_threshold"];
    }
    
    if([imageProcessingData objectForKey:@"ImageSize"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"ImageSize"] forKey:@"fd_max_image_size"];
    }
    
    if([imageProcessingData objectForKey:@"FaceOutlineColor"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"FaceOutlineColor"] forKey:@"fd_outline_color"];
    } else {
        [uiDictionary setObject:faceoutlinecolor forKey:@"fd_outline_color"];
    }
    
    if([imageProcessingData objectForKey:@"DetectedFaceOutlineColor"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"DetectedFaceOutlineColor"] forKey:@"fd_detected_face_outline_color"];
    } else {
        [uiDictionary setObject:dDetectedFaceOutlineColor forKey:@"fd_detected_face_outline_color"];
    }
    
    if([imageProcessingData objectForKey:@"OutsideColorOfFaceOutline"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"OutsideColorOfFaceOutline"] forKey:@"fd_outside_face_outline_color"];
    } else {
        [uiDictionary setObject:dOutsideFaceOutlineColor forKey:@"fd_outside_face_outline_color"];
    }
    
    if([imageProcessingData objectForKey:@"OutsideDetectedColorOfFaceOutline"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"OutsideDetectedColorOfFaceOutline"] forKey:@"fd_detected_outside_face_outline_color"];
    } else {
        [uiDictionary setObject:dDetectedOutsideFaceOutlineColor forKey:@"fd_detected_outside_face_outline_color"];
    }
    
    //**
    if([imageProcessingData objectForKey:@"retryButtonColor"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonColor"] forKey:@"fd_retry_button_color"];
        
    } else {
        [uiDictionary setObject:retryButtonColor forKey:@"fd_retry_button_color"];
    }
    
    if([imageProcessingData objectForKey:@"retryButtonColorAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonColorAlpha"] forKey:@"fd_retry_button_color_alpha"];
    } else {
        [uiDictionary setObject:@"1" forKey:@"fd_retry_button_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"confirmButtonColor"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonColor"] forKey:@"fd_confirm_button_color"];
        
    } else {
        [uiDictionary setObject:confirmButtonColor forKey:@"fd_confirm_button_color"];
    }
    
    if([imageProcessingData objectForKey:@"confirmButtonColorAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonColorAlpha"] forKey:@"fd_confirm_button_color_alpha"];
    } else {
        [uiDictionary setObject:@"1" forKey:@"fd_confirm_button_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"retryButtonBorderColor"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonBorderColor"] forKey:@"fd_retry_button_border_color"];
        
    } else {
        [uiDictionary setObject:retryButtonBorderColor forKey:@"fd_retry_button_border_color"];
    }
    
    if([imageProcessingData objectForKey:@"retryButtonColorBorderAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"retryButtonColorBorderAlpha"] forKey:@"fd_retry_button_border_color_alpha"];
    } else {
        [uiDictionary setObject:@"1" forKey:@"fd_retry_button_border_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"confirmButtonStyle"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonStyle"] forKey:@"fd_confirm_button_background_color"];
    } else {
        [uiDictionary setObject:confirmButtonBackgroundColor forKey:@"fd_confirm_button_background_color"];
    }
    
    if([imageProcessingData objectForKey:@"confirmButtonStyleAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"confirmButtonStyleAlpha"] forKey:@"fd_confirm_button_background_color_alpha"];
    } else {
        [uiDictionary setObject:@"1" forKey:@"fd_confirm_button_background_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"faceOutlineHexColorAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"faceOutlineHexColorAlpha"] forKey:@"fd_outline_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"detectedFaceOutlineHexColorAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"detectedFaceOutlineHexColorAlpha"] forKey:@"fd_detected_face_outline_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"outsideFaceOutlineColorAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"outsideFaceOutlineColorAlpha"] forKey:@"fd_outside_face_outline_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"detectedFaceOutsideColorAlpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"detectedFaceOutsideColorAlpha"] forKey:@"fd_detected_outside_face_outline_color_alpha"];
    }
    
    if([imageProcessingData objectForKey:@"HideFaceTitleAlignment"]) {
        if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"HideFaceTitleAlignment"]]) {
            [uiDictionary setObject:@"N" forKey:@"fd_hide_face_title_lable"];
        } else {
            [uiDictionary setObject:@"Y" forKey:@"fd_hide_face_title_lable"];
        }
    } else {
        [uiDictionary setObject:@"N" forKey:@"fd_hide_face_title_lable"];
    }
    
    if([imageProcessingData objectForKey:@"HideFaceHintMessageAlignment"]) {
        if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"HideFaceHintMessageAlignment"]]) {
            [uiDictionary setObject:@"N" forKey:@"fd_hide_face_hint_message"];
        } else {
            [uiDictionary setObject:@"Y" forKey:@"fd_hide_face_hint_message"];
        }
    } else {
        [uiDictionary setObject:@"N" forKey:@"fd_hide_face_hint_message"];
    }
    
    if([imageProcessingData objectForKey:@"FACE_CONTOURS"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"FACE_CONTOURS"] forKey:@"fd_face_contours"];
    } else {
        [uiDictionary setObject:defaultFaceContour forKey:@"fd_face_contours"];
    }
    
    // Passive Or Active Face Detection Flag
    if([imageProcessingData objectForKey:@"FaceDetectionMethod"] && ![[imageProcessingData objectForKey:@"FaceDetectionMethod"] isEqualToString:@"Passive"]) {
        [uiDictionary setObject:@"N" forKey:@"fd_enable_passive_face_detection"];
    } else {
        [uiDictionary setObject:defaultPassiveFaceCapture forKey:@"fd_enable_passive_face_detection"];
    }
    
    //Enable Manual CaptureButton
    if([imageProcessingData objectForKey:@"EnableManualCapture"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"EnableManualCapture"] forKey:@"fd_enable_manual_capture"];
    } else {
        [uiDictionary setObject:defaultManualCaptureEnable forKey:@"fd_enable_manual_capture"];
    }
    
    //Enable Manual Capture Time
    if([imageProcessingData objectForKey:@"fd_enable_manual_capture_time"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_manual_capture_time"] forKey:@"fd_enable_manual_capture_time"];
    } else {
        [uiDictionary setObject:defaultManualCaptureTime forKey:@"fd_enable_manual_capture_time"];
    }
    
    // Enable Manual Capture Retry Count
    if([imageProcessingData objectForKey:@"fd_enable_manual_capture_retry_count"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_manual_capture_retry_count"] forKey:@"fd_enable_manual_capture_retry_count"];
    } else {
        [uiDictionary setObject:defaultManualCaptureButtonRetryCount forKey:@"fd_enable_manual_capture_retry_count"];
    }
    
    //Latest changes
    //TitleImageBitmap
    if([imageProcessingData objectForKey:@"fd_title_img_bitmap_base64"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_title_img_bitmap_base64"] forKey:@"fd_title_img_bitmap_base64"];
    }
    
    //Eye Open Threshold
    if([imageProcessingData objectForKey:@"fd_eye_open_threshold"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_eye_open_threshold"] forKey:@"fd_eye_open_threshold"];
    }
    
    //Spoof Detection threshold
    if([imageProcessingData objectForKey:@"fd_Spoof_Detection_threshold"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_Spoof_Detection_threshold"] forKey:@"fd_Spoof_Detection_threshold"];
    }
    
    //Saturation value
    if([imageProcessingData objectForKey:@"fd_saturation_value"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_saturation_value"] forKey:@"fd_saturation_value"];
    }
    
    //Manual Capture Button Time
    if([imageProcessingData objectForKey:@"fd_enable_manual_capture_time"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_manual_capture_time"] forKey:@"fd_enable_manual_capture_time"];
    }
    
    //Manual Capture Retry count
    if([imageProcessingData objectForKey:@"fd_enable_manual_capture_retry_count"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_manual_capture_retry_count"] forKey:@"fd_enable_manual_capture_retry_count"];
    }
    
    //Label Shadow
    if([imageProcessingData objectForKey:@"fd_enable_label_shadow"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_label_shadow"] forKey:@"fd_enable_label_shadow"];
    }
    
    //Upload Face data
    if([imageProcessingData objectForKey:@"fd_upload_facedata"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_upload_facedata"] forKey:@"fd_upload_facedata"];
    }
    
    //Passive OutsideFaceOut line color
    if([imageProcessingData objectForKey:@"fd_passive_outside_face_outline_color"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_passive_outside_face_outline_color"] forKey:@"fd_passive_outside_face_outline_color"];
    }
    
    //Passive OutsideFaceOut line color Alpha
    if([imageProcessingData objectForKey:@"fd_passive_outside_face_outline_color_alpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_passive_outside_face_outline_color_alpha"] forKey:@"fd_passive_outside_face_outline_color_alpha"];
    }
    
    //Instruction Preview Background color
    if([imageProcessingData objectForKey:@"fd_instruction_preview_background_color"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_instruction_preview_background_color"] forKey:@"fd_instruction_preview_background_color"];
    }
    
    //Instruction Preview Background color Alpha
    if([imageProcessingData objectForKey:@"fd_instruction_preview_background_color_alpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_instruction_preview_background_color_alpha"] forKey:@"fd_instruction_preview_background_color_alpha"];
    }
    
    //Success Message color
    if([imageProcessingData objectForKey:@"fd_capture_success_message_color"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_capture_success_message_color"] forKey:@"fd_capture_success_message_color"];
    }
    
    //Success Message Color Alpha
    if([imageProcessingData objectForKey:@"fd_capture_success_message_color_alpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_capture_success_message_color_alpha"] forKey:@"fd_capture_success_message_color_alpha"];
    }
    
    //Preview Screen Enable
    if([imageProcessingData objectForKey:@"fd_preview_screen"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_preview_screen"] forKey:@"fd_preview_screen"];
    }
    
    //Dummy Image color
    if([imageProcessingData objectForKey:@"fd_dummy_image_color"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_dummy_image_color"] forKey:@"fd_dummy_image_color"];
    }
    
    //Dummy Image color alpha
    if([imageProcessingData objectForKey:@"fd_dummy_image_color_alpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_dummy_image_color_alpha"] forKey:@"fd_dummy_image_color_alpha"];
    }
    
    //Instruction Image Resource ID
    if([imageProcessingData objectForKey:@"fd_instruction_img_resource_id"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_instruction_img_resource_id"] forKey:@"fd_instruction_img_resource_id"];
    }
    
    //Enable Cropping
    if([imageProcessingData objectForKey:@"fd_enable_cropping"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_cropping"] forKey:@"fd_enable_cropping"];
    }
    
    //Enable dot capture
    if([imageProcessingData objectForKey:@"fd_enable_donotcapture"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_donotcapture"] forKey:@"fd_enable_donotcapture"];
    }
    
    //Enable BGR
    if([imageProcessingData objectForKey:@"fd_enable_bgr"]) {
        [nonUIDictionary setObject:[imageProcessingData objectForKey:@"fd_enable_bgr"] forKey:@"fd_enable_bgr"];
    }
    
    //Face Hint ICON
    if([imageProcessingData objectForKey:@"fd_hide_face_hint_icon"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_hide_face_hint_icon"] forKey:@"fd_hide_face_hint_icon"];
    }
    
    //Hide Title Image
    if([imageProcessingData objectForKey:@"fd_hide_title_image"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_hide_title_image"] forKey:@"fd_hide_title_image"];
    }
    
    //Show Custom UI
    if([imageProcessingData objectForKey:@"fd_show_custom_ui"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_show_custom_ui"] forKey:@"fd_show_custom_ui"];
    }
    
    //Face Outline Image ID
    if([imageProcessingData objectForKey:@"fd_face_outline_image_id"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_face_outline_image_id"] forKey:@"fd_face_outline_image_id"];
    }
    
    //Outside Face Outline Image ID
    if([imageProcessingData objectForKey:@"fd_outside_face_outline_image_id"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_outside_face_outline_image_id"] forKey:@"fd_outside_face_outline_image_id"];
    }
    
    //Face Outline Progress Images
    if([imageProcessingData objectForKey:@"fd_face_outline_progress_images"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_face_outline_progress_images"] forKey:@"fd_face_outline_progress_images"];
    }
    
    //Face Outline Progress Image Delay
    if([imageProcessingData objectForKey:@"fd_face_outline_progress_images_delay"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_face_outline_progress_images_delay"] forKey:@"fd_face_outline_progress_images_delay"];
    }
    
    //Face Turn Arrow List
    if([imageProcessingData objectForKey:@"fd_face_turn_arrow_list"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_face_turn_arrow_list"] forKey:@"fd_face_turn_arrow_list"];
    }
    
    //Toggle Camera Button icon
    if([imageProcessingData objectForKey:@"fd_toggle_camera_button_icon"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_toggle_camera_button_icon"] forKey:@"fd_toggle_camera_button_icon"];
    }
    
    //CaptureButton Color
    if([imageProcessingData objectForKey:@"fd_capture_button_color"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_capture_button_color"] forKey:@"fd_capture_button_color"];
    }
    
    //Capture Button Color Alpha
    if([imageProcessingData objectForKey:@"fd_capture_button_color_alpha"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_capture_button_color_alpha"] forKey:@"fd_capture_button_color_alpha"];
    }
    
    //Label Text Type
    if([imageProcessingData objectForKey:@"fd_label_text_type"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_label_text_type"] forKey:@"fd_label_text_type"];
    }
    
    //Header Text type
    if([imageProcessingData objectForKey:@"fd_header_text_type"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_header_text_type"] forKey:@"fd_header_text_type"];
    }
    
    //Face hint icon on top
    if([imageProcessingData objectForKey:@"fd_face_hint_icon_on_top"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_face_hint_icon_on_top"] forKey:@"fd_face_hint_icon_on_top"];
    }
    
    //Face title image on top
    if([imageProcessingData objectForKey:@"fd_title_image_on_top"]) {
        [uiDictionary setObject:[imageProcessingData objectForKey:@"fd_title_image_on_top"] forKey:@"fd_title_image_on_top"];
    }
    
    NSMutableDictionary *selfieCapDic = [[NSMutableDictionary alloc] init];
    [selfieCapDic setObject:uiDictionary forKey:@"face_capture"];
    [AppItSDK customizeUserInterface:selfieCapDic];
    
    [AppItSDK detectFace:self faceCaptureConfig:nonUIDictionary];
}

- (NSDictionary*)parse_string_to_json:(NSString*)jsonString{
    NSError *jsonError;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    return json;
}

- (NSMutableDictionary*)build_common_return_data{
    NSMutableDictionary *config = [NSMutableDictionary
                                   dictionaryWithObjectsAndKeys:operation,@"operation",
                                   [requestParamJson objectForKey:@"callBackParam"],@"callBackParam",
                                   [requestParamJson objectForKey:@"callbackHandlerName"],@"callbackHandlerName",
                                   nil];
    return config;
}

- (NSString*)get_encoded_json_string:(NSMutableDictionary *)json {
    NSError *error = nil;
    //convert object to data
    NSData* configJsonData = [NSJSONSerialization dataWithJSONObject:json
                                                             options:NSJSONWritingPrettyPrinted error:&error];
    if (! configJsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:configJsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"Json Created: %@", jsonString);
        // Base64 encode the string to avoid problems
        NSData *plainData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedJsonString = [plainData base64EncodedStringWithOptions:0];
        return encodedJsonString;
    }
    return nil;
}

- (NSString*)get_json_string:(NSMutableDictionary *)json {
    NSError *error = nil;
    //convert object to data
    NSData* configJsonData = [NSJSONSerialization dataWithJSONObject:json
                                                             options:NSJSONWritingPrettyPrinted error:&error];
    if (! configJsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:configJsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

- (void)call_inform_js:(NSString *)functionName functionParameters:(NSString *)functionParameters{
    NSString *function = [NSString stringWithFormat:@"%@(\"%@\");", functionName, functionParameters];
    //NSString *function = [NSString stringWithFormat: @"invokeIosAppitHandler(\"%@\");", encodedJsonString];
    //[_webView stringByEvaluatingJavaScriptFromString:function];
    [_webView evaluateJavaScript:function completionHandler:nil];
}

-(void)fourFingerprintDetectionResponse : (NSMutableDictionary*) result {
    
    NSMutableDictionary *config = [self build_common_return_data];
    NSString * uuidString =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if ([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
        [config setObject:@"0" forKey:@"status"];
    }else{
        [config setObject:@"1" forKey:@"status"];
    }
    
    NSMutableDictionary *fingerDictionary = [[NSMutableDictionary alloc] init];
    
    if([result objectForKey:@"LMFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"LMFINGER"] forKey:@"LMFINGER"];
    }
    
    if([result objectForKey:@"LRFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"LRFINGER"] forKey:@"LRFINGER"];
    }
    
    if([result objectForKey:@"LLFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"LLFINGER"] forKey:@"LLFINGER"];
    }
    
    if([result objectForKey:@"LIFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"LIFINGER"] forKey:@"LIFINGER"];
    }
    
    if([result objectForKey:@"RRFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"RRFINGER"] forKey:@"RRFINGER"];
    }
    
    if([result objectForKey:@"RLFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"RLFINGER"] forKey:@"RLFINGER"];
    }
    
    if([result objectForKey:@"RIFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"RIFINGER"] forKey:@"RIFINGER"];
    }
    
    if([result objectForKey:@"RMFINGER"]) {
        [fingerDictionary setObject:[result objectForKey:@"RMFINGER"] forKey:@"RMFINGER"];
    }
    
    [config setObject:[self get_json_string:fingerDictionary] forKey:@"dataFromAppit"];
    [config setObject:[self deviceName] forKey:@"model"];
    [config setObject:uuidString forKey:@"serialNumber"];
    [config setObject:@"B" forKey:@"BackgroundColor"];
    [config setObject:@"Y" forKey:@"fingerprintPreview"];
    [config setObject:@"1" forKey:@"NFIQ"];
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
    
}

-(void)fingerDetectionResponse:(NSMutableDictionary *)result{
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    NSString * uuidString =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    if ([result count] > 0) {
        [config setObject:@"0" forKey:@"status"];
    }else{
        [config setObject:@"1" forKey:@"status"];
    }
    [config setObject:[self get_json_string:result] forKey:@"dataFromAppit"];
    [config setObject:[self deviceName] forKey:@"model"];
    [config setObject:uuidString forKey:@"serialNumber"];
    [config setObject:@"B" forKey:@"BackgroundColor"];
    [config setObject:@"Y" forKey:@"fingerprintPreview"];
    [config setObject:@"1" forKey:@"NFIQ"];
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

-(void)idInstructionScreenResponse : (id) instance {
    idfaceshowInstruction = false;
    [self prepare_data_for_image_proc];
}

-(void)faceInstructionScreenResponse :(id) instance {
    idfaceshowInstruction = false;
    [self prepare_data_for_face_detection];
}

-(void)fingerInstructionResponse :(id) instance {
    idfaceshowInstruction = false;
    [self prepare_data_for_fingerprint];
}

//-(void)snippetCaptureResponse : (NSMutableDictionary*) result instance:(id)instance {
//    NSLog(@"Snippet Capture Response");
//    NSMutableDictionary *responseData = [self build_common_return_data];
//    [responseData setObject:@"saveImageSnippet" forKey:@"callbackHandlerName"];
//    SnippetCaptureController *snippetController = (SnippetCaptureController*)instance;
//    NSString *responseBarcodeData = [self get_json_string:[snippetController finalResultDictionary]];
//    if([@"0" isEqualToString:[result objectForKey:@"statusCode"]]) {
//        [responseData setValue:@"0" forKey:@"status"];
//    } else if([@"1" isEqualToString:[result objectForKey:@"statusCode"]]) {
//        [responseData setValue:@"59" forKey:@"status"]; //Snippet Back button pressed
//    }
//    [responseData setValue:@"" forKey:@"message"];
//    [responseData setValue:responseBarcodeData forKey:@"dataFromAppit"];
//
//    //convert object to data
//    NSString *encodedResponseJsonString = [self get_encoded_json_string:responseData];
//
//    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedResponseJsonString];
//    //[responseData setValue:@"0" forKey:@"status"];
//}
//
-(void)captureSignatureResponse : (NSMutableDictionary*) result {

    NSMutableDictionary *responseData = [self build_common_return_data];

    NSMutableDictionary *responseBarcodeDict = [[NSMutableDictionary alloc] init];

    NSString *signatureCaptureImage = [result objectForKey:@"signatureImage"];

    if(nil != signatureCaptureImage) {
        [responseBarcodeDict setValue:signatureCaptureImage forKey:@"defaultBarcodeImage"];
    } else {
        [responseBarcodeDict setValue:@"" forKey:@"defaultBarcodeImage"];
    }

    NSString *responseBarcodeData = [self get_json_string:responseBarcodeDict];

    NSString *statusCode = [result objectForKey:@"statusCode"];
    if([@"0" isEqualToString:statusCode]) {
        [responseData setValue:@"57" forKey:@"status"];
    } else {
        [responseData setValue:@"56" forKey:@"status"];
    }
    [responseData setValue:responseBarcodeData forKey:@"dataFromAppit"];

    //convert object to data
    NSString *encodedResponseJsonString = [self get_encoded_json_string:responseData];

    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedResponseJsonString];

}

//-(void)captureSignatureResponse : (NSMutableDictionary*) result instance:(id)instance {
//    NSLog(@"Signature Capture");
//    NSMutableDictionary *responseData = [self build_common_return_data];
//
//    CaptureSignatureController *signature = (CaptureSignatureController*)instance;
//
//    //if([signature.responseStatus isEqualToString:@"54"]) {
//    NSMutableDictionary *responseBarcodeDict = [[NSMutableDictionary alloc] init];
//    [responseBarcodeDict setValue:signature.defaultSignatureStringData forKey:@"defaultBarcodeImage"];
//    NSString *responseBarcodeData = [self get_json_string:responseBarcodeDict];
//    [responseData setValue:signature.responseStatus forKey:@"status"];
//    [responseData setValue:responseBarcodeData forKey:@"dataFromAppit"];
//
//    //convert object to data
//    NSString *encodedResponseJsonString = [self get_encoded_json_string:responseData];
//
//    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedResponseJsonString];
//    //    }
//}

-(void)scanBarcodeResponse : (NSMutableDictionary*) result {
    NSMutableDictionary *responseData = [self build_common_return_data];
    NSString *responseBarcodeData = @"";
    if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
        
        NSMutableDictionary *responseBarcodeDict = [[NSMutableDictionary alloc] init];
        [responseBarcodeDict setValue:[result objectForKey:@"content"] forKey:@"content"];
        [responseBarcodeDict setValue:[result objectForKey:@"format"] forKey:@"format"];
        [responseBarcodeDict setValue:[result objectForKey:@"defaultBarcodeImage"] forKey:@"defaultBarcodeImage"];
        
        responseBarcodeData = [self get_json_string:responseBarcodeDict];
        
    } else {
        
        NSMutableDictionary *responseBarcodeDict = [[NSMutableDictionary alloc] init];
        [responseBarcodeDict setValue:@"" forKey:@"content"];
        [responseBarcodeDict setValue:@"" forKey:@"format"];
        [responseBarcodeDict setValue:@"" forKey:@"defaultBarcodeImage"];
        responseBarcodeData = [self get_json_string:responseBarcodeDict];
        
    }
    
    [responseData setValue:@"54" forKey:@"status"];
    [responseData setValue:responseBarcodeData forKey:@"dataFromAppit"];
    
    //convert object to data
    NSString *encodedResponseJsonString = [self get_encoded_json_string:responseData];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedResponseJsonString];
}

//-(void)barcodeScanningResponse:(NSMutableDictionary *)result instance:(id)instance {
//    NSLog(@"Scanning barcode");
//    NSMutableDictionary *responseData = [self build_common_return_data];
//
//    BarcodeViewController *barcode = (BarcodeViewController*)instance;
//
//    if([barcode.responseStatus isEqualToString:@"54"]) {
//
//        NSMutableDictionary *responseBarcodeDict = [[NSMutableDictionary alloc] init];
//        [responseBarcodeDict setValue:barcode.barcodeContentData forKey:@"content"];
//        [responseBarcodeDict setValue:barcode.barcodeFormatType forKey:@"format"];
//        //        [responseBarcodeDict setValue:barcode.barcodeImageData forKey:@"barcodeImage"];
//        [responseBarcodeDict setValue:barcode.defaultBarcodeImageStringData forKey:@"defaultBarcodeImage"];
//        NSString *responseBarcodeData = [self get_json_string:responseBarcodeDict];
//
//        // responseData = [[NSMutableDictionary alloc] init];
//        //        [responseData setValue:barcode.responseStatus forKey:@"responseCode"];
//        //[responseData setValue:responseBarcodeData forKey:@"responseData"];
//        [responseData setValue:barcode.responseStatus forKey:@"status"];
//        [responseData setValue:responseBarcodeData forKey:@"dataFromAppit"];
//
//        //convert object to data
//        NSString *encodedResponseJsonString = [self get_encoded_json_string:responseData];
//
//        //call inform
//        [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedResponseJsonString];
//
//    }
//}

-(void)faceDetectionResponse : (NSMutableDictionary*) result {
    
    NSMutableDictionary *configOriginal = [self build_common_return_data];
    
    //    FaceDetectionNewViewController* face = (FaceDetectionNewViewController*)instance;
    NSMutableDictionary *configEllipse;
    // if([instance isKindOfClass:[MlKitFaceController class]]) {
    //     MlKitFaceController *face = (MlKitFaceController*)instance;
//    [configOriginal setObject:[result objectForKey:@"statusCode"] forKey:@"status"];
    
    //Creating copy of config
    configEllipse = [configOriginal mutableCopy];
    
    if ([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
        [configOriginal setObject:[result objectForKey:@"statusCode"] forKey:@"status"];
        
        NSMutableDictionary *imagRespOriginal = [NSMutableDictionary new];
        [imagRespOriginal setObject:[result objectForKey:@"FACE"] forKey:@"OriginalImage"];
        //            [imagResp setObject:face.respEllipseImgData forKey:@"EllipseImage"];
        
        if([result objectForKey:@"Is_Auto_Capture"] && [@"Y" isEqualToString:[result objectForKey:@"Is_Auto_Capture"]]) {
            [imagRespOriginal setObject:@"N" forKey:@"is_manual_capture"];
        } else if([result objectForKey:@"Is_Auto_Capture"] && [@"N" isEqualToString:[result objectForKey:@"Is_Auto_Capture"]]) {
            [imagRespOriginal setObject:@"Y" forKey:@"is_manual_capture"];
        }
        
        NSMutableDictionary *imagRespEllipse = [NSMutableDictionary new];
        [imagRespEllipse setObject:[result objectForKey:@"OVAL_FACE"] forKey:@"EllipseImage"];
        if([result objectForKey:@"Is_Auto_Capture"] && [@"Y" isEqualToString:[result objectForKey:@"Is_Auto_Capture"]]) {
            [imagRespEllipse setObject:@"N" forKey:@"is_manual_capture"];
        } else if([result objectForKey:@"Is_Auto_Capture"] && [@"N" isEqualToString:[result objectForKey:@"Is_Auto_Capture"]]) {
            [imagRespEllipse setObject:@"Y" forKey:@"is_manual_capture"];
        }
        
        [configOriginal setObject:[self get_json_string:imagRespOriginal] forKey:@"dataFromAppit"];
        [configEllipse setObject:[self get_json_string:imagRespEllipse] forKey:@"dataFromAppit"];
        
    }else if ([[result objectForKey:@"statusCode"] isEqualToString:@"26"]) {
        [configOriginal setObject:@"26" forKey:@"status"];
        // Make toast with a duration and position
        [self.view makeToast:@"Face detection failed."
                    duration:5.0
                    position:CSToastPositionCenter];
    } else {
        [configOriginal setObject:@"26" forKey:@"status"];
    }
    
    //convert object to data
    NSString *encodedJsonStringOriginal = [self get_encoded_json_string:configOriginal];
    NSString *encodedJsonStringEllipse = [self get_encoded_json_string:configEllipse];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonStringEllipse];
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonStringOriginal];
    
}

//-(void)faceDetectionResponse:(NSMutableDictionary *)result instance:(id)instance;{
//
//    NSMutableDictionary *configOriginal = [self build_common_return_data];
//
//    //    FaceDetectionNewViewController* face = (FaceDetectionNewViewController*)instance;
//    NSMutableDictionary *configEllipse;
//    if([instance isKindOfClass:[MlKitFaceController class]]) {
//        MlKitFaceController *face = (MlKitFaceController*)instance;
//        [configOriginal setObject: face.responseStatus forKey:@"status"];
//
//        //Creating copy of config
//        configEllipse = [configOriginal mutableCopy];
//
//        if ([face.responseStatus isEqualToString:@"0"]) {
//            NSMutableDictionary *imagRespOriginal = [NSMutableDictionary new];
//            [imagRespOriginal setObject:face.respOrigionalImgData forKey:@"OriginalImage"];
//            //            [imagResp setObject:face.respEllipseImgData forKey:@"EllipseImage"];
//
//            NSMutableDictionary *imagRespEllipse = [NSMutableDictionary new];
//            [imagRespEllipse setObject:face.respEllipseImgData forKey:@"EllipseImage"];
//
//            [configOriginal setObject:[self get_json_string:imagRespOriginal] forKey:@"dataFromAppit"];
//            [configEllipse setObject:[self get_json_string:imagRespEllipse] forKey:@"dataFromAppit"];
//        }else if ([face.responseStatus isEqualToString:@"26"]) {
//            // Make toast with a duration and position
//            [self.view makeToast:@"Face detection failed."
//                        duration:5.0
//                        position:CSToastPositionCenter];
//        }
//    } else {
//        FacePreviewViewController *face = (FacePreviewViewController*)instance;
//        [configOriginal setObject: face.responseStatus forKey:@"status"];
//
//        //Creating copy of config
//        configEllipse = [configOriginal mutableCopy];
//
//        if ([face.responseStatus isEqualToString:@"0"]) {
//            NSMutableDictionary *imagRespOriginal = [NSMutableDictionary new];
//            [imagRespOriginal setObject:face.respOrigionalImgData forKey:@"OriginalImage"];
//            //            [imagResp setObject:face.respEllipseImgData forKey:@"EllipseImage"];
//
//            NSMutableDictionary *imagRespEllipse = [NSMutableDictionary new];
//            [imagRespEllipse setObject:face.respEllipseImgData forKey:@"EllipseImage"];
//
//            [configOriginal setObject:[self get_json_string:imagRespOriginal] forKey:@"dataFromAppit"];
//            [configEllipse setObject:[self get_json_string:imagRespEllipse] forKey:@"dataFromAppit"];
//        }else if ([face.responseStatus isEqualToString:@"26"]) {
//            // Make toast with a duration and position
//            [self.view makeToast:@"Face detection failed."
//                        duration:5.0
//                        position:CSToastPositionCenter];
//        }
//    }
//
//    //convert object to data
//    NSString *encodedJsonStringOriginal = [self get_encoded_json_string:configOriginal];
//    NSString *encodedJsonStringEllipse = [self get_encoded_json_string:configEllipse];
//
//    //call inform
//    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonStringEllipse];
//    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonStringOriginal];
//}

- (NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

- (void)handle_opencv_result_callback {
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
    NSArray *imageResultArray = [dataToAppit objectForKey:@"imageResult"];
    NSDictionary *imageResult = [imageResultArray objectAtIndex:0];
    NSString *imageName = [imageResult objectForKey:@"ImageName"];
    
    if (processedImage != nil) {
        
        NSMutableDictionary *imageData;
        
        if ( [imageName isEqualToString: @"ProcessedImage"] ) {
            imageData = [NSMutableDictionary
                         dictionaryWithObjectsAndKeys:processedImage,@"ImageData",
                         nil];
        }
        else if ( [imageName isEqualToString: @"Photo"] || [imageName isEqualToString: @"FaceImage"] ) {
            imageData = [NSMutableDictionary
                         dictionaryWithObjectsAndKeys:faceImage,@"ImageData",
                         nil];
        }else if ( [imageName isEqualToString: @"InputImage"] ) {
            imageData = [NSMutableDictionary
                         dictionaryWithObjectsAndKeys:inputImage,@"ImageData",
                         nil];
        }else if ( [imageName isEqualToString: @"MatchedTemplate"]) {
            imageData = [NSMutableDictionary
                         dictionaryWithObjectsAndKeys:matchedTemplate,@"ImageData",
                         nil];
        }
        
        if([isImageSnippetCapture isEqualToString:@"Y"]) {
            [imageData setObject:@"Y" forKey:@"ImageSnippetPresentFlag"];
            [imageData setObject:snippetDictionary forKey:@"snippetData"];
        }
        
        if(nil != barcodeDataDictionary && [barcodeDataDictionary count] > 0) {
            NSMutableDictionary *IDDataDict = [[NSMutableDictionary alloc] init];
            [IDDataDict setObject:barcodeDataDictionary forKey:@"IDData"];
            [imageData setObject:@"Y" forKey:@"BarcodePresentFlag"];
            [imageData setObject:IDDataDict forKey:@"BarcodeData"];
        }
        
        if(nil != mrzDataDictionary && [mrzDataDictionary count] > 0) {
            [imageData setObject:@"Y" forKey:@"MRZPresentFlag"];
            NSMutableDictionary *IDDataDict = [[NSMutableDictionary alloc] init];
            [IDDataDict setObject:mrzDataDictionary forKey:@"IDData"];
//            [imageData setObject:mrzDataDictionary forKey:@"MRZData"];
            [imageData setObject:IDDataDict forKey:@"MRZData"];
        }
        
        NSError *error = nil;
        NSData* configImageData = [NSJSONSerialization dataWithJSONObject:imageData
                                                                  options:NSJSONWritingPrettyPrinted error:&error];
        NSString *imageDataString = [[NSString alloc] initWithData:configImageData encoding:NSUTF8StringEncoding];
        //0 = Success
        [config setObject:@"0" forKey:@"status"];
        [config setObject:imageDataString forKey:@"dataFromAppit"];
    }else{
        //1 = Error
        [config setObject:@"1" forKey:@"status"];
    }
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

- (void)download_templates {
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
    NSArray *templateDownloadArray = [dataToAppit objectForKey:@"templateDownload"];
    NSDictionary *templateDownload = [templateDownloadArray objectAtIndex:0];
    //NSArray *templateIdsArray = [templateDownload objectForKey:@"TemplateIds"];
    NSString* downloadStatus;
    
    if(templateDownloadStatus == 0){
        idServerInterface = [IDServerInterface alloc];
        idServerInterface.currentTemplateLocation = currentTemplateLocation;
        
        BOOL status = [idServerInterface isTemplateDownloadingRequire:templateDownload];
        if(status){
            NSLog(@"download_templates : Templates update require...");
            NSString* statusCode = [idServerInterface downloadTemplates:templateDownload];
            templateDownloadStatus = 1;
            downloadStatus = @"23";
        }else{
            NSLog(@"download_templates : Templates are updated...");
            templateDownloadStatus = 0;
            downloadStatus = @"38";
        }
    }else{
        if ([idServerInterface getTemplateDownloadStatus] == 2){
            templateDownloadStatus = 2;
        }
        
        if(templateDownloadStatus == 1){
            downloadStatus = @"23";
        }else if(templateDownloadStatus == 2){
            templateDownloadStatus = 0;
            downloadStatus = @"0";
        }
    }
    //NSLog(@"templateDownloadStatus: %d", templateDownloadStatus);
    
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    [config setObject:downloadStatus forKey:@"status"];
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

- (void)download_templates_old {
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    
    NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"colorado_id_front" ofType:@"xml" inDirectory:@"/templates/xml"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSData *databuffer = [filemgr contentsAtPath: dataFile];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/colorado_id_front_new.xml"];
    NSString *fileData = [[NSString alloc] initWithData:databuffer encoding:NSUTF8StringEncoding];
    [fileData writeToFile:docPath
               atomically:YES
                 encoding:NSUTF8StringEncoding
                    error:NULL];
    
    [config setObject:@"TemplateDownloadCompleted" forKey:@"dataFromAppit"];
    
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

- (NSString*) process_image:(UIImage*)image resizeImage:(BOOL)resizeImage{
    
    if(image == nil){
        return nil;
    }
    
    NSString *imageSize = [imageProcessingData objectForKey:@"ImageSizeLimit"];
    
    //We will get image height and width only in case of skip-image processing
    NSString *imageHeight = [imageProcessingData objectForKey:@"HighResolutionImageHeight"];
    NSString *imageWidth = [imageProcessingData objectForKey:@"HighResolutionImageWidth"];
    
    if(resizeImage && ![NS_String_Utils stringIsNilOrEmpty:imageHeight] && ![NS_String_Utils stringIsNilOrEmpty:imageWidth]){
        CGFloat width = [imageWidth floatValue];
        CGFloat height = [imageHeight floatValue];
        image = [self imageWithImage:image convertToSize:CGSizeMake(width, height)];
    }
    
    int imageSizeLimit = 1000 * 1024;
    if (imageSize != nil) {
        imageSizeLimit = [imageSize intValue]*1024;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    
    if([imageData length] > imageSizeLimit){
        //For reducing image size use below jpeg percentage
        NSArray *jpegQlty = @[@0.85, @0.80, @0.75];
        
        for(int i=0; i<[jpegQlty count]; i++) {
            float qlty = [[jpegQlty objectAtIndex:i] floatValue];
            imageData = UIImageJPEGRepresentation(image, qlty);
            if([imageData length] <= imageSizeLimit){
                break;
            }
        }
    }
    
    NSString *base64 = [imageData base64EncodedStringWithOptions:0];
    return base64;
}

-(void)captureImageResponse : (NSMutableDictionary*) result {
    [self restrictRotation_toMaskAll:NO];
    NSLog(@"");
    NSString* summary;
    NSMutableDictionary *config = [self build_common_return_data];
    if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
        if(![NS_String_Utils stringIsNilOrEmpty:[result objectForKey:@"FRONT"]]) {
            processedImage = [result objectForKey:@"FRONT"];
        } else if(![NS_String_Utils stringIsNilOrEmpty:[result objectForKey:@"BACK"]]) {
            processedImage = [result objectForKey:@"BACK"];
        } else {
            processedImage = [result objectForKey:@""];
        }
        
        if([result objectForKey:@"barcode_data"]) {
            barcodeDataDictionary = [result objectForKey:@"barcode_data"];
        }
        
        if([result objectForKey:@"MRZData"]) {
            mrzDataDictionary = [result objectForKey:@"MRZData"];
        }
        
        summary = @"<OCRLayoutDef></OCRLayoutDef>";
        [config setObject:@"0" forKey:@"status"];
        [config setObject:summary forKey:@"dataFromAppit"];
    } else if([[result objectForKey:@"statusCode"] isEqualToString:@"2"]) {
        processedImage = @"";
        [config setObject:@"2" forKey:@"status"];
        callbackExecuted = true;
    } else {
        processedImage = @"";
        if (!callbackExecuted) {
            //1 = Error
            [config setObject:@"1" forKey:@"status"];
        }else{
            [config setObject:@"2" forKey:@"status"];
        }
    }
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

- (void)handle_opencv_callback:(UIViewController *)sourceViewController callbackFrom:(NSString*)callbackFrom {
    
    UIImage* image;
    NSString* summary;
    
//    if([sourceViewController isKindOfClass:[OpenCvViewControllerAppit class]]){
//        OpenCvViewControllerAppit* view = (OpenCvViewControllerAppit*)sourceViewController;
//
//        image = [view snap];
//        NSString *xml = [view xml];
//        UIImage* actualFaceImage = [view get_face_image];
//        UIImage* actualInputImage = [view get_input_image];
//        UIImage* matchedTemplateImage = [view get_matched_template];
//
//        summary = xml;
//
//        processedImage = [self process_image:image resizeImage:true];
//        faceImage = [self process_image:actualFaceImage resizeImage:false];
//        inputImage = [self process_image:actualInputImage resizeImage:false];
//        matchedTemplate = [self process_image:matchedTemplateImage resizeImage:false];
//    }else if([sourceViewController isKindOfClass:[SkipImageProcessingViewController class]]){
//        SkipImageProcessingViewController* view = (SkipImageProcessingViewController*)sourceViewController;
//        image = [view resultImage];
//        processedImage = [self process_image:image resizeImage:true];
//        snippetDictionary = [view finalResultDictionary];
//        isImageSnippetCapture = [view isImageSnippetCapture];
//        summary = @"<OCRLayoutDef></OCRLayoutDef>";
//    }
    
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    if (image != nil) {
        //0 = Success
        [config setObject:@"0" forKey:@"status"];
        [config setObject:summary forKey:@"dataFromAppit"];
    }else{
        if ([callbackFrom isEqualToString:@"BackButton"]) {
            //2 = Error
            [config setObject:@"2" forKey:@"status"];
            callbackExecuted = true;
        }else{
            if (!callbackExecuted) {
                //1 = Error
                [config setObject:@"1" forKey:@"status"];
            }else{
                [config setObject:@"2" forKey:@"status"];
            }
        }
    }
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

-(void)snippetCaptureResponse : (NSMutableDictionary *)result {
    NSLog(@"");
    [self restrictRotation_toMaskAll:NO];
    if(![operation isEqualToString:@"imageSnippetCapture"]) {
        NSString *resultImageString = @"";
        NSString* summary;
        UIImage* resultImage;
        if([result objectForKey:@"resultImage"]) {
            resultImageString = [result objectForKey:@"resultImage"];
            NSData* data = [[NSData alloc] initWithBase64EncodedString:resultImageString options:0];
            resultImage = [UIImage imageWithData:data];
        }
        processedImage = [self process_image:resultImage resizeImage:true];
        
        NSMutableDictionary *sniDict = [result objectForKey:@"SnippetDictionary"];
        
        NSMutableDictionary *PSGFKeySnipDict = [[NSMutableDictionary alloc] init];
        
        if(nil != sniDict && [sniDict count] > 0) {
            
            NSMutableDictionary *snippetObjDataDict = [[NSMutableDictionary alloc] init];
            
            [sniDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                
                NSString *psgfKey = [psgfKeyValueSnippetDictionary objectForKey:key];
                [snippetObjDataDict setObject:(NSString *)obj forKey:psgfKey];
                
            }];
            NSMutableArray *snippetDictArray = [[NSMutableArray alloc] init];
            [snippetDictArray addObject:snippetObjDataDict];
            [PSGFKeySnipDict setObject:snippetDictArray forKey:@"SnippetObjectData"];
        }
        
        //snippetCaptureData
        if(nil == snippetDictionary) {
            snippetDictionary = [[NSMutableDictionary alloc] init];
        }
        [snippetDictionary setObject:PSGFKeySnipDict forKey:@"snippetCaptureData"];
        
        isImageSnippetCapture = @"Y";
        summary = @"<OCRLayoutDef></OCRLayoutDef>";
        // build a config object and convert to json
        NSMutableDictionary *config = [self build_common_return_data];
        
        if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
            [config setObject:@"0" forKey:@"status"];
            [config setObject:summary forKey:@"dataFromAppit"];
        } else if([[result objectForKey:@"statusCode"] isEqualToString:@"1"]) {
            [config setObject:@"2" forKey:@"status"];
            callbackExecuted = true;
        } else {
            if (!callbackExecuted) {
                //1 = Error
                [config setObject:@"1" forKey:@"status"];
            }else{
                [config setObject:@"2" forKey:@"status"];
            }
        }
        //convert object to data
        NSString *encodedJsonString = [self get_encoded_json_string:config];
        
        //call inform
        [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
    } else {
        NSMutableDictionary *responseData = [self build_common_return_data];
        [responseData setObject:@"saveImageSnippet" forKey:@"callbackHandlerName"];
        
        NSMutableDictionary *sniDict = [result objectForKey:@"SnippetDictionary"];
        
        NSMutableDictionary *PSGFKeySnipDict = [[NSMutableDictionary alloc] init];
        
        if(nil != sniDict && [sniDict count] > 0) {
            
            NSMutableDictionary *snippetObjDataDict = [[NSMutableDictionary alloc] init];
            
            for(id key in sniDict) {
                NSString *psgfKey = [psgfKeyValueSnippetDictionary objectForKey:key];
                [snippetObjDataDict setObject:[sniDict objectForKey:key] forKey:psgfKey];
            }
            
            NSMutableArray *snippetDictArray = [[NSMutableArray alloc] init];
            [snippetDictArray addObject:snippetObjDataDict];
            [PSGFKeySnipDict setObject:snippetDictArray forKey:@"SnippetObjectData"];
        }
        
        NSMutableDictionary *finalSnippetDictionary = [[NSMutableDictionary alloc] init];
        [finalSnippetDictionary setObject:PSGFKeySnipDict forKey:@"snippetCaptureData"];
        
        NSString *snippetStringData = [self get_json_string:finalSnippetDictionary];
        
        if([@"0" isEqualToString:[result objectForKey:@"statusCode"]]) {
            [responseData setValue:@"0" forKey:@"status"];
        } else if([@"1" isEqualToString:[result objectForKey:@"statusCode"]]) {
            [responseData setValue:@"59" forKey:@"status"]; //Snippet Back button pressed
        }
        
        [responseData setValue:@"" forKey:@"message"];
        [responseData setValue:snippetStringData forKey:@"dataFromAppit"];
        
        //convert object to data
        NSString *encodedResponseJsonString = [self get_encoded_json_string:responseData];
        
        [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedResponseJsonString];
        
    }
}


- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showOpenCvSeque"]){
        
//        OpenCvViewControllerAppit *controller = (OpenCvViewControllerAppit *)segue.destinationViewController;
//        controller.path_to_xml_template = path_to_xml_template;
//        controller.currentTemplateLocation = currentTemplateLocation;
//        controller.single_high_res_snapshot_mode = false;
//        NSString *imageCaptureCount = [imageProcessingData objectForKey:@"ImageCaptureCount"];
//        int imagesToInsert = 4;
//        if (imageCaptureCount != nil) {
//            imagesToInsert = [imageCaptureCount intValue];
//        }
//        controller.ImagesToInsert = imagesToInsert;
//        if(imagesToInsert>1){
//            controller.ImagesToConsume = imagesToInsert-1;
//        }else{
//            controller.ImagesToConsume = 1;
//        }
//
//        NSString *OCRMinimumLightThreshold = [imageProcessingData objectForKey:@"OCRMinimumLightThreshold"];
//        if(OCRMinimumLightThreshold != nil)
//            controller.MinImageIntensity =  [OCRMinimumLightThreshold intValue];
//        else
//            controller.MinImageIntensity =  90;
//
//        NSString *MinFocusScoreThreshold = [imageProcessingData objectForKey:@"MinFocusScoreThreshold"];
//        if(MinFocusScoreThreshold != nil)
//            controller.MinImageFocusScore =  [MinFocusScoreThreshold intValue];
//        else
//            controller.MinImageFocusScore =  10;
//
//        NSString *templateIds = [imageProcessingData objectForKey:@"TemplateIds"];
//        controller.template_ids = templateIds;
//
//        NSString *enableGlareDetection = [imageProcessingData objectForKey:@"EnableGlareDetection"];
//        NSString *glarePercentageThreshold = [imageProcessingData objectForKey:@"GlarePercentageThreshold"];
//
//        if(enableGlareDetection != nil && [enableGlareDetection isEqualToString:@"Y"]){
//            controller.enable_glare_detection = true;
//        }else{
//            controller.enable_glare_detection = false;
//        }
//
//        if(glarePercentageThreshold!=nil){
//            controller.glare_percentage_threshold = [glarePercentageThreshold intValue];
//        }else{
//            controller.glare_percentage_threshold = 100;
//        }
//
//        NSString *dIdOutlineColor = @"FFAD36", *dDetectedIdOutlineColor = @"6EB24C", *dOutsideIdOutlineColor = @"487D95",*dDetectedPOAOutlineColor = @"6EB24C",*dDetectedOutsideIdOutlineColor = @"FFFFFF";
//
//        NSString *idOutlineColor = dIdOutlineColor, *detectedidoutlinecolor = dDetectedIdOutlineColor, *idOutsideOutlineColor = dOutsideIdOutlineColor;
//
//        int mAlpha = 1;
//
//        int idOutlineColorAlpha = mAlpha,detectedidoutlinetransparency = mAlpha, idOutsideOutlineColorAlpha = mAlpha;
//        controller.id_outline_color = idOutlineColor;
//        controller.id_outline_color_alpha = idOutlineColorAlpha;
//        controller.id_outline_outside_color = idOutsideOutlineColor;
//        controller.id_outline_outside_color_alpha = idOutsideOutlineColorAlpha;
//        controller.detected_id_outline_color = dDetectedIdOutlineColor;
//        controller.detected_id_outline_color_alpha = mAlpha;
//        controller.detected_id_outline_outside_color = dDetectedOutsideIdOutlineColor;
//        controller.modalPresentationStyle = UIModalPresentationFullScreen;
//        controller.detected_id_outline_outside_color_alpha = mAlpha;
        
    }else if([segue.identifier isEqualToString:@"showFaceDetectionSegue"]){
//        FaceDetectionViewController *controller = (FaceDetectionViewController *)segue.destinationViewController;
//        controller.light_threshold = [[imageProcessingData objectForKey:@"MinLightThreshold"] intValue];
//        controller.focus_threshold = [[imageProcessingData objectForKey:@"FocusThreshold"] intValue];
//        NSString *cameraType = [[imageProcessingData objectForKey:@"CameraType"] uppercaseString];
//        if([cameraType isEqualToString:@"FRONT"]){
//            controller.launch_front_camera = true;
//        }else{
//            controller.launch_front_camera = false;
//        }
//        controller.smile_width_percentage_threshold = [[imageProcessingData objectForKey:@"FaceDetectionThreshold"] intValue];
//        controller.modalPresentationStyle = UIModalPresentationFullScreen;
//        controller.image_size = [[imageProcessingData objectForKey:@"ImageSize"] intValue];
    }else if ([segue.identifier isEqualToString:@"showCardScanSegue"]){
//        ScanCardIOViewController *controller = (ScanCardIOViewController *)segue.destinationViewController;
//        controller.modalPresentationStyle = UIModalPresentationFullScreen;
    }else if([segue.identifier isEqualToString:@"showVideoRecordingSegue"]){
//        VideoRecorderViewController *controller = (VideoRecorderViewController *)segue.destinationViewController;
//        controller.modalPresentationStyle = UIModalPresentationFullScreen;
    }else if([segue.identifier isEqualToString:@"showPasswordSegue"]){
        PasswordViewController *controller = (PasswordViewController *)segue.destinationViewController;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        controller.currentURL = [Settings getCurrentURL];
    }else if([segue.identifier isEqualToString:@"showSkipImageProcessing"]) {
//        SkipImageProcessingViewController *controller = (SkipImageProcessingViewController *)segue.destinationViewController;
//
//        NSString *OCRMinimumLightThreshold = [imageProcessingData objectForKey:@"OCRMinimumLightThreshold"];
//        if(OCRMinimumLightThreshold != nil)
//            controller.MinImageIntensity =  [OCRMinimumLightThreshold intValue];
//        else
//            controller.MinImageIntensity =  70;
//
//        NSString *MinFocusScoreThreshold = [imageProcessingData objectForKey:@"MinFocusScoreThreshold"];
//        if(MinFocusScoreThreshold != nil)
//            controller.MinImageFocusScore =  [MinFocusScoreThreshold intValue];
//        else
//            controller.MinImageFocusScore =  15;
//
//        NSString *enableGlareDetection = [imageProcessingData objectForKey:@"EnableGlareDetection"];
//        NSString *glarePercentageThreshold = [imageProcessingData objectForKey:@"GlarePercentageThreshold"];
//
//        //        if(enableGlareDetection != nil && [enableGlareDetection isEqualToString:@"Y"]){
//        //            controller.enable_glare_detection = true;
//        //        }else{
//        //            controller.enable_glare_detection = false;
//        //        }
//
//        //if(glarePercentageThreshold!=nil){
//        if(![NS_String_Utils stringIsNilOrEmpty:glarePercentageThreshold]){
//            controller.glare_percentage_threshold = [glarePercentageThreshold intValue];
//        }else{
//            controller.glare_percentage_threshold = 2;
//        }
//
//        NSString *enableCapButton = [imageProcessingData objectForKey:@"EnableCaptureButton"];
//        NSString *enableCapButtonTime = [imageProcessingData objectForKey:@"EnableCaptureButtonTime"];
//
//        if(enableCapButton != nil && [enableCapButton isEqualToString:@"Y"]){
//            controller.enable_capture_button = true;
//        }else{
//            controller.enable_capture_button = false;
//        }
//
//        if(enableCapButtonTime!=nil){
//            controller.enable_capture_button_time = [enableCapButtonTime intValue];
//        }else{
//            controller.enable_capture_button_time = 10;
//        }
//
//        NSString *capturePortrait = [imageProcessingData objectForKey:@"CapturePortrait"];
//        NSString *height = [imageProcessingData objectForKey:@"HighResolutionImageHeight"];
//        NSString *width = [imageProcessingData objectForKey:@"HighResolutionImageWidth"];
//
//        if(capturePortrait != nil && [capturePortrait isEqualToString:@"N"]){
//            controller.capture_in_portrait_mode = false;
//        }else{
//            controller.capture_in_portrait_mode = true;
//            //Swaping width and height
//            NSString *swap = height;
//            height = width;
//            width = swap;
//        }
//
//        if(height!=nil){
//            controller.imageHeight = [height intValue];
//        }else{
//            controller.imageHeight = 830;
//        }
//
//        if(width!=nil){
//            controller.imageWidth = [width intValue];
//        }else{
//            controller.imageWidth = 1170;
//        }
//
//        NSString *dIdOutlineColor = @"FFAD36", *dDetectedIdOutlineColor = @"6EB24C", *dOutsideIdOutlineColor = @"487D95",*dDetectedPOAOutlineColor = @"6EB24C",*dDetectedOutsideIdOutlineColor = @"FFFFFF",*titleMessageStyle = @"Default", *hintMessageStyle = @"Default" ,*titleMessageColor = @"FFFFFF", *hintMessageColor = @"FFFFFF", *backButtonColor = @"FEAD36", *titleTextFontSize=@"", *hintTextFontSize=@"", *idCaptureBorderType = @"Thick", *retryButtonColor = @"FEAD36", *confirmButtonColor = @"FEAD36", *retryButtonBordorColor = @"FEAD36", *confirmButtonStyleColor = @"FFFFFF";
//
//        NSString *idOutlineColor = dIdOutlineColor, *detectedidoutlinecolor = dDetectedIdOutlineColor, *idOutsideOutlineColor = dOutsideIdOutlineColor;
//
//        int mAlpha = 1;
//
//        int idOutlineColorAlpha = mAlpha,detectedidoutlinetransparency = mAlpha, idOutsideOutlineColorAlpha = mAlpha,titleMessageColorAlpha = mAlpha,hintMessageColorAlpha = mAlpha,backButtonColorAlpha = mAlpha, confirmButtonColorAlpha = mAlpha, retryButtonColorAlpha = mAlpha, retryButtonBorderColorAlpha = mAlpha, confirmButtonStyleColorAlpha = mAlpha;
//        if([imageProcessingData objectForKey:@"IdOutlineColor"]) {
//            controller.id_outline_color = [imageProcessingData objectForKey:@"IdOutlineColor"];
//        } else {
//            controller.id_outline_color = idOutlineColor;
//        }
//
//        if([imageProcessingData objectForKey:@"idOutlineColorAlpha"]) {
//            controller.id_outline_color_alpha = [[imageProcessingData objectForKey:@"idOutlineColorAlpha"] intValue];
//        } else {
//            controller.id_outline_color_alpha = mAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"ColorOutsideOutline"]) {
//            controller.id_outline_outside_color = [imageProcessingData objectForKey:@"ColorOutsideOutline"];
//        } else {
//            controller.id_outline_outside_color = idOutsideOutlineColor;
//        }
//
//        if([imageProcessingData objectForKey:@"idOutsideOutlineColorAlpha"]) {
//            controller.id_outline_outside_color_alpha = [[imageProcessingData objectForKey:@"idOutsideOutlineColorAlpha"] intValue];
//        } else {
//            controller.id_outline_outside_color_alpha = mAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"DetectedIdOutlineColor"]) {
//            controller.detected_id_outline_color = [imageProcessingData objectForKey:@"DetectedIdOutlineColor"];
//        } else {
//            controller.detected_id_outline_color = dDetectedIdOutlineColor;
//        }
//
//        if([imageProcessingData objectForKey:@"detectedIdOutlineColorAlpha"]) {
//            controller.detected_id_outline_color_alpha = [[imageProcessingData objectForKey:@"detectedIdOutlineColorAlpha"] intValue];
//        } else {
//            controller.detected_id_outline_color_alpha = mAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"DetectedColorOutsideOutline"]) {
//            controller.detected_id_outline_outside_color = [imageProcessingData objectForKey:@"DetectedColorOutsideOutline"];
//        } else {
//            controller.detected_id_outline_outside_color = dDetectedOutsideIdOutlineColor;
//        }
//
//        if([imageProcessingData objectForKey:@"detectedIdOutsideOutlineColorAlpha"]) {
//            controller.detected_id_outline_outside_color_alpha = [[imageProcessingData objectForKey:@"detectedIdOutsideOutlineColorAlpha"] intValue];
//        } else {
//            controller.detected_id_outline_outside_color_alpha = mAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"headerStyleIOS"]) {
//            controller.title_message_style = [imageProcessingData objectForKey:@"headerStyleIOS"];
//        } else {
//            controller.title_message_style = titleMessageStyle;
//        }
//
//        if([imageProcessingData objectForKey:@"styleIOS"]) {
//            controller.hint_message_style = [imageProcessingData objectForKey:@"styleIOS"];
//        } else {
//            controller.hint_message_style = hintMessageStyle;
//        }
//
//        if([imageProcessingData objectForKey:@"headerTextLabelColor"]) {
//            controller.title_message_color = [imageProcessingData objectForKey:@"headerTextLabelColor"];
//        } else {
//            controller.title_message_color = titleMessageColor;
//        }
//        if([imageProcessingData objectForKey:@"headerTextLabelAlpha"]) {
//            controller.title_message_color_alpha = [[imageProcessingData objectForKey:@"headerTextLabelAlpha"] intValue];
//        } else {
//            controller.title_message_color_alpha = titleMessageColorAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"textLabelColor"]) {
//            controller.hint_message_color = [imageProcessingData objectForKey:@"textLabelColor"];
//        } else {
//            controller.hint_message_color = hintMessageColor;
//        }
//        if([imageProcessingData objectForKey:@"textLabelAlpha"]) {
//            controller.hint_message_color_alpha = [[imageProcessingData objectForKey:@"textLabelAlpha"] intValue];
//        } else {
//            controller.hint_message_color_alpha = hintMessageColorAlpha;
//        }
//        if([imageProcessingData objectForKey:@"backButtonColor"]) {
//            controller.back_button_color = [imageProcessingData objectForKey:@"backButtonColor"];
//        } else {
//            controller.back_button_color = backButtonColor;
//        }
//        if([imageProcessingData objectForKey:@"backButtonColorAlpha"]) {
//            controller.back_button_color_alpha = [[imageProcessingData objectForKey:@"backButtonColorAlpha"] intValue];
//        } else {
//            controller.back_button_color_alpha = backButtonColorAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"headerTextLabelSize"]) {
//            controller.header_font_size = [imageProcessingData objectForKey:@"headerTextLabelSize"];
//        } else {
//            controller.header_font_size = titleTextFontSize;
//        }
//        if([imageProcessingData objectForKey:@"textLabelSize"]) {
//            controller.text_font_size = [imageProcessingData objectForKey:@"textLabelSize"];
//        } else {
//            controller.text_font_size = titleTextFontSize;
//        }
//
//        if([imageProcessingData objectForKey:@"idCaptureBorder"]) {
//            controller.id_Capture_BorderType = [imageProcessingData objectForKey:@"idCaptureBorder"];
//        } else {
//            controller.id_Capture_BorderType = idCaptureBorderType;
//        }
//
//        if([imageProcessingData objectForKey:@"IdAlignmentValue"]) {
//            controller.id_Capture_Title_Align = [imageProcessingData objectForKey:@"IdAlignmentValue"];
//        } else {
//            controller.id_Capture_Title_Align = @"Top";
//        }
//
//        if([imageProcessingData objectForKey:@"IdHintMessageAlignmentValue"]) {
//            controller.id_Capture_Hint_Align = [imageProcessingData objectForKey:@"IdHintMessageAlignmentValue"];
//        } else {
//            controller.id_Capture_Hint_Align = @"Center";
//        }
//
//        if([imageProcessingData objectForKey:@"IdTitleAlignment"]) {
//            if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"IdTitleAlignment"]]) {
//                controller.hideIdCaptureTitle = false;
//            } else {
//                controller.hideIdCaptureTitle = true;;
//            }
//        } else {
//            controller.hideIdCaptureTitle = false;
//        }
//
//        if([imageProcessingData objectForKey:@"IdHintMessageAlignment"]) {
//            if([@"Y" isEqualToString:[imageProcessingData objectForKey:@"IdHintMessageAlignment"]]) {
//                controller.hideIdCaptureHintMessage = false;
//            } else {
//                controller.hideIdCaptureHintMessage = true;
//            }
//        } else {
//            controller.hideIdCaptureHintMessage = false;
//        }
//
//        if([imageProcessingData objectForKey:@"confirmButtonColor"]) {
//            controller.confirm_button_color = [imageProcessingData objectForKey:@"confirmButtonColor"];
//        } else {
//            controller.confirm_button_color = confirmButtonColor;
//        }
//
//        if([imageProcessingData objectForKey:@"confirmButtonColorAlpha"]) {
//            controller.confirm_button_color_alpha = [[imageProcessingData objectForKey:@"confirmButtonColorAlpha"] intValue];
//        } else {
//            controller.confirm_button_color_alpha = confirmButtonColorAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"retryButtonColor"]) {
//            controller.retry_button_color = [imageProcessingData objectForKey:@"retryButtonColor"];
//        } else {
//            controller.retry_button_color = retryButtonColor;
//        }
//
//        if([imageProcessingData objectForKey:@"retryButtonColorAlpha"]) {
//            controller.retry_button_color_alpha = [[imageProcessingData objectForKey:@"retryButtonColorAlpha"] intValue];
//        } else {
//            controller.retry_button_color_alpha = retryButtonColorAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"retryButtonBorderColor"]) {
//            controller.retry_button_border_color = [imageProcessingData objectForKey:@"retryButtonBorderColor"];
//        } else {
//            controller.retry_button_border_color = retryButtonBordorColor;
//        }
//
//        if([imageProcessingData objectForKey:@"retryButtonColorBorderAlpha"]) {
//            controller.retry_button_border_color_alpha = [[imageProcessingData objectForKey:@"retryButtonColorBorderAlpha"] intValue];
//        } else {
//            controller.retry_button_border_color_alpha = retryButtonBorderColorAlpha;
//        }
//
//        if([imageProcessingData objectForKey:@"confirmButtonStyle"]) {
//            controller.confirm_button_style_color = [imageProcessingData objectForKey:@"confirmButtonStyle"];
//        } else {
//            controller.confirm_button_style_color = confirmButtonStyleColor;
//        }
//
//        if([imageProcessingData objectForKey:@"confirmButtonStyleAlpha"]) {
//            controller.confirm_button_border_style_alpha = [[imageProcessingData objectForKey:@"confirmButtonStyleAlpha"] intValue];
//        } else {
//            controller.confirm_button_border_style_alpha = confirmButtonStyleColorAlpha;
//        }
//        controller.modalPresentationStyle = UIModalPresentationFullScreen;
//        controller.delegate = self;
//        controller.imageProcDataDic = imageProcessingData;
    }
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    // http://stackoverflow.com/questions/12561735/what-are-unwind-segues-for-and-how-do-you-use-them
    
    UIViewController* sourceViewController = segue.sourceViewController;
//
//    if ([sourceViewController isKindOfClass:[OpenCvViewControllerAppit class]])
//    {
//        [self handle_opencv_callback:sourceViewController callbackFrom:@"ImageConsumer"];
//    } else if([sourceViewController isKindOfClass:[SkipImageProcessingViewController class]]) {
//        SkipImageProcessingViewController* view = (SkipImageProcessingViewController*)sourceViewController;
//        if(!view.isFomResume) {
//            [self handle_opencv_callback:sourceViewController callbackFrom:@"ImageConsumer"];
//        } else {
//            [self performSelector:@selector(lanunchOnResume) withObject:self afterDelay:0.5];
//        }
//    }
}

- (void)lanunchOnResume
{
    [self idInstructionScreenResponse:nil];
}

- (IBAction)unwindToListBack:(UIStoryboardSegue *)segue {
    // http://stackoverflow.com/questions/12561735/what-are-unwind-segues-for-and-how-do-you-use-them
    
//    UIViewController* sourceViewController = segue.sourceViewController;
//
//    if ([sourceViewController isKindOfClass:[OpenCvViewControllerAppit class]] ||
//        [sourceViewController isKindOfClass:[SkipImageProcessingViewController class]])
//    {
//        [sourceViewController viewWillDisappear:false];
//        [self handle_opencv_callback:sourceViewController callbackFrom:@"BackButton"];
//
//    }else if ([sourceViewController isKindOfClass:[FaceDetectionViewController class]]){
//
//        NSMutableDictionary *configOriginal = [self build_common_return_data];
//
//        FaceDetectionViewController* face = (FaceDetectionViewController*)sourceViewController;
//
//        [configOriginal setObject: face.responseStatus forKey:@"status"];
//
//        //Creating copy of config
//        NSMutableDictionary *configEllipse = [configOriginal mutableCopy];
//
//        if ([face.responseStatus isEqualToString:@"0"]) {
//            NSMutableDictionary *imagRespOriginal = [NSMutableDictionary new];
//            [imagRespOriginal setObject:face.respOrigionalImgData forKey:@"OriginalImage"];
//            //            [imagResp setObject:face.respEllipseImgData forKey:@"EllipseImage"];
//
//            NSMutableDictionary *imagRespEllipse = [NSMutableDictionary new];
//            [imagRespEllipse setObject:face.respEllipseImgData forKey:@"EllipseImage"];
//
//            [configOriginal setObject:[self get_json_string:imagRespOriginal] forKey:@"dataFromAppit"];
//            [configEllipse setObject:[self get_json_string:imagRespEllipse] forKey:@"dataFromAppit"];
//        }else if ([face.responseStatus isEqualToString:@"26"]) {
//            // Make toast with a duration and position
//            [self.view makeToast:@"Face detection failed."
//                        duration:5.0
//                        position:CSToastPositionCenter];
//        }
//
//        //convert object to data
//        NSString *encodedJsonStringOriginal = [self get_encoded_json_string:configOriginal];
//        NSString *encodedJsonStringEllipse = [self get_encoded_json_string:configEllipse];
//
//        //call inform
//        [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonStringEllipse];
//        [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonStringOriginal];
//    }else if ([sourceViewController isKindOfClass:[ScanCardIOViewController class]]){
//
//        NSMutableDictionary *config = [self build_common_return_data];
//
//        ScanCardIOViewController* scan = (ScanCardIOViewController*)sourceViewController;
//
//        [config setObject: scan.responseStatus forKey:@"status"];
//
//        NSLog(@"Exit from Scan Card Screen %@", scan.responseStatus);
//
//        if ([scan.responseStatus isEqualToString:@"0"]) {
//            NSMutableDictionary *cardResp = [NSMutableDictionary new];
//            [cardResp setObject:scan.responseCardType forKey:@"CardType"];
//            [cardResp setObject:scan.responseCardNumber forKey:@"CardNumber"];
//            [cardResp setObject:scan.responseCardImage forKey:@"CardImage"];
//
//            [config setObject:[self get_json_string:cardResp] forKey:@"dataFromAppit"];
//        }
//
//        //convert object to data
//        NSString *encodedJsonString = [self get_encoded_json_string:config];
//
//        //call inform
//        [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
//    }
}

-(void)cardDetectionResponse:(NSMutableDictionary *)result {
    NSLog(@"Just to chek");
    
    NSMutableDictionary *config = [self build_common_return_data];
    
    [config setObject: [result objectForKey:@"statusCode"] forKey:@"status"];
    
    if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
        NSMutableDictionary *cardResp = [NSMutableDictionary new];
        [cardResp setObject:[result objectForKey:@"cardType"] forKey:@"CardType"];
        [cardResp setObject:[result objectForKey:@"cardNumber"] forKey:@"CardNumber"];
        [cardResp setObject:[result objectForKey:@"CARD"] forKey:@"CardImage"];
        
        [config setObject:[self get_json_string:cardResp] forKey:@"dataFromAppit"];
    } else if([[result objectForKey:@"statusCode"] isEqualToString:@"9"]) {
        [config setObject:@"18" forKey:@"status"];
    }
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
    
}

-(void)voiceRecordingResponse : (NSMutableDictionary*) result {
    NSLog(@"Voice Recording Response ");
    
    NSError *err = nil;
    
    NSData *audioData = [NSData dataWithContentsOfFile:[result objectForKey:@"VOICE_DATA"] options: 0 error:&err];
    
    [self handle_voice_recording_callback:audioData];
}

- (NSDictionary *) getVoiceRecordingConfigData
{
    NSString *dataToAppitString = [requestParamJson objectForKey:@"dataToAppit"];
    NSDictionary *dataToAppit = [self parse_string_to_json:dataToAppitString];
    NSArray *voiceRecordingConfigArray = [dataToAppit objectForKey:@"voiceRecordingConfig"];
    NSDictionary *voiceRecordingConfig = [voiceRecordingConfigArray objectAtIndex:0];
    return voiceRecordingConfig;
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSError *err = nil;
    
    NSLog(@"Recording Path : %@ ", [aRecorder.url path]);
    NSLog(@"Recording Path : Converted : %@ ", [AppItSDK getRecordedFilePath]);
    
    //    NSData *audioData = [NSData dataWithContentsOfFile:[aRecorder.url path] options: 0 error:&err];
    NSData *audioData = [NSData dataWithContentsOfFile:[AppItSDK getRecordedFilePath] options: 0 error:&err];
    [self handle_voice_recording_callback:audioData];
}

- (void)handle_voice_recording_callback:(NSData *)audio {
    //@autoreleasepool {
    float rateHertz = [AppItSDK getSampleRateHertz];
    NSString *time = [AppItSDK getRecordedAudioDuration];
    
    NSError *err = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[AppItSDK getRecordedFilePath] error:&err];
    
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    
    
    if (audio != nil) {
        /*NSString *tempaudioString = [audio base64EncodedStringWithOptions:0];
         NSLog(@"tempaudioString: %@",tempaudioString);*/
        //compress audio data
        NSData *compressedAudio = [audio gzippedData];
        //convert audio data to string
        NSString *audioString = [compressedAudio base64EncodedStringWithOptions:0];
        //0 = Success
        [config setObject:@"0" forKey:@"status"];
        [config setObject:audioString forKey:@"dataFromAppit"];
        [config setObject:@(rateHertz).stringValue forKey:@"sampleRateHertz"];
        [config setObject:time forKey:@"audioDuration"];
    }else{
        //1 = Error
        [config setObject:@"1" forKey:@"status"];
    }
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
    //}
}

-(void)handle_get_spectification_callback {
    NSString *currentiOSAppitVersion = [IDServerInterface getURLFromProperty:@"CFBundleShortVersionString"];
    
    NSString *buildnumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    NSMutableString *versionString = [NSMutableString stringWithFormat:@"%@(%@)", currentiOSAppitVersion, buildnumber];
    
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    
    NSString * uuidString =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSMutableDictionary *getSpecDict = [[NSMutableDictionary alloc] init];
    [getSpecDict setObject:@"iOSAppIT" forKey:@"APPIT"];
    [getSpecDict setObject:@"iOS" forKey:@"OS"];
    [getSpecDict setObject:versionString forKey:@"APPIT_VERSION"];
    [getSpecDict setObject:@"" forKey:@"APPIT_VERSION_CODE"];
    [getSpecDict setObject:uuidString forKey:@"APPIT_HRADWARE_ID"];
    
    NSString *getSpecString = [self get_json_string:getSpecDict];
    
    [config setValue:@"0" forKey:@"status"];
    [config setValue:getSpecString forKey:@"dataFromAppit"];
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

- (void)handle_appit_version_callback{
    
    //Current iOSAppit Version
    NSString *currentiOSAppitVersion = [IDServerInterface getURLFromProperty:@"CFBundleShortVersionString"];
    NSString *currentiOSAppitVersionCode = [currentiOSAppitVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *supportedFeatureList = @"imageProcResult,templateDownload,scanFingerprint,cancelScan,startVoiceRecording,stopVoiceRecording,faceDetection,cardIO,getAppitVersion,thirdPartyResult,signaturecapture,imageSnippetCapture";
    
    NSString * uuidString =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    //build a config object and convert to json
    NSMutableDictionary *config = [self build_common_return_data];
    
    [config setObject:@"0" forKey:@"status"];
    [config setObject:currentiOSAppitVersion forKey:@"dataFromAppit"];
    [config setObject:currentiOSAppitVersionCode forKey:@"appitVersionCode"];
    [config setObject:supportedFeatureList forKey:@"supportedFeatureList"];
    [config setObject:uuidString forKey:@"MACAddress"];
    [config setObject:uuidString forKey:@"DeviceSerialNumber"];
    
    //convert object to data
    NSString *encodedJsonString = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonString];
}

- (void)testOutputEqualsInput
{
    //set up data
    NSString *inputString = @"Hello World!";
    NSData *inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    
    //compress
    NSData *compressedData = [inputData gzippedData];
    
    NSString *compressedString = [compressedData base64EncodedStringWithOptions:0];
    NSLog(@"compressedString: %@",compressedString);
    //decode
    //NSData *outputData = [compressedData gunzippedData];
    //NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
}

- (IBAction)optionsButtonClicked:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                              message: nil
                                                                       preferredStyle: UIAlertControllerStyleActionSheet];
    //Added cancel button...it will be display in iPhones only
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"User clicked button called %@ or tapped elsewhere",action.title);
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"Settings" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"showPasswordSegue" sender:self];
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"Refresh" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self reloadURL];
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"Clear Data" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Confirmation"
                                              message:@"Are you sure you want to clear data?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                             //Clearing app data and refreshing url
                                                             [self clearAppDataAndRefresh];
                                                         }];
        [alertController addAction:actionCancel];
        [alertController addAction:actionOk];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"About Appit" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString * version = nil;
        version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!version) {
            version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        }
        
        NSString * buildnumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        
        NSMutableString *versionString = [NSMutableString stringWithFormat:@"%@ %@(%@)", @"Application Version", version, buildnumber];
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"About Appit"
                                              message:versionString
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             
                                                         }];
        [alertController addAction:actionOk];
        alertController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertController animated:YES completion:nil];
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"Exit" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // Handle Exit here
        //show confirmation message to user
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                        message:@"Are you sure you want to exit?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
    }]];
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = alertController.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = self.webView;
    //popover.sourceRect = self.webView.bounds;
    popover.barButtonItem = optionsButton;
    
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController: alertController animated: YES completion: nil];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)  // 0 == the cancel button
    {
        exit(0);
    }
}

-(void) reloadURL{
    NSString* url = [Settings getCurrentURL];
//    self.webView.allowsInlineMediaPlayback = YES;
//    self.webView.mediaPlaybackRequiresUserAction = NO;
//    self.webView.allowsPictureInPictureMediaPlayback = NO;
    
    [self setCurrentTemplateLocation:url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(void) setresettingUrl:(NSString*) resettingUrl {
    urlRelode = resettingUrl;
}

-(void) setCurrentTemplateLocation: (NSString*) currentURL{
    
    NSURL *nsurl = [NSURL URLWithString:currentURL];
    if(nsurl == nil || nsurl.absoluteString.length==0){
        currentTemplateLocation = @"DefaultTemplateLocation";
    }else{
        NSString *host = nsurl.host;
        if(host==nil || host.length==0){
            currentTemplateLocation = @"DefaultTemplateLocation";
        }else{
            currentTemplateLocation = host;
        }
    }
    
    [self createTemplatesDirectory : currentTemplateLocation];
    currentTemplateLocation = [NSString stringWithFormat:@"%@/%@", TEMPLATES_FOLDER, currentTemplateLocation];
    NSLog(@"Current Location %@", currentTemplateLocation);
}

-(NSString*)createTemplatesDirectory:(NSString*) currentTemplateFolder{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *currentTemplateFolderPath = [NSString stringWithFormat:@"/templates/%@", currentTemplateFolder];
    NSString *dataPath = [documentPath stringByAppendingPathComponent:currentTemplateFolderPath];
    
    if (![defaultManager fileExistsAtPath:dataPath]){
        [defaultManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
        
    }
    
    //Skip iCloud back-up of templates folder
    //[self addSkipBackupAttributeToItemAtPath:dataPath];
    return dataPath;
}

-(void)clearAppDataAndRefresh{
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    //Clearing cache directoty for clearing webview related data
    NSArray *cacheBasePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if(cacheBasePath != nil){
        NSString *cacheDirectory = ([cacheBasePath count] > 0) ? [cacheBasePath objectAtIndex:0] : nil;
        if(cacheDirectory != nil){
            NSArray *cacheDirectoryItems = [defaultManager contentsOfDirectoryAtPath:cacheDirectory error:nil];
            if(cacheDirectoryItems != nil){
                for (int i=0; i<cacheDirectoryItems.count; i++) {
                    NSString *item = [cacheDirectoryItems objectAtIndex:i];
                    NSString *itemPath = [NSString stringWithFormat:@"%@/%@",cacheDirectory, item];
                    if([item containsString:@"http"]){
                        BOOL isDeleted = [defaultManager removeItemAtPath:itemPath error:nil];
                        NSLog(@"clearAppDataAndRefresh>Deleting cache: filename: %@, isDeleted: %d", item, isDeleted);
                    }
                }
            }
        }
    }
    
    //Clearing templates folder for removing downloaded template
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(documentPaths != nil){
        NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
        if(documentPath != nil){
            NSString *templatesDirectory = [documentPath stringByAppendingPathComponent:@"templates"];
            if([defaultManager fileExistsAtPath:templatesDirectory]){
                NSArray *templatesDirectoryItems = [defaultManager contentsOfDirectoryAtPath:templatesDirectory error:nil];
                if(templatesDirectoryItems != nil){
                    for (int i=0; i<templatesDirectoryItems.count; i++) {
                        NSString *item = [templatesDirectoryItems objectAtIndex:i];
                        NSString *itemPath = [NSString stringWithFormat:@"%@/%@",templatesDirectory, item];
                        BOOL isDeleted = [defaultManager removeItemAtPath:itemPath error:nil];
                        NSLog(@"clearAppDataAndRefresh>Deleting template: filename: %@, isDeleted: %d", item, isDeleted);
                    }
                }
            }
        }
    }
    
    [self reloadURL];
}

// video rec

-(BOOL)initVideoCameraSession{
    
    NSLog(@"initVideoCameraSession - Start");
    
    captureSession = [[AVCaptureSession alloc] init];
    
    //Adding Video Input
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (videoDevice){
        NSError *error;
        videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if (!error){
            if ([captureSession canAddInput:videoInputDevice]){
                [captureSession addInput:videoInputDevice];
            }else{
                NSLog(@"Couldn't add video input");
            }
        }else{
            NSLog(@"Couldn't create video input");
        }
    }else{
        NSLog(@"Couldn't create video capture device");
    }
    
    
    //Adding Audio Input
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput){
        [captureSession addInput:audioInput];
    }
    
    
    //Adding Movie File Output
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    //    Float64 totalSeconds = 120;            //Total seconds
    Float64 totalSeconds = recordingDuration;
    int32_t preferredTimeScale = 30;    //Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(totalSeconds, preferredTimeScale);    //<<SET MAX DURATION
    [movieFileOutput setMaxRecordedDuration:maxDuration];
    //    [movieFileOutput setMinFreeDiskSpaceLimit:1024*1024];
    
    if ([captureSession canAddOutput:movieFileOutput]){
        [captureSession addOutput:movieFileOutput];
    }
    
    
    //Setting image quality
    [captureSession setSessionPreset:AVCaptureSessionPresetLow];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]){
        [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    
    //Adding Video Preview Layer
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //Frame Rate
    
    BOOL isFPSSupported = NO;
    AVCaptureDeviceFormat *currentFormat = [videoDevice activeFormat];
    for ( AVFrameRateRange *range in currentFormat.videoSupportedFrameRateRanges ) {
        if ( range.maxFrameRate >= 20 && range.minFrameRate <= 20 )        {
            isFPSSupported = YES;
            break;
        }
    }
    
    if( isFPSSupported ) {
        if ( [videoDevice lockForConfiguration:NULL] ) {
            videoDevice.activeVideoMaxFrameDuration = CMTimeMake( 1, 15 );
            videoDevice.activeVideoMinFrameDuration = CMTimeMake( 1, 15 );
            [videoDevice unlockForConfiguration];
        }
    }
    
    //Screen size according to current orientation
    CGRect layerRect = [[[self view] layer] bounds];
    //Creating CGRect of landscape and portrait mode...according to current screen size
    if(layerRect.size.height > layerRect.size.width){ //Launched in portrait mode
        portraitLayerRect = layerRect;
        landscapeLayerRect = CGRectMake(layerRect.origin.x, layerRect.origin.y, layerRect.size.height, layerRect.size.width);
    }else{                                            //Launched in landscape mode
        landscapeLayerRect = layerRect;
        portraitLayerRect = CGRectMake(layerRect.origin.x, layerRect.origin.y, layerRect.size.height, layerRect.size.width);
    }
    //Display Preview Layer
    [_videoPreviewLayer setBounds:layerRect];
    [_videoPreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    //[[[self view] layer] addSublayer:[[self CaptureManager] previewLayer]];
    //We use this instead so it goes on a layer behind our UI controls (avoids us having to manually bring each control to the front):
    UIView *cameraView = [[UIView alloc] init];
    [[self view] addSubview:cameraView];
    [self.view sendSubviewToBack:cameraView];
    
    
    [[cameraView layer] addSublayer:_videoPreviewLayer];
    
    
    //Start The Capture Session Running
    [captureSession startRunning];
    
    NSLog(@"initVideoCameraSession - End");
    
    [_webView setHidden:YES];
    
    return TRUE;
}

-(void)destroyVideoCameraSession{
    [captureSession stopRunning];
    [captureSession removeInput:videoInputDevice];
    [captureSession removeOutput:movieFileOutput];
    [_videoPreviewLayer removeFromSuperlayer];
    [playerViewController.view removeFromSuperview];
    
    _videoPreviewLayer = nil;
    playerViewController = nil;
    videoInputDevice = nil;
    captureSession = nil;
    movieFileOutput = nil;
    myTimer = nil;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    
    NSLog(@"captureOutput - Start");
    if(!isBackPressed) {
        [recordingButton setImage:[UIImage imageNamed:@"start_recording.png"] forState:UIControlStateNormal];
        BOOL recordedSuccessfully = YES;
        if ([error code] != noErr){
            // A problem occurred: Find out if the recording was successful.
            id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
            if (value){
                recordedSuccessfully = [value boolValue];
            }
        }
        
        if (recordedSuccessfully){
            [myTimer invalidate];
            NSLog(@"Recorded Successfully");
            CGRect layerRect = [[[self view] layer] bounds];
            recordingInProgress = NO;
            NSURL* finalURL = [self resizeVideo:outputFileURL];
            
            [self playRecordedVideo:finalURL];
            //For getting thumbnail image from video
            //        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outputFileURL options:nil];
            //        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            //        imageGenerator.appliesPreferredTrackTransform = YES;
            //        CMTime time = CMTimeMake(1, 1); // time range in which you want screenshot
            //        CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
            //        UIImage *uiimage = [[UIImage alloc] initWithCGImage:imgRef];
            
        }
    }
    NSLog(@"captureOutput - End");
}

-(void) playRecordedVideo:(NSURL*)path {
    // dispatch_async(dispatch_get_main_queue(), ^{
    CGRect layerRect = [[[self view] layer] bounds];
    int x = layerRect.size.width*65/100;
    int y = 0;
    int w = layerRect.size.width-x;
    int h = layerRect.size.height*35/100;
    AVPlayer *player = [AVPlayer playerWithURL:path];
    playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    
    [self addChildViewController:playerViewController];
    [self.view addSubview:playerViewController.view];
    if(isMinimized) {
        playerViewController.view.frame = CGRectMake(x,y,w,h);
    } else {
        int x = 50;
        int y = 110;
        if(layerRect.size.height <= 623) {
            x = 25;
            y = 60;
        }
        playerViewController.view.frame = CGRectMake(x,y,self.view.frame.size.width-x-x,self.view.frame.size.height-y-y);
    }
    
    NSError *err;
    
    NSData *videoData = [NSData dataWithContentsOfURL:path options: 0 error:&err];
    
    base64Encoded = [videoData base64EncodedStringWithOptions:0];
    recordingStarted = @"false";
    [self refreshVideoRecordingScreen];
    [self.view bringSubviewToFront:recordingButton];
    [self.view bringSubviewToFront:expandVideo];
    
    //   });
}

-(NSURL*)resizeVideo:(NSURL*)path{
    NSError *error = nil;
    __block NSURL *finalURL;
    
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output1.mov"];
    
    NSURL *outputURL1 = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]){
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO){
            //Error - handle if requried
        }
    }
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:outputURL1 fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter);
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:path options:nil] ;
    CMTime time = [avAsset duration];
    videoRecSeconds = ceil(time.value/time.timescale);
    NSDictionary *videoCleanApertureSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithInt:640], AVVideoCleanApertureWidthKey,
                                                [NSNumber numberWithInt:480], AVVideoCleanApertureHeightKey,
                                                [NSNumber numberWithInt:10], AVVideoCleanApertureHorizontalOffsetKey,
                                                [NSNumber numberWithInt:10], AVVideoCleanApertureVerticalOffsetKey,
                                                nil];
    NSDictionary *codecSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:200000], AVVideoAverageBitRateKey,
                                   [NSNumber numberWithInt:24],AVVideoMaxKeyFrameIntervalKey,
                                   videoCleanApertureSettings, AVVideoCleanApertureKey,
                                   nil];
    NSDictionary *videoCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                              AVVideoCodecH264, AVVideoCodecKey,
                                              codecSettings,AVVideoCompressionPropertiesKey,
                                              [NSNumber numberWithInt:640], AVVideoWidthKey,
                                              [NSNumber numberWithInt:480], AVVideoHeightKey,
                                              nil];
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoCompressionSettings];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    NSError *aerror = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:avAsset error:&aerror];
    AVAssetTrack *videoTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    videoWriterInput.transform = videoTrack.preferredTransform;
    NSDictionary *videoOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *asset_reader_output = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoOptions];
    [reader addOutput:asset_reader_output];
    //audio setup
    AVAssetWriterInput* audioWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeAudio
                                            outputSettings:nil];
    //  AVAssetReader *audioReader = [AVAssetReader assetReaderWithAsset:avAsset error:&error];
    AVAssetTrack* audioTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    AVAssetReader *audioReader;
    AVAssetReaderOutput *readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
    
    if(isMute) {
        AVMutableComposition *composition = [AVMutableComposition composition];
        
        AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        CMTimeRange x = CMTimeRangeMake(kCMTimeZero, [avAsset duration]);
        
        bool ok = [compositionVideoTrack insertTimeRange:x ofTrack:audioTrack atTime:kCMTimeZero error:nil];
        audioReader = [AVAssetReader assetReaderWithAsset:composition error:&error];
    } else {
        audioReader = [AVAssetReader assetReaderWithAsset:avAsset error:&error];
        [audioReader addOutput:readerOutput];
    }
    
    NSParameterAssert(audioWriterInput);
    NSParameterAssert([videoWriter canAddInput:audioWriterInput]);
    audioWriterInput.expectsMediaDataInRealTime = NO;
    [videoWriter addInput:audioWriterInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    [reader startReading];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t _processingQueue = dispatch_queue_create("assetAudioWriterQueue", NULL);
    [videoWriterInput requestMediaDataWhenReadyOnQueue:_processingQueue usingBlock:
     ^{
         while ([videoWriterInput isReadyForMoreMediaData]) {
             CMSampleBufferRef sampleBuffer;
             if ([reader status] == AVAssetReaderStatusReading &&
                 (sampleBuffer = [asset_reader_output copyNextSampleBuffer])) {
                 BOOL result = [videoWriterInput appendSampleBuffer:sampleBuffer];
                 CFRelease(sampleBuffer);
                 if (!result) {
                     // PROBLEM SEEMS TO BE HERE... result is getting false value....
                     [reader cancelReading];
                     NSLog(@"NO RESULT");
                     NSLog(@"videoWriter.error: %@", videoWriter.error);
                     break;
                 }
             } else {
                 [videoWriterInput markAsFinished];
                 switch ([reader status]) {
                     case AVAssetReaderStatusUnknown:
                         break;
                     case AVAssetReaderStatusReading:
                         // the reader has more for other tracks, even if this one is done
                         break;
                     case AVAssetReaderStatusCompleted:
                         // your method for when the conversion is done
                         // should call finishWriting on the writer
                         //hook up audio track
                         [audioReader startReading];
                         [videoWriter startSessionAtSourceTime:kCMTimeZero];
                         // dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
                         // [audioWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^
                         //{
                         NSLog(@"Request");
                         NSLog(@"Asset Writer ready :%d",audioWriterInput.readyForMoreMediaData);
                         while (audioWriterInput.readyForMoreMediaData) {
                             CMSampleBufferRef nextBuffer;
                             if ([audioReader status] == AVAssetReaderStatusReading &&
                                 (nextBuffer = [readerOutput copyNextSampleBuffer])) {
                                 NSLog(@"Ready");
                                 if (nextBuffer) {
                                     NSLog(@"NextBuffer");
                                     [audioWriterInput appendSampleBuffer:nextBuffer];
                                 }
                             }else{
                                 [audioWriterInput markAsFinished];
                                 switch ([audioReader status]) {
                                     case AVAssetReaderStatusCompleted:
                                         [videoWriter finishWriting];
                                         NSLog(@"setting  final... the URL");
                                         //  self.finalURL=[[NSURL alloc]initFileURLWithPath:newName];
                                         finalURL = [[NSURL alloc]initFileURLWithPath:outputPath];
                                         dispatch_semaphore_signal(semaphore);
                                         //[self playRecordedVideo:finalURL];
                                         break;
                                 }
                             }
                         }
                         break;
                     case AVAssetReaderStatusFailed:
                         [videoWriter cancelWriting];
                         break;
                     case AVAssetReaderStatusCancelled:
                         break;
                 }
                 break;
             }
         }
     }
     ];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"Write Ended");
    return finalURL;
}

-(void)refreshVideoRecordingScreen{
    _videoPreviewLayer.borderWidth = 0.0f;
    playerViewController.view.layer.borderWidth = 0.0f;
    if(fullScreen){
        if([recordingStarted isEqualToString:@"true"]){
            [toogleCamera setHidden:YES];
            [muteUnmuteBtn setHidden:YES];
            [playPauseVideo setHidden:YES];
            //[progressView setHidden:NO];
            [progressView setHidden:YES];
            [backUIButton setHidden:NO];
            [recordingTimeLabel setHidden:NO];
            [recordingLabel setHidden:NO];
            [labelScrolledData setHidden:NO];
        } else if([recordingStarted isEqualToString:@"false"]){
            [playPauseVideo setHidden:NO];
            playerViewController.showsPlaybackControls = true;
            [progressView setHidden:YES];
            [backUIButton setHidden:NO];
            [recordingTimeLabel setHidden:NO];
            [recordingLabel setHidden:NO];
            [labelScrolledData setHidden:NO];
        } else if([recordingStarted isEqualToString:@"nil"]){
            //[playPauseVideo setHidden:NO];
            [recordingButton setHidden:NO];
            [toogleCamera setHidden:NO];
            [muteUnmuteBtn setHidden:NO];
            [expandVideo setHidden:NO];
            [backUIButton setHidden:NO];
            [recordingTimeLabel setHidden:NO];
            [recordingLabel setHidden:NO];
            [labelScrolledData setHidden:NO];
        }
    }else{
        _videoPreviewLayer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
        _videoPreviewLayer.borderWidth = 2.0f;
        if([recordingStarted isEqualToString:@"true"]){
            [toogleCamera setHidden:YES];
            [muteUnmuteBtn setHidden:YES];
            [playPauseVideo setHidden:YES];
            //[progressView setHidden:NO];
            [progressView setHidden:YES];
            [backUIButton setHidden:YES];
            [recordingTimeLabel setHidden:NO];
            [recordingLabel setHidden:NO];
            [labelScrolledData setHidden:NO];
        } else if([recordingStarted isEqualToString:@"false"]){
            [playPauseVideo setHidden:YES];
            playerViewController.showsPlaybackControls = false;
            playerViewController.view.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor;
            playerViewController.view.layer.borderWidth = 2.0f;
            [progressView setHidden:YES];
            [backUIButton setHidden:YES];
            [recordingTimeLabel setHidden:NO];
            [recordingLabel setHidden:NO];
            [labelScrolledData setHidden:NO];
        } else if([recordingStarted isEqualToString:@"nil"]){
            [recordingButton setHidden:NO];
            [toogleCamera setHidden:YES];
            [muteUnmuteBtn setHidden:YES];
            [backUIButton setHidden:YES];
            [recordingTimeLabel setHidden:NO];
            [recordingLabel setHidden:NO];
            [labelScrolledData setHidden:NO];
        }
    }
}

-(void) restrictRotation_toMaskAll:(BOOL) restriction
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.restrictOrientationToSupportAll = restriction;
}

-(void)addFooter{
    bool isIphoneX = false;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        NSLog(@"iPhone");
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        
        switch (height) {
                
            case 2688:
                isIphoneX = true;
                break;
            case 1792:
                isIphoneX = true;
                break;
            case 2436:
                isIphoneX = true;
                break;
        }
    }
    
    if(isIphoneX) {
        if(self.webView != nil){
            self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 130);
        }
    }
}

-(void) checkCameraPermission_videoConference:(NSDictionary*)videoConfDictionary {
    
    NSMutableDictionary *videoConferenceDictionary = [[NSMutableDictionary alloc] init];
        
    [videoConferenceDictionary setObject:[videoConfDictionary objectForKey:@"conferenceId"] forKey:@"conferenceId"];
    [videoConferenceDictionary setObject:[videoConfDictionary objectForKey:@"source"] forKey:@"source"];
    [videoConferenceDictionary setObject:[videoConfDictionary objectForKey:@"destination"] forKey:@"destination"];
    [videoConferenceDictionary setObject:[videoConfDictionary objectForKey:@"appName"] forKey:@"appName"];
    [videoConferenceDictionary setObject:[videoConfDictionary objectForKey:@"targetOrigin"] forKey:@"targetOrigin"];
    [videoConferenceDictionary setObject:[videoConfDictionary objectForKey:@"conferenceServerUrl"] forKey:@"conferenceServerUrl"];
    
    [self getCameraPermission:videoConferenceDictionary];
}

-(void)videoConferencingResponse : (NSMutableDictionary*) result{
    NSLog(@"Video conferencing response::: %@", result);
    
    NSMutableDictionary *config = [self build_common_return_data];
    
    if ([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
        [config setObject:@"0" forKey:@"status"];   //Success
        [config setObject:@"success" forKey:@"message"];   //Success
    }else{
        [config setObject:@"1" forKey:@"status"];   //Failed
        [config setObject:@"cancelled" forKey:@"message"];   //Failed
    }
    
    //convert object to data
    NSString *encodedJsonStringOriginal = [self get_encoded_json_string:config];
    
    //call inform
    [self call_inform_js:@"invokeIosAppitHandler" functionParameters:encodedJsonStringOriginal];
}

-(void)initializeSDKResponse : (NSMutableDictionary*) result{
    NSLog(@"initializeSDKResponse ::: %@", result);
}

-(void)getCameraPermission:(NSMutableDictionary*)videoConferenceDictionary{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusAuthorized: { // camera authorized
            // do camera intensive stuff
            [self notifyUserOfCameraAccessAccept:videoConferenceDictionary];
        }
            break;
        case AVAuthorizationStatusNotDetermined: { // request authorization
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(granted) {
                        // do camera intensive stuff
                        [self notifyUserOfCameraAccessAccept:videoConferenceDictionary];
                    } else {
                        [self notifyUserOfCameraAccessDenial];
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyUserOfCameraAccessDenial];
            });
        }
            break;
        default:
            break;
    }
}

- (void)notifyUserOfCameraAccessDenial {
    NSLog(@"VideoConference ::: Camera access denial");
    // display a useful message asking the user to grant permissions from within Settings > Privacy > Camera
    [self sendCancelResponse];
}

- (void)notifyUserOfCameraAccessAccept:(NSMutableDictionary*)videoConferenceDictionary{
    //Ask Microphone permission
    NSLog(@"VideoConference ::: Camera access granted");
    [self getMicrophonePermission:videoConferenceDictionary];
}

-(void)getMicrophonePermission:(NSMutableDictionary*)videoConferenceDictionary{
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            [self notifyUserOfMicrophoneAccessAccept:videoConferenceDictionary];
        }else {
            [self notifyUserOfMicrophoneAccessDenial];
        }
    }];
}

- (void)notifyUserOfMicrophoneAccessDenial {
    // display a useful message asking the user to grant permissions from within Settings > Privacy > Microphone
    NSLog(@"VideoConference ::: Microphone access denial");
    [self sendCancelResponse];
}

- (void)notifyUserOfMicrophoneAccessAccept:(NSMutableDictionary*)videoConferenceDictionary{
    NSLog(@"VideoConference ::: Microphone access granted");

    [AppItSDK startVideoConferencing:self videoConferenceData:videoConferenceDictionary];
}

-(void)sendCancelResponse{
    NSMutableDictionary *_resultDictionary = [NSMutableDictionary new];
    [_resultDictionary setObject:@"1" forKey:@"statusCode"];
    [self videoConferencingResponse: _resultDictionary];
}

- (void) setUpWebViewForPDF:(NSString *)url {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        
        [self URL_download_Process_pdf:url];
        
    });
    
    [_top_buttons_viewHolder_pdf setHidden:NO];
    [_another_wkWebview_viewHolder_pdf setHidden:NO];
    [_file_name_label_pdf setText:[url lastPathComponent]];
    
    pdf_webView = [[WKWebView alloc] initWithFrame: CGRectZero
                                      configuration: [self setJS]];
//    self.webView.UIDelegate = self;
//    self.webView.navigationDelegate = self;
    pdf_webView.allowsBackForwardNavigationGestures = YES;
    pdf_webView.configuration.preferences.javaScriptEnabled = YES;
    [_another_wkWebview_viewHolder_pdf addSubview: pdf_webView];
    [self setConstraints_for_PDF_WkWebView:pdf_webView parentView:_another_wkWebview_viewHolder_pdf];
    
//    [pdf_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://demo.idmission.com/Faysal-Bank-Demo/images/downloadFormPDFPrd-1.pdf"]]];
    [pdf_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

-(void) setConstraints_for_PDF_WkWebView:(WKWebView *)webView parentView:(UIView *)parentView{
    
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *trailing =[NSLayoutConstraint
    constraintWithItem:webView
    attribute:NSLayoutAttributeTrailing
    relatedBy:NSLayoutRelationEqual
    toItem:parentView
    attribute:NSLayoutAttributeTrailing
    multiplier:1.0f
    constant:0.f];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
    constraintWithItem:webView
    attribute:NSLayoutAttributeLeading
    relatedBy:NSLayoutRelationEqual
    toItem:parentView
    attribute:NSLayoutAttributeLeading
    multiplier:1.0f
    constant:0.f];
    
    NSLayoutConstraint *bottom =[NSLayoutConstraint
    constraintWithItem:webView
    attribute:NSLayoutAttributeBottom
    relatedBy:NSLayoutRelationEqual
    toItem:parentView
    attribute:NSLayoutAttributeBottom
    multiplier:1.0f
    constant:0.f];

    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.f];
    
    [parentView addConstraint:trailing];
    [parentView addConstraint:leading];
    [parentView addConstraint:top];
    [parentView addConstraint:bottom];
    
}


- (IBAction)closeWkWebviewButtonClicked:(id)sender {
    
    [self.webView setHidden:NO];
    [pdf_webView removeFromSuperview];
    pdf_webView = nil;
    [_top_buttons_viewHolder_pdf setHidden:YES];
    [_another_wkWebview_viewHolder_pdf setHidden:YES];
}
- (IBAction)shareDataButtonClicked:(id)sender {
    if(![NS_String_Utils stringIsNilOrEmpty:content_file_name]) {
        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSString *resourcePath = [documentsDirectory stringByAppendingPathComponent:@"/Content_Folder/"];
        
        resourcePath = [resourcePath stringByAppendingPathComponent:content_file_name];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:resourcePath]) {
            NSURL *URL = [NSURL fileURLWithPath:resourcePath];
            
            if (URL) {
                self->documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
                
                [self->documentInteractionController setDelegate:self];
                
                [self->documentInteractionController presentOptionsMenuFromRect:[_top_buttons_viewHolder_pdf frame] inView:self.view animated:YES];
            }
        }
    
    }
    
}

-(void) URL_download_Process_pdf:(NSString *)url_string_data {
    
    NSDate *executionStart = [NSDate date];
    
    NSURL *url = [NSURL URLWithString:url_string_data];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
        @"Content-Type":@"application/xml; charset=utf-8",
    };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];

    NSURLSessionDataTask *downloadDataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDate *executionFinish = [NSDate date];
        NSTimeInterval executionTime = [executionFinish timeIntervalSinceDate:executionStart];
        
        if(error != nil){
            NSLog(@"Error while downloading content = %@", error);
        }else{
            if(nil != data) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                NSString *outFileDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"/Content_Folder/"];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:outFileDirectoryPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:outFileDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
                }
                
                content_file_name = [url_string_data lastPathComponent];
                
                if(![NS_String_Utils stringIsNilOrEmpty:content_file_name]) {
                    NSString *content_file_path = [NSString stringWithFormat:@"%@/%@", outFileDirectoryPath, content_file_name];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:content_file_path]) {
                        // delete if exist
                        [[NSFileManager defaultManager] removeItemAtPath:content_file_path error:nil];
                    }
                    
                    [data writeToFile:content_file_path atomically:YES];
                    
                    NSLog(@"");
                }
               
            }
            
        }
    }];
    
    [downloadDataTask resume];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

@end
