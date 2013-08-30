#import "_Note.h"
#import "TempNote.h"

NSString* const kNoteIdKey;
NSString* const kNoteTitleKey;
NSString* const kNoteDetailsKey;
NSString* const kNoteCreatedAtKey;
NSString* const kNoteUpdatedAtKey;
NSString* const kNoteAPIIdKey;

typedef NS_ENUM(NSInteger, NoteSortOption) {
    NoteSortOptionCREATED,
    NoteSortOptionUPDATED,
    NoteSortOptionALPHABETICAL
};

extern NSString* SortDescriptorForSortOption(NoteSortOption sortOption);

@interface Note : _Note

+ (Note*)addNote:(TempNote*)note;
+ (Note*)reAddNote:(Note*)note;
+ (BOOL)removeNote:(Note*)note;
+ (BOOL)removeAllNotes;
+ (BOOL)markAsDeleted:(Note*)note;
+ (BOOL)updateNote:(Note*)note withTempNote:(TempNote*)tempNote;
+ (NSArray*)allNotesSortedBy:(NoteSortOption)sortOption ascending:(BOOL)asc;
+ (NSArray*)allUnsyncedNotes;
+ (NSArray*)allNotesMarkedForDeletion;
+ (Note*)noteWithCriteria:(NSDictionary*)filterCriteria;

- (BOOL)updateUpdatedAt;
- (BOOL)updateApiId:(NSNumber*)apiId;

@end
