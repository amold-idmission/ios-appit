//
//  SnippetCaptureController.m
//  AppItFramework
//
//  Created by  on 04/07/18.
//  Copyright © 2018 idmission solutions pvt ltd . All rights reserved.
//

#import "SnippetCaptureController.h"
#import "UIColor+fromHex.h"
#import "NSStringUtils.h"
#import "SkipImageProcessingViewController.h"
#import "SnippetData.h"

@interface SnippetCaptureController ()

@end
static int counter;
static NSMutableDictionary *storedFieldCoordinatesDict;
static NSString *storedSnippetImage;
static NSMutableArray *storedKeyArray;
@implementation SnippetCaptureController {
    NSArray *_selectedPickerData;
    UIPickerView *myPickerView;
    UIToolbar *toolbarForPicker;
    UITextField *alertTextField;
    NSMutableArray *_snippetFieldPickerData;
    NSMutableDictionary *fieldsCoordinates;
    UIImage *defaultImage;
    CGSize defaultSize;
    NSMutableDictionary *resultDict;
    NSMutableArray *keyArray;
    NSMutableDictionary *tagAndTitleDict;
    int tappedTagValue;
}

+(NSString *)getStoredSnippetImage{
    return storedSnippetImage;
}
+(void)setStoredSnippetImage:(NSString*)storedsnippetimage{
    storedSnippetImage = storedsnippetimage;
}

+(NSMutableDictionary *)getStoredFieldCoordinatesDict {
    return storedFieldCoordinatesDict;
}

+(void)setStoredFieldCoordinatesDict:(NSMutableDictionary*)storedfieldcoordinates {
    storedFieldCoordinatesDict = storedfieldcoordinates;
}

+(NSMutableArray *)getStoredKeyArray {
    return storedKeyArray;
}

+(void)setStoredKeyArray:(NSMutableArray*)storedkeyarray {
    storedKeyArray = storedkeyarray;
}

-(void)dealloc {
    //    std::cout << "dealloc" << std::endl;
}

-(void)updateResultObject : (NSString*)resultCode resultMessage:(NSString*)resultMessage{
    [_resultDictionary setObject:resultCode forKey:@"StatusCode"];
    [_resultDictionary setObject:resultCode forKey:@"statusCode"];
    [_resultDictionary setObject:resultMessage forKey:@"statusMessage"];
}

-(void)updateResultObjectWithData : (NSString*)key resultMessage:(NSObject*)value{
    [_resultDictionary setObject:value forKey:key];
}

-(void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    counter = 0;
    tappedTagValue = 0;
    resultDict = [[NSMutableDictionary alloc] init];
    _resultDictionary = [NSMutableDictionary new];
    _finalResultDictionary = [NSMutableDictionary new];
     tagAndTitleDict = [[NSMutableDictionary alloc] init];
    NSNumber *value;
    if(![self isLandscape]) {
        value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    } else {
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    }
    
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(void)viewDidAppear:(BOOL)animated {
    fieldsCoordinates = [NSMutableDictionary new];
    keyArray = [NSMutableArray new];
    [self initUI];
    myPickerView = [[UIPickerView alloc] init];
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    //[alertTextField setDelegate:(id)self];
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pickerDoneClicked)];
//    _snippetFieldPickerData = [_snippetCaptureDictionary allValues];
//    _selectedPickerData = [_snippetCaptureDictionary allValues];
    NSArray *sortedKeys = [_snippetNameArray sortedArrayUsingSelector: @selector(compare:)];
    _snippetFieldPickerData = [[NSMutableArray alloc]initWithArray:sortedKeys];
    //_snippetFieldPickerData = _snippetNameArray;
//    _selectedPickerData = _snippetNameArray;
    _selectedPickerData = sortedKeys;
    toolbarForPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
//    NSArray *toolbarItems = [NSArray arrayWithObjects:doneButton,nil];
     NSArray *toolbarItems = [NSArray arrayWithObjects:nil,nil];
    [toolbarForPicker setItems:toolbarItems];
}

