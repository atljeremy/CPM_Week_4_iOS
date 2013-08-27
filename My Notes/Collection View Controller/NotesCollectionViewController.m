//
//  NotesCollectionViewController.m
//  My Notes
//
//  Created by Jeremy Fox on 8/26/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "NotesCollectionViewController.h"
#import "NotesCollectionViewCell.h"

static NSString* const kCollectionCellReuseID = @"NotesCollectionViewCell";

@interface NotesCollectionViewController ()
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSArray* notes;
@end

@implementation NotesCollectionViewController

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
	self.user = [User userWithNotesSortedBy:NoteSortOptionCREATED ascending:YES];
    self.notes = [self.user.notes allObjects];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.notes.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NotesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellReuseID forIndexPath:indexPath];
    Note* note = [self.notes objectAtIndex:indexPath.row];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:recognizer];
    cell.noteTitle.text = note.title;
//    cell.photo = photo;
//    if (!cell.isSelected) {
//        cell.checkMark.hidden = YES;
//    } else {
//        cell.checkMark.hidden = NO;
//    }
    return cell;

}

@end
