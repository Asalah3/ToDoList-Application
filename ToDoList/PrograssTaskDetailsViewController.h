//
//  PrograssTaskDetailsViewController.h
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrograssTaskDetailsViewController : UIViewController
@property Task *task;
@property NSInteger taskIndex;
@end

NS_ASSUME_NONNULL_END
