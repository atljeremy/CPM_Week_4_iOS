//
//  NewNoteViewController.m
//  My Notes
//
//  Created by Jeremy Fox on 8/27/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "NewNoteViewController.h"

@interface NewNoteViewController ()

@end

@implementation NewNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelNewNote:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveNewNote:(id)sender
{
    NSString* title = self.noteTitle.text;
    NSString* details = self.noteDetails.text;
    if ((!title || title.length == 0) || (!details || details.length == 0)) {
        [[[UIAlertView alloc] initWithTitle:@"All Fields Required" message:@"Please provide both a title and details for your note." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } else {
        TempNote* note = [[TempNote alloc] init];
        note.title = title;
        note.details = details;
        [Note addNote:note];
        [self cancelNewNote:self];
    }
}
@end
