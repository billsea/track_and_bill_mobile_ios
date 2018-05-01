//
//  TextInputTableViewCell.m
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/16/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import "TextInputTableViewCell.h"
#import "AppDelegate.h"

@implementation TextInputTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
  self.textInput.delegate = self;
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.textInput) {
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	self.fieldUpdateCallback(textField.text,_fieldName);
}

@end
