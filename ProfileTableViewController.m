//
//  ProfileTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/16/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "TextInputTableViewCell.h"
#import "Profile.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

@synthesize arrProfiles = _arrProfiles;
@synthesize arrFormText = _arrFormText;

NSMutableArray * formFields;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[self navigationItem] setTitle:@"Profile"];
    
    //input form text fields
    formFields = [[NSMutableArray alloc] init];
    [formFields addObject:@"Your Name or Company"];
    [formFields addObject:@"Address"];
    [formFields addObject:@"City"];
    [formFields addObject:@"State"];
    [formFields addObject:@"Postal Code"];
    [formFields addObject:@"Phone"];
    [formFields addObject:@"Email"];
    [formFields addObject:@"Contact Person"];
    [formFields addObject:@"Submit"];
    
    
    _arrFormText = [[NSMutableArray alloc] init];
    
    [self loadDataFromDisk];
    
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
    return [formFields count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
    
    TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    if([[formFields objectAtIndex:[indexPath row]] isEqualToString:@"Submit"])
    {
        [[cell textInput] setHidden:YES];

        
     UIButton * submit = [[UIButton alloc] initWithFrame:[cell frame]];
        
        [submit setTitle:[formFields objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
        [submit setBackgroundColor:[UIColor grayColor]];
        [submit setTag:[indexPath row]];
        [submit addTarget:self action:@selector(handleProfileSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //[submit setTitleColor:[UIColor whiteColor] forState:UIControlEventValueChanged];
        [cell addSubview:submit];
    }
    else
    {
        //set placeholder value for new cell
        [[cell textInput] setPlaceholder:[formFields objectAtIndex:[indexPath row]]];
        [cell setTag:[indexPath row]];
        [cell setFieldName:[formFields objectAtIndex:[indexPath row]]];
        [[cell textInput] setBorderStyle:UITextBorderStyleNone];
        [[cell textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
        [[cell textInput] setTextColor:[UIColor blackColor]];
        cell.textInput.delegate = self;
        
        //populate text fields
        switch ([indexPath row]) {
            case 0:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profileName]];
                break;
            case 1:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profileAddress]];
                break;
            case 2:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profileCity]];
                break;
            case 3:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profileState]];
                break;
            case 4:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profileZip]];
                break;
            case 5:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profilePhone]];
                break;
            case 6:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profileEmail]];
                break;
            case 7:
                [[cell textInput] setText:[[_arrProfiles objectAtIndex:0] profileContact]];
                break;
            default:
                break;
        }
        
       
        [[self arrFormText] addObject:cell];
    }
    
    return cell;
}

- (IBAction)handleProfileSubmit:(id)sender
{
    //todo: handle form validation
    
    
    //add to profile file
    //[self setDateFormat];
    
    //save plist setting
    //[self writeSettings:@"invoiceImage" :[lblInvoiceImg stringValue]];
    
    _arrProfiles = [[NSMutableArray alloc] init];
    
    Profile *nProfile = [[Profile alloc] init];
    
    
//    for(TextInputTableViewCell * cell in self.arrFormText)
//    {
//        NSLog(@"field: %ld", (long)cell.tag);
//        NSLog(@"value: %@", cell.textInput);
//    }
    
    //[nProfile setProfileName:(NSString *)]
    
    //Only one profile allowed for now
    if ([_arrProfiles count] < 1) {
        [_arrProfiles addObject:nProfile];
    }
    

    //set form values
    [[_arrProfiles objectAtIndex:0] setProfileName:[[[[self arrFormText]objectAtIndex:0] textInput] text]];
    [[_arrProfiles objectAtIndex:0] setProfileAddress:[[[[self arrFormText]objectAtIndex:1] textInput] text]];
    [[_arrProfiles objectAtIndex:0] setProfileCity:[[[[self arrFormText]objectAtIndex:2] textInput] text]];
    [[_arrProfiles objectAtIndex:0] setProfileState:[[[[self arrFormText]objectAtIndex:3] textInput] text]];
    [[_arrProfiles objectAtIndex:0] setProfileZip:[[[[self arrFormText]objectAtIndex:4] textInput] text]];
    [[_arrProfiles objectAtIndex:0] setProfilePhone:[[[[self arrFormText]objectAtIndex:5] textInput] text]];
    [[_arrProfiles objectAtIndex:0] setProfileEmail:[[[[self arrFormText]objectAtIndex:6] textInput] text]];
    [[_arrProfiles objectAtIndex:0] setProfileContact:[[[[self arrFormText]objectAtIndex:7] textInput] text]];
    
    [self saveDataToDisk];
    
    [[self view] endEditing:YES];
    
    
    
}



- (void) loadDataFromDisk
{
    //TODO: May need to test if file exists to avoid error
    NSDictionary * rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile]];
  
    [self setProfiles: [rootObject valueForKey:@"profile"]];
   
}

- (void) setProfiles: (NSArray *)newProfiles
{
    if (_arrProfiles != newProfiles)
    {
        
        _arrProfiles = [[NSMutableArray alloc] initWithArray: newProfiles];
    }
    
        [[self tableView] reloadData];
}

- (NSString *)pathForDataFile
{
    //Accessible files are stored in the devices "Documents" directory
    NSArray*	documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*	path = nil;
    
    if (documentDir) {
        path = [documentDir objectAtIndex:0];
    }
    
    
    NSLog(@"path....%@",[NSString stringWithFormat:@"%@/%@", path, @"profiles.tbd"]);
    
    return [NSString stringWithFormat:@"%@/%@", path, @"profiles.tbd"];
  
}

- (void) saveDataToDisk
{

    NSMutableDictionary * rootObject = [NSMutableDictionary dictionary];

    [rootObject setValue:_arrProfiles forKey:@"profile"];

    BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject toFile:[self pathForDataFile]];

    if(success)
    {
        //message
        [self showMessage:@"Your personal profile has been stored" withTitle:@"Profile completed!"];
    }
    else{
        //message
          [self showMessage:@"Could not save profile" withTitle:@"Profile error"];
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
