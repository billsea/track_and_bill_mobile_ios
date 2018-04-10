//
//  AppDelegate.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "AppDelegate.h"
#import "Project+CoreDataClass.h"
#import "Invoice+CoreDataClass.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  // check ios version
  NSString *version = [[UIDevice currentDevice] systemVersion];
  NSLog(@"ios version: %@", version);

  // navigation bar style
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
  shadow.shadowOffset = CGSizeMake(0, 1);

  [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
      setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSShadowAttributeName : shadow,
        NSFontAttributeName : [UIFont fontWithName:@"Avenir Next" size:18.0]
      }
                    forState:UIControlStateNormal];

  [[UINavigationBar appearance]
      setTitleTextAttributes:
          [NSDictionary
              dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0 / 255.0
                                                           green:245.0 / 255.0
                                                            blue:245.0 / 255.0
                                                           alpha:1.0],
                                           NSForegroundColorAttributeName,
                                           shadow, NSShadowAttributeName,
                                           [UIFont fontWithName:@"Avenir Next"
                                                           size:21.0],
                                           NSFontAttributeName, nil]];

  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

  // set navigation bar background color
  UIColor *navBarBgColor =
      [UIColor colorWithRed:0.22 green:0.41 blue:0.60 alpha:1.0];
  [[UINavigationBar appearance] setBarTintColor:navBarBgColor];

  // [[UINavigationBar appearance] setBackIndicatorImage:[UIImage
  // imageNamed:@"back-25.png"]];
  // [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage
  // imageNamed:@"back-25.png"]];

  [self RegisterForNotifications];

  _currentSessions = [[NSMutableArray alloc] init];
  _clientProjects = [[NSMutableArray alloc] init];
  _allProjects = [[NSMutableArray alloc] init];
  _storedSessions = [[NSMutableArray alloc] init];
  _removedSession = [[Session alloc] init]; // session removed in session
                                            // details
  _arrInvoices = [[NSMutableArray alloc] init];
	
	//TODO DATA
//
//  [self loadClients];
//  [self loadAllProjects];
//  [self loadAllSessions];
//  [self loadInvoices];

  // add tabbed main view
  [self createNavigationRootView];

  // [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
  // forBarMetrics:UIBarMetricsDefault];
  // [UINavigationBar appearance].shadowImage = [UIImage new];
  // [UINavigationBar appearance].translucent = YES;

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.

  // save current date/time, as timer will stop
 // [self stopTimersAndStamp];//TODO DATA
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.

  [self saveProjectsToDisk];
  [self saveClientsToDisk];
  [self saveSessionsToDisk];
  [self saveInvoicesToDisk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.

  // timer stops when entering background on the iOS device only. simulator
  // still runs.
  // we'll track the amount of seconds the app is in the background.
  // using _timeSave date, calculate the amount of time the app was inactive,
  // and add to current sessions
  NSDate *restoreDate = [NSDate date];
  NSTimeInterval secondsInBackground =
      [restoreDate timeIntervalSinceDate:_timeSave];

//TODO DATA
//  for (Session *curSession in [self currentSessions]) {
//    // only start active session
//    if (curSession.sessionID == _activeSession.sessionID) {
//      [curSession setTicks:curSession.ticks + secondsInBackground];
//      [curSession startTimer];
//    }
//  }
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the
  // application terminates.
}

#pragma mark - Notifications
- (void)RegisterForNotifications {
  //    [[NSNotificationCenter defaultCenter] addObserver:self
  //                                             selector:@selector(authenticationSuccessHandler:)
  //                                                 name:kAuthenticationSuccessNotification
  //                                               object:nil];
}

//TODO dATA
//#pragma mark timers
//- (void)stopTimersAndStamp {
//  // save current date/time, as timer will stop when app(device) enters
//  // background
//  _timeSave = [NSDate date];
//
//  // stop all timers
//  for (Session *curSession in [self currentSessions]) {
//    if (curSession.sessionID == _activeSession.sessionID) {
//      [curSession stopTimer];
//    }
//  }
//}

#pragma mark Build Navigation
- (BOOL)createNavigationRootView {
  // load dashboard
	_dashboardViewController = [[DashboardCollectionViewController alloc]
	 initWithNibName:@"DashboardCollectionViewController"
	 bundle:nil];
	
	UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:_dashboardViewController];
	
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [[self window] setRootViewController:nav];
  [[self window] makeKeyAndVisible];

  return YES;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
	// The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
	@synchronized (self) {
		if (_persistentContainer == nil) {
			_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"trackandbill_ios"];
			[_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
				if (error != nil) {
					// Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					
					/*
					 Typical reasons for an error here include:
					 * The parent directory does not exist, cannot be created, or disallows writing.
					 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
					 * The device is out of space.
					 * The store could not be migrated to the current model version.
					 Check the error message to determine what the actual problem was.
					 */
					NSLog(@"Unresolved error %@, %@", error, error.userInfo);
					abort();
				}
			}];
		}
	}
	
	return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
	NSManagedObjectContext *context = self.persistentContainer.viewContext;
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
		abort();
	}
}


