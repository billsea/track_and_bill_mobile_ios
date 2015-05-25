//
//  SessionEditTableViewController.m
//  trackandbill_ios
//
//  Created by William Seaman on 5/5/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import "SessionEditTableViewController.h"
#import "TextInputTableViewCell.h"
#import "AppDelegate.h"

#define kTableRowHeight 54

@interface SessionEditTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@property (nonatomic, strong) NSIndexPath *firstNumberPickerIndexPath;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation SessionEditTableViewController

@synthesize selectedSession = _selectedSession;
NSArray * sessionFormFields;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [[self navigationItem] setTitle:@"Session Edit"];
    
    //set background image
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture_02.png"]]];
    
    
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    
    //initialize table view date picker rows
    //Set indexPathForRow to the row number the date picker should be placed
    self.firstDatePickerIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    self.datePickerPossibleIndexPaths = @[self.firstDatePickerIndexPath];
    [self setDate:_selectedSession.sessionDate forIndexPath:self.firstDatePickerIndexPath];
    
    
    //number picker rows
    self.firstNumberPickerIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    self.numberPickerPossibleIndexPaths = @[self.firstNumberPickerIndexPath];
    [self setNumber:_selectedSession.sessionHours forIndexPath:self.firstNumberPickerIndexPath];
    
    
    //input form text fields
    sessionFormFields = [[NSMutableArray alloc] init];
    sessionFormFields = @[

                  @{@"FieldName": @"Client",@"FieldValue": _selectedSession.clientName},
                  @{@"FieldName": @"Project Name", @"FieldValue": _selectedSession.projectName},
                  @{@"FieldName": @"Date",@"FieldValue": [df stringFromDate:_selectedSession.sessionDate]},//replaced with date picker
                  @{@"FieldName": @"Hours",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.sessionHours]},
                  @{@"FieldName": @"Minutes",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.sessionMinutes]},
                  @{@"FieldName": @"Seconds",@"FieldValue": [self formatNumber:_selectedSession.sessionSeconds : 0]},
                  @{@"FieldName": @"Materials",@"FieldValue":[NSString stringWithFormat:@"%@", _selectedSession.materials]},
                  @{@"FieldName": @"Milage",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.milage]},
                  @{@"FieldName": @"Notes",@"FieldValue": [NSString stringWithFormat:@"%@",_selectedSession.txtNotes]},
                  
                  ];
    


//    //view has been touched, for dismiss keyboard - CAN'T USE TAPGESTURE WITH CUSTOM DATEPICKER TABLEVIEW CLASS
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleSingleTap:)];
//    
//    [self.view addGestureRecognizer:singleFingerTap];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    
    //must close date picker row to avoid crash
    [super hideExistingPicker];
    
    //save all but client and project info
     NSIndexPath *iPath = [NSIndexPath indexPathForRow:3 inSection:0] ;
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    //date -
    NSDate *firstDate = [self dateForIndexPath:self.firstDatePickerIndexPath];
    [_selectedSession setSessionDate: firstDate];


    //hours
    iPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSString * hours =[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] textInput]text];
    
    [_selectedSession setSessionHours:[NSNumber numberWithFloat:[hours floatValue]]];
    
    //minutes
    iPath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSString * minutes =[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] textInput] text];
    [_selectedSession setSessionMinutes:[NSNumber numberWithFloat:[minutes floatValue]]];
    
    //seconds
    iPath = [NSIndexPath indexPathForRow:5 inSection:0];
    NSString * seconds =[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] textInput] text];
    [_selectedSession setSessionSeconds:[NSNumber numberWithFloat:[seconds floatValue]]];
    
    //materials
    iPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [_selectedSession setMaterials:[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] textInput] text]];
    
    //milage
    iPath = [NSIndexPath indexPathForRow:7 inSection:0];
    NSString * milage =[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] textInput] text];
    [_selectedSession setMilage:[NSNumber numberWithFloat:[milage floatValue]]];
    
    //notes
    iPath = [NSIndexPath indexPathForRow:8 inSection:0];
    [_selectedSession setTxtNotes:[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] textInput] text]];
}

