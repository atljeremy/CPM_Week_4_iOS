#import "_User.h"
#import "TempUser.h"
#import "Note.h"

@interface User : _User

+ (User*)addUser:(TempUser*)user;
+ (BOOL)removeUser:(User*)user;
+ (User*)userWithNotesSortedBy:(NoteSortOption)sortOption ascending:(BOOL)asc;
+ (NSString*)apiToken;

- (BOOL)updateAPIUserId:(NSNumber*)apiUserId;
- (BOOL)updateAPIToken:(NSString*)apiToken;
- (BOOL)updateEmail:(NSString*)email;
- (BOOL)updateLastSyncDate:(NSDate*)lastSyncDate;

@end
