//
//  locationPermission.m
//  userPermissions
//
//  Created by Ariel Gelbard on 2015-04-15.
//  Copyright (c) 2015 Ariel Gelbard. All rights reserved.
//

#import "locationPermission.h"
#import "AppDelegate.h"

@interface locationPermission ()

@end

@implementation locationPermission

AppDelegate *appdelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appdelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view.
}



- (IBAction)AskLocationPermission:(id)sender {
//    [appdelegate.locationManager startUpdatingLocation];
    [appdelegate askForLocationPermission];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