-(NSString *)formatNumber:(NSNumber *)number : (NSUInteger)fractionDigits
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:fractionDigits];
    [formatter setMinimumFractionDigits:fractionDigits];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString *numberString = [formatter stringFromNumber:number];
    
    return numberString;
}

//CAN'T USE TAPGESTURE WITH CUSTOM DATEPICKER TABLEVIEW CLASS
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

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return sessionFormFields.count;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = sessionFormFields;
    NSInteger numberOfRows = [super tableView:tableView numberOfRowsInSection:section] + [sectionArray count];
    return numberOfRows;
}



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//
//    if([[[sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"] isEqualToString:@"Date"])
//    {
//
//    }
//    else
//    {
//        
//    }
//    
//    static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
//    
//    TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//        
//    }
//    
//    [[cell labelCell] setText:[[sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
//    [[cell textInput] setText:[[sessionFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
//    [[cell textInput] setBorderStyle:UITextBorderStyleNone];
//    [[cell textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
//    [[cell textInput] setTextColor:[UIColor blackColor]];
//    
//    //project and client are read only
//    if([indexPath row] == 0 || [indexPath row] == 1)
//    {
//        [[cell textInput] setEnabled:FALSE];
//    }
//    
//    return cell;
//
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];;
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        //clear cell subviews-clears old cells
        if (cell != nil)
        {
            NSArray* subviews = [cell.contentView subviews];
            for (UIView* view in subviews)
            {
                [view removeFromSuperview];
            }
        }
        
        NSIndexPath *adjustedIndexPath = [self adjustedIndexPathForDatasourceAccess:indexPath];
        if ([adjustedIndexPath compare:self.firstDatePickerIndexPath] == NSOrderedSame)
        {
            NSDate *firstDate = [self dateForIndexPath:self.firstDatePickerIndexPath];
            
            NSString * dateFormatted = [NSDateFormatter localizedStringFromDate:firstDate
                                                                 dateStyle:NSDateFormatterShortStyle
                                                                 timeStyle:NSDateFormatterNoStyle];

            //add date label for date
            UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 23, 304, 30)];
            [dateLabel setText:dateFormatted];
            [dateLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
            [dateLabel setTintColor:[UIColor blackColor]];
            [[cell contentView] addSubview:dateLabel];
            
            //add field label for date
            UILabel * fieldTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 13)];
            [fieldTitle setText:@"Date"];
            [fieldTitle setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
            [fieldTitle setTintColor:[UIColor lightGrayColor]];
            
            [[cell contentView] addSubview:fieldTitle];
            
        }
        else if ([adjustedIndexPath compare:self.firstNumberPickerIndexPath] == NSOrderedSame)
        {
              NSNumber *firstNumber = [self numberForIndexPath:self.firstNumberPickerIndexPath];
            
            //add date label for date
            UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 23, 304, 30)];
            [numberLabel setText:[NSString stringWithFormat:@"%@",firstNumber]];
            [numberLabel setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
            [numberLabel setTintColor:[UIColor blackColor]];
            [[cell contentView] addSubview:numberLabel];
            
            //add field label for date
            UILabel * fieldTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 200, 13)];
            [fieldTitle setText:@"Hours"];
            [fieldTitle setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
            [fieldTitle setTintColor:[UIColor lightGrayColor]];
            
            [[cell contentView] addSubview:fieldTitle];
        }
        else
        {
                static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
            
                TextInputTableViewCell *cellText = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
                if (cellText == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
                    cellText = [nib objectAtIndex:0];
            
                }

                [[cellText labelCell] setText:[[sessionFormFields objectAtIndex:[adjustedIndexPath row]] valueForKey:@"FieldName"]];
                [[cellText textInput] setText:[[sessionFormFields objectAtIndex:[adjustedIndexPath row]] valueForKey:@"FieldValue"]];
                [[cellText textInput] setBorderStyle:UITextBorderStyleNone];
                [[cellText textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
                [[cellText textInput] setTextColor:[UIColor blackColor]];
                
                //project and client are read only
                if([adjustedIndexPath row] == 0 || [adjustedIndexPath row] == 1)
                {
                    [[cellText textInput] setEnabled:FALSE];
                }
        
            [[cell contentView] addSubview:cellText];
        }
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (rowHeight == 0) {
        rowHeight = kTableRowHeight;//self.tableView.rowHeight;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
