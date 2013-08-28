//
//  NotesCollectionViewController.h
//  My Notes
//
//  Created by Jeremy Fox on 8/26/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kCollectionViewReloadNotification;

@interface NotesCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *syncBtn;

- (IBAction)syncNotes:(id)sender;
- (IBAction)newNote:(id)sender;

@end
