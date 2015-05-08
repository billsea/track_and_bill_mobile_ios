//
//  InvoiceTableViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "InvoiceTableViewController.h"
#import "AppDelegate.h"
#import "Session.h"
#import "Profile.h"

#define kPadding 5
#define kHeaderPadding 5

@interface InvoiceTableViewController (){
    CGSize _pageSize;
}

@property UIBarButtonItem * previewButton;

@end

@implementation InvoiceTableViewController

@synthesize selectedProject = _selectedProject;
@synthesize selectedInvoice = _selectedInvoice;

@synthesize nInvoice = _nInvoice;

NSArray * invoiceFormFields;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setTitle:@"Invoice"];
    
    
    //add help navigation bar button
    self.previewButton = [[UIBarButtonItem alloc]
                       //initWithImage:[UIImage imageNamed:@"reload-50.png"]
                       initWithTitle:@"Export"
                       style:UIBarButtonItemStyleBordered
                       target:self
                       action:@selector(exportInvoice:)];
    //self.addClientButton.tintColor = [UIColor blackColor];
    [[self navigationItem] setRightBarButtonItem:self.previewButton];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    //new invoice object
    _nInvoice = [[Invoice alloc] init];
    
    //input form text fields
    invoiceFormFields = [[NSMutableArray alloc] init];
    
    //Set form values
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //calculate hours,minutes, seconds from seconds
    NSNumber * hours = [[NSNumber alloc] init];
    NSNumber * minutes = [[NSNumber alloc] init];
    NSNumber * seconds = [[NSNumber alloc] init];
    NSNumber * miles = [[NSNumber alloc] init];
    [self projectTotals:&hours :&minutes :&seconds :&miles];
  
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    //Could be new invoice or edit
    if(self.selectedInvoice && self.selectedInvoice.invoiceNumber)
    {
            invoiceFormFields = @[
                 @{@"FieldName": @"Invoice Number", @"FieldValue": _selectedInvoice.invoiceNumber},
                 @{@"FieldName": @"Invoice Date",@"FieldValue": [df stringFromDate: _selectedInvoice.invoiceDate]},
                 @{@"FieldName": @"Client Name",@"FieldValue": [_selectedInvoice clientName]},
                 @{@"FieldName": @"Project Name",@"FieldValue":[_selectedInvoice projectName] },
                 @{@"FieldName": @"Start Date",@"FieldValue": [df stringFromDate:[_selectedInvoice startDate]]},
                 @{@"FieldName": @"End Date",@"FieldValue":[df stringFromDate:[_selectedInvoice endDate]] },
                 @{@"FieldName": @"Approval Name",@"FieldValue":[_selectedInvoice approvalName] },
                 @{@"FieldName": @"Mileage",@"FieldValue": [NSString stringWithFormat:@"%@",miles]},
                 @{@"FieldName": @"Notes",@"FieldValue": [_selectedInvoice invoiceNotes] },
                 @{@"FieldName": @"Materials",@"FieldValue":[_selectedInvoice invoiceMaterials] },
                 @{@"FieldName": @"Materials Total",@"FieldValue":[NSString stringWithFormat:@"%f",[_selectedInvoice materialsTotal]]},
                 @{@"FieldName": @"Total Hours",@"FieldValue": [_selectedInvoice totalTime]},
                 @{@"FieldName": @"Terms",@"FieldValue":[_selectedInvoice invoiceTerms]},
                 @{@"FieldName": @"Deposit",@"FieldValue":[NSString stringWithFormat:@"%f",[_selectedInvoice invoiceDeposit]]},
                 @{@"FieldName": @"Rate",@"FieldValue":[NSString stringWithFormat:@"%f",[_selectedInvoice invoiceRate]]}
                 
                 ];
    }
    else if(self.selectedProject)
    {
        //remove exisitng
        [self removeExistingInvoice];
        
        //create long string with all notes, materials
        NSString * allNotes = [[NSString alloc] init];
        NSString * allMaterials = [[NSString alloc] init];
        

        
        for(Session * s in [appDelegate storedSessions])
        {
            if(s.projectIDref == _selectedProject.projectID)
            {
                allNotes = [allNotes stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n", [df stringFromDate:s.sessionDate],s.txtNotes]];
                allMaterials =[allMaterials stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n", [df stringFromDate:s.sessionDate],s.materials]];
                
            }
        }
        
        
         invoiceFormFields = @[
                 @{@"FieldName": @"Invoice Number", @"FieldValue": [self createInvoiceNumber]},
                 @{@"FieldName": @"Invoice Date",@"FieldValue": [df stringFromDate:[NSDate date]]},
                 @{@"FieldName": @"Client Name",@"FieldValue": [_selectedProject clientName]},
                 @{@"FieldName": @"Project Name",@"FieldValue":[_selectedProject projectName] },
                 @{@"FieldName": @"Start Date",@"FieldValue": [df stringFromDate:[_selectedProject startDate]]},
                 @{@"FieldName": @"End Date",@"FieldValue":[df stringFromDate:[_selectedProject endDate]] },
                 @{@"FieldName": @"Approval Name",@"FieldValue":@""},
                 @{@"FieldName": @"Mileage",@"FieldValue": [NSString stringWithFormat:@"%@",miles]},
                 @{@"FieldName": @"Notes",@"FieldValue": allNotes},
                 @{@"FieldName": @"Materials",@"FieldValue":allMaterials},
                 @{@"FieldName": @"Materials Total",@"FieldValue":@""},
                 @{@"FieldName": @"Total Hours",@"FieldValue": [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%2@:%2@:%4@", hours, minutes, seconds]]},
                 @{@"FieldName": @"Terms",@"FieldValue":@""},
                 @{@"FieldName": @"Deposit",@"FieldValue":@"" },
                 @{@"FieldName": @"Rate",@"FieldValue": @""}
                 
                 ];
  
    }
    
    
    //view has been touched, for dismiss keyboard
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.view addGestureRecognizer:singleFingerTap];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)projectTotals:(NSNumber **)hours : (NSNumber **)minutes : (NSNumber **)seconds : (NSNumber **)miles{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    int ml=0;
    int ticks = 0;
    for(Session * s in [appDelegate storedSessions])
    {
        if([s projectIDref] == [_selectedProject projectID])
        {
            
            ticks = ticks + s.sessionHours.intValue * 3600;
            ticks = ticks + s.sessionMinutes.intValue * 60;
            ticks = ticks + s.sessionSeconds.intValue;
            ml = ml + s.milage.intValue;
        }
    }

    double sec = fmod(ticks, 60.0);
    double m = fmod(trunc(ticks / 60.0), 60.0);
    double h = trunc(ticks / 3600.0);
    
    *hours = [NSNumber numberWithDouble:h];
    *minutes = [NSNumber numberWithDouble:m];
    *seconds = [NSNumber numberWithDouble:sec];
    *miles = [NSNumber numberWithInt:ml];
}



- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [[self view] endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //save invoice to invoice stack
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    //add new invoice object to clients list
    [[appDelegate arrInvoices] addObject:_nInvoice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeExistingInvoice
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //Remove existing invoice for this project
    for(Invoice * remInvoice in [appDelegate arrInvoices])
    {
        if(remInvoice.projectID == _nInvoice.projectID)
        {
            [[appDelegate arrInvoices] removeObjectIdenticalTo:remInvoice];
            break;
        }
    }
}

//create invoice number based on last invoice number
- (NSString *)createInvoiceNumber
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    int invNumber;
    int tempNumber;
    int i;
    NSString *lastNumber;
    NSString *newNumber;
    
    if ([[appDelegate arrInvoices] count] == 0) {
        return @"1";
    }else{
        
        Invoice *tInvoice = [[Invoice alloc] init];
        tempNumber = 0;
        
        for (i=0;i<[[appDelegate arrInvoices] count];i++){
            
            tInvoice = [[appDelegate arrInvoices] objectAtIndex:i];
            lastNumber = [tInvoice invoiceNumber];
            if ([lastNumber intValue] > tempNumber){
                tempNumber = [lastNumber intValue];
            }
        }
        //set new invoice number to the highest invoice number found, plus one.
        invNumber = tempNumber;
        invNumber++; 
        newNumber = [NSString stringWithFormat:@"%d", invNumber];
        return newNumber;	
    }
}

- (IBAction)exportInvoice:(id)sender
{
    
    //create the new invoice from form fields
    
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    NSString * invoiceNumber = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_nInvoice setInvoiceNumber:[NSNumber numberWithInt:[invoiceNumber intValue]]];
    
    [_nInvoice setProjectID:_selectedProject.projectID];
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
 
    iPath = [NSIndexPath indexPathForRow:1 inSection:0] ;
   // NSString * invoiceDate = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_nInvoice setInvoiceDate:[NSDate date]];//date formatter was failing, but direct cast to nsdate works(see warning)
    
    [_nInvoice setClientID:_selectedProject.clientID];
    
     iPath = [NSIndexPath indexPathForRow:2 inSection:0] ;
    [_nInvoice setClientName:_selectedProject.clientName];
    //[_nInvoice setClientName:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
    
    iPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [_nInvoice setProjectName:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
    
    //dates
    iPath = [NSIndexPath indexPathForRow:4 inSection:0];
   [_nInvoice setStartDate:[df dateFromString:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]]];
    
    //end date
    iPath = [NSIndexPath indexPathForRow:5 inSection:0];
   [_nInvoice setEndDate:[df dateFromString:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]]];
    
    
    //approvale
    iPath = [NSIndexPath indexPathForRow:6 inSection:0] ;
    [_nInvoice setApprovalName:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
    
    //milage
    iPath = [NSIndexPath indexPathForRow:7 inSection:0];
    NSInteger miles = [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text] integerValue];
    [_nInvoice setMilage:[NSNumber numberWithInteger:miles]];
    
    //notes
    iPath = [NSIndexPath indexPathForRow:8 inSection:0];
    [_nInvoice setInvoiceNotes:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
    
    //materials - get from sessions
    iPath = [NSIndexPath indexPathForRow:9 inSection:0];
    [_nInvoice setInvoiceMaterials:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
    
    //materials totals
    iPath = [NSIndexPath indexPathForRow:10 inSection:0];
    NSString * materialsTotal = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_nInvoice setMaterialsTotal: [materialsTotal floatValue]];
    
    //total time
    iPath = [NSIndexPath indexPathForRow:11 inSection:0];
     NSString * totalTime =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [_nInvoice setTotalTime:[NSString stringWithFormat:@"%@",totalTime]];
    
 
    //terms
    iPath = [NSIndexPath indexPathForRow:12 inSection:0];
    [_nInvoice setInvoiceTerms:[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text]];
   
    
    //deposit
     iPath = [NSIndexPath indexPathForRow:13 inSection:0];
     [_nInvoice setInvoiceDeposit:[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text] doubleValue]];
    
    //rate
    iPath = [NSIndexPath indexPathForRow:14 inSection:0];
    [_nInvoice setInvoiceRate:[[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text] doubleValue]];
    
    //calculate total due - invoice class will calculate

    //show exported pdf view
    [self MakePDF:_nInvoice];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return invoiceFormFields.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    static NSString *CellIdentifier = @"InvoiceCell";
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
    
    
    if([[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"] isEqualToString:@"Save and Preview"])
    {
        
        UIButton * submit = [[UIButton alloc] initWithFrame:[cell frame]];
        
        [submit setTitle:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"] forState:UIControlStateNormal];
        [submit setBackgroundColor:[UIColor grayColor]];
        [submit setTag:[indexPath row]];
        [submit addTarget:self action:@selector(newInvoiceSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[submit setTitleColor:[UIColor whiteColor] forState:UIControlEventValueChanged];
        [[cell contentView] addSubview:submit];

    }
    else
    {
        UITextField * cellText = [[UITextField alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 20, 21)];
        [cellText setText:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
        [cellText setBorderStyle:UITextBorderStyleNone];
        [cellText setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
        [cellText setTextColor:[UIColor blackColor]];
        //set placeholder text
        [cellText setPlaceholder:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
        
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    
}

#pragma mark pdf create methods

- (void)OpenPDF {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString * invoicefile;
    
    if(_selectedInvoice)
    {
        invoicefile = [NSString stringWithFormat:@"%@_%@.pdf",[[self selectedInvoice] projectName],[[self selectedInvoice] projectID]];
    }
    else
    {
        invoicefile = [NSString stringWithFormat:@"%@_%@.pdf",[[self selectedProject] projectName],[[self selectedProject] projectID]];
    }
    
    
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:invoicefile];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
        
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:readerViewController animated:YES completion:nil];
            
            //depricated
            //[self presentModalViewController:readerViewController animated:YES];
        }
    }
}

- (void)MakePDF:(Invoice *)newInvoice {
    [self setupPDFDocumentNamed:[NSString stringWithFormat:@"%@_%@",[_nInvoice projectName],[_nInvoice projectID]] Width:850 Height:1100];
    
     AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    
    if([[self MyProfile] count]>0)
    {
        
        [self beginPDFPage];

        //Header
        //Logo image
//                UIImage *anImage = [UIImage imageNamed:@"bill-32.png"];
//                CGRect imageRect = [self addImage:anImage
//                                          atPoint:CGPointMake(kPadding, kPadding)];
        
        CGRect nameRect = [self addText:[[[self MyProfile] objectAtIndex:0] profileName]
                             withFrame:CGRectMake(kHeaderPadding, kPadding, 400,4) fontSize:48.0f];
        CGRect inoviceRect = [self addText: [NSString stringWithFormat:@"Invoice #%@",_nInvoice.invoiceNumber]
                                 withFrame:CGRectMake(_pageSize.width/2, kPadding, _pageSize.width/2,4) fontSize:40.0f];
        
        CGRect addressRect = [self addText:[[[self MyProfile] objectAtIndex:0] profileAddress]
                                 withFrame:CGRectMake(kHeaderPadding, nameRect.origin.y + nameRect.size.height + kPadding, _pageSize.width - kHeaderPadding*2, 4) fontSize:40.0f];
        
        NSUInteger cityLen =  [[[[self MyProfile] objectAtIndex:0] profileCity] length];
        CGRect cityRect = [self addText:[NSString stringWithFormat:@"%@, ",[[[self MyProfile] objectAtIndex:0] profileCity]]
                               withFrame:CGRectMake(kHeaderPadding, addressRect.origin.y + addressRect.size.height + kPadding, cityLen * 4, 4) fontSize:40.0f];
        
        CGRect stateRect = [self addText:[NSString stringWithFormat:@"%@%@",[[[self MyProfile] objectAtIndex:0] profileState], @" "]
                             withFrame:CGRectMake(cityRect.origin.x + cityRect.size.width + kPadding, addressRect.origin.y + addressRect.size.height + kPadding,20, 4) fontSize:40.0f];
        
        CGRect zipRect = [self addText:[[[self MyProfile] objectAtIndex:0] profileZip]
                             withFrame:CGRectMake(stateRect.origin.x + stateRect.size.width + kPadding, addressRect.origin.y + addressRect.size.height + kPadding, _pageSize.width/3, 4) fontSize:40.0f];
        
        CGRect blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, zipRect.origin.y + zipRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) withColor:[UIColor blackColor]];
        
        

        CGRect clientHeader = [self addText:@"Client Info" withFrame:CGRectMake(kPadding, blueLineRect.origin.y + blueLineRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        
        
        CGRect lineRect =[self addLineWithFrame:CGRectMake(kPadding, clientHeader.origin.y + clientHeader.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                     withColor:[UIColor blackColor]];
        
        //project/client info
        NSString * clientName = [NSString stringWithFormat:@"Client: %@",[_nInvoice clientName]];
        CGRect clientRect = [self addText:clientName
                                withFrame:CGRectMake(kPadding, lineRect.origin.y + lineRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        
        NSString * projectName = [NSString stringWithFormat:@"Project: %@",[_nInvoice projectName]];
        CGRect projectRect = [self addText:projectName
                                withFrame:CGRectMake(kPadding, clientRect.origin.y + clientRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        NSString * clientAddress = [NSString stringWithFormat:@"Address: %@",[_nInvoice clientName]];
        CGRect clientAddressRect = [self addText:clientAddress
                              withFrame:CGRectMake(kPadding, projectRect.origin.y + projectRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
    
        
        
        //Dates
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        
        NSString * startDate = [NSString stringWithFormat:@"Start Date: %@",[df stringFromDate:[_nInvoice startDate]]];
        CGRect startRect = [self addText:startDate
                                withFrame:CGRectMake(kPadding, clientAddressRect.origin.y + clientAddressRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        NSString * endDate = [NSString stringWithFormat:@"End Date: %@",[df stringFromDate:[_nInvoice endDate]]];
        CGRect endRect = [self addText:endDate
                               withFrame:CGRectMake(kPadding, startRect.origin.y + startRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        
        //get total hours, notes, materials, etc from sessions
        NSString * totalHours = [NSString stringWithFormat:@"Total Hours: %@",_nInvoice.totalTime];
        CGRect hoursRect = [self addText:totalHours
                             withFrame:CGRectMake(kPadding, endRect.origin.y + endRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        
        [self finishPDF];
    }
    else
    {
        [self showMessage:@"You must complete your personal profile before creating an invoice." withTitle:@"Missing Profile"];
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

- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    _pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
    
    [self OpenPDF];
}

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(_pageSize.width - 2*20-2*20, _pageSize.height - 2*20 - 2*20) lineBreakMode:UILineBreakModeWordWrap];
    
    float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect
            withFont:font
       lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
}

- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [image drawInRect:imageFrame];
    
    return imageFrame;
}

#pragma mark methods
- (NSMutableArray *) MyProfile
{
    //TODO: May need to test if file exists to avoid error
    NSDictionary * rootObject;
    rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile]];
    
     NSMutableArray * oProfile = [[NSMutableArray alloc] initWithArray: [rootObject valueForKey:@"profile"]];
    
    return oProfile;
    
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

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
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
