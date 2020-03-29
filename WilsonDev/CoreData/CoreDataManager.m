//
//  CoreDataManager.m
//  WilsonDev
//
//  Created by Wilson on 2020/3/28.
//  Copyright © 2020 Wilson. All rights reserved.
//

#import "CoreDataManager.h"
#import "StudentCoreData+CoreDataProperties.h"
#import <CoreData/CoreData.h>

API_AVAILABLE(ios(10.0))
@interface CoreDataManager()

@property(nonatomic, strong) NSPersistentContainer *persistentContainer;
@property(nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic, strong, readonly) NSString *bundleName;
@property(nonatomic, strong, readonly) NSString *entityName;

@end

@implementation CoreDataManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static CoreDataManager *messageInstance = nil;
    dispatch_once(&onceToken, ^{
        messageInstance = [[CoreDataManager alloc] init];
    });
    return messageInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.bundleName = @"WilsonDev";
        self.entityName = @"StudentCoreData";
    }
    return self;
}

- (BOOL)save:(Student *)student {
    NSError *error;
    StudentCoreData *insertStudent = [NSEntityDescription insertNewObjectForEntityForName:_entityName inManagedObjectContext:self.context];
    insertStudent.score = student.score;
    insertStudent.name = student.name;
    insertStudent.height = student.height;
    
    if ([self.context hasChanges] && ![self.context save:&error]) {
        [NSException exceptionWithName:@"core data 存储失败" reason:error.description userInfo:nil];
        return NO;
    } else {
        NSLog(@"插入数据成功！");
        return YES;
    }
}

- (BOOL)clear {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:_entityName];
    NSError *error = nil;
    NSArray *fetchStudents = [self.context executeFetchRequest:request error:&error];
    for (StudentCoreData *deleteStudent in fetchStudents) {
        [self.context deleteObject:deleteStudent];
    }
    
    if ([self.context hasChanges]) {
        [self.context save:&error];
    }
    
    if (error) {
        [NSException exceptionWithName:@"core data 删除失败" reason:error.description userInfo:nil];
        return NO;
    } else {
        NSLog(@"删除成功");
        return YES;
    }
}

- (BOOL)remove:(int)score {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:_entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"score <= %d", 60];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *fetchStudents = [self.context executeFetchRequest:request error:&error];
    for (StudentCoreData *deleteStudent in fetchStudents) {
        [self.context deleteObject:deleteStudent];
    }
    
    if ([self.context hasChanges]) {
        [self.context save:&error];
    }
    
    if (error) {
        [NSException exceptionWithName:@"core data 删除失败" reason:error.description userInfo:nil];
        return NO;
    } else {
        NSLog(@"删除成功");
        return YES;
    }
}

- (BOOL)alterContent:(int)score {
    return YES;
}

- (NSArray *)fetchData:(int)score {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error = nil;
    
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"score >= %d", score];
    request.predicate = predict;
    NSArray *fetchStudents = [self.context executeFetchRequest:request error:&error];
    NSMutableArray *students = [[NSMutableArray alloc] init];
    
    if (error) {
        [NSException exceptionWithName:@"core data 查找失败" reason:error.description userInfo:nil];
        return [NSArray new];
    } else {
        for (StudentCoreData *fetchStudent in fetchStudents) {
            Student *std = [[Student alloc] init];
            std.height = fetchStudent.height;
            std.score = fetchStudent.score;
            std.name = fetchStudent.name;
            [students addObject:std];
        }
    }
    return students;
}

- (NSArray *)fetchData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    NSError *error = nil;
    NSArray *fetchStudents = [self.context executeFetchRequest:request error:&error];
    NSMutableArray *students = [[NSMutableArray alloc] init];
    
    if (error) {
        [NSException exceptionWithName:@"core data 查找失败" reason:error.description userInfo:nil];
        return [NSArray new];
    } else {
        for (StudentCoreData *fetchStudent in fetchStudents) {
            Student *std = [[Student alloc] init];
            std.height = fetchStudent.height;
            std.score = fetchStudent.score;
            std.name = fetchStudent.name;
            [students addObject:std];
        }
    }
    return students;
}

#pragma mark - coreData接口

- (void)setBundleName:(NSString *)bundleName {
    _bundleName = bundleName;
}

- (void)setEntityName:(NSString *)entityName {
    _entityName = entityName;
}

/** NSManagedObjectContext */
- (NSManagedObjectContext *)context {
    if (_context == nil) {
        NSManagedObjectModel *model = [self objectModel];
        
        if (@available (iOS 10.0, *)) {
            return self.persistentContainer.viewContext;
        } else {
            _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
            
            // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
            NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite",self.bundleName];
            
            [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
            
            _context.persistentStoreCoordinator = coordinator;
        }
    }
    return _context;
}

- (NSManagedObjectModel *)objectModel {
    // .xcdatamodeld文件 编译之后变成.momd文件  （.mom文件）
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:self.bundleName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    return model;
}

- (NSPersistentContainer *)persistentContainer  API_AVAILABLE(ios(10.0)){
    @synchronized (self) {
        if (_persistentContainer == nil) {
            //iOS 10之后，系统会在'**/Library/Application Support' 下创建.split .sqlite-shm .sqlite-wal三个文件
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:_bundleName];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

@end
