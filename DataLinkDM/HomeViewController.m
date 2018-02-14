//
//  HomeViewController.m
//  DataLinkDM
//
//  Created by Twinklestar on 12/16/16.
//  Copyright © 2016 Yujin. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingViewController.h"
#import "ActionListViewController.h"
#import "AlertViewController.h"
#import "HelpViewController.h"

#import "Globals.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize vwHomeHelp;
@synthesize vwHomeAlert;
@synthesize vwHomeMessage;
@synthesize vwHomeSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblHomeAlertCount.hidden = YES;
    self.lblHomeAlertCount.layer.cornerRadius = 13;
    self.lblHomeAlertCount.clipsToBounds = YES;
    
    [Globals loadUserInfo];
    
    UITapGestureRecognizer *helpClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpClick:)];
    [vwHomeHelp addGestureRecognizer:helpClick];
    
    UITapGestureRecognizer *settingClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingClick:)];
    [vwHomeSetting addGestureRecognizer:settingClick];
    
    UITapGestureRecognizer *messageClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageClick:)];
    [vwHomeMessage addGestureRecognizer:messageClick];
    
    UITapGestureRecognizer *alertClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertClick:)];
    [vwHomeAlert addGestureRecognizer:alertClick];
    
    [self init];

}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateAlertNotify:)
                                                 name:@"updateAlert"
                                               object:nil];

    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateAlert];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(isFirstAppRun) {
        SettingViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
        isFirstAppRun = NO;
    }
}

- (void) updateAlertNotify :(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateAlert];

    });
    
}


-(void) helpClick:(UITapGestureRecognizer *) recognizer
{
    HelpViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void) settingClick:(UITapGestureRecognizer *) recognizer
{
    SettingViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void) messageClick:(UITapGestureRecognizer *) recognizer
{
    ActionListViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ActionListViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void) alertClick:(UITapGestureRecognizer *) recognizer
{
    AlertViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AlertViewController"];
    [self presentViewController:viewController animated:YES completion:nil];}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateAlert {
    if(lstAlerts != nil){
        
        int newAlertCount = 0;
        for (int i = 0;i < lstAlerts.count;i++)
        {
            BaseModel * bModel = [lstAlerts objectAtIndex:i];
            if(bModel.mRead != nil && [bModel.mRead isEqualToString:@"1"]){
            }else{
                newAlertCount++;
            }
            //[self serviceUpdateAction:bModel :2];
        }
        
        self.lblHomeAlertCount.hidden = newAlertCount == 0;
        NSString* countStr = [NSString stringWithFormat:@"%lu",(unsigned long)newAlertCount];
        
        self.lblHomeAlertCount.text = countStr;
    }
    
    if(lstActions != nil) {
        int newActionsCount = 0;
        for (int i = 0;i < lstActions.count;i++)
        {
            BaseModel * bModel = [lstActions objectAtIndex:i];
            if(bModel.mRead != nil && [bModel.mRead isEqualToString:@"1"]){
            }else{
                newActionsCount++;
            }
            //[self serviceUpdateAction:bModel :2];
        }
        
        self.lblHomeActionCount.hidden = newActionsCount == 0;
        NSString* countStr = [NSString stringWithFormat:@"%lu",(unsigned long)newActionsCount];
        
        self.lblHomeActionCount.text = countStr;
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)ContactSync:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate contactSync];
}
- (IBAction)CalendarSync:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate calendarSync];
}

@end
