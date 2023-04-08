//
//  ViewController.m
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import "ViewController.h"
#import "AddTaskViewController.h"
#import "TaskDetailsViewController.h"
#import "Task.h"

@interface ViewController ()
@property NSUserDefaults *def;
@property NSMutableArray <Task*> *tasksArray;
@property NSMutableArray <Task*> *filterTasks;
@property BOOL isFiltered;
@property Task *task;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [_todoTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _def = [NSUserDefaults standardUserDefaults];
    _task = [Task new];
    NSError *error;
    
    NSData *savedData = [_def objectForKey:@"todoTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    _isFiltered = NO;
    self.searchBar.delegate = self;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        _isFiltered = NO;
    }else{
        _isFiltered = YES;
        _filterTasks= [[NSMutableArray alloc] init];
        for (Task *task in _tasksArray) {
            NSRange tasksRange = [task.taskName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(tasksRange.location !=NSNotFound){
                [_filterTasks addObject:task];
            }
        }
    }
    [_todoTable reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(_isFiltered){
        _task =[_filterTasks objectAtIndex:indexPath.row];
    }else{
        _task =[_tasksArray objectAtIndex:indexPath.row];

    }
    cell.textLabel.text = _task.taskName;
    if ([_task.taskPriority  isEqual: @"Low"]) {
        cell.imageView.image=[UIImage imageNamed:@"0"];
    }else if ([_task.taskPriority  isEqual: @"Medium"]) {
        cell.imageView.image=[UIImage imageNamed:@"1"];
    }else if ([_task.taskPriority  isEqual: @"High"]) {
        cell.imageView.image=[UIImage imageNamed:@"2"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isFiltered){
        return _filterTasks.count;
    }
    return _tasksArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"TODO Tasks";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isFiltered){
        _task =[_filterTasks objectAtIndex:indexPath.row];    }
    else{
        _task =[_tasksArray objectAtIndex:indexPath.row];
    }
    TaskDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetails"];
    viewController.task = _task;
    viewController.taskIndex = indexPath.row;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_isFiltered){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Can't Delete When Using Searching " preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:no];
        
        [self presentViewController:alert animated:YES completion:^{
            printf("alert done \n");
        }];
        [_todoTable reloadData];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Do You Want To Delete This Task?" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                
                    [self->_tasksArray removeObjectAtIndex:indexPath.row];
                    NSError *error;
                    NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArray requiringSecureCoding:YES error:&error];
                    [self->_def setObject:savedData forKey:@"todoTasks"];

                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            }
            [self.todoTable reloadData];
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:yes];
        [alert addAction:no];
        
        [self presentViewController:alert animated:YES completion:^{
            printf("alert done \n");
        }];
        [_todoTable reloadData];
    }
    
}

- (IBAction)addTask:(id)sender {
    AddTaskViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addTask"];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
