//
//  StudentCoreData+CoreDataProperties.h
//  
//
//  Created by Wilson on 2020/3/29.
//
//

#import "StudentCoreData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface StudentCoreData (CoreDataProperties)

+ (NSFetchRequest<StudentCoreData *> *)fetchRequest;

@property (nonatomic) int16_t score;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float height;

@end

NS_ASSUME_NONNULL_END
