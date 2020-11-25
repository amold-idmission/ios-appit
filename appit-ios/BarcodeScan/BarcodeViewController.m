
#import <AudioToolbox/AudioToolbox.h>
#import "BarcodeViewController.h"

@interface BarcodeViewController ()

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIView *scanRectView;
//@property (nonatomic, weak) IBOutlet UILabel *decodedLabel;

@end

@implementation BarcodeViewController {
	CGAffineTransform _captureSizeTransform;
    bool isFirstScanResponse;
}

#pragma mark - View Controller Methods

- (void)dealloc {
  [self.capture.layer removeFromSuperlayer];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.capture = [[ZXCapture alloc] init];
  self.capture.camera = self.capture.back;
  self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;

  [self.view.layer addSublayer:self.capture.layer];

  [self.view bringSubviewToFront:self.scanRectView];
  _resultDictionary = [NSMutableDictionary new];
    
    isFirstScanResponse = true;
 // [self.view bringSubviewToFront:self.decodedLabel];
    _barcodeImageData = @"";
    _barcodeFormatType = @"";
    _barcodeContentData = @"";
    _defaultBarcodeImageStringData = @"";
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.capture.delegate = self;

//  [self applyOrientation];
}

-(void)viewDidAppear:(BOOL)animated {
    [self applyOrientation];
    int viewHeight = self.view.bounds.size.height;
    int viewWidth = self.view.bounds.size.width;
    
    int bottomLabelHeight = (viewHeight*10)/100;
    int bottomPadding = 5;
    CGRect titleMsgLabelRectBottom = CGRectMake(0,
                                                viewHeight - bottomPadding -bottomLabelHeight,
                                                viewWidth,
                                                bottomLabelHeight);
    UILabel *titleUiLableBottom = [[UILabel alloc] initWithFrame:titleMsgLabelRectBottom];
    
    [titleUiLableBottom setNumberOfLines:0];
    [titleUiLableBottom setLineBreakMode:NSLineBreakByWordWrapping];
    [titleUiLableBottom setTextAlignment:NSTextAlignmentCenter];
    [titleUiLableBottom setText:@"Barcode Scan"];
    [titleUiLableBottom setTextColor:[UIColor redColor]];
    [titleUiLableBottom setShadowColor:[UIColor blackColor]];
    [titleUiLableBottom setShadowOffset:CGSizeMake(2.0, 2.0)];
    [titleUiLableBottom setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:titleUiLableBottom];
    [self.view bringSubviewToFront:titleUiLableBottom];
}

