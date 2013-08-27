#import "_Note.h"
#import "TempNote.h"

NSString* const kNoteIdKey;
NSString* const kNoteTitleKey;
NSString* const kNoteDetailsKey;
NSString* const kNoteCreatedAtKey;
NSString* const kNoteUpdatedAtKey;

typedef NS_ENUM(NSInteger, NoteSortOption) {
    NoteSortOptionCREATED,
    NoteSortOptionUPDATED,
    NoteSortOptionALPHABETICAL
};

extern NSString* SortDescriptorForSortOption(NoteSortOption sortOption);

@interface Note : _Note

+ (Note*)addNote:(TempNote*)note;
+ (BOOL)removeNote:(Note*)note;
+ (BOOL)updateNote:(Note*)note withTempNote:(TempNote*)tempNote;
+ (NSArray*)allNotesSortedBy:(NoteSortOption)sortOption ascending:(BOOL)asc;
+ (NSArray*)allUnsyncedNotes;

- (BOOL)updateUpdatedAt;
- (BOOL)updateApiId:(NSNumber*)apiId;

@end
