//
//  NotesCollectionViewCell.m
//  My Notes
//
//  Created by Jeremy Fox on 8/26/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "NotesCollectionViewCell.h"

@implementation NotesCollectionViewCell

- (void)setNote:(Note *)note
{
    _note = note;
    self.noteTitle.text = _note.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.noteDate.text = [dateFormatter stringFromDate:_note.createdAt];
}

@end
