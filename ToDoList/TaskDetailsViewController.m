//
//  TaskDetailsViewController.m
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import "TaskDetailsViewController.h"
#import "ViewController.h"
#import "DoneViewController.h"
#import "InPrograssViewController.h"
#import "Task.h"

@interface TaskDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property (weak, nonatomic) IBOutlet UILabel *taskStatus;
@property NSUserDefaults *def;
@property Task *inPrograssTask;
@property Task *doneTask;
@property NSMutableArray <Task*> *tasksArray;
@property NSMutableArray <Task*> *doneTasksArray;
@property NSMutableArray <Task*> *inPrograssTasksArray;
@end

@implementation TaskDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _taskName.text =_task.taskName;
    _taskDescription.text = _task.taskDescription;
    _taskStatus.text = _task.taskStatus;
    _taskDate.date = _task.taskDate;
    if([_task.taskPriority  isEqual: @"Low"]){
        _taskPriority.selectedSegmentIndex = 0;
    }else if([_task.taskPriority  isEqual: @"Medium"]){
        _taskPriority.selectedSegmentIndex = 1;
    }else if([_task.taskPriority  isEqual: @"High"]){
        _taskPriority.selectedSegmentIndex = 2;
    }
    _inPrograssTask =[Task new];
    _doneTask =[Task new];
    _def = [NSUserDefaults standardUserDefaults];
    NSError *error;
    
    NSData *saveData = [_def objectForKey:@"todoTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:saveData error:&error];
    
    NSData *saveInPrograssData = [_def objectForKey:@"inPrograssTasks" ];
    NSSet *inPrograssSet = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _inPrograssTasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:inPrograssSet fromData:saveInPrograssData error:&error];

    
    NSData *saveDoneData = [_def objectForKey:@"doneTasks" ];
    NSSet *doneSet = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _doneTasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:doneSet fromData:saveDoneData error:&error];
    
    if(_tasksArray == nil){
        _tasksArray = [NSMutableArray new];
    }
    if(_inPrograssTasksArray == nil){
        _inPrograssTasksArray = [NSMutableArray new];
    }
    if(_doneTasksArray == nil){
        _doneTasksArray = [NSMutableArray new];
    }
    
}
- (IBAction)editTask:(id)sender {
    if([_taskName.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Edits" message:@"Do You Want To Save Edits" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self->_tasksArray[self->_taskIndex].taskName = self->_taskName.text;
                self->_tasksArray[self->_taskIndex].taskDescription = self->_taskDescription.text;
                self->_tasksArray[self->_taskIndex].taskDate = self->_taskDate.date;
                switch (self->_taskPriority.selectedSegmentIndex) {
                    case 0:
                        self->_tasksArray[self->_taskIndex].taskPriority = @"Low";
                        break;
                    case 1:
                        self->_tasksArray[self->_taskIndex].taskPriority = @"Medium";
                        break;
                    case 2:
                        self->_tasksArray[self->_taskIndex].taskPriority = @"High";
                        break;
                }
                self->_tasksArray[self->_taskIndex].taskStatus = @"ToDo";
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArray requiringSecureCoding:YES error:&error];
                [self->_def setObject:savedData forKey:@"todoTasks"];
                ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todoTask"];
                [viewController.todoTable reloadData];
                [self.navigationController pushViewController:viewController animated:YES];
            }];
            [alert addAction:yes];
            [self presentViewController:alert animated:YES completion:^{    }];
    }
    
}

- (IBAction)addToPrograss:(id)sender {
    if([_taskName.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Edits" message:@"Do You Want To Save Edits" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self->_tasksArray removeObjectAtIndex:self->_taskIndex];
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArray requiringSecureCoding:YES error:&error];
                [self->_def setObject:savedData forKey:@"todoTasks"];

                self->_inPrograssTask.taskName = self->_taskName.text;
                self->_inPrograssTask.taskDescription = self->_taskDescription.text;
                self->_inPrograssTask.taskDate = self->_taskDate.date;
                switch (self->_taskPriority.selectedSegmentIndex) {
                    case 0:
                        self->_inPrograssTask.taskPriority = @"Low";
                        break;
                    case 1:
                        self->_inPrograssTask.taskPriority = @"Medium";
                        break;
                    case 2:
                        self->_inPrograssTask.taskPriority = @"High";
                        break;
                }
                self->_inPrograssTask.taskStatus = @"In Prograss";
        
                [self->_inPrograssTasksArray addObject: self->_inPrograssTask];
                NSData *savedInPrograssData = [NSKeyedArchiver archivedDataWithRootObject:self->_inPrograssTasksArray requiringSecureCoding:YES error:&error];
                [self->_def setObject:savedInPrograssData forKey:@"inPrograssTasks"];
        
            InPrograssViewController *inPrograssViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inPrograss"];
            [inPrograssViewController.inPrograssTable reloadData];
        
            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todoTask"];
            [viewController.todoTable reloadData];
            [self.navigationController pushViewController:viewController animated:YES];
            }];
            [alert addAction:yes];
            [self presentViewController:alert animated:YES completion:^{    }];
    }
    
}
- (IBAction)addToDone:(id)sender {
    if([_taskName.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Edits" message:@"Do You Want To Save Edits" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->_tasksArray removeObjectAtIndex:self->_taskIndex];
            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self->_tasksArray requiringSecureCoding:YES error:&error];
            [self->_def setObject:savedData forKey:@"todoTasks"];

            self->_doneTask.taskName = self->_taskName.text;
            self->_doneTask.taskDescription = self->_taskDescription.text;
            self->_doneTask.taskDate = self->_taskDate.date;
            switch (self->_taskPriority.selectedSegmentIndex) {
                case 0:
                    self->_doneTask.taskPriority = @"Low";
                    break;
                case 1:
                    self->_doneTask.taskPriority = @"Medium";
                    break;
                case 2:
                    self->_doneTask.taskPriority = @"High";
                    break;
            }
            self->_doneTask.taskStatus = @"Done";
        
            [self->_doneTasksArray addObject:self->_doneTask];
            NSData *savedDoneData = [NSKeyedArchiver archivedDataWithRootObject:self->_doneTasksArray requiringSecureCoding:YES error:&error];
            [self->_def setObject:savedDoneData forKey:@"doneTasks"];
        
        
            DoneViewController *doneViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"done"];
            [doneViewController.doneTable reloadData];
        
            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todoTask"];
            [viewController.todoTable reloadData];
            [self.navigationController pushViewController:viewController animated:YES];
            }];
            [alert addAction:yes];
            [self presentViewController:alert animated:YES completion:^{    }];
        }
}


@end
