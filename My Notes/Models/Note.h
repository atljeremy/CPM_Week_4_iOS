#import "_Note.h"
#import "TempNote.h"

typedef NS_ENUM(NSInteger, NoteSortOption) {
    NoteSortOptionCREATED,
    NoteSortOptionUPDATED,
    NoteSortOptionALPHABETICAL
};

extern NSString* SortDescriptorForSortOption(NoteSortOption sortOption);

@interface Note : _Note

+ (Note*)addNote:(TempNote*)note;
+ (BOOL)removeNote:(Note*)note;
+ (BOOL)updateNote:(Note*)note withNote:(Note*)upatedNote;
+ (NSArray*)allNotesSortedBy:(NoteSortOption)sortOption ascending:(BOOL)asc;
+ (NSArray*)allUnsyncedNotes;

@end
