//
//  AddTaskViewController.m
//  ToDoList
//
//  Created by Asalah Sayed on 07/04/2023.
//

#import "AddTaskViewController.h"
#import "ViewController.h"
#import "Task.h"

@interface AddTaskViewController (){
    
}
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property NSUserDefaults *def;
@property NSMutableArray <Task*> *tasksArray;
@property Task *task;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _task = [Task new];
    _def = [NSUserDefaults standardUserDefaults];
    NSError *error;
    NSData *saveData = [_def objectForKey:@"todoTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[Task class]]];
    _tasksArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:saveData error:&error];
    if(_tasksArray == nil){
        _tasksArray = [NSMutableArray new];
    }

}

- (IBAction)addTask:(id)sender {
    if([_taskName.text  isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warrning" message:@"Don't Add An Empty Task Name" preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:yes];
        
        [self presentViewController:alert animated:YES completion:^{    }];
    }else{
        _task.taskName = _taskName.text;
        _task.taskDescription = _taskDescription.text;
        _task.taskDate = _taskDate.date;
        switch (_taskPriority.selectedSegmentIndex) {
            case 0:
                _task.taskPriority = @"Low";
                break;
             case 1:
                _task.taskPriority = @"Medium";
                break;
             case 2:
                _task.taskPriority = @"High";
                break;
        }
        _task.taskStatus = @"ToDo";
        [_tasksArray addObject:_task];
        
        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:_tasksArray requiringSecureCoding:YES error:&error];
        [_def setObject:savedData forKey:@"todoTasks"];
        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"todoTask"];
        [viewController.todoTable reloadData];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
