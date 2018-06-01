//
//  trackandbill_iosUITests.m
//  trackandbill_iosUITests
//
//  Created by Loud on 6/1/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface trackandbill_iosUITests : XCTestCase

@end

@implementation trackandbill_iosUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddClientsAndProjects {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
	
	int clientCount = 10;

	XCUIApplication *app = [[XCUIApplication alloc] init];
	[[app.collectionViews.cells.otherElements containingType:XCUIElementTypeImage identifier:@"clients"].element tap];
	
	for(int i = 0; i < clientCount; i++) {
		[app.navigationBars[@"Clients"].buttons[@"New"] tap];
		
		NSString* cName = [NSString stringWithFormat:@"Client %d", i];
		XCUIElementQuery *tablesQuery = app.tables;
		[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Client Name"] childrenMatchingType:XCUIElementTypeTextField].element tap];
		XCUIElement *textField = [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Client Name"] childrenMatchingType:XCUIElementTypeTextField].element;
		[textField typeText:cName];
		
		XCTAssertEqual([textField value], cName);
		
		[app.navigationBars[@"New Client"].buttons[@"Clients"] tap];
		
		//project
		[[[tablesQuery childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:i].staticTexts[cName] tap];
		[app.navigationBars[cName].buttons[@"New"] tap];
		
		XCUIElementQuery *projectNameCellsQuery = [tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Project Name"];
		[[projectNameCellsQuery childrenMatchingType:XCUIElementTypeTextField].element tap];
		//[[projectNameCellsQuery.textFields containingType:XCUIElementTypeButton identifier:@"Clear text"].element typeText:@"111"];
		
		NSString* pName = [NSString stringWithFormat:@"Project %d", i];
		
		XCUIElement *textField2 = [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Project Name"] childrenMatchingType:XCUIElementTypeTextField].element;
		[textField2 typeText:pName];
		
		XCTAssertEqual([textField2 value], pName);
		
		[app.navigationBars[@"New Project"].buttons[cName] tap];
		
		[app.navigationBars[cName].buttons[@"Clients"] tap];
		
	}
	
}

- (void)testSessionAdd {
	
	int sessionCount = 10;
	
	XCUIApplication *app = [[XCUIApplication alloc] init];
	XCUIElementQuery *collectionViewsQuery = app.collectionViews;
	XCUIElementQuery *cellsQuery = collectionViewsQuery.cells;
	[[cellsQuery.otherElements containingType:XCUIElementTypeImage identifier:@"clients"].element tap];
	
	XCUIElementQuery *tablesQuery = app.tables;
	[tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Client 0"]/*[[".cells.staticTexts[@\"Client 0\"]",".staticTexts[@\"Client 0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
	[tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Project 0"]/*[[".cells.staticTexts[@\"Project 0\"]",".staticTexts[@\"Project 0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
	
	
	for(int i = 0; i < sessionCount; i ++) {
		[[cellsQuery.otherElements containingType:XCUIElementTypeImage identifier:@"new_session"].element tap];
		XCUIElement *switch2 = collectionViewsQuery/*@START_MENU_TOKEN@*/.switches[@"0"]/*[[".cells.switches[@\"0\"]",".switches[@\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
		[switch2 tap];
		
//		//milage
//		[[app.collectionViews.cells.otherElements containingType:XCUIElementTypeImage identifier:@"milage_track"].element tap];
//		[app.navigationBars[@"Milage Tracking"].buttons[@"Project 0"] tap];
		
		//leave session
		[app.collectionViews/*@START_MENU_TOKEN@*/.switches[@"1"]/*[[".cells.switches[@\"1\"]",".switches[@\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];//stop timer
		[app.navigationBars[@"Project 0"].buttons[@"Save & Exit"] tap];
	}
	
}

@end
