//
//  Task.m
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import "Task.h"

@implementation Task
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_taskName forKey:@"name"];
    [coder encodeObject:_taskDescription forKey:@"description"];
    [coder encodeObject:_taskDate forKey:@"date"];
    [coder encodeObject:_taskPriority forKey:@"priority"];
    [coder encodeObject:_taskStatus forKey:@"status"];
}

- (id)initWithCoder:(nonnull NSCoder *)decoder {
    
    self.taskName = [decoder decodeObjectOfClass:[NSString class] forKey:@"name"];
    self.taskDescription = [decoder decodeObjectOfClass:[NSString class] forKey:@"description"];
    self.taskDate = [decoder decodeObjectOfClass:[NSDate class] forKey:@"date"];
    self.taskPriority = [decoder decodeObjectOfClass:[NSString class] forKey:@"priority"];
    self.taskStatus = [decoder decodeObjectOfClass:[NSString class] forKey:@"status"];
    
    return self;
}
+ (BOOL)supportsSecureCoding{
    return YES;
}
@end
