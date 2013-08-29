//
//  NoteDetailsViewController.h
//  My Notes
//
//  Created by Jeremy Fox on 8/28/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *noteTitle;
@property (weak, nonatomic) IBOutlet UITextView *noteDetails;
@property (nonatomic, strong) Note* note;

- (IBAction)deleteNote:(id)sender;
@end
