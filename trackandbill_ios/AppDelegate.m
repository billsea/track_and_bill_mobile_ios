//
//  AppDelegate.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/14/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "AppDelegate.h"
#import "ClientsTableViewController.h"
#import "InvoicesTableViewController.h"
#import "SettingsTableViewController.h"
#import "Project.h"
#import "Session.h"
#import "Invoice.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //check ios version
    NSString * version = [[UIDevice currentDevice] systemVersion];
    NSLog(@"ios version: %@", version);
    
    
    //navigation bar style
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Next" size:18.0]
       }
     forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Avenir Next" size:21.0], NSFontAttributeName, nil]];

    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //set navigation bar background color
    UIColor * navBarBgColor =[UIColor colorWithRed:0.22 green:0.41 blue:0.60 alpha:1.0];
    [[UINavigationBar appearance] setBarTintColor:navBarBgColor];
    
// [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back-25.png"]];
// [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back-25.png"]];

    
    //tab bar style
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    [self RegisterForNotifications];
    
    _currentSessions = [[NSMutableArray alloc] init];
    _clientProjects = [[NSMutableArray alloc] init];
    _allProjects = [[NSMutableArray alloc] init];
    _storedSessions = [[NSMutableArray alloc] init];
    _removedSession = [[Session alloc] init]; //session removed in session details
    _arrInvoices = [[NSMutableArray alloc] init];
    
    [self loadClients];
    [self loadAllProjects];
    [self loadAllSessions];
    [self loadInvoices];
    
    //add tabbed main view
    [self createNavigationRootView];
    
    
   // [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
   // [UINavigationBar appearance].shadowImage = [UIImage new];
   // [UINavigationBar appearance].translucent = YES;
    
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //save current date/time, as timer will stop
    [self stopTimersAndStamp];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 
    [self saveProjectsToDisk];
    [self saveClientsToDisk];
    [self saveSessionsToDisk];
    [self saveInvoicesToDisk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //timer stops when entering background on the iOS device only. simulator still runs.
    //we'll track the amount of seconds the app is in the background.
    //using _timeSave date, calculate the amount of time the app was inactive, and add to current sessions
    NSDate * restoreDate = [NSDate date];
    NSTimeInterval secondsInBackground = [restoreDate timeIntervalSinceDate:_timeSave];
    
    for(Session * curSession in [self currentSessions])
    {
        //only start active session
        if(curSession.sessionID == _activeSession.sessionID)
        {
            [curSession setTicks:curSession.ticks + secondsInBackground];
            [curSession startTimer];
        }
        
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
 
}

#pragma mark - Notifications
- (void)RegisterForNotifications
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(authenticationSuccessHandler:)
    //                                                 name:kAuthenticationSuccessNotification
    //                                               object:nil];
}

#pragma mark timers
-(void)stopTimersAndStamp
{
    //save current date/time, as timer will stop when app(device) enters background
    _timeSave = [NSDate date];
    
    //stop all timers
    for(Session * curSession in [self currentSessions])
    {
        if(curSession.sessionID == _activeSession.sessionID)
        {
            [curSession stopTimer];
        }
        
    }
}

#pragma mark Build Navigation
-(BOOL)createNavigationRootView
{
    
    //create viewControllers
    ClientsTableViewController * clientsTableView;
    
    @try {
        clientsTableView = [[ClientsTableViewController alloc] init];
        // [[CustomerSharedModel sharedModel] setMainViewController:mainViewController];
    }
    @catch (NSException *exception) {
        clientsTableView = nil;
        NSString *alertString = [NSString stringWithFormat:@"There was an error while initializing the clients view"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error initializing clients view" message:alertString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    
    //clients tab
    UINavigationController *mainNavController = [[UINavigationController alloc]
                                                 initWithRootViewController:clientsTableView];
    mainNavController.tabBarItem.title = @"Main";
    mainNavController.tabBarItem.image = [UIImage imageNamed:@"group-32.png"];//set tab image
    
    //Settings tab
    SettingsTableViewController * settingsView = [[SettingsTableViewController alloc] init];
    UINavigationController * settingsNavController=[[UINavigationController alloc] initWithRootViewController:settingsView];
    settingsNavController.tabBarItem.title = @"Settings";
    settingsNavController.tabBarItem.image = [UIImage imageNamed:@"settings3-32.png"];
    
    
    //add all nav controllers to stack
    NSArray *viewControllers;
    if(clientsTableView != nil)
        viewControllers = [NSArray arrayWithObjects:mainNavController, settingsNavController,nil];
    else
        viewControllers = [NSArray arrayWithObjects:mainNavController, settingsNavController, nil];
    
    //load tab bar with view controllers
    // if valid request, add views to tab bar
    self.tabBarController=[[UITabBarController alloc]init];
    
    //set tab bar color
    self.tabBarController.tabBar.barTintColor= [UIColor colorWithRed:0.85 green:0.85 blue:0.86 alpha:1.0];
    
    [self.tabBarController setViewControllers:viewControllers];
    self.tabBarController.delegate=self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[self window] setRootViewController: self.tabBarController];
    [[self window] makeKeyAndVisible];
    
    
    return YES;
}

- (void)loadClients
{
 
    NSString  *path= [self pathToDataFile:@"clients.tbd"];
    NSDictionary *rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    //add clients to array
    self.arrClients= [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"client"]];
    
}

