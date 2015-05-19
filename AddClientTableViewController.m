//
//  AddClientTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/8/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//


#import "AddClientTableViewController.h"
#import "TextInputTableViewCell.h"
#import "AppDelegate.h"

@interface AddClientTableViewController ()

@end

@implementation AddClientTableViewController

NSArray * clientFormFields;
@synthesize userData = _userData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[self navigationItem] setTitle:@"New Client"];
    
    //input form text fields

    clientFormFields = @[
                          @{@"FieldName": @"Client Name", @"FieldValue":@""},
                          @{@"FieldName": @"Contact Person",@"FieldValue":@""},
                          @{@"FieldName": @"Address",@"FieldValue":@"" },
                          @{@"FieldName": @"City",@"FieldValue": @""},
                          @{@"FieldName": @"State",@"FieldValue": @""},
                          @{@"FieldName": @"Country",@"FieldValue": @""},
                          @{@"FieldName": @"Postal Code",@"FieldValue": @""},
                          @{@"FieldName": @"Phone",@"FieldValue": @""},
                          @{@"FieldName": @"Email",@"FieldValue": @""}
                          
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
    [self newClientSubmit];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [[self view] endEditing:YES];
}

- (void)newClientSubmit
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //todo: handle form validation

    Client * newClient = [[Client alloc] init];
    
    //init new client with form values
    [newClient setCompanyName:[self.userData objectAtIndex:0]];
    [newClient setContactName:[self.userData objectAtIndex:1]];
    [newClient setStreet:[self.userData objectAtIndex:2]];
    [newClient setCity:[self.userData objectAtIndex:3]];
    [newClient setState:[self.userData objectAtIndex:4]];
    [newClient setCountry:[self.userData objectAtIndex:5]];
    [newClient setPostalCode:[self.userData objectAtIndex:6]];
    [newClient setPhoneNumber:[self.userData objectAtIndex:7]];
    [newClient setEmail:[self.userData objectAtIndex:8]];
    [newClient setClientID:[self createClientID]];
    
    //add new client object to clients list
    [[appDelegate arrClients] addObject:newClient];
    
   // [self saveDataToDisk];
    
    [[self view] endEditing:YES];
    
    //back to client list
    [[self navigationController] popViewControllerAnimated:YES];
    
    //set background image
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture_02.png"]]];
}


-(NSNumber *)createClientID
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSNumber * newId = [[NSNumber alloc] initWithLong:0];
   
    if([[appDelegate arrClients] count] > 0)
    {
        Client * lastClient = (Client *)[[appDelegate arrClients] objectAtIndex:[[appDelegate arrClients] count] - 1];
        newId = [NSNumber numberWithLong:lastClient.clientID.longValue + 1];
    }
    
    return newId;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [clientFormFields count];
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
    //[[cell textInput] setPlaceholder:[clientFormFields objectAtIndex:[indexPath row]]];
    [[cell labelCell] setText:[[clientFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
    [[cell textInput] setTag:[indexPath row]];//for scrolling workaround
    [cell setTag:[indexPath row]];
    [cell setFieldName:[clientFormFields objectAtIndex:[indexPath row]]];
    [[cell textInput] setBorderStyle:UITextBorderStyleNone];
    [[cell textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
    [[cell textInput] setTextColor:[UIColor blackColor]];
    cell.textInput.delegate = self;

    //check if user entered text into field, and load it. this fixes problem with scrolling, and text field input disappearing
    if(![[self.userData objectAtIndex:indexPath.row] isEqualToString:@""]){
        cell.textInput.text = [self.userData objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark text field delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.userData[textField.tag] = textField.text;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //save text input in user data. workaround for disappearing text entry issue on scroll
    [textField resignFirstResponder];
    self.userData[textField.tag] = textField.text;
    
}


-(NSMutableArray *)userData
{
    if(!_userData){
        _userData = [[NSMutableArray alloc] initWithCapacity:[clientFormFields count]];
        for (int i = 0; i < [clientFormFields count]; i++)
            [_userData addObject:@""];
    }
    return _userData;
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
