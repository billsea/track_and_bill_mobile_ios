//
//  SessionNotesViewController.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/11/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "SessionNotesViewController.h"

@interface SessionNotesViewController ()
@property(nonatomic) UITextView *notesTextView;
@end

@implementation SessionNotesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.

  // Set the title of the navigation item
  [[self navigationItem] setTitle:@"Session Notes"];

  // set background image
  [[self view]
      setBackgroundColor:[UIColor
                             colorWithPatternImage:
                                 [UIImage imageNamed:@"paper_texture_02.png"]]];

  // set textview
  CGRect screenRect = [[UIScreen mainScreen] bounds];

  _notesTextView = [[UITextView alloc]
      initWithFrame:CGRectMake(10, 10, screenRect.size.width - 10,
                               screenRect.size.height - 50)];

  [_notesTextView setFont:[UIFont fontWithName:@"Avenir Next Medium" size:21]];
  [_notesTextView setTextColor:[UIColor blackColor]];
  [_notesTextView setBackgroundColor:[UIColor clearColor]];
  [[self view] addSubview:_notesTextView];

  // view has been touched, for dismiss keyboard
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handleSingleTap:)];
  [self.view addGestureRecognizer:singleFingerTap];
}
- (void)viewWillAppear:(BOOL)animated {
  [_notesTextView setText:_selectedSession.txtNotes];
}
- (void)viewWillDisappear:(BOOL)animated {
  // save notes
  [_selectedSession setTxtNotes:[_notesTextView text]];
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
