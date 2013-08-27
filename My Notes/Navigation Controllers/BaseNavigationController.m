//
//  STBaseNavigationController.m
//  SnapTo
//
//  Created by Jeremy Fox on 11/1/12.
//  Copyright (c) 2012 Jeremy Fox. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    UIColor* logoColor = [UIColor colorWithRed:135.0f/255.0f green:181.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    viewController.navigationItem.leftBarButtonItem.tintColor = logoColor;
    viewController.navigationItem.rightBarButtonItem.tintColor = logoColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

#pragma mark iOS 6 Rotation Support

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
