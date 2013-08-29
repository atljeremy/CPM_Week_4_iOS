// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.h instead.

#import <CoreData/CoreData.h>


extern const struct NoteAttributes {
	__unsafe_unretained NSString *apiNoteId;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *deleted;
	__unsafe_unretained NSString *details;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updatedAt;
} NoteAttributes;

extern const struct NoteRelationships {
	__unsafe_unretained NSString *user;
} NoteRelationships;

extern const struct NoteFetchedProperties {
} NoteFetchedProperties;

@class User;








@interface NoteID : NSManagedObjectID {}
@end

@interface _Note : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NoteID*)objectID;





@property (nonatomic, strong) NSNumber* apiNoteId;



@property int16_t apiNoteIdValue;
- (int16_t)apiNoteIdValue;
- (void)setApiNoteIdValue:(int16_t)value_;

//- (BOOL)validateApiNoteId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* deleted;



@property BOOL deletedValue;
- (BOOL)deletedValue;
- (void)setDeletedValue:(BOOL)value_;

//- (BOOL)validateDeleted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* details;



//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Note (CoreDataGeneratedAccessors)

@end

@interface _Note (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveApiNoteId;
- (void)setPrimitiveApiNoteId:(NSNumber*)value;

- (int16_t)primitiveApiNoteIdValue;
- (void)setPrimitiveApiNoteIdValue:(int16_t)value_;




- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveDeleted;
- (void)setPrimitiveDeleted:(NSNumber*)value;

- (BOOL)primitiveDeletedValue;
- (void)setPrimitiveDeletedValue:(BOOL)value_;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;





- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
