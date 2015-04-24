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

NSMutableArray * clientFormFields;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[self navigationItem] setTitle:@"New Client"];
    
    //input form text fields
    clientFormFields = [[NSMutableArray alloc] init];
    [clientFormFields addObject:@"Client Name"];
    [clientFormFields addObject:@"Contact Person"];
    [clientFormFields addObject:@"Address"];
    [clientFormFields addObject:@"City"];
    [clientFormFields addObject:@"State"];
    [clientFormFields addObject:@"Country"];
    [clientFormFields addObject:@"Postal Code"];
    [clientFormFields addObject:@"Phone"];
    [clientFormFields addObject:@"Email"];
    [clientFormFields addObject:@"Add Client"];
    
    _arrFormText = [[NSMutableArray alloc] init];
    
    
    //view has been touched, for dismiss keyboard
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.view addGestureRecognizer:singleFingerTap];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [[self view] endEditing:YES];
}

- (IBAction)newClientSubmit:(id)sender
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //todo: handle form validation

    Client * newClient = [[Client alloc] init];
    
    //init new client with form values
    
    [newClient setCompanyName:[[[[self arrFormText]objectAtIndex:0] textInput] text]];
    [newClient setContactName:[[[[self arrFormText]objectAtIndex:1] textInput] text]];
    [newClient setStreet:[[[[self arrFormText]objectAtIndex:2] textInput] text]];
    [newClient setCity:[[[[self arrFormText]objectAtIndex:3] textInput] text]];
    [newClient setState:[[[[self arrFormText]objectAtIndex:4] textInput] text]];
    [newClient setCountry:[[[[self arrFormText]objectAtIndex:5] textInput] text]];
    [newClient setPostalCode:[[[[self arrFormText]objectAtIndex:6] textInput] text]];
    [newClient setPhoneNumber:[[[[self arrFormText]objectAtIndex:7] textInput] text]];
    [newClient setEmail:[[[[self arrFormText]objectAtIndex:8] textInput] text]];
    [newClient setClientID:[self createClientID]];
    
    //add new client object to clients list
    [[appDelegate arrClients] addObject:newClient];
    
   // [self saveDataToDisk];
    
    [[self view] endEditing:YES];
    
    //back to client list
    [[self navigationController] popViewControllerAnimated:YES];
}


-(NSNumber *)createClientID
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSNumber * newId = [[NSNumber alloc] initWithLong:0];
    NSString  *path= [appDelegate pathToDataFile:@"clients.tbd"];
    NSDictionary *rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    //add clients to array
    NSMutableArray * allClients = [[NSMutableArray alloc] initWithArray:[rootObject valueForKey:@"client"]];
    
    if([allClients count] > 0)
    {
        for(Client * client in allClients)
        {
            NSLog(@"clientID: %@",client.clientID);
            if(client.clientID >= newId)
            {
                newId = [NSNumber numberWithLong:client.clientID.intValue + 1];
            }
        }
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
    
    if([[clientFormFields objectAtIndex:[indexPath row]] isEqualToString:@"Add Client"])
    {
        [[cell textInput] setHidden:YES];
        
        UIButton * submit = [[UIButton alloc] initWithFrame:[cell frame]];
        
        [submit setTitle:[clientFormFields objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
        [submit setBackgroundColor:[UIColor grayColor]];
        [submit setTag:[indexPath row]];
        [submit addTarget:self action:@selector(newClientSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[submit setTitleColor:[UIColor whiteColor] forState:UIControlEventValueChanged];
        [cell addSubview:submit];
    }
    else
    {
        //set placeholder value for new cell
        [[cell textInput] setPlaceholder:[clientFormFields objectAtIndex:[indexPath row]]];
        [cell setTag:[indexPath row]];
        [cell setFieldName:[clientFormFields objectAtIndex:[indexPath row]]];
        cell.textInput.delegate = self;

        
        [[self arrFormText] addObject:cell];
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
