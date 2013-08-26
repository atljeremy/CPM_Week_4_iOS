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
        success(responseObject);
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
    for (Note* note in notes) {
        NSDictionary* params = [self buildParams:note];
        NSMutableURLRequest* request = [client requestWithMethod:@"POST" path:@"notes.json" parameters:params];
        AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Successfully synced note with response: %@", responseObject);
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
    }
}

+ (void)sendNoteToAPI:(Note*)note
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary* params = [self buildParams:note];
    [[AFAppWebServiceClient sharedClient] postPath:@"notes.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

+ (void)deleteNotesFromAPI:(NSArray*)notes
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    for (Note* note in notes) {
        NSString* noteRoute = [NSString stringWithFormat:@"notes/%@.json", note.apiNoteId];
        NSDictionary* params = [self buildParams:nil];
        [[AFAppWebServiceClient sharedClient] deletePath:noteRoute parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
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
