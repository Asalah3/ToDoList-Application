//
//  ViewController.h
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *todoTable;


@end

