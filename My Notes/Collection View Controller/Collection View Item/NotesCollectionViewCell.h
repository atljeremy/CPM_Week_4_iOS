//
//  NotesCollectionViewCell.h
//  My Notes
//
//  Created by Jeremy Fox on 8/26/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) Note* note;
@property (nonatomic, weak) IBOutlet UILabel *noteTitle;

@end
