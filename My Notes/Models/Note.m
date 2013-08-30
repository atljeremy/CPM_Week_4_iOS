#import "Note.h"

NSString* const kNoteIdKey = @"id";
NSString* const kNoteTitleKey = @"title";
NSString* const kNoteDetailsKey = @"details";
NSString* const kNoteCreatedAtKey = @"created_at";
NSString* const kNoteUpdatedAtKey = @"updated_at";
NSString* const kNoteAPIIdKey = @"apiNoteId";

NSString* SortDescriptorForSortOption(NoteSortOption sortOption) {
    NSString* sortDescriptor = @"";
    switch (sortOption) {
        case NoteSortOptionUPDATED:
            sortDescriptor = @"updatedAt";
            break;

        case NoteSortOptionALPHABETICAL:
            sortDescriptor = @"title";
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
        newNote           = [self getNoteByAPIId:note.apiNoteId];
        newNote           = (newNote) ? newNote : [self insertInManagedObjectContext:context];
        newNote.title     = note.title;
        newNote.details   = note.details;
        newNote.deleted   = @NO;
        NSDate* now       = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"]; // 2013-08-20T02:11:39Z
        newNote.createdAt = (note.createdAt) ? [formatter dateFromString:note.createdAt] : now;
        newNote.updatedAt = (note.updatedAt) ? [formatter dateFromString:note.updatedAt] : now;
        newNote.apiNoteId = (note.apiNoteId) ? note.apiNoteId : [NSNumber numberWithInt:-1];
        
        if (![[JFCoreDataManager sharedInstance] saveContext]) {
            newNote = nil;
        }
    }
    return newNote;
}

+ (Note*)reAddNote:(Note*)note
{
    Note* newNote = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (note && context) {
        newNote           = [self getNoteByAPIId:note.apiNoteId];
        newNote           = (newNote) ? newNote : [self insertInManagedObjectContext:context];
        newNote.title     = note.title;
        newNote.details   = note.details;
        newNote.deleted   = @NO;
        newNote.createdAt = note.createdAt;
        newNote.updatedAt = note.updatedAt;
        newNote.apiNoteId = (note.apiNoteId) ? note.apiNoteId : [NSNumber numberWithInt:-1];
        
        if (![[JFCoreDataManager sharedInstance] saveContext]) {
            newNote = nil;
        }
    }
    return newNote;
}

+ (BOOL)markAsDeleted:(Note*)note
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (note && context) {
        note.deleted = @YES;
        
        updated = [[JFCoreDataManager sharedInstance] saveContext];

    }
    return updated;
}

+ (BOOL)removeNote:(Note*)note
{
    BOOL removed = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (note && context) {
        [context deleteObject:note];
        
        removed = [[JFCoreDataManager sharedInstance] saveContext];
    }
    return removed;
}

+ (BOOL)removeAllNotes
{
    BOOL allRemoved = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        NSArray* allNotes = [self allNotesSortedBy:NoteSortOptionCREATED ascending:YES];
        for (Note* note in allNotes) {
            [context deleteObject:note];
        }
        allRemoved = [[JFCoreDataManager sharedInstance] saveContext];
    }
    return allRemoved;
}

+ (BOOL)updateNote:(Note*)note withTempNote:(TempNote*)tempNote
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (note && tempNote && context) {
        note.title     = tempNote.title;
        note.details   = tempNote.details;
        note.updatedAt = [NSDate date];
        
        updated = [[JFCoreDataManager sharedInstance] saveContext];
    }
    return updated;
}

+ (Note*)getNoteByAPIId:(NSNumber*)apiId
{
    Note* note = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[Note entityName]
                                                  inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"apiNoteId = %@", apiId];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray* notes = [context executeFetchRequest:request error:&error];
        if (notes != nil && notes.count == 1) {
            note = [notes lastObject];
        }
    }
    return note;
}

+ (Note*)noteWithCriteria:(NSDictionary*)filterCriteria
{
    Note* note = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[Note entityName]
                                                  inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSMutableArray* predicates = [@[] mutableCopy];
        for (NSString* key in filterCriteria.allKeys) {
            NSString* value = [filterCriteria objectForKey:key];
            if ([key isEqualToString:kNoteTitleKey]) {
                [predicates addObject:[NSPredicate predicateWithFormat:@"title = %@", value]];
            } else if ([key isEqualToString:kNoteDetailsKey]) {
                [predicates addObject:[NSPredicate predicateWithFormat:@"details = %@", value]];
            } else if ([key isEqualToString:kNoteCreatedAtKey]) {
                [predicates addObject:[NSPredicate predicateWithFormat:@"createdAt = %@", value]];
            } else if ([key isEqualToString:kNoteUpdatedAtKey]) {
                [predicates addObject:[NSPredicate predicateWithFormat:@"updatedAt = %@", value]];
            } else if ([key isEqualToString:kNoteAPIIdKey]) {
                [predicates addObject:[NSPredicate predicateWithFormat:@"apiNoteId = %@", value]];
            }
        }
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray* notes = [context executeFetchRequest:request error:&error];
        if (notes.count == 1) {
            note = [notes lastObject];
        }
    }
    return note;
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == NO"];
        [request setPredicate:predicate];
        
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"apiNoteId = %@", [NSNumber numberWithInt:-1]];
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

+ (NSArray*)allNotesMarkedForDeletion
{
    NSArray* notes = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[Note entityName]
                                                  inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deleted == YES"];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        notes = [context executeFetchRequest:request error:&error];
        if (notes == nil) {
            // Handle the error.
        }
    }
    return notes;
}

- (BOOL)updateUpdatedAt
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        self.updatedAt = [NSDate date];
        
        updated = [[JFCoreDataManager sharedInstance] saveContext];
    }
    return updated;
}

- (BOOL)updateApiId:(NSNumber*)apiId
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (apiId && context) {
        self.apiNoteId = apiId;
        
        updated = [[JFCoreDataManager sharedInstance] saveContext];
    }
    return updated;
}

@end