-(void)initUI {
    
    int iPhoneXPadding = 0;
    if([self isLandscape]) {
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
            NSLog(@"iPhone");
            int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
            int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
            
            switch (height) {
                case 2436:
                    iPhoneXPadding = 30;
                    break;
                    
                case 1792:
                    iPhoneXPadding = 30;
                    break;
                    
                default: ;
                    
            }
        }
    }
    
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
    
    float x = [UIScreen mainScreen].bounds.origin.x;
    float y = [UIScreen mainScreen].bounds.origin.y;
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    
//    if([AppItSDK getCapturePortrait]) {
     if(![self isLandscape]) {
//         imageView = [[MMSCropImageView alloc] initWithFrame:CGRectMake(x,height - (height/100)*90,width,height/100*80)];
        imageView = [[MMSCropImageView alloc] initWithFrame:CGRectMake((width/100)*10,height - (height/100)*90,(width/100)*80,height/100*80)];
    } else {
         imageView = [[MMSCropImageView alloc] initWithFrame:CGRectMake( (width/100)*10 ,height - (height/100)*90 , (width/100)*80, height/100*80)];
    }
    imageView.delegate = self;
    imageView.image = _actualImage;
    imageView.passedImage = _actualImage;
    imageView.mainScreendefaultSize = self.view.frame.size;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [scrollView setMaximumZoomScale:5.0f];
    [scrollView setClipsToBounds:YES];
    [scrollView setDelegate:self];
    [scrollView setScrollEnabled:false];
    [self.view addSubview:scrollView];
    [scrollView addSubview:imageView];
    imageView.defaultSize = imageView.frame.size;
    imageView.defaultOrigin = imageView.frame.origin;
    defaultImage = imageView.image;
    defaultSize = imageView.frame.size;
    
