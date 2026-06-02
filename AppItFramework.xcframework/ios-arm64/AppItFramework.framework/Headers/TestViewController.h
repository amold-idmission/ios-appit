//
//  TestViewController.h
//  AppItDepedency
//
//  Created by Amol Deshmukh on 13/07/23.
//  Copyright © 2023 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
}

@property(nonatomic,assign)id delegate;
@property(nonatomic, retain)IBOutlet UIButton *selectImage;
@property(nonatomic, retain)IBOutlet UIImageView *imageView;

@property(nonatomic, retain)IBOutlet UITextField *modelTextfield;
@property(nonatomic, retain)IBOutlet UITableView *modelTableView;
@property(nonatomic, retain)IBOutlet UIImageView *arrowimageView;

//Process Button
@property(nonatomic, retain)IBOutlet UIButton *processImage;

//Final Images
@property(nonatomic, retain)IBOutlet UITableView *idDocumentDetailsTableView;

@end

NS_ASSUME_NONNULL_END
