//
//  MaterialsViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "MaterialsViewController.h"

@interface MaterialsViewController ()


@end

@implementation MaterialsViewController

UITextView * textView;
@synthesize selectedSession = _selectedSession;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set the title of the navigation item
    [[self navigationItem] setTitle:@"Materials"];
    
    //set textview
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10,10, screenRect.size.width - 10, screenRect.size.height - 50)];
    //[notesTextView setBackgroundColor:[UIColor lightGrayColor]];
    
    [[self view] addSubview:textView];
    
    
    //view has been touched, for dismiss keyboard
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //save notes
    [_selectedSession setMaterials:[textView text]];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [[self view] endEditing:YES];
}

- (void)textWillChange:(id<UITextInput>)textInput
{
    
}

-(void)textDidChange:(id<UITextInput>)textInput
{
    
}
-(void)selectionWillChange:(id<UITextInput>)textInput
{
    
}
-(void)selectionDidChange:(id<UITextInput>)textInput
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
