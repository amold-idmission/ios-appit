//
//  SnippetCaptureController.h
//  AppItFramework
//
//  Created by  on 04/07/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Firebase.h"
#import "MMSCropImageView.h"
#import "AppItSDK.h"
//#import <GoogleMobileVision/GoogleMobileVision.h>
#import "Reachability.h"

@interface SnippetCaptureController : UIViewController<UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate> {
    MMSCropImageView *imageView;
}
@property(nonatomic,assign)id delegate;
@property (nonatomic) NSMutableDictionary *snippetCaptureDictionary;
//@property(nonatomic) GMVDetector *detector;
@property(nonatomic) UIImage *actualImage;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *hostReachability;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) bool isPreviousStoredImage;

+(NSString *)getStoredSnippetImage;
+(void)setStoredSnippetImage:(NSString*)storedsnippetimage;

+(NSMutableDictionary *)getStoredFieldCoordinatesDict;
+(void)setStoredFieldCoordinatesDict:(NSMutableDictionary*)storedfieldcoordinates;

+(NSArray *)getStoredKeyArray;
+(void)setStoredKeyArray:(NSArray*)storedkeyarray;

@end
