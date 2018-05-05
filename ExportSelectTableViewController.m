//
//  ExportSelectTableViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/5/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "ExportSelectTableViewController.h"
#import "ExportDeliverViewController.h"

@interface ExportSelectTableViewController (){
	NSMutableArray* _cellData;
}

@end

@implementation ExportSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[self navigationItem] setTitle: NSLocalizedString(@"export",nil)];
	
	//Cell item data
	NSMutableDictionary* newSessionDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"csv_file", nil),@"title", nil];
	
	_cellData = [[NSMutableArray alloc] initWithObjects:newSessionDict, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"exportCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
																	reuseIdentifier:CellIdentifier];
	}

	cell.textLabel.text = [[_cellData objectAtIndex:indexPath.row] objectForKey:@"title"];
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0) {
		   ExportDeliverViewController *exportDeliver = [[ExportDeliverViewController alloc] initWithNibName:@"ExportDeliverViewController" bundle:nil];
		[exportDeliver setSelectedProject:_selectedProject];
		  [self.navigationController pushViewController:exportDeliver animated:YES];
	}
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
