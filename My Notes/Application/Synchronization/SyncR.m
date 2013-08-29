//
//  SyncR.m
//  My Notes
//
//  Created by Jeremy Fox on 8/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "SyncR.h"

@implementation SyncR

+ (void)getNotesFromAPIWithSuccess:(void (^)(NSArray *notes))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = [self buildParams:nil];
    [[AFAppWebServiceClient sharedClient] getPath:@"notes.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_queue_t queue = dispatch_queue_create("com.jeremyfox.GetNotesSyncQueue", NULL);
        dispatch_async(queue, ^{
            
            /**
             * First, get all unsynced notes and set aside
             */
            NSArray* unsyncedNotes = [Note allUnsyncedNotes];
            
            /**
             * Then Remove all Notes from the database
             */
            [Note removeAllNotes];
            
            /**
             * Now iterate over all notes returned from the API and save to the local db.
             *
             * Do this in an @autoreleasepool to ensure memory doesn't get out of hand in the
             * event there are hundreds of notes to sync. We don't need hundreds of TempNote 
             * and Note objects sitting in memory not being used.
             */
            @autoreleasepool {
                for (NSDictionary* note in responseObject) {
                    TempNote* tempNote = [[TempNote alloc] init];
                    tempNote.title = [note objectForKey:kNoteTitleKey];
                    tempNote.details = [note objectForKey:kNoteDetailsKey];
                    tempNote.createdAt = [note objectForKey:kNoteCreatedAtKey];
                    tempNote.updatedAt = [note objectForKey:kNoteUpdatedAtKey];
                    tempNote.apiNoteId = [note objectForKey:kNoteIdKey];
                    [Note addNote:tempNote];
                    tempNote = nil;
                }
            }
            
            /**
             * Last, re-add the unsynced notes to the db.
             */
            for (Note* note in unsyncedNotes) {
                [Note reAddNote:note];
            }
            unsyncedNotes = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                success([Note allNotesSortedBy:NoteSortOptionCREATED ascending:YES]);
                
            });
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+ (void)sendUnsyncedNotesToAPIWithCompletionBlock:(void (^)(NSError* error))completionBlock
{
    NSArray* notes = [Note allUnsyncedNotes];
    AFAppWebServiceClient* client = [AFAppWebServiceClient sharedClient];
    
    __block BOOL anOperationFailed = NO;
    NSMutableArray* operations = [@[] mutableCopy];
    for (__block Note* note in notes) {
        NSDictionary* params = [self buildParams:note];
        NSMutableURLRequest* request = [client requestWithMethod:@"POST" path:@"notes.json" parameters:params];
        AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully synced note with response: %@", responseObject);
            
            
            Need to find a way to update the note at this point!
            
            note.apiNoteId = [responseObject objectForKey:kNoteIdKey];
            [[JFCoreDataManager sharedInstance] saveContext];
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to sync note with error: %@", error.localizedDescription);
            anOperationFailed = YES;
        }];
        [operations addObject:operation];
    }
    
    if (operations.count > 0) {
        [client enqueueBatchOfHTTPRequestOperations:operations progressBlock:nil completionBlock:^(NSArray *operations) {
            NSError* error = nil;
            if (anOperationFailed) {
                error = [NSError errorWithDomain:@"UnsuccessfulSyncError" code:999 userInfo:nil];
            }
            completionBlock(error);
        }];
    } else {
        completionBlock(nil);
    }
}

+ (void)sendNoteToAPI:(Note*)note
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    __block Note* blockNote = note;
    NSDictionary* params = [self buildParams:note];
    [[AFAppWebServiceClient sharedClient] postPath:@"notes.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        blockNote.apiNoteId = [responseObject objectForKey:kNoteIdKey];
        [[JFCoreDataManager sharedInstance] saveContext];
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+ (void)deleteNotesFromAPI:(NSArray*)notes withCompletionBlock:(void (^)(NSError* error))completionBlock
{
    AFAppWebServiceClient* client = [AFAppWebServiceClient sharedClient];
    
    __block BOOL anOperationFailed = NO;
    NSMutableArray* operations = [@[] mutableCopy];
    for (__block Note* note in notes) {
        NSDictionary* params = [self buildParams:nil];
        NSString* noteRoute = [NSString stringWithFormat:@"notes/%@.json", note.apiNoteId];
        NSMutableURLRequest* request = [client requestWithMethod:@"DELETE" path:noteRoute parameters:params];
        AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully Deleted a Note from the API!");
            
            Need to find a way to delete the note from the local DB at this point!
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to delete a note fromt he API!");
            anOperationFailed = YES;
        }];
        [operations addObject:operation];
    }
    
    if (operations.count > 0) {
        [client enqueueBatchOfHTTPRequestOperations:operations progressBlock:nil completionBlock:^(NSArray *operations) {
            NSError* error = nil;
            if (anOperationFailed) {
                error = [NSError errorWithDomain:@"UnsuccessfulSyncError" code:999 userInfo:nil];
            }
            completionBlock(error);
        }];
    } else {
        completionBlock(nil);
    }

}

+ (void)updateNoteInAPI:(Note*)note
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString* noteRoute = [NSString stringWithFormat:@"notes/%@.json", note.apiNoteId];
    NSDictionary* params = [self buildParams:note];
    [[AFAppWebServiceClient sharedClient] putPath:noteRoute parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+ (NSDictionary*)buildParams:(Note*)note
{
    if (note) {
        return @{@"note":@{@"title":note.title, @"details":note.details}, @"unique_id":[User apiToken]};
    } else {
        return @{@"unique_id":[User apiToken]};
    }
}

@end
