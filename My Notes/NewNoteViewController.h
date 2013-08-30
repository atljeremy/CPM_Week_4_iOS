//
//  NewNoteViewController.h
//  My Notes
//
//  Created by Jeremy Fox on 8/27/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewEditNoteDelegate;

@interface NewNoteViewController : UIViewController

@property (weak, nonatomic) Note* editingNote;
@property (weak, nonatomic) IBOutlet UITextField *noteTitle;
@property (weak, nonatomic) IBOutlet UITextField *noteDetails;
@property (weak, nonatomic) id<NewEditNoteDelegate> delegate;

- (IBAction)cancelNewNote:(id)sender;
- (IBAction)saveNewNote:(id)sender;
- (IBAction)valueChanged:(id)sender;

@end

@protocol NewEditNoteDelegate

- (void)newEditNoteViewController:(NewNoteViewController*)vc didEditNote:(Note*)note;

@end
