//
//  NoteDetailsViewController.m
//  My Notes
//
//  Created by Jeremy Fox on 8/28/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "NoteDetailsViewController.h"
#import "NewNoteViewController.h"
#import "SyncR.h"

static NSString* const kPresentNewNoteScreenForEditing = @"PresentNewNoteScreenForEditing";

@interface NoteDetailsViewController () <NewEditNoteDelegate>
@property (nonatomic, assign) BOOL isEditingNote;
@end

@implementation NoteDetailsViewController

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
	
    if (self.note) {
        self.noteTitle.text = self.note.title;
        self.noteDetails.text = self.note.details;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)deleteNote:(id)sender
{
    if ([Note markAsDeleted:self.note]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"An error occurred while trying to delete your note. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPresentNewNoteScreenForEditing]) {
        self.isEditingNote = YES;
        NewNoteViewController* destinationVC = (NewNoteViewController*)segue.destinationViewController;
        destinationVC.delegate = self;
        [destinationVC setEditingNote:self.note];
    }
}

#pragma mark - NewEditNoteDelegate

- (void)newEditNoteViewController:(NewNoteViewController*)vc didEditNote:(Note*)note
{
    if (note) {
        self.note = note;
        self.noteTitle.text = self.note.title;
        self.noteDetails.text = self.note.details;
        [SyncR updateNoteInAPI:self.note success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Note updated!");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"An error occurred while trying to send your updates to the server. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }];
    }
}

@end
