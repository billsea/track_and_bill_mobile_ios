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
#import "TextInputTableViewCell.h"
#import "Client.h"
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
@synthesize userData = _userData;

NSArray * invoiceFormFields;
NSNumber * invoiceNumberSelected;

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
    
    
    //saves form fields input
    
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
        //remove exisitng invoice - a new one will be created
        [self removeExistingInvoice: _selectedInvoice.projectID];
        
        invoiceNumberSelected = [_selectedInvoice invoiceNumber];
        
            invoiceFormFields = @[
                 @{@"FieldName": @"Invoice Number", @"FieldValue":[NSString stringWithFormat:@"%@",[_selectedInvoice invoiceNumber]]},
                 @{@"FieldName": @"Invoice Date",@"FieldValue": [df stringFromDate: _selectedInvoice.invoiceDate]},
                 @{@"FieldName": @"Client Name",@"FieldValue": [_selectedInvoice clientName]},
                 @{@"FieldName": @"Project Name",@"FieldValue":[_selectedInvoice projectName]},
                 @{@"FieldName": @"Start Date",@"FieldValue": [df stringFromDate:[_selectedInvoice startDate]]},
                 @{@"FieldName": @"End Date",@"FieldValue":[df stringFromDate:[_selectedInvoice endDate]] },
                 @{@"FieldName": @"Approval Name",@"FieldValue":[_selectedInvoice approvalName] },
                 @{@"FieldName": @"Mileage",@"FieldValue": [NSString stringWithFormat:@"%@",[_selectedInvoice milage]]},
                 @{@"FieldName": @"Notes",@"FieldValue": [_selectedInvoice invoiceNotes] },
                 @{@"FieldName": @"Materials",@"FieldValue":[_selectedInvoice invoiceMaterials] },
                 @{@"FieldName": @"Materials Total",@"FieldValue":[NSString stringWithFormat:@"%f",[_selectedInvoice materialsTotal]]},
                 @{@"FieldName": @"Total Hours",@"FieldValue": [_selectedInvoice totalTime]},
                 @{@"FieldName": @"Terms",@"FieldValue":[_selectedInvoice invoiceTerms]},
                 @{@"FieldName": @"Deposit",@"FieldValue":[NSString stringWithFormat:@"%f",[_selectedInvoice invoiceDeposit]]},
                 @{@"FieldName": @"Rate",@"FieldValue":[NSString stringWithFormat:@"%f",[_selectedInvoice invoiceRate]]},
                 @{@"FieldName": @"Paid Check #",@"FieldValue": [_selectedInvoice checkNumber]},
                 
                 ];
    }
    else if(self.selectedProject)
    {
        //remove exisitng invoice - a new one will be created
        [self removeExistingInvoice: _selectedProject.projectID];
        
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
        
        //create new invoice number
        invoiceNumberSelected = [self createInvoiceNumber];
        
         invoiceFormFields = @[
                 @{@"FieldName": @"Invoice Number", @"FieldValue": [NSString stringWithFormat:@"%@",invoiceNumberSelected]},
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
                 @{@"FieldName": @"Rate",@"FieldValue": @""},
                 @{@"FieldName": @"Paid Check #",@"FieldValue": @""}
                 
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

-(NSMutableArray *)userData
{
    if(!_userData){
        _userData = [[NSMutableArray alloc] initWithCapacity:[invoiceFormFields count]];
        for (int i = 0; i < [invoiceFormFields count]; i++)
            [_userData addObject:@""];
    }
    return _userData;
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
    [self saveInvoice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeExistingInvoice:(NSNumber *)projectId
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableArray * invoicesToRemove = [[NSMutableArray alloc] init];
    
    //Remove existing invoice for this project
    for(Invoice * remInvoice in [appDelegate arrInvoices])
    {
        if(remInvoice.projectID == projectId)
        {
            [invoicesToRemove addObject:remInvoice];
        }
    }
    
    for(Invoice * t in invoicesToRemove)
    {
        [[appDelegate arrInvoices] removeObjectIdenticalTo:t];
    }
}

//create invoice number based on last invoice number
- (NSNumber *)createInvoiceNumber
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    int invNumber;
    int tempNumber;
    int i;
    NSNumber *lastNumber;
    
    if ([[appDelegate arrInvoices] count] == 0) {
        return [NSNumber numberWithInt:1];
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
        return [NSNumber numberWithInt:invNumber];
    }
}

- (Invoice *)createInvoice
{
    //create the new invoice from form fields
    Invoice * cInvoice = [[Invoice alloc] init];
    
    
    //new invoice or update existing?
    if(_selectedProject)
    {
        [cInvoice setProjectID:_selectedProject.projectID];
        [cInvoice setClientID:_selectedProject.clientID];
    }
    else
    {

        [cInvoice setProjectID:_selectedInvoice.projectID];
        [cInvoice setClientID:_selectedInvoice.clientID];
    }
    
    
//    //allow to update the invoice number
//    NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
//    NSString * invoiceNumber = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
//    if(!invoiceNumber)
//    {
//        invoiceNumber = [[invoiceFormFields objectAtIndex:0] objectForKey:@"FieldValue"];
//    }
//    [cInvoice setInvoiceNumber:[NSNumber numberWithInt:[invoiceNumber intValue]]];

    //invoice number is read only
    [cInvoice setInvoiceNumber:invoiceNumberSelected];

    //invoice date - today
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:1 inSection:0] ;
    // NSString * invoiceDate = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    [cInvoice setInvoiceDate:[NSDate date]];//date formatter was failing, but direct cast to nsdate works(see warning)
    
    iPath = [NSIndexPath indexPathForRow:2 inSection:0] ;
    //[cInvoice setClientName:_selectedProject.clientName];
    NSString * clientName = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!clientName)
    {
        clientName = [[invoiceFormFields objectAtIndex:2] objectForKey:@"FieldValue"];
    }
    [cInvoice setClientName:clientName];
    
    
    //project name
    iPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSString * projectName = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!projectName)
    {
        projectName = [[invoiceFormFields objectAtIndex:3] objectForKey:@"FieldValue"];
    }
    [cInvoice setProjectName:projectName];
    
    //dates
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    iPath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSString * stDate =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!stDate)
    {
        stDate = [[invoiceFormFields objectAtIndex:4] objectForKey:@"FieldValue"];
    }
    [cInvoice setStartDate:[df dateFromString:stDate]];
    
    //end date
    iPath = [NSIndexPath indexPathForRow:5 inSection:0];
    NSString * endDate = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!endDate)
    {
        endDate = [[invoiceFormFields objectAtIndex:5] objectForKey:@"FieldValue"];
    }
    [cInvoice setEndDate:[df dateFromString:endDate]];
    
    
    //approvale
    iPath = [NSIndexPath indexPathForRow:6 inSection:0];
    NSString * approvalName =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!approvalName)
    {
        approvalName = [[invoiceFormFields objectAtIndex:6] objectForKey:@"FieldValue"];
    }
    [cInvoice setApprovalName:approvalName];
    
    //milage
    iPath = [NSIndexPath indexPathForRow:7 inSection:0];
    NSInteger miles = [[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text] integerValue];
    if(!miles)
    {
        miles = [[[invoiceFormFields objectAtIndex:7] objectForKey:@"FieldValue"] integerValue];
    }
    [cInvoice setMilage:[NSNumber numberWithInteger:miles]];
    
    
    //notes
    iPath = [NSIndexPath indexPathForRow:8 inSection:0];
    NSString * invNotes = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!invNotes)
    {
        invNotes = [[invoiceFormFields objectAtIndex:8] objectForKey:@"FieldValue"];
    }
    [cInvoice setInvoiceNotes:invNotes];
    
    //materials - get from sessions
    iPath = [NSIndexPath indexPathForRow:9 inSection:0];
    NSString * invMaterials = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!invMaterials)
    {
        invMaterials = [[invoiceFormFields objectAtIndex:9] objectForKey:@"FieldValue"];
    }
    [cInvoice setInvoiceMaterials:invMaterials];
    
    //materials totals
    iPath = [NSIndexPath indexPathForRow:10 inSection:0];
    NSString * materialsTotal = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!materialsTotal)
    {
        materialsTotal = [[invoiceFormFields objectAtIndex:10] objectForKey:@"FieldValue"];
    }
    [cInvoice setMaterialsTotal: [materialsTotal floatValue]];
    
    
    //total time
    iPath = [NSIndexPath indexPathForRow:11 inSection:0];
    NSString * totalTime =[[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!totalTime)
    {
        totalTime = [[invoiceFormFields objectAtIndex:11] objectForKey:@"FieldValue"];
    }
    [cInvoice setTotalTime:totalTime];
    
    
    //terms
    iPath = [NSIndexPath indexPathForRow:12 inSection:0];
    NSString * invTerms = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!invTerms)
    {
        invTerms = [[invoiceFormFields objectAtIndex:12] objectForKey:@"FieldValue"];
    }
    [cInvoice setInvoiceTerms:invTerms];
    
    
    //deposit
    iPath = [NSIndexPath indexPathForRow:13 inSection:0];
    NSString * invDeposit = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!invDeposit)
    {
        invDeposit = [[invoiceFormFields objectAtIndex:13] objectForKey:@"FieldValue"];
    }
    [cInvoice setInvoiceDeposit:[invDeposit doubleValue]];
    
    //rate
    iPath = [NSIndexPath indexPathForRow:14 inSection:0];
    NSString * invRate = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!invRate)
    {
        invRate = [[invoiceFormFields objectAtIndex:14] objectForKey:@"FieldValue"];
    }
    [cInvoice setInvoiceRate:[invRate doubleValue]];
    
    iPath = [NSIndexPath indexPathForRow:15 inSection:0];
    NSString * invCheck = [[[[[[self tableView] cellForRowAtIndexPath:iPath] contentView] subviews] objectAtIndex:0] text];
    if(!invCheck)
    {
        invCheck = [[invoiceFormFields objectAtIndex:15] objectForKey:@"FieldValue"];
    }
    [cInvoice setCheckNumber:invCheck];
    
    return  cInvoice;
}

