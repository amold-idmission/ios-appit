//
//  SnippetCaptureController.h
//  AppItFramework
//
//  Created by  on 04/07/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSCropImageView.h"
#import "AppItSDK.h"
#import "Reachability.h"
#import <MLKit.h>

@interface SnippetCaptureController : UIViewController<UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate> {
    MMSCropImageView *imageView;
}
@property (nonatomic,assign)id delegate;
@property (nonatomic,assign)id instruction_screen_delegate;
@property (nonatomic) NSMutableDictionary *snippetCaptureDictionary;
@property (nonatomic) UIImage *actualImage;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) NSMutableDictionary *resultDictionary;
@property (nonatomic) bool isPreviousStoredImage;

+(NSString *)getStoredSnippetImage;
+(void)setStoredSnippetImage:(NSString*)storedsnippetimage;

@end