//TODO DATA Loading?
//- (void)loadClients {
//
//  NSString *path = [self pathToDataFile:@"clients.tbd"];
//  NSDictionary *rootObject;
//  rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//
//  // add clients to array
//  self.arrClients =
//      [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"client"]];
//}
//
//- (void)loadAllProjects {
//  NSString *path = [self pathToDataFile:@"projects.tbd"];
//  NSDictionary *rootObject;
//  rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//
//  // add clients to array
//  self.allProjects = [[NSMutableArray alloc]
//      initWithArray:[rootObject valueForKey:@"project"]];
//}
//
//- (void)loadAllSessions {
//  NSString *path = [self pathToDataFile:@"sessions.tbd"];
//  NSDictionary *rootObject;
//  rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//
//  // add sessions to array
//  self.storedSessions = [[NSMutableArray alloc]
//      initWithArray:[rootObject valueForKey:@"session"]];
//
//  NSLog(@"stored sessions:%@", [self storedSessions]);
//}
//
//- (void)loadInvoices {
//  NSString *path = [self pathToDataFile:@"invoices.tbd"];
//  NSDictionary *rootObject;
//  rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//
//  // add invoices to array
//  self.arrInvoices = [[NSMutableArray alloc]
//      initWithArray:[rootObject valueForKey:@"invoice"]];
//
//  NSLog(@"stored invoices:%@", [self arrInvoices]);
//}
//
//#pragma mark save data
//
//- (NSString *)pathToDataFile:(NSString *)fileName {
//  // Accessible files are stored in the devices "Documents" directory
//  NSArray *documentDir = NSSearchPathForDirectoriesInDomains(
//      NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *path = nil;
//
//  if (documentDir) {
//    path = [documentDir objectAtIndex:0];
//  }
//
//  NSLog(@"path....%@", [NSString stringWithFormat:@"%@/%@", path, fileName]);
//
//  return [NSString stringWithFormat:@"%@/%@", path, fileName];
//}
//
//- (void)saveClientsToDisk {
//  NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
//  [rootObject setValue:[self arrClients] forKey:@"client"];
//	[self archiveObjectWithFileName:@"clients.tbd" andRootObject:rootObject];
//}
//
//- (void)saveInvoicesToDisk {
//
//  NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
//  [rootObject setValue:[self arrInvoices] forKey:@"invoice"];
//	[self archiveObjectWithFileName:@"invoices.tbd" andRootObject:rootObject];
//}
//
//- (void)saveProjectsToDisk {
//
//  NSMutableArray *storeProjects = [[NSMutableArray alloc] init];
//
//  // save only projects not the "add project" row
//  for (Project *proj in [self allProjects]) {
//    if (proj.clientID) {
//      [storeProjects addObject:proj];
//    }
//  }
//
//  NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
//  [rootObject setValue:storeProjects forKey:@"project"];
//	[self archiveObjectWithFileName:@"projects.tbd" andRootObject:rootObject];
//}
//
//- (void)saveSessionsToDisk {
//  NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
//  [rootObject setValue:[self storedSessions] forKey:@"session"];
//	[self archiveObjectWithFileName:@"sessions.tbd" andRootObject:rootObject];
//}
//
//- (void)archiveObjectWithFileName:(NSString*)fileName andRootObject:(NSMutableDictionary*)rootObject {
//	BOOL success =
//	[NSKeyedArchiver archiveRootObject:rootObject
//															toFile:[self pathToDataFile:fileName]];
//
//	assert(success);
//}
//
//#pragma mark update lists
//- (void)removeSessionsForProjectId:(NSNumber *)ProjectId {
//  NSMutableArray *sessionsToRemove = [[NSMutableArray alloc] init];
//
//  for (Session *s in [self storedSessions]) {
//    if (s.projectIDref == ProjectId) {
//      [sessionsToRemove addObject:s];
//    }
//  }
//
//  for (Session *sr in sessionsToRemove) {
//    [[self storedSessions] removeObjectIdenticalTo:sr];
//  }
//}
//
//- (void)removeInvoicesForProjectId:(NSNumber *)ProjectId {
//  NSMutableArray *invoicesToRemove = [[NSMutableArray alloc] init];
//
//  for (Invoice *inv in [self arrInvoices]) {
//    if (inv.projectID == ProjectId) {
//      [invoicesToRemove addObject:inv];
//    }
//  }
//
//  for (Invoice *invRem in invoicesToRemove) {
//    [[self arrInvoices] removeObjectIdenticalTo:invRem];
//  }
//}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title {
  [[[UIAlertView alloc] initWithTitle:title
                              message:text
                             delegate:self
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil] show];
}

@end

