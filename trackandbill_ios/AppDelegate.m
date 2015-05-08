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

@synthesize tabBarController = _tabBarController;
@synthesize sessionTimer = _sessionTimer;
@synthesize arrClients = _arrClients;
@synthesize arrInvoices = _arrInvoices;
@synthesize currentSessions = _currentSessions;
@synthesize storedSessions = _storedSessions;
@synthesize clientProjects = _clientProjects;//only currently displayed projects for selected client
@synthesize allProjects = _allProjects;
@synthesize removedSession = _removedSession;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //check ios version
    NSString * version = [[UIDevice currentDevice] systemVersion];
    NSLog(@"ios version: %@", version);
    
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
    
    //    //navigation bar style
    //back button
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Avenir Next Medium" size:24.0], NSFontAttributeName, nil]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
  
    
    [self saveProjectsToDisk];
    [self saveClientsToDisk];
    [self saveSessionsToDisk];
    [self saveInvoicesToDisk];
}

#pragma mark - Notifications
- (void)RegisterForNotifications
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(authenticationSuccessHandler:)
    //                                                 name:kAuthenticationSuccessNotification
    //                                               object:nil];
}

#pragma mark Build Navigation
-(BOOL)createNavigationRootView
{
    //style settings - temp
     UIColor * navBarBgColor = [UIColor colorWithRed:0.71 green:0.84 blue:0.66 alpha:1.0];//[UIColor colorWithRed:99.0f/255.0f green:143.0f/255.0f blue:214.0f/255.0f alpha:1.0];//light blue
    
    
    //navigation top bar bg image
    //UIImage * navBgImage =[UIImage imageNamed:@"brushedMetal.png"];
    //UIColor * navBarBgWithImage = [UIColor colorWithPatternImage:navBgImage];
    
    
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
    [mainNavController.navigationBar  setBarTintColor:navBarBgColor];
    
    mainNavController.tabBarItem.title = @"Clients";
    mainNavController.tabBarItem.image = [UIImage imageNamed:@"group-32.png"];//set tab image

    
//    //invoices tab
//    InvoicesTableViewController * invoicesTableView = [[InvoicesTableViewController alloc] init];
//    UINavigationController *invoicesNavController = [[UINavigationController alloc]
//                                                 initWithRootViewController:invoicesTableView];
//    [invoicesNavController.navigationBar  setBarTintColor:navBarBgColor];
//    invoicesNavController.tabBarItem.title = @"Invoices";
//    invoicesNavController.tabBarItem.image = [UIImage imageNamed:@"bill-32.png"];
//    
    
    
    //Settings tab
    SettingsTableViewController * settingsView = [[SettingsTableViewController alloc] init];
    UINavigationController * settingsNavController=[[UINavigationController alloc] initWithRootViewController:settingsView];
    [settingsNavController.navigationBar  setBarTintColor:navBarBgColor];
    settingsNavController.tabBarItem.title = @"Settings";
    settingsNavController.tabBarItem.image = [UIImage imageNamed:@"settings_wrench-32.png"];
    
    
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
    self.tabBarController.tabBar.barTintColor= navBarBgColor;
    
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
    //update stored sessions
    for(Session * cur in [self currentSessions])
    {
        for(Session * stored in [self storedSessions])
        {
            if(cur.sessionID == stored.sessionID)
            {
                //replace session
                [[self storedSessions] removeObjectIdenticalTo:stored];
                break;
            }
        }
        
        //updated
        [[self storedSessions] addObject:cur];
    }
    
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



@end

