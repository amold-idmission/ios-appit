//
//  ViewController.h
//  ios-appit-client
//
//  Created by idmission on 04/11/15.
//  Copyright © 2015 idmission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{

    //Face detection component
    IBOutlet UIButton *faceDetectionTest;
    IBOutlet UIButton *originalImageButton;
    IBOutlet UIButton *ellipseImageButton;
    IBOutlet UILabel *statusLabel;
    
    //Image Processing component
    IBOutlet UIButton *callImageProcButton;
    IBOutlet UIButton *processedImageButton;
    IBOutlet UIButton *inputImageButton;
    IBOutlet UIButton *templateImageButton;
    IBOutlet UIButton *faceImageButton;
    IBOutlet UITextView *multilineText;
    IBOutlet UITextField *templateIDs;
    
    //Download Template component
    IBOutlet UIButton *downloadTemplateButton;
}

    //Face detection function & ui component
- (IBAction)callFaceDetection:(id)sender;
- (void)setOrigionalImage:(UIImage*)imageData;
- (void)setOvalImage:(UIImage*)imageData;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

    //Face detection property
@property(nonatomic, retain) UIImage* orImage;
@property(nonatomic, retain) UIImage* ovImage;
@property(nonatomic, assign) NSString* status;

    //Image Processing function & ui component
- (IBAction)callImageProcessing:(id)sender;

//Image Processing property
@property(nonatomic, retain) UIImage* processedImage;
@property(nonatomic, retain) UIImage* inputImage;
@property(nonatomic, retain) UIImage* templateImage;
@property(nonatomic, retain) UIImage* faceImage;
@property(nonatomic, assign) NSString* imageProcResponseXML;

//Download Template function & ui component
- (IBAction)callDownloadTemplate:(id)sender;

@end

