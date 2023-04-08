//
//  InPrograssViewController.m
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import "InPrograssViewController.h"
#import "PrograssTaskDetailsViewController.h"
#import "Task.h"

@interface InPrograssViewController ()
@property NSUserDefaults *def;
@property NSMutableArray <Task*> *tasksArray;
@property NSMutableArray <Task*> *lowTasks;
@property NSMutableArray <Task*> *highTasks;
@property NSMutableArray <Task*> *medTasks;
@property BOOL isSorted;
@property Task *task;
@end

@implementation InPrograssViewController
-(void)viewWillAppear:(BOOL)animated{
    [_inPrograssTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _def = [NSUserDefaults standardUserDefaults];
    _task = [Task new];
    _lowTasks = [NSMutableArray new];
    _medTasks = [NSMutableArray new];
    _highTasks = [NSMutableArray new];
    NSError *error;
    
    NSData *savedData = [_def objectForKey:@"inPrograssTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    for (int i =0; i<_tasksArray.count; i++) {
        if([_tasksArray[i].taskPriority  isEqual: @"Low"]){
            [_lowTasks addObject:_tasksArray[i]];
        }else if([_tasksArray[i].taskPriority  isEqual: @"Medium"]){
            [_medTasks addObject:_tasksArray[i]];
        }else if([_tasksArray[i].taskPriority  isEqual: @"High"]){
            [_highTasks addObject:_tasksArray[i]];
        }
    }
    [_inPrograssTable reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    _task =[_tasksArray objectAtIndex:indexPath.row];
    
    if(_isSorted){
        switch (indexPath.section) {
            case 0:
                _task =[_lowTasks objectAtIndex:indexPath.row];
                cell.textLabel.text = _task.taskName;
                cell.imageView.image=[UIImage imageNamed:@"0"];
                return cell;
                break;
            case 1:
                _task =[_medTasks objectAtIndex:indexPath.row];
                cell.textLabel.text = _task.taskName;
                cell.imageView.image=[UIImage imageNamed:@"1"];
                return cell;
                break;
            case 2:
                _task =[_highTasks objectAtIndex:indexPath.row];
                cell.textLabel.text = _task.taskName;
                cell.imageView.image=[UIImage imageNamed:@"2"];
                return cell;
                break;
        }
    }
    else{
        cell.textLabel.text = _task.taskName;
        if ([_task.taskPriority  isEqual: @"Low"]) {
            cell.imageView.image=[UIImage imageNamed:@"0"];
        }else if ([_task.taskPriority  isEqual: @"Medium"]) {
            cell.imageView.image=[UIImage imageNamed:@"1"];
        }else if ([_task.taskPriority  isEqual: @"High"]) {
            cell.imageView.image=[UIImage imageNamed:@"2"];
        }
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isSorted){
        switch (section) {
            case 0:
                return _lowTasks.count;
                break;
            case 1:
                return _medTasks.count;
                break;
            case 2:
                return _highTasks.count;
                break;
        }
    }
    return _tasksArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_isSorted){
        return 3;
    }
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_isSorted){
        switch (section) {
            case 0:
                return @"Low Priority";
                break;
            case 1:
                return @"Medium Priority";
                break;
            case 2:
                return @"High Priority";
                break;
        }
    }

    return @"In Prograss Tasks";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Do You Want To Delete This Task?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self->_tasksArray removeObjectAtIndex:indexPath.row];
            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArray requiringSecureCoding:YES error:&error];
            [self->_def setObject:savedData forKey:@"inPrograssTasks"];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.inPrograssTable reloadData];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        }
        [self.inPrograssTable reloadData];
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:^{    }];
    [self.inPrograssTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _task =[_tasksArray objectAtIndex:indexPath.row];
    PrograssTaskDetailsViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"prograssTaskDetails"];
    viewController.task = _task;
    viewController.taskIndex = indexPath.row;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)sortButton:(id)sender {
    _isSorted = !_isSorted;
    [_inPrograssTable reloadData];
}
@end
