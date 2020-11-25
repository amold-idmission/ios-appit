
#import <ZXingObjC/ZXingObjC.h>
//#import <GoogleMobileVision/GoogleMobileVision.h>

@protocol barcodeScanningResponse <NSObject>
@required
-(void)barcodeScanningResponse : (NSMutableDictionary*) result instance:(id)instance;
@end

@interface BarcodeViewController : UIViewController <ZXCaptureDelegate>

@property(nonatomic,assign)id delegate;
@property(nonatomic, strong) NSString *barcodeImageData;
@property(nonatomic, strong) NSString *defaultBarcodeImageStringData;
@property(nonatomic, strong) NSString *barcodeContentData;
@property(nonatomic, strong) NSString *barcodeFormatType;
@property(nonatomic) NSMutableDictionary *resultDictionary;
@property(nonatomic, strong) NSString *responseStatus;
@end