- (IBAction)exportInvoice:(id)sender
{
    //show exported pdf view
    [self MakePDF:[self createInvoice]];
}

-(void)saveInvoice
{
    //save invoice to invoice stack
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //add new invoice object to clients list
    [[appDelegate arrInvoices] addObject:[self createInvoice]];
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

   // static NSString *CellIdentifier = @"InvoiceCell";
    static NSString *simpleTableIdentifier = @"TextInputTableViewCell";
    
    TextInputTableViewCell *cell = (TextInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextInputTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    // [cell setBackgroundColor:[UIColor clearColor]];
//    cell.accessoryView =nil;
//    
//    UITextField * cellText = [[UITextField alloc] initWithFrame:CGRectMake(10,11, cell.frame.size.width - 20, 21)];
//    [cellText setText:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
//    [cellText setBorderStyle:UITextBorderStyleNone];
//    [cellText setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
//    [cellText setTextColor:[UIColor blackColor]];
//    //set placeholder text
//    [cellText setPlaceholder:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
//    
    
    [[cell textInput] setPlaceholder:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldName"]];
    [[cell textInput] setText:[[invoiceFormFields objectAtIndex:[indexPath row]] valueForKey:@"FieldValue"]];
    [[cell textInput] setTag:[indexPath row]];
    [cell setTag:[indexPath row]];
    [cell setFieldName:[invoiceFormFields objectAtIndex:[indexPath row]]];
    [[cell textInput] setBorderStyle:UITextBorderStyleNone];
    [[cell textInput] setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
    [[cell textInput] setTextColor:[UIColor blackColor]];
    cell.textInput.delegate = self;
 
    //check if user entered text into field, and load it. this fixes problem with scrolling, and text field input disappearing
    if(![[self.userData objectAtIndex:indexPath.row] isEqualToString:@""]){
        NSLog(@"%@ at indexPath.row %ld",[invoiceFormFields objectAtIndex:indexPath.row], (long)indexPath.row);
        cell.textInput.placeholder = nil;
        cell.textInput.text = [self.userData objectAtIndex:indexPath.row];
    }

    
    
    // [[cell contentView] addSubview:cellText];
    

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
    
    //remove spaces
    NSString * fileString = [[[self selectedInvoice] projectName] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    if(_selectedInvoice)
    {
        invoicefile = [NSString stringWithFormat:@"%@_%@.pdf",fileString,[[self selectedInvoice] projectID]];
    }
    else
    {
        invoicefile = [NSString stringWithFormat:@"%@_%@.pdf",fileString,[[self selectedProject] projectID]];
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
    
     AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //remove spaces
    NSString * fileString = [[[self selectedInvoice] projectName] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    [self setupPDFDocumentNamed:[NSString stringWithFormat:@"%@_%@",fileString,[newInvoice projectID]] Width:850 Height:1100];
    
    //get client info
    Client * selClient;
    
    for(Client * c in [appDelegate arrClients])
    {
        if(c.clientID == newInvoice.clientID)
        {
            selClient = c;
            break;
        }
    }
    
    
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
        CGRect inoviceRect = [self addText: [NSString stringWithFormat:@"Invoice #%@",newInvoice.invoiceNumber]
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
        
        
//
//        CGRect clientHeader = [self addText:@"Client Info" withFrame:CGRectMake(kPadding, blueLineRect.origin.y + blueLineRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        
        
        CGRect lineRect =[self addLineWithFrame:CGRectMake(kPadding, blueLineRect.origin.y + blueLineRect.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                     withColor:[UIColor blackColor]];
        
        //project/client info
        NSString * clientName = [NSString stringWithFormat:@"Client: %@",[newInvoice clientName]];
        CGRect clientRect = [self addText:clientName
                                withFrame:CGRectMake(kPadding, lineRect.origin.y + lineRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        NSString * clientAddress = [NSString stringWithFormat:@"Address: %@",[selClient streetAddress]];
        CGRect clientAddressRect = [self addText:clientAddress
                                       withFrame:CGRectMake(kPadding, clientRect.origin.y + clientRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        NSString * clientCity = [NSString stringWithFormat:@"City: %@,%@ %@",[selClient city],[selClient state], [selClient postalCode]];
        CGRect clientCityRect = [self addText:clientCity
                                       withFrame:CGRectMake(kPadding, clientAddressRect.origin.y + clientAddressRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
//        NSString * projectName = [NSString stringWithFormat:@"Project: %@",[newInvoice projectName]];
//        CGRect projectRect = [self addText:projectName
//                                withFrame:CGRectMake(kPadding, clientRect.origin.y + clientRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
       
    
        
        
//        //Dates
//        NSDateFormatter * df = [[NSDateFormatter alloc] init];
//        [df setDateFormat:@"MM/dd/yyyy"];
//        
//        NSString * startDate = [NSString stringWithFormat:@"Start Date: %@",[df stringFromDate:[newInvoice startDate]]];
//        CGRect startRect = [self addText:startDate
//                                withFrame:CGRectMake(kPadding, clientAddressRect.origin.y + clientAddressRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
//        
//        NSString * endDate = [NSString stringWithFormat:@"End Date: %@",[df stringFromDate:[newInvoice endDate]]];
//        CGRect endRect = [self addText:endDate
//                               withFrame:CGRectMake(kPadding, startRect.origin.y + startRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
//        
//        
//        //get total hours, notes, materials, etc from sessions
//        NSString * totalHours = [NSString stringWithFormat:@"Total Hours: %@",newInvoice.totalTime];
//        CGRect hoursRect = [self addText:totalHours
//                             withFrame:CGRectMake(kPadding, endRect.origin.y + endRect.size.height + kPadding, _pageSize.width - kPadding*2, 4) fontSize:48.0f];
        
        
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
