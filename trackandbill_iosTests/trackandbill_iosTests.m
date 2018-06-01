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
	 app = [UIApplication sharedApplication];
	dashboardVC = [[DashboardCollectionViewController alloc] init];
	clientVC = [[ClientsTableViewController alloc] init];
	profileVC = [[ProfileTableViewController alloc] init];
	
	//core data tests setup
	NSPersistentContainer *pc = [[NSPersistentContainer alloc] initWithName:@"trackandbill_ios"];
	
	[pc loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
		if (error != nil) {
			NSLog(@"Unresolved error %@, %@", error, error.userInfo);
			abort();
		}
	}];
	
//	XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
	
	managedObjectContext = pc.viewContext;
	
	managedObjectContext.persistentStoreCoordinator = pc.persistentStoreCoordinator;
	
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

- (void)testDataLoad {
	for(int i = 0; i < 1000; i++) {
		[self testDataStuff];
	}
}

- (void) testDataStuff {
	NSManagedObject *managedObj = [NSEntityDescription insertNewObjectForEntityForName:@"Client" inManagedObjectContext:managedObjectContext];
	
	[managedObj setValue:@"testName" forKey:@"name"];
	//[managedObj setValue:[NSNumber numberWithInt:90000] forKey:@"remoteid"];
	
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
