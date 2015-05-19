//
//  AddProjectTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/5/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "AddProjectTableViewController.h"
#import "TextInputTableViewCell.h"
#import "project.h"
#import "AppDelegate.h"
#import "Session.h"

@interface AddProjectTableViewController ()

@end

@implementation AddProjectTableViewController

@synthesize selectedClient = _selectedClient;



NSArray * projectFormFields;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[self navigationItem] setTitle:@"New Project"];
    
    //input form text fields
    projectFormFields = @[
                         @{@"FieldName": @"Project Name", @"FieldValue":@""},
                         @{@"FieldName": @"Start Date",@"FieldValue":[NSString stringWithFormat:@"%@",[NSDate date]]},
                         @{@"FieldName": @"End Date",@"FieldValue":[NSString stringWithFormat:@"%@",[NSDate date]]},
                         ];
    
    
    //view has been touched, for dismiss keyboard
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
     [self.view addGestureRecognizer:singleFingerTap];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //set background image
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture_02.png"]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self newProjectSubmit];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//create project ID
-(NSNumber *)createProjectID
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSNumber * newId = [[NSNumber alloc] initWithLong:0];
    
    if([[appDelegate allProjects] count] > 0)
    {
        for(Project * proj in [appDelegate allProjects])
        {
            NSLog(@"ProjectID: %@",proj.projectID);
            if(proj.projectID >= newId)
            {
                newId = [NSNumber numberWithLong:proj.projectID.intValue + 1];
            }
        }
    }
    
    
    return newId;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [projectFormFields count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
    
    TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    //set placeholder value for new cell
    [[cell textInput] setText:[[projectFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
    [[cell labelCell] setText:[[projectFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
    [cell setTag:[indexPath row]];
    [cell setFieldName:[projectFormFields objectAtIndex:[indexPath row]]];
    [[cell textInput] setBorderStyle:UITextBorderStyleNone];
    [[cell textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
    [[cell textInput] setTextColor:[UIColor blackColor]];
     cell.textInput.delegate = self;

    
    return cell;
}


- (void)newProjectSubmit
{
   
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //todo: handle form validation
    
    Project *nProject = [[Project alloc] init];
  
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSString * projName = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    
    
    if(![projName isEqualToString:@""])
    {
        //set new project with form value, and generate id
        [nProject setProjectName:projName];
        [nProject setClientName:[_selectedClient company]];
        

        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        
        iPath = [NSIndexPath indexPathForRow:1 inSection:0];
        NSString * projStart = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
        NSDate * startDate = [df dateFromString:projStart];
        
        iPath = [NSIndexPath indexPathForRow:2 inSection:0];
        NSString * projEnd = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
        NSDate * endDate = [df dateFromString:projEnd];
        
        if(!startDate)
        {
           [nProject setStartDate:[NSDate date]];
        }
        else
        {
            [nProject setStartDate:startDate];
        }
        
        if(!endDate)
        {
            [nProject setEndDate:[NSDate date]];
        }
        else
        {
            [nProject setEndDate:endDate];
        }
        
        [nProject setClientID:[[self selectedClient] clientID]];
        [nProject setProjectID:[self createProjectID]];
        
        
        //add projects to all projects list
        [[appDelegate allProjects] addObject:nProject];
      
        //save to archive file
       // [appDelegate saveProjectsToDisk];
     }
    [[self view] endEditing:YES];
    
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
