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

@property (weak, nonatomic) IBOutlet UILabel *labelRunningOn;
@property (nonatomic) WKWebView *webView;
@property(nonatomic) NSString *currentTemplateLocation;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *optionsButton;
@property (retain) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *top_buttons_viewHolder_pdf;
@property (weak, nonatomic) IBOutlet UIView *another_wkWebview_viewHolder_pdf;
@property (weak, nonatomic) IBOutlet UILabel *file_name_label_pdf;

-(UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
-(IBAction)unwindToList:(UIStoryboardSegue *)segue;
-(IBAction)unwindToListBack:(UIStoryboardSegue *)segue;
-(IBAction)optionsButtonClicked:(id)sender;
-(void) setresettingUrl:(NSString*) resettingUrl;
- (IBAction)closeWkWebviewButtonClicked:(id)sender;
- (IBAction)shareDataButtonClicked:(id)sender;

@end

