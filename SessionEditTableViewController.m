//
//  SessionEditTableViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/5/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "SessionEditTableViewController.h"

@interface SessionEditTableViewController ()

@end

@implementation SessionEditTableViewController

@synthesize selectedSession = _selectedSession;
NSArray * sessionFormFields;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[self navigationItem] setTitle:@"Session Edit"];
    
    //input form text fields
    sessionFormFields = [[NSMutableArray alloc] init];
    sessionFormFields = @[

                  @{@"FieldName": @"Client",@"FieldValue": _selectedSession.clientName},
                  @{@"FieldName": @"Project Name", @"FieldValue": _selectedSession.projectName},
                  @{@"FieldName": @"Date",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.sessionDate]},
                  @{@"FieldName": @"Hours",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.sessionHours]},
                  @{@"FieldName": @"Minutes",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.sessionMinutes]},
                  @{@"FieldName": @"Seconds",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.sessionSeconds]},
                  @{@"FieldName": @"Materials",@"FieldValue": _selectedSession.materials},
                  @{@"FieldName": @"Milage",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.milage]},
                  @{@"FieldName": @"Notes",@"FieldValue": _selectedSession.txtNotes},
                  
                  ];

    
   
    
    //view has been touched, for dismiss keyboard
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.view addGestureRecognizer:singleFingerTap];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //save all but client and project info
     NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    
    //date
    iPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [_selectedSession setSessionDate:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
    
    //hours
    iPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSString * hours =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_selectedSession setSessionHours:[NSNumber numberWithFloat:[hours floatValue]]];
    
    //minutes
    iPath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSString * minutes =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_selectedSession setSessionMinutes:[NSNumber numberWithFloat:[minutes floatValue]]];
    
    //seconds
    iPath = [NSIndexPath indexPathForRow:5 inSection:0];
    NSString * seconds =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_selectedSession setSessionSeconds:[NSNumber numberWithFloat:[seconds floatValue]]];
    
    //materials
    iPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [_selectedSession setMaterials:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
    
    //milage
    iPath = [NSIndexPath indexPathForRow:7 inSection:0];
    NSString * milage =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_selectedSession setMilage:[NSNumber numberWithFloat:[milage floatValue]]];
    
    //notes
    iPath = [NSIndexPath indexPathForRow:8 inSection:0];
    [_selectedSession setTxtNotes:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return sessionFormFields.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"SessionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryView =nil;
    
    //clear cell subviews-clears old cells
    if (cell != nil)
    {
        NSArray* subviews = [cell.contentView subviews];
        for (UIView* view in subviews)
        {
            [view removeFromSuperview];
        }
    }
    
    
    if([[[sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"] isEqualToString:@"Save and Preview"])
    {
        
//        UIButton * submit = [[UIButton alloc] initWithFrame:[cell frame]];
//        
//        [submit setTitle:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"] forState:UIControlStateNormal];
//        [submit setBackgroundColor:[UIColor grayColor]];
//        [submit setTag:[indexPath row]];
//        [submit addTarget:self action:@selector(newInvoiceSubmit:) forControlEvents:UIControlEventTouchUpInside];
//        [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        //[submit setTitleColor:[UIColor whiteColor] forState:UIControlEventValueChanged];
//        [[cell contentView] addSubview:submit];
        
    }
    else
    {
        UITextField * cellText = [[UITextField alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 20, 21)];
        [cellText setText:[[sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
        [cellText setBorderStyle:UITextBorderStyleRoundedRect];
        
        //set placeholder text
        [cellText setPlaceholder:[[sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
        
        [[cell contentView] addSubview:cellText];
    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