-(void)viewWillDisappear:(BOOL)animated {
    if(nil != _delegate) {
        [_delegate barcodeScanningResponse:_resultDictionary instance:self];;
    }
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
//}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight; // or Right of course
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    [self applyOrientation];
//}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
//    {
//        [self applyOrientation];
//    }];
//}

#pragma mark - Private
- (void)applyOrientation {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	float scanRectRotation;
	float captureRotation;

	switch (orientation) {
		case UIInterfaceOrientationPortrait:
			captureRotation = 0;
			scanRectRotation = 90;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			captureRotation = 90;
			scanRectRotation = 180;
			break;
		case UIInterfaceOrientationLandscapeRight:
			captureRotation = 270;
			scanRectRotation = 0;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			captureRotation = 180;
			scanRectRotation = 270;
			break;
		default:
			captureRotation = 0;
			scanRectRotation = 90;
			break;
	}
	[self applyRectOfInterest:orientation];
	CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
	[self.capture setTransform:transform];
	[self.capture setRotation:scanRectRotation];
	self.capture.layer.frame = self.view.frame;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
	CGFloat scaleVideo, scaleVideoX, scaleVideoY;
	CGFloat videoSizeX, videoSizeY;
	CGRect transformedVideoRect = self.scanRectView.frame;
	if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
		videoSizeX = 1080;
		videoSizeY = 1920;
	} else {
		videoSizeX = 720;
		videoSizeY = 1280;
	}
	if(UIInterfaceOrientationIsPortrait(orientation)) {
		scaleVideoX = self.view.frame.size.width / videoSizeX;
		scaleVideoY = self.view.frame.size.height / videoSizeY;
		scaleVideo = MAX(scaleVideoX, scaleVideoY);
		if(scaleVideoX > scaleVideoY) {
			transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
		} else {
			transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
		}
	} else {
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
		scaleVideoX = width / videoSizeY;
		scaleVideoY = height / videoSizeX;
		scaleVideo = MAX(scaleVideoX, scaleVideoY);
		if(scaleVideoX > scaleVideoY) {
			transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
		} else {
			transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
		}
	}
	_captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
	self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
  switch (format) {
    case kBarcodeFormatAztec:
      return @"Aztec";

    case kBarcodeFormatCodabar:
      return @"CODABAR";

    case kBarcodeFormatCode39:
      return @"Code 39";

    case kBarcodeFormatCode93:
      return @"Code 93";

    case kBarcodeFormatCode128:
      return @"Code 128";

    case kBarcodeFormatDataMatrix:
      return @"Data Matrix";

    case kBarcodeFormatEan8:
      return @"EAN-8";

    case kBarcodeFormatEan13:
      return @"EAN-13";

    case kBarcodeFormatITF:
      return @"ITF";

    case kBarcodeFormatPDF417:
      return @"PDF417";

    case kBarcodeFormatQRCode:
      return @"QR Code";

    case kBarcodeFormatRSS14:
      return @"RSS 14";

    case kBarcodeFormatRSSExpanded:
      return @"RSS Expanded";

    case kBarcodeFormatUPCA:
      return @"UPCA";

    case kBarcodeFormatUPCE:
      return @"UPCE";

    case kBarcodeFormatUPCEANExtension:
      return @"UPC/EAN extension";

    default:
      return @"Unknown";
  }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
  if (!result) return;

    if(isFirstScanResponse) {
    isFirstScanResponse = false;
    [self.capture stop];
	CGAffineTransform inverse = CGAffineTransformInvert(_captureSizeTransform);
	NSMutableArray *points = [[NSMutableArray alloc] init];
	NSString *location = @"";
	for (ZXResultPoint *resultPoint in result.resultPoints) {
		CGPoint cgPoint = CGPointMake(resultPoint.x, resultPoint.y);
		CGPoint transformedPoint = CGPointApplyAffineTransform(cgPoint, inverse);
		transformedPoint = [self.scanRectView convertPoint:transformedPoint toView:self.scanRectView.window];
		NSValue* windowPointValue = [NSValue valueWithCGPoint:transformedPoint];
		location = [NSString stringWithFormat:@"%@ (%f, %f)", location, transformedPoint.x, transformedPoint.y];
		[points addObject:windowPointValue];
	}

  // We got a result. Display information about the result onscreen.
  _barcodeFormatType = [self barcodeFormatToString:result.barcodeFormat];
  _barcodeContentData = [NSString stringWithFormat:@"%@",result.text];

  // Vibrate
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

  CGImageRef imageData =  capture.lastScannedImage;
  UIImage* defaultBarcodeImageData = [[UIImage alloc] initWithCGImage:imageData];
    
  // barcode crop changes start
        
//    NSDictionary *options = @{
//                              GMVDetectorBarcodeFormats : @(
//                                  GMVDetectorBarcodeFormatQRCode |
//                                  GMVDetectorBarcodeFormatEAN13 |
//                                  GMVDetectorBarcodeFormatUPCA | GMVDetectorBarcodeFormatITF | GMVDetectorBarcodeFormatEAN8 |
//                                  GMVDetectorBarcodeFormatUPCE |
//                                  GMVDetectorBarcodeFormatAztec |
//                                  GMVDetectorBarcodeFormatCode39 |
//                                  GMVDetectorBarcodeFormatCode93 |
//                                  GMVDetectorBarcodeFormatCodaBar |
//                                  GMVDetectorBarcodeFormatCode128 |
//                                  GMVDetectorBarcodeFormatDataMatrix)
//                              };
//
//  GMVDetector *detector = [GMVDetector detectorOfType:GMVDetectorTypeBarcode  options:options];
//
//  NSArray<GMVBarcodeFeature *> *features = [detector featuresInImage:defaultBarcodeImageData options:nil];
//    CGPoint firstPointValue,lastPointValue;
//
//    bool isSizeZero = false;
//    if(0 == [features count]) {
//        isSizeZero = true;
//    } else if(1 == [features count]) {
//      GMVBarcodeFeature *barcode = [features firstObject];
//      NSArray<NSValue *> *cornerpointsData =  barcode.cornerPoints;
//      NSValue *firstValue = [cornerpointsData firstObject];
//      NSValue *lastValue = [cornerpointsData objectAtIndex:2];
//      firstPointValue  = firstValue.CGPointValue;
//      lastPointValue = lastValue.CGPointValue;
//   } else{
//      for (GMVBarcodeFeature *barcode in features) {
//          NSArray<NSValue *> *cornerpointsData =  barcode.cornerPoints;
//          NSString *extractedExpr = [barcode rawValue];
//          if([_barcodeContentData isEqualToString:extractedExpr]) {
//              NSValue *firstValue = [cornerpointsData firstObject];
//              NSValue *lastValue = [cornerpointsData objectAtIndex:2];
//              firstPointValue  = firstValue.CGPointValue;
//              lastPointValue = lastValue.CGPointValue;
//          }
//      }
//  }
//    //cropping image code
//  CGRect aRect = CGRectMake(firstPointValue.x , firstPointValue.y,lastPointValue.x - firstPointValue.x ,lastPointValue.y - firstPointValue.y);
//  CGImageRef imageRef = CGImageCreateWithImageInRect([defaultBarcodeImageData CGImage], aRect);
//  if(isSizeZero) {
//      imageRef = imageData;
//  }
//  UIImage *croppedImage = [[UIImage alloc] initWithCGImage:imageRef];
//  NSData *imageNSData = UIImageJPEGRepresentation(croppedImage, 0.9);
//  _barcodeImageData = [imageNSData base64EncodedStringWithOptions:0];
        
//  barcode crop changes stop
        
  NSData *defaultimageNSData = UIImageJPEGRepresentation(defaultBarcodeImageData, 0.9);
  _defaultBarcodeImageStringData = [defaultimageNSData base64EncodedStringWithOptions:0];
  _responseStatus = @"54";
  NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
  [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
  [self dismissViewControllerAnimated:YES completion:nil];
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//    [self.capture start];
//  });
    }
}
@end
