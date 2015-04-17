//
//  notificationPermission.m
//  userPermissions
//
//  Created by Ariel Gelbard on 2015-04-15.
//  Copyright (c) 2015 Ariel Gelbard. All rights reserved.
//

#import "notificationPermission.h"
#import "AppDelegate.h"

@interface notificationPermission ()

@end

@implementation notificationPermission

AppDelegate *appdelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appdelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}



- (IBAction)askNotificationClicked {
    [appdelegate askForNotificationPermission];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
