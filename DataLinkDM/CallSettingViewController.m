//
//  CallSettingViewController.m
//  DataLinkDM
//
//  Created by BoHuang on 6/27/17.
//  Copyright © 2017 Yujin. All rights reserved.
//

#import "CallSettingViewController.h"
#import "Globals.h"

@interface CallSettingViewController ()
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@end

@implementation CallSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.minuteInterval = 30;
    
    [datePicker addTarget:self action:@selector(updateStartDate:) forControlEvents:UIControlEventValueChanged];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:9];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *defaultDate = [calendar dateFromComponents:components];
    datePicker.date = defaultDate;
    [self.timeFrom setInputView:datePicker];

    self.timeFrom.text = [dateFormat stringFromDate:defaultDate];
    self.startTime = defaultDate;
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc] init];
    endDatePicker.minuteInterval = 30;
    endDatePicker.datePickerMode = UIDatePickerModeTime;
    
    NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    [components2 setHour:21];
    [components2 setMinute:0];
    [components2 setSecond:0];
    NSDate *defaultDate2 = [calendar dateFromComponents:components2];
    
    [endDatePicker setDate:defaultDate2];
    [endDatePicker addTarget:self action:@selector(updateEndDate:) forControlEvents:UIControlEventValueChanged];
    [self.timeTo setInputView:endDatePicker];
    self.timeTo.text = [dateFormat stringFromDate:defaultDate2];
    self.endTime = defaultDate2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) updateStartDate:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.timeFrom.inputView;
    picker.minuteInterval = 30;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    
    
    self.startTime = picker.date;
    self.timeFrom.text = [dateFormat stringFromDate:picker.date];
}

- (void) updateEndDate:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.timeTo.inputView;
    picker.minuteInterval = 30;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    
    
    
    self.timeTo.text = [dateFormat stringFromDate:picker.date];
    self.endTime = picker.date;
}
// MARK: - IBActions

- (IBAction)applyAction:(id)sender {
    if(self.startTime == nil || self.endTime == nil){
        [Globals AlertMessage:self Message:@"Please input Range of hours." Title:@"Alert"];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.startTime];
    
    
    
    NSDateComponents *componentsTo = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.endTime];
    
    if([components hour] > [componentsTo hour]) {
        [Globals AlertMessage:self Message:@"You cannot have a negative range of hours." Title:@"Alert"];
    }else {
        mAccount.questionStartHour = [components hour];
        mAccount.questionStartMin = [components minute];
        mAccount.questionEndHour = [componentsTo hour];
        mAccount.questionEndMin = [componentsTo minute];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (IBAction)backAction:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
