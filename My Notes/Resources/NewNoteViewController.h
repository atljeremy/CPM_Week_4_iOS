//
//  NewNoteViewController.h
//  My Notes
//
//  Created by Jeremy Fox on 8/27/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *noteTitle;
@property (weak, nonatomic) IBOutlet UITextField *noteDetails;

- (IBAction)cancelNewNote:(id)sender;
- (IBAction)saveNewNote:(id)sender;

@end
