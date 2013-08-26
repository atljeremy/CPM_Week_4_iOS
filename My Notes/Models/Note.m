#import "Note.h"

NSString* SortDescriptorForSortOption(NoteSortOption sortOption) {
    NSString* sortDescriptor = @"";
    switch (sortOption) {
        case NoteSortOptionUPDATED:
            sortDescriptor = @"title";
            break;

        case NoteSortOptionALPHABETICAL:
            sortDescriptor = @"updatedAt";
            break;
            
        case NoteSortOptionCREATED:
        default:
            sortDescriptor = @"createdAt";
            break;
    }
    return sortDescriptor;
}

@implementation Note

+ (Note*)addNote:(TempNote*)note
{
    Note* newNote = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (note && context) {
        newNote           = [self insertInManagedObjectContext:context];
        newNote.title     = note.title;
        newNote.details   = note.details;
        NSDate* now       = [NSDate date];
        newNote.createdAt = now;
        newNote.updatedAt = now;
        newNote.apiNoteId = [NSNumber numberWithInt:-1];
        
        NSError* error;
        if (![context save:&error]) {
            // Handle the error.
            
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return newNote;
}

+ (BOOL)removeNote:(Note*)note
{
    BOOL removed = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (note && context) {
        [context deleteObject:note];
        
        NSError* error;
        if (![context save:&error]) {
            // Handle the error.
            
            removed = NO;
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return removed;
}

+ (BOOL)updateNote:(Note*)note withNote:(Note*)upatedNote
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (note && context) {
        note.title     = upatedNote.title;
        note.details   = upatedNote.details;
        note.createdAt = upatedNote.createdAt;
        note.updatedAt = [NSDate date];
        
        NSError* error;
        if (![context save:&error]) {
            // Handle the error.
            
            updated = NO;
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return updated;
}

+ (NSArray*)allNotesSortedBy:(NoteSortOption)sortOption ascending:(BOOL)asc
{
    NSArray* notes = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[Note entityName]
                                                  inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSString* key = SortDescriptorForSortOption(sortOption);
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        
        NSError *error = nil;
        notes = [context executeFetchRequest:request error:&error];
        if (notes == nil) {
            // Handle the error.
        }
    }
    return notes;
}

+ (NSArray*)allUnsyncedNotes
{
    NSArray* notes = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[Note entityName]
                                                  inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"apiNoteId = %@", [NSNumber numberWithInt:-1], [NSNumber numberWithBool:NO]];
        [request setPredicate:predicate];
        
        NSString* key = SortDescriptorForSortOption(NoteSortOptionCREATED);
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        
        NSError *error = nil;
        notes = [context executeFetchRequest:request error:&error];
        if (notes == nil) {
            // Handle the error.
        }
    }
    return notes;
}

@end
