//
//  Task.h
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<NSCoding,NSSecureCoding>
@property NSString *taskName;
@property NSString *taskDescription;
@property NSString *taskPriority;
@property NSDate *taskDate;
@property NSString *taskStatus;

-(void) encodeWithCoder:(NSCoder *)coder;

@end

NS_ASSUME_NONNULL_END
