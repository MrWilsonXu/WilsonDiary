//
//  StudentCoreData+CoreDataProperties.m
//  
//
//  Created by Wilson on 2020/3/29.
//
//

#import "StudentCoreData+CoreDataProperties.h"

@implementation StudentCoreData (CoreDataProperties)

+ (NSFetchRequest<StudentCoreData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"StudentCoreData"];
}

@dynamic score;
@dynamic name;
@dynamic height;

@end
