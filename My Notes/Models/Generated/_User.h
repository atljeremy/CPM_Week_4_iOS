// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *apiToken;
	__unsafe_unretained NSString *apiUserId;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *lastSyncDate;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *notes;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class Note;






@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;





@property (nonatomic, strong) NSString* apiToken;



//- (BOOL)validateApiToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* apiUserId;



@property int16_t apiUserIdValue;
- (int16_t)apiUserIdValue;
- (void)setApiUserIdValue:(int16_t)value_;

//- (BOOL)validateApiUserId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastSyncDate;



//- (BOOL)validateLastSyncDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *notes;

- (NSMutableSet*)notesSet;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(Note*)value_;
- (void)removeNotesObject:(Note*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveApiToken;
- (void)setPrimitiveApiToken:(NSString*)value;




- (NSNumber*)primitiveApiUserId;
- (void)setPrimitiveApiUserId:(NSNumber*)value;

- (int16_t)primitiveApiUserIdValue;
- (void)setPrimitiveApiUserIdValue:(int16_t)value_;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSDate*)primitiveLastSyncDate;
- (void)setPrimitiveLastSyncDate:(NSDate*)value;





- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;


@end
