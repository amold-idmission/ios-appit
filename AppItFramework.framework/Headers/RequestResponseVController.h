//
//  RequestResponseVController.h
//  AppItFramework
//
//  Created by  on 25/04/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+fromHex.h"

@interface RequestResponseVController : UIViewController <UIDocumentInteractionControllerDelegate> {
   UIDocumentInteractionController *documentInteractionController;
}
 @property(nonatomic) NSString* requestResponseType;
@end
