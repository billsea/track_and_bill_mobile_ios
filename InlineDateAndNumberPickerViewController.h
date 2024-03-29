//
//  InlineDateAndNumberPickerViewController.h
//  trackandbill_ios
//
//  Created by William Seaman on 5/25/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

/*
 This view controller is based on the ALEInlineDatePickerViewController code which simplifies the presentation of a date picker inline in a tableview. This class includes a number picker as well as the date picker
 
 DATE PICKER RULES:
 The dates inserted by the user can be accessed with the corresponding date picker's indexPath.
 Must sublclass to use.
 
 Subclasses MUST do at least 2 things:
 - provide an array of indexPaths from which the date picker can be displayed (datePickerPossibleIndexPaths)
 - call super in the tableview delegate & datasource before their implementation as detailed below
 
 Notes: you can use a nib if you want and connect the tableView outlet, otherwise you can use initWithSyle:
 */

@interface InlineDatePickerCell : UITableViewCell
@property (strong, nonatomic) UIDatePicker *datePicker;
@end

@interface InlineNumberPickerCell : UITableViewCell
@property (strong, nonatomic) UIPickerView *numberPicker;
@property NSMutableArray * pickerData;
@end

@interface InlineDateAndNumberPickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readonly) NSIndexPath *datePickerIndexPath;
@property (nonatomic, strong) NSArray *datePickerPossibleIndexPaths;

@property (nonatomic, strong, readonly) NSIndexPath *numberPickerIndexPath;
@property (nonatomic, strong) NSArray *numberPickerPossibleIndexPaths;

@property NSMutableArray * pickerData;


- (id)initWithStyle:(UITableViewStyle)style;

- (BOOL)datePickerIsShown;
- (void)hideExistingPicker;

- (BOOL)numberPickerIsShown;
- (void)hideExistingNumberPicker;

//  you can override this method, call super and then customize the date picker associated with the cell
- (InlineDatePickerCell *)createPickerCell:(NSDate *)date;

- (InlineNumberPickerCell *)createNumberPickerCell:(NSNumber *)dollars;

//  call super if you override this
- (IBAction)dateChanged:(UIDatePicker *)sender;

- (IBAction)numberPickerChanged:(UIPickerView *)sender;

//  you can use this methods to get and set the date object associated with an indexPath
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (void)setDate:(NSDate *)date forIndexPath:(NSIndexPath *)indexPath;

- (NSNumber *)numberForIndexPath:(NSIndexPath *)indexPath;
- (void)setNumber:(NSNumber *)number forIndexPath:(NSIndexPath *)indexPath;



//  utils
//  recalculates the correct index path for accessing the datasource depending on the date picker presence in the tableview. Call this method before accessing your datasource
- (NSIndexPath *)adjustedIndexPathForDatasourceAccess:(NSIndexPath *)indexPath;

- (NSIndexPath *)adjustedNumberIndexPathForDatasourceAccess:(NSIndexPath *)indexPath;

//-------------------------------------------------------------------
//  tableview delegate & datasource
//  subclasses must call super at the beginning of these methods

//  subclasses should add the number returned by this method to their own values
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

//  this method returns the date picker cell for the right indexpath. If it returns nil, procede with your implementation of the method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

//  this method returns the correct height for the date picker cell. If it returns 0, you should procede to implement your own logic
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

//  subclasses should call this method on super, before proceding with their own implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end
