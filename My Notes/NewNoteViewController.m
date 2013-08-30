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
    if (self.editingNote) {
        self.navigationItem.title = @"Edit Note";
        self.noteTitle.text = self.editingNote.title;
        self.noteDetails.text = self.editingNote.details;
    }
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
        if (self.editingNote) {
            TempNote* tempNote = [[TempNote alloc] init];
            tempNote.title = title;
            tempNote.details = details;
            if ([Note updateNote:self.editingNote withTempNote:tempNote]) {
                if (self.delegate) {
                    Note* note = [Note noteWithCriteria:@{kNoteTitleKey:title, kNoteDetailsKey:details}];
                    [self.delegate newEditNoteViewController:self didEditNote:note];
                }
                [self cancelNewNote:self];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"An error occurred while trying to update your note. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
        } else {
            TempNote* note = [[TempNote alloc] init];
            note.title = title;
            note.details = details;
            if ([Note addNote:note]) {
                [self cancelNewNote:self];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"An error occurred while trying to save your note. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
        }
    }
}

- (IBAction)valueChanged:(UISegmentedControl *)sender {
}

@end
