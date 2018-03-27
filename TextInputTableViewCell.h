//
//  TextInputTableViewCell.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/16/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputTableViewCell : UITableViewCell <UITextFieldDelegate>
@property(nonatomic) void (^fieldUpdateCallback)(NSString*, NSString*);
@property(weak, nonatomic) IBOutlet UITextField *textInput;
@property(strong, nonatomic) NSString *fieldName;
@property(weak, nonatomic) IBOutlet UILabel *labelCell;
@end
