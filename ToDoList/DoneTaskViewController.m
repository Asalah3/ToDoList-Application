//
//  DoneTaskViewController.m
//  ToDoList
//
//  Created by Asalah Sayed on 08/04/2023.
//

#import "DoneTaskViewController.h"

@interface DoneTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskPriority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *taskStatusControl;

@end

@implementation DoneTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _taskName.text =_task.taskName;
    _taskDescription.text = _task.taskDescription;
    _taskDate.date = _task.taskDate;
    if([_task.taskStatus  isEqual: @"ToDo"]){
        _taskStatusControl.selectedSegmentIndex = 0;
    }else if([_task.taskStatus  isEqual: @"In Prograss"]){
        _taskStatusControl.selectedSegmentIndex = 1;
    }else if([_task.taskStatus  isEqual: @"Done"]){
        _taskStatusControl.selectedSegmentIndex = 2;
    }
    if([_task.taskPriority  isEqual: @"Low"]){
        _taskPriority.selectedSegmentIndex = 0;
    }else if([_task.taskPriority  isEqual: @"Medium"]){
        _taskPriority.selectedSegmentIndex = 1;
    }else if([_task.taskPriority  isEqual: @"High"]){
        _taskPriority.selectedSegmentIndex = 2;
    }}


@end
