//
//  DoneViewController.h
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *doneTable;

@end

NS_ASSUME_NONNULL_END