- (void)loadAllProjects
{
    NSString  *path= [self pathToDataFile:@"projects.tbd"];
    NSDictionary *rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    //add clients to array
    self.allProjects = [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"project"]];
}

- (void)loadAllSessions
{
    NSString  *path= [self pathToDataFile:@"sessions.tbd"];
    NSDictionary *rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    //add sessions to array
    self.storedSessions = [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"session"]];

    NSLog(@"stored sessions:%@",[self storedSessions]);
}

-(void)loadInvoices
{
    NSString  *path= [self pathToDataFile:@"invoices.tbd"];
    NSDictionary *rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    //add invoices to array
    self.arrInvoices = [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"invoice"]];
    
     NSLog(@"stored invoices:%@",[self arrInvoices]);
}

#pragma mark save data

- (NSString *)pathToDataFile:(NSString *)fileName
{
    //Accessible files are stored in the devices "Documents" directory
    NSArray*	documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*	path = nil;
    
    if (documentDir) {
        path = [documentDir objectAtIndex:0];
    }
    
    
    NSLog(@"path....%@",[NSString stringWithFormat:@"%@/%@", path, fileName]);
    
    return [NSString stringWithFormat:@"%@/%@", path, fileName];
}

- (void) saveClientsToDisk
{
 
    NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue:[self arrClients] forKey:@"client"];
    
    BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject toFile:[self pathToDataFile:@"clients.tbd"]];
}

- (void) saveInvoicesToDisk
{
    
    NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue:[self arrInvoices] forKey:@"invoice"];
    
    BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject toFile:[self pathToDataFile:@"invoices.tbd"]];
}

- (void) saveProjectsToDisk
{
  
    NSMutableArray * storeProjects = [[NSMutableArray alloc] init];
    
    //save only projects not the "add project" row
    for(Project * proj in [self allProjects])
    {
        if(proj.clientID)
        {
            [storeProjects addObject:proj];
        }
    }
    
    NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue:storeProjects forKey:@"project"];
    
    BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject toFile:[self pathToDataFile:@"projects.tbd"]];
}

-(void)saveSessionsToDisk
{
    NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];
    
    [rootObject setValue:[self storedSessions] forKey:@"session"];
    
    BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject toFile:[self pathToDataFile:@"sessions.tbd"]];
}


#pragma  mark update lists
-(void)removeSessionsForProjectId:(NSNumber *)ProjectId
{
    NSMutableArray * sessionsToRemove = [[NSMutableArray alloc] init];
    
    for(Session * s in [self storedSessions])
    {
        if(s.projectIDref == ProjectId)
        {
            [sessionsToRemove addObject:s];
        }
    }
    
    for(Session *sr in sessionsToRemove)
    {
        [[self storedSessions] removeObjectIdenticalTo:sr];
    }
}

-(void)removeInvoicesForProjectId:(NSNumber *)ProjectId
{
    NSMutableArray * invoicesToRemove = [[NSMutableArray alloc] init];
    
    for(Invoice * inv in [self arrInvoices])
    {
        if(inv.projectID == ProjectId)
        {
            [invoicesToRemove addObject:inv];
        }
    }
    
    for(Invoice *invRem in invoicesToRemove)
    {
        [[self arrInvoices] removeObjectIdenticalTo:invRem];
    }
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end