//    UIButton *cropButton = [[UIButton alloc] initWithFrame:CGRectMake(10 , (height/100)*91 , (height/100)*8, (height/100)*8)];
//    [cropButton setBackgroundColor:[UIColor blueColor]];
//    [cropButton setTitle:@"CROP" forState:UIControlStateNormal];
//    [self.view addSubview:cropButton];
//    [cropButton addTarget:self action:@selector(cropButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *markButton = [[UIButton alloc] initWithFrame:CGRectMake( width/2 - (height/100)*4 , (height/100)*91,(height/100)*8 , (height/100)*8)];
    NSString *crop_icon = [frameworkBundle pathForResource:@"addsnippet" ofType:@"png"];
    UIImage *cropSnippetImage = [[UIImage imageNamed:crop_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [markButton setImage:cropSnippetImage forState:UIControlStateNormal];
    [self.view addSubview:markButton];
    [markButton addTarget:self action:@selector(markButton:) forControlEvents:UIControlEventTouchUpInside];
    //Hiding MarkButton
    [markButton setHidden:YES];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setFrame:CGRectMake(width - 10 - (height/100)*8 - iPhoneXPadding, (height/100)*91 , (height/100)*8, (height/100)*8)];
    NSString *done_icon = [frameworkBundle pathForResource:@"donesnippet" ofType:@"png"];
    UIImage *doneSnippetImage = [[UIImage imageNamed:done_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [doneButton setImage:doneSnippetImage forState:UIControlStateNormal];
    [self.view addSubview:doneButton];
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //Back button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect backBtnRect = CGRectMake(width/100*2, height/100*2, 50, 50);
    [backButton setFrame:backBtnRect];
    
    NSString *back_icon = [frameworkBundle pathForResource:@"back_cancel_arrow" ofType:@"png"];
    UIImage *backImage = [[UIImage imageNamed:back_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTintColor:[UIColor colorwithHexString:@"0A0000" alpha:1.0]];
    [self.view addSubview:backButton];
    if(_isPreviousStoredImage) {
        fieldsCoordinates = storedFieldCoordinatesDict;
        keyArray = storedKeyArray;
        [self addPreviousStoredcoordinates:storedFieldCoordinatesDict];
    }

}

-(bool)isLandscape{
    
    bool isLandscape = false;
    int height = _actualImage.size.height;
    int width = _actualImage.size.width;
    
    if(height > width) {
        isLandscape = false;
    } else {
        isLandscape = true;
    }
    
    return isLandscape;
}

-(void)backPressed:(UIButton*)button {
    [self updateResultObject:@"1" resultMessage:NSLocalizedString(@"empty_response_msg", @"")];
    NSMutableDictionary *finalResultDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *snippetArray = [[NSMutableArray alloc] init];
    [snippetArray addObject:finalResultDict];
    NSMutableDictionary *ObjectSnippet = [[NSMutableDictionary alloc] init];
    [ObjectSnippet setObject:snippetArray forKey:@"SnippetObjectData"];
    
    [_finalResultDictionary setObject:ObjectSnippet forKey:@"snippetCaptureData"];
    if(_isDocumentImageProcessing) {
        SkipImageProcessingViewController *ctrl = (SkipImageProcessingViewController *)_delegate;
        //((SkipImageProcessingViewController *)_delegate).exitFromSkipImagProcessing;
        [ctrl exitFromSkipImagProcessing:_finalResultDictionary];
    }
    [self dismissCurrentViewController];
}

-(NSUInteger)supportedInterfaceOrientations{
    NSUInteger *orientation;
//    if([AppItSDK getCapturePortrait]) {
    if(![self isLandscape]) {
        orientation = UIInterfaceOrientationMaskPortrait;
    } else {
        orientation = UIInterfaceOrientationMaskLandscapeRight;
    }
    return orientation;
}

- (IBAction)doneButton:(id)sender {
    [self googleVisionExtractorMatcher];
//    NSMutableDictionary *justToCheck = fieldsCoordinates;
//    NSMutableDictionary *justtochkres = resultDict;
//    [self updateResultObject:@"0" resultMessage:[StringLabels getLabelForKey:@"success_msg"]];
//    [self updateResultObjectWithData:@"SnippetDictionary" resultMessage:resultDict];
//    NSLog(@"Done Pressed");
//    NSLog(@"Snippet Capture");
//    [self dismissCurrentViewController];
}

-(void)doneSnippetCapture {
    NSMutableDictionary *finalResultDict = [[NSMutableDictionary alloc] init];
    
    for(int i = 0; i < [_snippetCaptureList count]; i++) {
        SnippetData *snippetData = [_snippetCaptureList objectAtIndex:i];
        [resultDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *SniName = [snippetData getSnippetName];
            NSString *chkKey = (NSString *)key;
            NSString *formFieldKey = [snippetData getResponseFormFieldKey];
            if([[snippetData getSnippetName] isEqualToString:(NSString *)key]) {
                [finalResultDict setObject:(NSString *)obj forKey:[snippetData getResponseFormFieldKey]];
            }
        }];
    }
    if([self checkForMandatoryField]) {
        
        storedFieldCoordinatesDict = fieldsCoordinates;
        storedKeyArray = keyArray;
        NSMutableArray *snippetArray = [[NSMutableArray alloc] init];
        [snippetArray addObject:finalResultDict];
        NSMutableDictionary *ObjectSnippet = [[NSMutableDictionary alloc] init];
        [ObjectSnippet setObject:snippetArray forKey:@"SnippetObjectData"];
        
        [_finalResultDictionary setObject:ObjectSnippet forKey:@"snippetCaptureData"];
        
        [self updateResultObject:@"0" resultMessage:NSLocalizedString(@"success_msg", @"")];
        [self updateResultObjectWithData:@"SnippetDictionary" resultMessage:resultDict];
        if(_isDocumentImageProcessing) {
            SkipImageProcessingViewController *ctrl = (SkipImageProcessingViewController *)_delegate;
            //((SkipImageProcessingViewController *)_delegate).exitFromSkipImagProcessing;
            [ctrl exitFromSkipImagProcessing:_finalResultDictionary];
        }
        [self dismissCurrentViewController];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please select mandatory field"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)dismissCurrentViewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(nil != _delegate){
            if(!_isDocumentImageProcessing) {
//            [_delegate snippetCaptureResponse:resultDict];
             [_delegate snippetCaptureResponse:_resultDictionary instance:self];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)markButtonClicked {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"select_snippet", @"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:nil];
    [alert addButtonWithTitle:NSLocalizedString(@"continue", @"")];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = NSLocalizedString(@"select_field", @"");
    if(nil != _snippetFieldPickerData && [_snippetFieldPickerData count]>0) {
        [alertTextField setText:[_snippetFieldPickerData objectAtIndex:0]];
    } else {
        [alertTextField setText:@""];
    }
    [alertTextField setInputAccessoryView:toolbarForPicker];
    [alertTextField setInputView:myPickerView];
    [alert show];
}

- (IBAction)markButton:(id)sender {
    [self markButtonClicked];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:NSLocalizedString(@"continue", @"")])
    {
        if([tagAndTitleDict objectForKey:[alertTextField text]]) {
            NSString *tagValue = [tagAndTitleDict objectForKey:[alertTextField text]];
            [self removeViewFromSubView:[tagValue intValue]];
        }
        [fieldsCoordinates setObject:NSStringFromCGRect(imageView.crop) forKey:[alertTextField text]];
        [keyArray addObject:[alertTextField text]];
        [self addRemoveMultipleView:[alertTextField text]];
    } else if([title isEqualToString:@"Cancel"]) {
        tappedTagValue = 0;
    }
}

//-(void)pickerDoneClicked{
//    NSLog(@"Picker Done Clicked!");
//    [alertTextField resignFirstResponder];
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == alertTextField){
        _selectedPickerData = _snippetFieldPickerData;
        [myPickerView reloadAllComponents];
    }
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_selectedPickerData count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_selectedPickerData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component{
    
    if([_selectedPickerData isEqualToArray:_snippetFieldPickerData]){
        [alertTextField setText:_snippetFieldPickerData[row]];
        [alertTextField setTag:row+1];
    }
}

-(void)addPreviousStoredcoordinates : (NSMutableDictionary *)fieldCoordinates {
    [fieldCoordinates enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *croppedRectString = [fieldCoordinates objectForKey:key];
        CGRect croppedRect = CGRectFromString(croppedRectString);
        counter++;
        //Multiple
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
        tapGesture1.numberOfTapsRequired = 1;
        [tapGesture1 setDelegate:self];
        NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
        
        UIView *markView = [[UIView alloc] initWithFrame:croppedRect];
        [markView setTag:counter];
        markView.backgroundColor = [UIColor clearColor];  // background color is white
        
        markView.alpha = 0.65;  // the background is modestly transparent
        
        markView.layer.borderWidth = 1.0;  // the crop rectangle has a solid border
        
        markView.layer.borderColor = [[UIColor redColor] CGColor];// the crop border is white
        markView.userInteractionEnabled = YES;
        [markView addGestureRecognizer:tapGesture1];
        [imageView addSubview:markView];
        
        //Title Label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(markView.frame.origin.x + (self.view.frame.size.height/100)*2, markView.frame.origin.y - 15, (self.view.frame.size.width/100)*50, 14)];
        [titleLabel setTag:counter];
        [titleLabel setTextColor:[UIColor redColor]];
        [titleLabel setText:(NSString*)key];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [imageView addSubview:titleLabel];
        
        UIButton *crossBtn = [[UIButton alloc] initWithFrame:CGRectMake(markView.frame.origin.x + markView.frame.size.width - (self.view.frame.size.height/100)*3, markView.frame.origin.y - (self.view.frame.size.height/100)*3, (self.view.frame.size.height/100)*3, (self.view.frame.size.height/100)*3)];
        [crossBtn setBackgroundColor:[UIColor blueColor]];
        [crossBtn setTag:counter];
        [imageView addSubview:crossBtn];
        NSString *crop_icon = [frameworkBundle pathForResource:@"cancelsnippet" ofType:@"png"];
        UIImage *cropSnippetImage = [[UIImage imageNamed:crop_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [crossBtn setImage:cropSnippetImage forState:UIControlStateNormal];
        
        [crossBtn addTarget:self action:@selector(crossButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //Adding TopDragPoint
        UIButton *topDragPointBtn = [[UIButton alloc] initWithFrame:CGRectMake(croppedRect.origin.x - (self.view.frame.size.height/100)*2 , croppedRect.origin.y - (self.view.frame.size.height/100)*2, (self.view.frame.size.height/100)*4, (self.view.frame.size.height/100)*4)];
        //[topDragPointBtn setBackgroundColor:[UIColor blueColor]];
        [topDragPointBtn setTag:counter];
        [imageView addSubview:topDragPointBtn];
        NSString *dot_icon = [frameworkBundle pathForResource:@"circle" ofType:@"png"];
        UIImage *dotImage = [[UIImage imageNamed:dot_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [topDragPointBtn setImage:dotImage forState:UIControlStateNormal];
        [topDragPointBtn addTarget:self action:@selector(topDragButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //Adding BottomDragPoint
        UIButton *bottomDragPointBtn = [[UIButton alloc] initWithFrame:CGRectMake(croppedRect.origin.x + croppedRect.size.width - (self.view.frame.size.height/100)*2, croppedRect.origin.y + croppedRect.size.height - (self.view.frame.size.height/100)*2, (self.view.frame.size.height/100)*4, (self.view.frame.size.height/100)*4)];
        //[bottomDragPointBtn setBackgroundColor:[UIColor blueColor]];
        [bottomDragPointBtn setTag:counter];
        [imageView addSubview:bottomDragPointBtn];
        [bottomDragPointBtn setImage:dotImage forState:UIControlStateNormal];
        [bottomDragPointBtn addTarget:self action:@selector(bottomDragButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //PanGestureRecognizor
        //    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        //    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
        [topDragPointBtn addGestureRecognizer:[self setRecognizer]];
        [bottomDragPointBtn addGestureRecognizer:[self setRecognizer]];
        [tagAndTitleDict setObject:[NSString stringWithFormat: @"%d", counter] forKey:(NSString*)key];
    }];
}

-(void)addRemoveMultipleView:(NSString *)titleName {
    CGRect croppedImage;
    counter++;
    //imageView.defaultSize = imageView.frame.size;
    //imageView.defaultPoint =  imageView.frame.origin;
    
    UIImage *defaultImage = imageView.image;
    
    croppedImage = [imageView crop];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [tapGesture1 setDelegate:self];
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
    
    //Multiple
    UIView *markView = [[UIView alloc] initWithFrame:croppedImage];
    [markView setTag:counter];
    markView.backgroundColor = [UIColor clearColor];  // background color is white
    
    markView.alpha = 0.65;  // the background is modestly transparent
    
    markView.layer.borderWidth = 1.0;  // the crop rectangle has a solid border
    
    markView.layer.borderColor = [[UIColor redColor] CGColor];// the crop border is white
    markView.userInteractionEnabled = YES;
    [markView addGestureRecognizer:tapGesture1];
    [imageView addSubview:markView];
    
    //Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(markView.frame.origin.x + (self.view.frame.size.height/100)*2, markView.frame.origin.y - 15, (self.view.frame.size.width/100)*50, 14)];
    [titleLabel setTag:counter];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setText:titleName];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [imageView addSubview:titleLabel];
    
    UIButton *crossBtn = [[UIButton alloc] initWithFrame:CGRectMake(markView.frame.origin.x + markView.frame.size.width - (self.view.frame.size.height/100)*3, markView.frame.origin.y - (self.view.frame.size.height/100)*3, (self.view.frame.size.height/100)*3, (self.view.frame.size.height/100)*3)];
    [crossBtn setBackgroundColor:[UIColor blueColor]];
    [crossBtn setTag:counter];
    [imageView addSubview:crossBtn];
    NSString *crop_icon = [frameworkBundle pathForResource:@"cancelsnippet" ofType:@"png"];
    UIImage *cropSnippetImage = [[UIImage imageNamed:crop_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [crossBtn setImage:cropSnippetImage forState:UIControlStateNormal];
    
    [crossBtn addTarget:self action:@selector(crossButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //Adding TopDragPoint
    UIButton *topDragPointBtn = [[UIButton alloc] initWithFrame:CGRectMake(croppedImage.origin.x - (self.view.frame.size.height/100)*2 , croppedImage.origin.y - (self.view.frame.size.height/100)*2, (self.view.frame.size.height/100)*4, (self.view.frame.size.height/100)*4)];
    //[topDragPointBtn setBackgroundColor:[UIColor blueColor]];
    [topDragPointBtn setTag:counter];
    [imageView addSubview:topDragPointBtn];
    NSString *dot_icon = [frameworkBundle pathForResource:@"circle" ofType:@"png"];
    UIImage *dotImage = [[UIImage imageNamed:dot_icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [topDragPointBtn setImage:dotImage forState:UIControlStateNormal];
    [topDragPointBtn addTarget:self action:@selector(topDragButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //Adding BottomDragPoint
    UIButton *bottomDragPointBtn = [[UIButton alloc] initWithFrame:CGRectMake(croppedImage.origin.x + croppedImage.size.width - (self.view.frame.size.height/100)*2, croppedImage.origin.y + croppedImage.size.height - (self.view.frame.size.height/100)*2, (self.view.frame.size.height/100)*4, (self.view.frame.size.height/100)*4)];
    //[bottomDragPointBtn setBackgroundColor:[UIColor blueColor]];
    [bottomDragPointBtn setTag:counter];
    [imageView addSubview:bottomDragPointBtn];
    [bottomDragPointBtn setImage:dotImage forState:UIControlStateNormal];
    [bottomDragPointBtn addTarget:self action:@selector(bottomDragButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //PanGestureRecognizor
    //    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [topDragPointBtn addGestureRecognizer:[self setRecognizer]];
    [bottomDragPointBtn addGestureRecognizer:[self setRecognizer]];
    [tagAndTitleDict setObject:[NSString stringWithFormat: @"%d", counter] forKey:titleName];
    //Multiple
    
}

-(UIPanGestureRecognizer*)setRecognizer{
    UIPanGestureRecognizer *panRecognizor = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panRecognizor.maximumNumberOfTouches = panRecognizor.minimumNumberOfTouches = 1;
    return panRecognizor;
}

- (UIImage *) resizeImage: (UIImage*) image toSize: (CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)googleVisionExtractorMatcher {
    float x = [UIScreen mainScreen].bounds.origin.x;
    float y = [UIScreen mainScreen].bounds.origin.y;
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    CGSize imgviewSiz = imageView.frame.size;
    
    UIImage *imgg = [self resizeImage:defaultImage toSize:defaultSize];

    if(nil != fieldsCoordinates && [fieldsCoordinates count] > 0) {
        [fieldsCoordinates enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            NSString *croppedRectString = [fieldsCoordinates objectForKey:key];
            CGRect croppedRect = CGRectFromString(croppedRectString);
            
            CGImageRef drawImage = CGImageCreateWithImageInRect(imgg.CGImage, croppedRect);
            UIImage *croppedSnippetImage = [UIImage imageWithCGImage:drawImage];
            CGImageRelease(drawImage);
            
            FIRVision *vision = [FIRVision vision];
            FIRVisionTextRecognizer *textRecognizer = [vision onDeviceTextRecognizer];
            if(nil != croppedSnippetImage) {
            FIRVisionImage *image = [[FIRVisionImage alloc] initWithImage:croppedSnippetImage];

            [textRecognizer processImage:image
                              completion:^(FIRVisionText *_Nullable result,
                                           NSError *_Nullable error) {
                                  if (error != nil || result == nil) {
                                      NSLog(@"");
                                      [resultDict setObject:@"" forKey:key];
                                      NSArray *allKeys = [fieldsCoordinates allKeys];
                                      if([[allKeys objectAtIndex:[allKeys count] - 1] isEqualToString:key]) {
                                          [self doneSnippetCapture];
                                      }
                                      return;
                                  }
                                  
                                  NSString *resultText = result.text;
                                  resultText = [resultText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                                  [resultDict setObject:resultText forKey:key];
                                  NSArray *allKeys = [fieldsCoordinates allKeys];
                                  if([[allKeys objectAtIndex:[allKeys count] - 1] isEqualToString:key]) {
                                      [self doneSnippetCapture];
                                  }
                              }];
            } else {
                [resultDict setObject:@"" forKey:key];
                NSArray *allKeys = [fieldsCoordinates allKeys];
                if([[allKeys objectAtIndex:[allKeys count] - 1] isEqualToString:key]) {
                    [self doneSnippetCapture];
                }
            }
        }];
    } else {
        [self doneSnippetCapture];
    }
}

-(void) removeViewFromSubView:(int) tagValue {
    bool breakFlow = true;
    NSArray *subViews = [imageView subviews];
    for(UIView *view in subViews)
    {
        if(tagValue == [view tag]) {
            if(breakFlow) {
                int indx = tagValue - 1;
                NSArray *allKeysForObject = [tagAndTitleDict allKeysForObject:[NSString stringWithFormat: @"%d", tagValue]];
                NSString *titleText = [allKeysForObject firstObject];
                [fieldsCoordinates removeObjectForKey:titleText];
                breakFlow = false;
            }
            NSArray *chkArray = view.gestureRecognizers;
            if(chkArray.count > 0) {
                for(int i = 0; i <[chkArray count]; i++) {
                    UIGestureRecognizer *recognizor = chkArray[i];
                    [view removeGestureRecognizer:recognizor];
                }
            }
            [view removeFromSuperview];
        }
    }
}

- (IBAction)crossButton:(id)sender {
    
    int inte = [sender tag];
    [self removeViewFromSubView:inte];
}

- (IBAction)topDragButton:(id)sender {
    NSLog(@"TopDragButton");
}

- (IBAction)bottomDragButton:(id)sender {
    NSLog(@"bottomDragButton");
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return imageView;
}

-(void)onDraggedFinishedProtocol:(bool) isFromTapped isFomExpandCorner:(bool)isFomExpandCorner viewTagValue:(int)viewTagValue {
    
    if(!isFomExpandCorner) {
        if(!isFromTapped) {
            [self markButtonClicked];
        } else {
            if(0 != tappedTagValue) {
                [self removeViewFromSubView:tappedTagValue];
                NSArray *allKeysForObject = [tagAndTitleDict allKeysForObject:[NSString stringWithFormat: @"%d", tappedTagValue]];
                NSString *titleText = [allKeysForObject firstObject];
                [tagAndTitleDict removeObjectForKey:titleText];
                [fieldsCoordinates setObject:NSStringFromCGRect(imageView.crop) forKey:titleText];
                [self addRemoveMultipleView:titleText];
            } else {
                [self markButtonClicked];
            }
        }
    } else {
        [self removeViewFromSubView:viewTagValue];
        NSArray *allKeysForObject = [tagAndTitleDict allKeysForObject:[NSString stringWithFormat: @"%d", viewTagValue]];
        NSString *titleText = [allKeysForObject firstObject];
        [tagAndTitleDict removeObjectForKey:titleText];
        [fieldsCoordinates setObject:NSStringFromCGRect(imageView.crop) forKey:titleText];
        [self addRemoveMultipleView:titleText];
    }
    
}

-(bool) checkForMandatoryField {
    bool isAllMandatoryFieldPresent = true;
    for(int i = 0; i < [_snippetCaptureList count]; i++) {
        SnippetData *snippetData = [_snippetCaptureList objectAtIndex:i];
        if([@"Y" isEqualToString:[snippetData getIsMandatory]]) {
            if(![resultDict objectForKey:[snippetData getSnippetName]]) {
                isAllMandatoryFieldPresent = false;
            }
        }
    }
    return isAllMandatoryFieldPresent;
}

- (void) tapGesture: (id)sender
{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;
    UIView *tappedView = (UIView *)recognizer.view;
    int inte = [tappedView tag];
    tappedTagValue = [tappedView tag];
    CGRect rect = tappedView.frame;
    [imageView settingCropViewFrame:&rect];
    NSLog(@"");
}

- (void)pan:(UIPanGestureRecognizer *)aPan {
    UIButton *panView = (UIButton *)aPan.view;
    NSLog(@"");
    NSArray *subViews = [imageView subviews];
    for(UIView *view in subViews)
    {
        if(panView.tag == [view tag]) {
            if(!view.hidden) {
                [view setHidden:YES];
            }
            if([view isMemberOfClass:[UIView class]]) {
                
                CGPoint currentPoint = [imageView convertPoint:view.frame.origin toView:self.view];
                CGPoint point2 = [imageView convertPoint:view.frame.origin toView:imageView];
                CGPoint dragOrigin = [aPan locationInView:imageView];
                CGPoint makePoint;
                if(panView.frame.origin.x < view.frame.origin.x) {   // Condition to check which exapand button is clicked top or bottom
                    makePoint = CGPointMake(view.frame.origin.x + view.frame.size.width, view.frame.origin.y + view.frame.size.height);
                } else {
                    makePoint = CGPointMake(view.frame.origin.x, view.frame.origin.y);
                }
                [imageView rectTopAndBtmCornerButtonClicked:aPan constantPoint:makePoint viewTagValue:[view tag]];
                NSLog(@"Matched");
                
            }
        }
    }
}


@end
