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

@interface ProfileTableViewController () {
  NSArray *_formFields;
}

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  [[self navigationItem] setTitle:@"Profile"];

  [self loadDataFromDisk];

  // view has been touched, for dismiss keyboard
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handleSingleTap:)];

  [self.view addGestureRecognizer:singleFingerTap];

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  // set background image
  [[self view]
      setBackgroundColor:[UIColor
                             colorWithPatternImage:
                                 [UIImage imageNamed:@"paper_texture_02.png"]]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self handleProfileSubmit];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  // CGPoint location = [recognizer locationInView:[recognizer.view superview]];

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

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  // Return the number of rows in the section.
  return [_formFields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *simpleTableIdentifier = @"TextInputTableViewCell";

  TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:simpleTableIdentifier];

  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell"
                                                 owner:self
                                               options:nil];
    cell = [nib objectAtIndex:0];
  }

  // set placeholder value for new cell
  //[[cell textInput] setPlaceholder:[clientFormFields objectAtIndex:[indexPath
  //row]]];
  [[cell labelCell] setText:[[_formFields objectAtIndex:[indexPath row]]
                                valueForKey:@"FieldName"]];
  [[cell textInput] setTag:[indexPath row]]; // for scrolling workaround
  [[cell textInput] setText:[[_formFields objectAtIndex:[indexPath row]]
                                valueForKey:@"FieldValue"]];
  [cell setTag:[indexPath row]];
  [cell setFieldName:[_formFields objectAtIndex:[indexPath row]]];
  [[cell textInput] setBorderStyle:UITextBorderStyleNone];
  [[cell textInput]
      setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
  [[cell textInput] setTextColor:[UIColor blackColor]];
  cell.textInput.delegate = self;

  // check if user entered text into field, and load it. this fixes problem with
  // scrolling, and text field input disappearing
  if (![[self.userData objectAtIndex:indexPath.row] isEqualToString:@""]) {
    cell.textInput.text = [self.userData objectAtIndex:indexPath.row];
  }

  return cell;
}

#pragma mark text field delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  self.userData[textField.tag] = textField.text;
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  // save text input in user data. workaround for disappearing text entry issue
  // on scroll
  [textField resignFirstResponder];
  self.userData[textField.tag] = textField.text;
}

- (NSMutableArray *)userData {
  if (!_userData) {
    _userData = [[NSMutableArray alloc] initWithCapacity:[_formFields count]];
    for (int i = 0; i < [_formFields count]; i++)
      [_userData addObject:@""];
  }
  return _userData;
}

- (void)handleProfileSubmit {
  // todo: handle form validation
  _arrProfiles = [[NSMutableArray alloc] init];

  Profile *nProfile = [[Profile alloc] init];

  // Only one profile allowed for now
  if ([_arrProfiles count] < 1) {
    [_arrProfiles addObject:nProfile];
  }

  // set form values
  NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0];
  NSString *profName =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfileName:profName];
  if ([profName isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfileName:[self.userData objectAtIndex:0]];
  }

  iPath = [NSIndexPath indexPathForRow:1 inSection:0];
  NSString *profad =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfileAddress:profad];
  if ([profad isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfileAddress:[self.userData objectAtIndex:1]];
  }

  iPath = [NSIndexPath indexPathForRow:2 inSection:0];
  NSString *profcity =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfileCity:profcity];
  if ([profcity isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfileCity:[self.userData objectAtIndex:2]];
  }

  iPath = [NSIndexPath indexPathForRow:3 inSection:0];
  NSString *profstate =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfileState:profstate];
  if ([profstate isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfileState:[self.userData objectAtIndex:3]];
  }

  iPath = [NSIndexPath indexPathForRow:4 inSection:0];
  NSString *profzip =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfileZip:profzip];
  if ([profzip isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfileZip:[self.userData objectAtIndex:4]];
  }

  iPath = [NSIndexPath indexPathForRow:5 inSection:0];
  NSString *profPhone =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfilePhone:profPhone];
  if ([profPhone isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfilePhone:[self.userData objectAtIndex:5]];
  }

  iPath = [NSIndexPath indexPathForRow:6 inSection:0];
  NSString *profemail =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfileEmail:profemail];
  if ([profemail isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfileEmail:[self.userData objectAtIndex:6]];
  }

  iPath = [NSIndexPath indexPathForRow:7 inSection:0];
  NSString *profcontact =
      [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews]
          objectAtIndex:0] text];
  [[_arrProfiles objectAtIndex:0] setProfileContact:profcontact];
  if ([profcontact isEqualToString:@""]) {
    [[_arrProfiles objectAtIndex:0]
        setProfileContact:[self.userData objectAtIndex:7]];
  }

  [self saveDataToDisk];

  [[self view] endEditing:YES];
}

- (void)loadDataFromDisk {
  // TODO: May need to test if file exists to avoid error
  NSDictionary *rootObject;
  rootObject =
      [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile]];

  [self setProfiles:[rootObject valueForKey:@"profile"]];
}

- (void)setProfiles:(NSArray *)newProfiles {
  if (_arrProfiles != newProfiles) {

    _arrProfiles = [[NSMutableArray alloc] initWithArray:newProfiles];
  }

  _formFields = @[
    @{
      @"FieldName" : @"Your Name or Company",
      @"FieldValue" : [NSString
          stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0] profileName]]
    },
    @{
      @"FieldName" : @"Address",
      @"FieldValue" :
          [NSString stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0]
                                                profileAddress]]
    },
    @{
      @"FieldName" : @"City",
      @"FieldValue" : [NSString
          stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0] profileCity]]
    },
    @{
      @"FieldName" : @"State",
      @"FieldValue" : [NSString
          stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0] profileState]]
    },
    @{
      @"FieldName" : @"Postal Code",
      @"FieldValue" : [NSString
          stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0] profileZip]]
    },
    @{
      @"FieldName" : @"Phone",
      @"FieldValue" : [NSString
          stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0] profilePhone]]
    },
    @{
      @"FieldName" : @"Email",
      @"FieldValue" : [NSString
          stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0] profileEmail]]
    },
    @{
      @"FieldName" : @"Contact Person",
      @"FieldValue" :
          [NSString stringWithFormat:@"%@", [[_arrProfiles objectAtIndex:0]
                                                profileContact]]
    }

  ];

  [[self tableView] reloadData];
}

- (NSString *)pathForDataFile {
  // Accessible files are stored in the devices "Documents" directory
  NSArray *documentDir = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = nil;

  if (documentDir) {
    path = [documentDir objectAtIndex:0];
  }

  NSLog(@"path....%@",
        [NSString stringWithFormat:@"%@/%@", path, @"profiles.tbd"]);

  return [NSString stringWithFormat:@"%@/%@", path, @"profiles.tbd"];
}

- (void)saveDataToDisk {

  NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];

  [rootObject setValue:_arrProfiles forKey:@"profile"];

   BOOL success =  [NSKeyedArchiver archiveRootObject: rootObject
   toFile:[self pathForDataFile]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in
-tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#>
alloc] initWithNibName:<#@"Nib name"#> bundle:nil];

    // Pass the selected object to the new view controller.

    // Push the view controller.
    [self.navigationController pushViewController:detailViewController
animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
