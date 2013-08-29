//
//  NotesCollectionViewController.m
//  My Notes
//
//  Created by Jeremy Fox on 8/26/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "NotesCollectionViewController.h"
#import "NotesCollectionViewCell.h"
#import "SyncR.h"
#import "NoteDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

static NSString* const kCollectionCellReuseID = @"NotesCollectionViewCell";
static NSString* const kPresentNewNoteViewController = @"PresentNewNoteViewController";
static NSString* const kPresentNoteDetails = @"PresentNoteDetails";

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startRotatingArrows)
                                                 name:kSyncDidStartNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadNotes)
                                                 name:kSyncDidFinishNotification
                                               object:nil];
    [self loadNotes];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [AFAppWebServiceClient synchronize];
    [self loadNotes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRotatingArrows
{
    CABasicAnimation *halfTurn;
    halfTurn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn.fromValue = [NSNumber numberWithFloat:0];
    halfTurn.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn.duration = 1.0;
    halfTurn.repeatCount = HUGE_VALF;
    [[self.syncBtn layer] addAnimation:halfTurn forKey:@"180"];
}

- (void)stopRotatingArrows
{
    [self.syncBtn.layer removeAllAnimations];
}

- (IBAction)syncNotes:(id)sender
{
    [AFAppWebServiceClient synchronize];
}

- (IBAction)newNote:(id)sender
{
    [self performSegueWithIdentifier:kPresentNewNoteViewController sender:self];
}

- (void)loadNotes
{
    self.user = [User userWithNotesSortedBy:NoteSortOptionCREATED ascending:YES];
    self.notes = [self.user.notes allObjects];
    [self.collectionView reloadData];
    [self stopRotatingArrows];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kPresentNoteDetails]) {
        if (sender) {
            Note* note = ((NotesCollectionViewCell*)sender).note;
            [(NoteDetailsViewController*)segue.destinationViewController setNote:note];
        }
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.notes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NotesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellReuseID forIndexPath:indexPath];
    Note* note = [self.notes objectAtIndex:indexPath.row];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:recognizer];
    [cell setNote:note];
//    cell.photo = photo;
//    if (!cell.isSelected) {
//        cell.checkMark.hidden = YES;
//    } else {
//        cell.checkMark.hidden = NO;
//    }
    return cell;

}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 150);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

@end
