//
//  AppDelegate.m
//  userPermissions
//
//  Created by Ariel Gelbard on 2015-04-15.
//  Copyright (c) 2015 Ariel Gelbard. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () 
@end

@implementation AppDelegate

//============================================================
// Welcome!
//============================================================

NSString* setupFileLocation; //Location of setup step data file
NSString *currentSetupStep; //contains which step the user us in the setup process

//Open App From Background or for the First Time
bool firstTimeLoad=false;
- (void)applicationDidBecomeActive:(UIApplication *)application {     // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if(firstTimeLoad==true){
        [self redirectToViewController];
    }
    
    firstTimeLoad=true;
}

//Loaded App First Time
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //create path to setup data file
    NSString* getDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    setupFileLocation = [getDirectoryPath stringByAppendingPathComponent:@"setup.dat"];
   
    //initialize location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    //if setup file does not exist yet
    if ([NSKeyedUnarchiver unarchiveObjectWithFile:setupFileLocation] == nil){
        [NSKeyedArchiver archiveRootObject:[NSString stringWithFormat:@"0"] toFile:setupFileLocation];
        currentSetupStep=@"0";
    }
    else{
    //if setup file exists
        currentSetupStep=[NSKeyedUnarchiver unarchiveObjectWithFile:setupFileLocation];
    }
    
    //check which UIViewController Screen to Load
    [self redirectToViewController];
    
    return YES;
}

//============================================================
// Checking for Permissions / Current Setup Step
//============================================================
//Check which step the user is located in the setup process
-(void)redirectToViewController{
    
    if([currentSetupStep intValue] == 0){
        [self segueToController:@"grantLocation"];
    }
    
    else if([currentSetupStep intValue] == 1){
        if([self checkLocationManagerIsEnabled]==false ){ //check if user changed location permission
            [self segueToController:@"lockOut"];
        }
        else{
            [self segueToController:@"grantNotification"];
        }
    }
    
    else if([currentSetupStep intValue] == 2){
        
        if([self checkLocationManagerIsEnabled]==false || [self checkNotificationsIsEnabled]==false){ //check if user changed location/notification permissions
            [self segueToController:@"lockOut"];
        }
        else{
            [self segueToController:@"grantContact"];
        }
    }
    
    else if([currentSetupStep intValue] == 3){
        if([self checkLocationManagerIsEnabled]==false || [self checkNotificationsIsEnabled]==false || [self checkContactsIsEnabled] == false){ //check if user changed location/notification/contact permissions
            [self segueToController:@"lockOut"];
        }
        else{
            [self segueToController:@"mainWin"];
        }
    }
}


//============================================================
// Asking for Permission
//============================================================

//Step 1: Ask for Location Permission
bool justClickedLocationButton=false;
-(void)askForLocationPermission{
    [self writeToSetupFile:@"1"];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    justClickedLocationButton=true;
}

//Recieve Location Permission Response From User
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    //Why is there no segueToController Methods called? because everytime a permission box pops up, it calls the applicationDidBecomeActive method for some reason...
    
    if(justClickedLocationButton == true){
        [self.locationManager stopUpdatingLocation];
    }
    
    
//    if (status == kCLAuthorizationStatusNotDetermined){ }
//    else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
//
////            [self writeToSetupFile:@"1"];
////            [self segueToController:@"lockOut"];
//        }
//    }
//    else{
//        if(justClickedLocationButton == true){
//            [self.locationManager stopUpdatingLocation];
////            [self writeToSetupFile:@"1"];
////            [self segueToController:@"grantNotification"];
//        }
//    }
}


//Step 2: Ask for Local Notification Permission
BOOL justClickedNotificationButton=false;
-(void)askForNotificationPermission{
    [self writeToSetupFile:@"2"];
    justClickedNotificationButton = true;
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
}

//Recieve Local Notification Permission Response From User
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    if(justClickedNotificationButton == true){
//        if([self checkNotificationsIsEnabled]){
//            [self segueToController:@"grantContact"];
//        }
//        else{
//            [self segueToController:@"lockOut"];
//        }
//    }
}

//Step 3: Ask for Contacts Permission
-(void)askForContactPermission{
    [self writeToSetupFile:@"3"];
    __block BOOL accessGranted = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    
    //Recieve Contacts Permission Response From User
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        accessGranted = granted;
        dispatch_semaphore_signal(sema);
    
    });

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    [self redirectToViewController];

}




//============================================================
// Checking for Permission
//============================================================

//Check Location Permissions
-(BOOL)checkLocationManagerIsEnabled{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return false;
    }
    else{
        return true;
    }
}

//Check Notification Permissions
-(BOOL)checkNotificationsIsEnabled{
    UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if (grantedSettings.types == UIUserNotificationTypeNone) {
        //NSLog(@"No permission granted");
        return false;
    }
    else if (grantedSettings.types & UIUserNotificationTypeSound & UIUserNotificationTypeAlert ){ //Fix This Part
        //NSLog(@"Sound and alert permissions");
        return false;
    }
    else { //if (grantedSettings.types  & UIUserNotificationTypeAlert){
        //NSLog(@"Permission Granted");
        return true;
    }
}

//Check Contacts Permissions
-(BOOL)checkContactsIsEnabled{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        return true;
    }
    else{
        return false;
    }
}



//============================================================
// Other Methods
//============================================================

//Write Setup Step Information to File
-(void)writeToSetupFile:(NSString *)theNumber{
    currentSetupStep=theNumber;
    [NSKeyedArchiver archiveRootObject:theNumber toFile:setupFileLocation];
}

//Segue from Controller to Controller
-(void)segueToController:(NSString *)redirectToView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:redirectToView];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = initViewController;
    [self.window makeKeyAndVisible];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
