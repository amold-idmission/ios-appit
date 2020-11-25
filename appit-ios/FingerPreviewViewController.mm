//
//  FingerPreviewViewController.m
//  appit-ios
//
//  Created by Pranjal Lamba on 08/11/17.
//  Copyright © 2017 IDMission. All rights reserved.
//

#import "FingerDetectionViewController2.h"
#import "FingerPreviewViewController.h"
#import "ViewController.h"
#import "ImageUtils.h"


@interface FingerPreviewViewController ()

@end

@implementation FingerPreviewViewController{
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        _resultDictionary = [NSMutableDictionary new];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    //Calling exit code only when _resultDictionary contain some value
    if ([_resultDictionary count] > 0) {
        if(_confirm){
            if(nil != _delegate){
                [_delegate fingerDetectionResponse:_resultDictionary];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:@"com.idmission.appit-ios"];
    NSString *retryIcon = [frameworkBundle pathForResource:@"retry" ofType:@"png"];
    NSString *confirmIcon = [frameworkBundle pathForResource:@"confirm" ofType:@"png"];
    NSString *handIconLeft = [frameworkBundle pathForResource:@"left_hand_start" ofType:@"png"];
    NSString *handIconRight = [frameworkBundle pathForResource:@"right_hand_start" ofType:@"png"];
    
    //Adding image preview view
    int width = self.view.frame.size.height;
    int height = self.view.frame.size.width;
    
    //Setting view's background color
    //    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.view setBackgroundColor:[UIColor colorWithRed:48/255.f green:48/255.f blue:48/255.f alpha:1]];
    
    //Adding retry button
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retryButton setImage:[UIImage imageNamed:retryIcon] forState:UIControlStateNormal];
    [retryButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:255]];
    [retryButton addTarget:self action:@selector(retry_capture:) forControlEvents:UIControlEventTouchUpInside];
    retryButton.frame = CGRectMake(2, width-50-2, (height/3)-2, 50); //2 is padding
    [self.view addSubview:retryButton];
 
    //Adding hand button
    UIButton *handButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(_currentHandLeft){
        [handButton setImage:[UIImage imageNamed:handIconRight] forState:UIControlStateNormal];
    }else{
        [handButton setImage:[UIImage imageNamed:handIconLeft] forState:UIControlStateNormal];
    }
    [handButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:1]];
    [handButton addTarget:self action:@selector(next_capture:) forControlEvents:UIControlEventTouchUpInside];
    handButton.frame = CGRectMake((height/3)+2, width-50-2, (height/3)-2, 50); //2 is padding
    [self.view addSubview:handButton];
    
    //Adding confirm button
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setImage:[UIImage imageNamed:confirmIcon] forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor colorWithRed:90/255.f green:89/255.f blue:91/255.f alpha:1]];
    [confirmButton addTarget:self action:@selector(confirm_image:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.frame = CGRectMake((height/3)+(height/3)+2, width-50-2, (height/3)-2, 50); //2 is padding
    [self.view addSubview:confirmButton];
    
    //Adding preview image
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (height/2), (width/2))]; //5 is padding
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = _preview_image_1;
    [self.view addSubview:imgView];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake((height/2)+2, 0, (height/2), (width/2))]; //5 is padding
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    imgView2.image = _preview_image_2;
    [self.view addSubview:imgView2];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, width/2, (height/2), (width/2)-50)]; //5 is padding
    imgView3.contentMode = UIViewContentModeScaleAspectFit;
    imgView3.image = _preview_image_3;
    [self.view addSubview:imgView3];
    
    UIImageView *imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake((height/2)+2, width/2, (height/2), (width/2)-50)]; //5 is padding
    imgView4.contentMode = UIViewContentModeScaleAspectFit;
    imgView4.image = _preview_image_4;
    [self.view addSubview:imgView4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)next_capture:(id)sender {
    _confirm = false;
    [self dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FingerDetectionViewController2 *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FingerDetectionViewController2"];
        vc.delegate = _delegate;
        vc.resultDictionary = _resultDictionary;
        vc.focus_threshold = _focus_threshold;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [_delegate presentModalViewController:vc animated:YES];
    }];
}

- (void)retry_capture:(id)sender {
    _confirm = false;
    [self dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        if(_currentHandLeft){
            [_resultDictionary removeObjectForKey:@"LIFINGER"];
            [_resultDictionary removeObjectForKey:@"LMFINGER"];
            [_resultDictionary removeObjectForKey:@"LRFINGER"];
            [_resultDictionary removeObjectForKey:@"LLFINGER"];
        }else{
            [_resultDictionary removeObjectForKey:@"RIFINGER"];
            [_resultDictionary removeObjectForKey:@"RMFINGER"];
            [_resultDictionary removeObjectForKey:@"RRFINGER"];
            [_resultDictionary removeObjectForKey:@"RLFINGER"];
        }
        
        FingerDetectionViewController2 *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FingerDetectionViewController2"];
        vc.delegate = _delegate;
        vc.resultDictionary = _resultDictionary;
        vc.focus_threshold = _focus_threshold;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [_delegate presentModalViewController:vc animated:YES];
    }];
}

- (void)confirm_image:(id)sender {
        _confirm = true;
        [self dismissViewControllerAnimated:YES completion:nil];
}

@end
