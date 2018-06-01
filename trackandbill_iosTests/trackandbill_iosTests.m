//
//  trackandbill_iosTests.m
//  trackandbill_iosTests
//
//  Created by William Seaman on 4/24/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "DashboardCollectionViewController.h"
#import "ClientsTableViewController.h"
#import "ProfileTableViewController.h"

//create class categories so we can expose private methods for testing
@interface ClientsTableViewController (Testing)
- (void)fetchData;
@end

@interface ProfileTableViewController (Testing)
- (NSString*)valueForTextCellWithIndex:(int)rowIndex;
- (void)save;
@end


@interface trackandbill_iosTests : XCTestCase {
@private
	UIApplication       *app;
	DashboardCollectionViewController* dashboardVC;
	ClientsTableViewController* clientVC;
	ProfileTableViewController* profileVC;
	
	NSManagedObjectContext *managedObjectContext;
}
@end

@implementation trackandbill_iosTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	self.continueAfterFailure = NO;

	app = [UIApplication sharedApplication];
	
	dashboardVC = [[DashboardCollectionViewController alloc] init];
	clientVC = [[ClientsTableViewController alloc] init];
	profileVC = [[ProfileTableViewController alloc] init];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(dashboardVC, @"Pass");
	  //[clientVC fetchData];
}

//Load a ton of data into database
- (void)testDataLoad {
	
	//NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles: nil];
	
	//core data tests setup
	NSPersistentContainer *pc = [[NSPersistentContainer alloc] initWithName:@"trackandbill_ios"];
	
	[pc loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
		if (error != nil) {
			NSLog(@"Unresolved error %@, %@", error, error.userInfo);
			abort();
		}
	}];
	
	managedObjectContext = pc.viewContext;
	managedObjectContext.persistentStoreCoordinator = pc.persistentStoreCoordinator;
	
	
	//add lots of records
	
	int clientCount = 50;
	int projectCount = 100;
	int sessionCount = 50;
	
	for(int i = 0; i < clientCount; i++) {
		//add clients
		NSManagedObject *managedObjClient = [NSEntityDescription insertNewObjectForEntityForName:@"Client" inManagedObjectContext:managedObjectContext];
		
		NSString* clientName =[NSString stringWithFormat:@"Client %@", [NSNumber numberWithInt:i]];
		[managedObjClient setValue:clientName forKey:@"name"];
	
		XCTAssertEqual([managedObjClient valueForKey:@"name"], clientName);
		
		//add projects
		for(int p = 0; p < projectCount; p++) {
			NSManagedObject *managedObjProject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
			
			NSString* projectName = [NSString stringWithFormat:@"Project %@", [NSNumber numberWithInt:p]];
			
			[managedObjProject setValue:projectName forKey:@"name"];
			NSMutableSet *changeProjects = [managedObjClient mutableSetValueForKey:@"projects"];
			[changeProjects addObject:managedObjProject];
			
			XCTAssertEqual([managedObjProject valueForKey:@"name"], projectName);
			
			//add Sessions
			for(int s = 0; s < sessionCount; s++) {
				NSManagedObject *managedObjSessions = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:managedObjectContext];
				
				[managedObjSessions setValue:[NSDate date] forKey:@"start"];
				NSMutableSet *changeSessions = [managedObjProject mutableSetValueForKey:@"sessions"];
				[changeSessions addObject:managedObjSessions];
			}
			
			//add invoice
			NSManagedObject *managedObjInvoice = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice" inManagedObjectContext:managedObjectContext];

			[managedObjInvoice setValue:[NSNumber numberWithInt:p] forKey:@"number"];
//			NSMutableSet *changeInvoices = [managedObjProject mutableSetValueForKey:@"invoices"];
//			[changeInvoices addObject:managedObjInvoice];
		
		}
		
	}
	
	
	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		XCTFail(@"failed with error: %@, %@", error, [error userInfo]);
	}
	
}

- (void)testTableValueReturn {
	for(int i = 0; i < 8; i++) {
		XCTAssert([profileVC valueForTextCellWithIndex:i], @"Pass");
	}
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
			//[clientVC setTitle:@"test"];
			
			
    }];
}

@end
