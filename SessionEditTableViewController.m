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

@interface SessionEditTableViewController () {
    NSArray * _sessionFormFields;

}

@property (nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@property (nonatomic, strong) NSIndexPath *firstNumberPickerIndexPath;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation SessionEditTableViewController

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
    _sessionFormFields = [[NSMutableArray alloc] init];
    _sessionFormFields = @[

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
    NSArray *sectionArray = _sessionFormFields;
    NSInteger numberOfRows = [super tableView:tableView numberOfRowsInSection:section] + [sectionArray count];
    return numberOfRows;
}



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
        
        NSLog(@"row:%ld",(long)indexPath.row);
        NSLog(@"adjusted index path row:%ld",(long)adjustedIndexPath.row);
        
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

                [[cellText labelCell] setText:[[_sessionFormFields objectAtIndex:[adjustedIndexPath row]] valueForKey:@"FieldName"]];
                [[cellText textInput] setText:[[_sessionFormFields objectAtIndex:[adjustedIndexPath row]] valueForKey:@"FieldValue"]];
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

@end
