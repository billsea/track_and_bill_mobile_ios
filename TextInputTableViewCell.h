//
//  TextInputTableViewCell.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/16/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (strong,nonatomic) NSString * fieldName;
@property (weak, nonatomic) IBOutlet UILabel *labelCell;
@end
