//
//  MaterialsViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "MaterialsViewController.h"

@interface MaterialsViewController ()
@property(nonatomic) UITextView *textView;
@end

@implementation MaterialsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  // Set the title of the navigation item
  [[self navigationItem] setTitle:NSLocalizedString(@"materials", nil)];

  // set textview
  CGRect screenRect = [[UIScreen mainScreen] bounds];

  _textView = [[UITextView alloc]
      initWithFrame:CGRectMake(10, 10, screenRect.size.width - 10,
                               screenRect.size.height - 50)];
  [_textView setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
  [_textView setTextColor:[UIColor blackColor]];
  [_textView setBackgroundColor:[UIColor clearColor]];

  [[self view] addSubview:_textView];

  // view has been touched, for dismiss keyboard
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handleSingleTap:)];
  [self.view addGestureRecognizer:singleFingerTap];
	
	[_textView becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
  [_textView setText:self.selectedSession.materials];
}

- (void)viewWillDisappear:(BOOL)animated {
  // save notes
  [self.selectedSession setMaterials:[_textView text]];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  // CGPoint location = [recognizer locationInView:[recognizer.view superview]];

  [[self view] endEditing:YES];
}

- (void)textWillChange:(id<UITextInput>)textInput {
}

- (void)textDidChange:(id<UITextInput>)textInput {
}

- (void)selectionWillChange:(id<UITextInput>)textInput {
}

- (void)selectionDidChange:(id<UITextInput>)textInput {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
