//
//  AppDelegate.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Session+CoreDataClass.h"
#import "DashboardCollectionViewController.h"

@interface AppDelegate
    : UIResponder <UIApplicationDelegate>
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property(strong, nonatomic) UIWindow *window;
@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic)DashboardCollectionViewController* dashboardViewController;
@property(nonatomic) NSDate *sessionStartTime;
@property(nonatomic)UIColor *navBarBgColor;
- (void)saveContext;
@end


