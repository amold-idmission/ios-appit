//
//  ViewController.h
//  appit-ios
//
//  Created by Goran Rauker on 1/29/15.
//  Copyright (c) 2015 IDMission. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController <AVCaptureFileOutputRecordingDelegate,WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler,UIDocumentInteractionControllerDelegate> {
    
    BOOL recordingInProgress;
    
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *videoInputDevice;
    AVCaptureMovieFileOutput *movieFileOutput;
    
    AVPlayerViewController *playerViewController;
    
    //Screen size CGRect -landscape and portrait
    CGRect portraitLayerRect, landscapeLayerRect;
}

@property (retain) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) WKWebView *webView;
@property(nonatomic) NSString *currentTemplateLocation;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *optionsButton;
@property (weak, nonatomic) IBOutlet UIView *pdf_View;
@property (weak, nonatomic) IBOutlet WKWebView *pdf_WebView;
@property (weak, nonatomic) IBOutlet UILabel *pdf_TitleLabel;

-(UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
-(IBAction)optionsButtonClicked:(id)sender;
-(void)setresettingUrl:(NSString*) resettingUrl;
-(IBAction)closeWkWebviewButtonClicked:(id)sender;
-(IBAction)shareDataButtonClicked:(id)sender;

@end

