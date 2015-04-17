//
//  AppDelegate.h
//  userPermissions
//
//  Created by Ariel Gelbard on 2015-04-15.
//  Copyright (c) 2015 Ariel Gelbard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic)CLLocationManager *locationManager;
-(void)askForLocationPermission;
-(void)askForNotificationPermission;
-(void)askForContactPermission;
@end

