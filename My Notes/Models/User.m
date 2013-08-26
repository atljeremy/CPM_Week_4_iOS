#import "User.h"

@implementation User

+ (User*)addUser:(TempUser*)user
{
    User* newUser = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (user && context) {
        newUser              = [self insertInManagedObjectContext:context];
        newUser.apiToken     = user.apiToken ? user.apiToken : @"";
        newUser.apiUserId    = user.apiUserId ? user.apiUserId : [NSNumber numberWithInt:-1];
        NSDate* now          = [NSDate date];
        newUser.lastSyncDate = now;
        newUser.email        = user.email ? user.email : @"";
        
        NSError* error;
        if (![context save:&error]) {
            // Handle the error.
            
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return newUser;
}

+ (BOOL)removeUser:(User*)user
{
    BOOL removed = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (user && context) {
        [context deleteObject:user];
        
        NSError* error;
        if (![context save:&error]) {
            // Handle the error.
            
            removed = NO;
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return removed;
}

+ (User*)userWithNotesSortedBy:(NoteSortOption)sortOption ascending:(BOOL)asc
{
    User* user = nil;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[User entityName]
                                                  inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSError *error = nil;
        NSArray* users = [context executeFetchRequest:request error:&error];
        if (users != nil) {
            user = [users lastObject];
            user.notes = [NSSet setWithArray:[Note allNotesSortedBy:sortOption ascending:asc]];
        }
    }
    return user;
}

+ (NSString*)apiToken
{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kAPIStoredPrivateKey];
#warning TODO: remove the following line after CPM Week 4 project submission
    return @"cOmMSjw2gYGtGjvHrGOkow";
}

- (BOOL)updateAPIUserId:(NSNumber*)apiUserId
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (apiUserId && context) {
        self.apiUserId = apiUserId;
        
        NSError* error;
        if ([context save:&error]) {
            
            updated = NO;
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return updated;
}

- (BOOL)updateAPIToken:(NSString*)apiToken
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (apiToken && context) {
        self.apiToken = apiToken;
        
        NSError* error;
        if ([context save:&error]) {
            
            updated = NO;
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return updated;
}

- (BOOL)updateEmail:(NSString*)email
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (email && context) {
        self.email = email;
        
        NSError* error;
        if ([context save:&error]) {
            
            updated = NO;
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return updated;
}

- (BOOL)updateLastSyncDate:(NSDate*)lastSyncDate
{
    BOOL updated = YES;
    NSManagedObjectContext* context = [JFCoreDataManager getContext];
    if (lastSyncDate && context) {
        self.lastSyncDate = lastSyncDate;
        
        NSError* error;
        if ([context save:&error]) {
            
            updated = NO;
            NSLog(@"%@", error.localizedDescription);
        }
    }
    return updated;
}


@end
