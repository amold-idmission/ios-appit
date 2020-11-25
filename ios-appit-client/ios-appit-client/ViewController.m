//
//  ViewController.m
//  ios-appit-client
//
//  Created by idmission on 04/11/15.
//  Copyright © 2015 idmission. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//Face detection property
@synthesize orImage = _orImage;
@synthesize ovImage = _ovImage;
@synthesize status = _status;

//Image Processing property
@synthesize processedImage = _processedImage;
@synthesize inputImage = _inputImage;
@synthesize templateImage = _templateImage;
@synthesize faceImage = _faceImage;
@synthesize imageProcResponseXML = _imageProcResponseXML;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    UIImage *image = [UIImage imageNamed: @"camera.png"];
//    [originalImageButton setImage:image forState:UIControlStateNormal];
//    [ellipseImageButton setImage:image forState:UIControlStateNormal];


    if(nil != _orImage){
        [originalImageButton setBackgroundImage:_orImage forState:UIControlStateNormal];
        [originalImageButton setTitle:@"" forState: UIControlStateNormal];
    }

    if(nil != _ovImage){
        [ellipseImageButton setBackgroundImage:_ovImage forState:UIControlStateNormal];
        [ellipseImageButton setTitle:@"" forState: UIControlStateNormal];
    }
    
    if(nil != _status){
        [statusLabel setText:_status];
    }
    
    if(nil != _processedImage){
        [processedImageButton setBackgroundImage:_processedImage forState:UIControlStateNormal];
        [processedImageButton setTitle:@"" forState: UIControlStateNormal];
    }
    
    if(nil != _inputImage){
        [inputImageButton setBackgroundImage:_inputImage forState:UIControlStateNormal];
        [inputImageButton setTitle:@"" forState: UIControlStateNormal];
    }
    
    if(nil != _templateImage){
        [templateImageButton setBackgroundImage:_templateImage forState:UIControlStateNormal];
        [templateImageButton setTitle:@"" forState: UIControlStateNormal];
    }
    
    if(nil != _faceImage){
        [faceImageButton setBackgroundImage:_faceImage forState:UIControlStateNormal];
        [faceImageButton setTitle:@"" forState: UIControlStateNormal];
    }
    
    if(nil != _imageProcResponseXML){
        [multilineText setText:_imageProcResponseXML];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callFaceDetection:(id)sender {
    /* Note: 
     * You have to add "URL Types>URL Schemes" value "client" in "info.list" to support below URL.
     * If you change its valu you need to update here as well.
     */
    NSMutableString *response_url = [NSMutableString stringWithFormat:@"%@://%@/%@?", @"client", @"client-app", @"faceDetectionResponse"];
    
    //scheme, host, action
    NSMutableString *final_url = [NSMutableString stringWithFormat:@"%@://%@/%@?", @"idmission", @"ios-appit", @"callFaceDetection"];

    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    [requestParam setObject:@"10" forKey:@"threshold"];
    [requestParam setObject:@"SMILE" forKey:@"thresholdSetting"];
    [requestParam setObject:@"YES" forKey:@"support_eyewear"];
    [requestParam setObject:@"YES" forKey:@"take_image_while_processing"];
    [requestParam setObject:@"NO" forKey:@"verify_final_image"];
    [requestParam setObject:@"40" forKey:@"verify_final_image_Minimum_Match"];
    [requestParam setObject:@"90" forKey:@"LowLightThresholdValue"];
    //Response url
    [requestParam setObject:response_url forKey:@"response_url"];
    
    NSError * err;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestParam options:NSJSONWritingPrettyPrinted error:&err];
    NSString * myString = [jsonData base64EncodedStringWithOptions:0];


    [final_url appendString:@"&requestParam="];
    [final_url appendString:myString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:final_url]];
}

-(void)setOrigionalImage:(UIImage *)imageData{
    [originalImageButton setBackgroundImage:imageData forState:UIControlStateNormal];
}

-(void)setOvalImage:(UIImage *)imageData{
    [ellipseImageButton setBackgroundImage:imageData forState:UIControlStateNormal];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)callImageProcessing:(id)sender {
    
    NSString *template_ids = [templateIDs text];
    template_ids = [template_ids stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /* Note:
     * You have to add "URL Types>URL Schemes" value "client" in "info.list" to support below URL.
     * If you change its valu you need to update here as well.
     */
    NSMutableString *response_url = [NSMutableString stringWithFormat:@"%@://%@/%@?", @"client", @"client-app", @"imageProcResponse"];
    
    //scheme, host, action
    NSMutableString *final_url = [NSMutableString stringWithFormat:@"%@://%@/%@?", @"idmission", @"ios-appit", @"callImageProc"];
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    /*
     Add id values if you want to scan with particular template
     or you can skip it for scanning with all the template.
     */
    [requestParam setObject:template_ids forKey:@"TemplateIds"];
    [requestParam setObject:@"512" forKey:@"ImageSizeLimit"];
    [requestParam setObject:@"4" forKey:@"ImageCaptureCount"];
    [requestParam setObject:@"NO" forKey:@"HighResolutionImageMode"];
//    [requestParam setObject:@"240" forKey:@"HighResolutionImageHeight"];
//    [requestParam setObject:@"240" forKey:@"HighResolutionImageWidth"];

    [requestParam setObject:@"YES" forKey:@"SendAllImages"];
    
    //Response url
    [requestParam setObject:response_url forKey:@"response_url"];
    
    NSError * err;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestParam options:NSJSONWritingPrettyPrinted error:&err];
    NSString * myString = [jsonData base64EncodedStringWithOptions:0];
    
    
    [final_url appendString:@"&requestParam="];
    [final_url appendString:myString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:final_url]];
}
- (IBAction)callDownloadTemplate:(id)sender {

    /* Note:
     * You have to add "URL Types>URL Schemes" value "client" in "info.list" to support below URL.
     * If you change its valu you need to update here as well.
     */
    NSMutableString *response_url = [NSMutableString stringWithFormat:@"%@://%@/%@?", @"client", @"client-app", @"downloadTemplateResponse"];
    
    //scheme, host, action
    NSMutableString *final_url = [NSMutableString stringWithFormat:@"%@://%@/%@?", @"idmission", @"ios-appit", @"callDownloadTemplate"];
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    //Add request parameter here
    [requestParam setObject:@"5774" forKey:@"merchantId"];
    [requestParam setObject:@"ScotiaPOCTest" forKey:@"loginId"];
    [requestParam setObject:@"Merchant#1" forKey:@"password"];
    
    //Response url
    [requestParam setObject:response_url forKey:@"response_url"];
    
    NSError * err;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestParam options:NSJSONWritingPrettyPrinted error:&err];
    NSString * myString = [jsonData base64EncodedStringWithOptions:0];
    
    
    [final_url appendString:@"&requestParam="];
    [final_url appendString:myString];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:final_url]];
}
@end
