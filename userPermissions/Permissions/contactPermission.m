//
//  contactPermission.m
//  userPermissions
//
//  Created by Ariel Gelbard on 2015-04-15.
//  Copyright (c) 2015 Ariel Gelbard. All rights reserved.
//

#import "contactPermission.h"
#import "AppDelegate.h"

@interface contactPermission ()

@end

@implementation contactPermission

AppDelegate *appdelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appdelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (IBAction)askForContactPermission:(id)sender {
    [appdelegate askForContactPermission];
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
