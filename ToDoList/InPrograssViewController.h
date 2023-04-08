//
//  InPrograssViewController.h
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InPrograssViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *inPrograssTable;

@end

NS_ASSUME_NONNULL_END
