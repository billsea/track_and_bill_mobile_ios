//
//  AppDelegate.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Session.h"
#import "DashboardCollectionViewController.h"

@interface AppDelegate
    : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(readonly, strong, nonatomic)
    NSManagedObjectContext *managedObjectContext;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic)
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic)DashboardCollectionViewController* dashboardViewController;
@property(weak) NSTimer *sessionTimer;

@property(nonatomic, retain) NSMutableArray *arrClients;
@property(nonatomic, retain) NSMutableArray *currentSessions;
@property(nonatomic, retain) NSMutableArray *storedSessions;
@property(nonatomic, retain) NSMutableArray *selSessions;
@property(nonatomic, retain) NSMutableArray *arrInvoices;
@property(nonatomic, retain) NSMutableArray *clientProjects;
@property(nonatomic, retain) NSMutableArray *allProjects;
@property Session *removedSession;
@property Session *activeSession;
@property NSDate *timeSave;

- (void)saveProjectsToDisk;
- (void)saveInvoicesToDisk;
- (void)saveClientsToDisk;
- (void)saveSessionsToDisk;

- (void)RegisterForNotifications;
- (NSString *)pathToDataFile:(NSString *)fileName;
- (void)removeSessionsForProjectId:(NSNumber *)ProjectId;
- (void)removeInvoicesForProjectId:(NSNumber *)ProjectId;
- (void)showMessage:(NSString *)text withTitle:(NSString *)title;
@end


