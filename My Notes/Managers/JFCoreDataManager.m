//
//  JFCoreDataManager.m
//  My Notes
//
//  Created by Jeremy Fox on 8/25/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "JFCoreDataManager.h"

@interface JFCoreDataManager()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation JFCoreDataManager

+ (instancetype)sharedInstance
{
    static JFCoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Core Data stack

- (BOOL)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext && [managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        NSLog(@"An Error Occurred while Trying to Save Context: %@", error.localizedDescription);
    }
    
    if (error) {
        return NO;
    }
    return YES;
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"My_Notes" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"My_Notes.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSString *configuration = nil;
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [self comparePersistentStore:_persistentStoreCoordinator withStoreURL:storeURL];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        _persistentStoreCoordinator = nil;
        _managedObjectModel = nil;
        
        // If unable to perform the automatic migration, recreate the model and data file
        if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
            
            if (![[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error]) {
                NSLog(@"Unresolved error while trying to remove store. %@, %@", error, [error userInfo]);
            } else {
                _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
                
                if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:configuration URL:storeURL options:options error:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                }
            }
        }
    }
    
    return _persistentStoreCoordinator;
}

- (BOOL)comparePersistentStore:(NSPersistentStoreCoordinator *)psc withStoreURL: (NSURL *)storeURL {
    NSError *error = nil;
    
    // Get the entities & keys from the persistent store coordinator
    NSManagedObjectModel *pscModel = [psc managedObjectModel];
    NSDictionary *pscEntities = [pscModel entitiesByName];
    NSSet *pscKeys = [NSSet setWithArray:[pscEntities allKeys]];
    //NSLog(@"psc model:%@", pscModel);
    //NSLog(@"psc keys:%@", pscKeys);
    NSLog(@"psc contains %d entities", [pscModel.entities count]);
    
    // Get the entity hashes from the storeURL
    NSDictionary *storeMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                             URL:storeURL
                                                                                           error:&error];
    NSDictionary *storeHashes = [storeMetadata objectForKey:@"NSStoreModelVersionHashes"];
    //NSLog(@"store metadata:%@", sourceMetadata);
    NSLog(@"store URL:%@", storeURL);
    NSLog(@"store NSStoreUUID:%@", [storeMetadata objectForKey:@"NSStoreUUID"]);
    NSLog(@"store NSStoreType:%@", [storeMetadata objectForKey:@"NSStoreType"]);
    NSSet *storeKeys = [NSSet setWithArray:[storeHashes allKeys]];
    
    // Determine store entities that were added, removed, and in common (to/with psc)
    NSMutableSet *addedEntities = [NSMutableSet setWithSet:pscKeys];
    NSMutableSet *removedEntities = [NSMutableSet setWithSet:storeKeys];
    NSMutableSet *commonEntities = [NSMutableSet setWithSet:pscKeys];
    NSMutableSet *changedEntities = [NSMutableSet new];
    [addedEntities minusSet:storeKeys];
    [removedEntities minusSet:pscKeys];
    [commonEntities minusSet:removedEntities];
    [commonEntities minusSet:addedEntities];
    
    // Determine entities that have changed (with different hashes)
    [commonEntities enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
        NSData *storeHash = [storeHashes objectForKey:key];
        NSEntityDescription *pscDescrip = [pscEntities objectForKey:key];
        if ( ! [pscDescrip.versionHash isEqualToData:storeHash]) {
            if (storeHash != nil && pscDescrip.versionHash != nil) {
                [changedEntities addObject:key];
            }
        }
    }];
    
    // Remove changed entities from common list
    [commonEntities minusSet:changedEntities];
    
    if ([commonEntities count] > 0) {
        NSLog(@"Common entities:");
        [commonEntities enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
            __unused NSEntityDescription *pscDescrip = [pscEntities objectForKey:key];
            NSLog(@"\t%@:\t%@", key, pscDescrip.versionHash);
        }];
    }
    if ([changedEntities count] > 0) {
        NSLog(@"Changed entities:");
        [changedEntities enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
            __unused NSData *storeHash = [storeHashes objectForKey:key];
            __unused NSEntityDescription *pscDescrip = [pscEntities objectForKey:key];
            NSLog(@"\tpsc   %@:\t%@", key, pscDescrip.versionHash);
            NSLog(@"\tstore %@:\t%@", key, storeHash);
        }];
    }
    if ([addedEntities count] > 0) {
        NSLog(@"Added entities to psc model (not in store):");
        [addedEntities enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
            __unused NSEntityDescription *pscDescrip = [pscEntities objectForKey:key];
            NSLog(@"\t%@:\t%@", key, pscDescrip.versionHash);
        }];
    }
    if ([removedEntities count] > 0) {
        NSLog(@"Removed entities from psc model (exist in store):");
        [removedEntities enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
            __unused NSData *storeHash = [storeHashes objectForKey:key];
            NSLog(@"\t%@:\t%@", key, storeHash);
        }];
    }
    
    BOOL pscCompatibile = [pscModel isConfiguration:nil     compatibleWithStoreMetadata:storeMetadata];
    NSLog(@"Migration needed? %@", pscCompatibile?@"no":@"yes");
    
    return pscCompatibile;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Get NSManagedObjectContext

+ (NSManagedObjectContext*)getContext
{
    return [JFCoreDataManager sharedInstance].managedObjectContext;
}

+ (NSManagedObjectContext*)newContext
{
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = [JFCoreDataManager sharedInstance].persistentStoreCoordinator;
    return context;
}

#pragma mark - Context Monitoring

- (void)registerForContextSavedNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextHasChanged:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

- (void)contextHasChanged:(NSNotification*)notification
{
    if ([notification object] == _managedObjectContext) return;
    
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(contextHasChanged:)
                               withObject:notification
                            waitUntilDone:YES];
        return;
    }
    
    [_managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

@end
