//
//  ViewController.m
//  My Notes
//
//  Created by Jeremy Fox on 8/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) User* user;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.user = [User userWithNotesSortedBy:NoteSortOptionCREATED ascending:YES];
    NSLog(@"here");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
