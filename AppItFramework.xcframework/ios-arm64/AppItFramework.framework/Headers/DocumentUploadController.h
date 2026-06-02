//
//  DocumentUploadController.h
//  AppItFramework
//
//  Created by Sanket Garde on 09/04/21.
//  Copyright © 2021 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppItSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface DocumentUploadController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate> {
    
}

@property(nonatomic,assign)id delegate;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic) NSString *imageType;
@property(nonatomic) NSString *genericFieldName;
@property(nonatomic, strong) IBOutlet UIView *imageUpload_uiview;
@property(nonatomic, strong) IBOutlet UIView *pdfUpload_uiview;
@property(nonatomic, strong) IBOutlet UIImageView *backButton;

@property(nonatomic, strong) IBOutlet UILabel *imageUpload_label;
@property(nonatomic, strong) IBOutlet UILabel *pdfUpload_label;
//- (IBAction)imageUpload_Action:(id)sender;
//- (IBAction)pdfUpload_Action:(id)sender;

- (IBAction)imageUpload_Action:(UITapGestureRecognizer *)sender;
- (IBAction)pdfUpload_Action:(UITapGestureRecognizer *)sender;
- (IBAction)backButton_Action:(UITapGestureRecognizer *)sender;


@end

NS_ASSUME_NONNULL_END
