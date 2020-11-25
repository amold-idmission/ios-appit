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
#import "Firebase.h"
//#import <GoogleMobileVision/GoogleMobileVision.h>

@protocol snippetCaptureResponse <NSObject>
@required
-(void)snippetCaptureResponse : (NSMutableDictionary*) result instance:(id)instance;
@end

@interface SnippetCaptureController : UIViewController<UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate> {
    MMSCropImageView *imageView;
}
@property(nonatomic,assign)id delegate;
@property (nonatomic) NSMutableArray *snippetNameArray;
//@property(nonatomic) GMVDetector *detector;
@property (nonatomic) NSMutableArray *snippetCaptureList;
@property(nonatomic) UIImage *actualImage;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) NSMutableDictionary *finalResultDictionary;
@property(nonatomic) bool isDocumentImageProcessing;
@property(nonatomic) bool isPreviousStoredImage;

+(NSString *)getStoredSnippetImage;
+(void)setStoredSnippetImage:(NSString*)storedsnippetimage;

+(NSMutableDictionary *)getStoredFieldCoordinatesDict;
+(void)setStoredFieldCoordinatesDict:(NSMutableDictionary*)storedfieldcoordinates;

+(NSArray *)getStoredKeyArray;
+(void)setStoredKeyArray:(NSArray*)storedkeyarray;

@end
