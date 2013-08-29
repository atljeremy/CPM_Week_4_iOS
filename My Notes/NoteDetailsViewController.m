//
//  NoteDetailsViewController.m
//  My Notes
//
//  Created by Jeremy Fox on 8/28/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "NoteDetailsViewController.h"

@interface NoteDetailsViewController ()

@end

@implementation NoteDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (self.note) {
        self.noteTitle.text = self.note.title;
        self.noteDetails.text = self.note.details;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteNote:(id)sender
{
    if ([Note markAsDeleted:self.note]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"An error occurred while trying to delete your note. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

@end
