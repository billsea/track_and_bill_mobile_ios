//
//  SessionsTableViewCell.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 2/15/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionsTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *sessionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionTimeLabel;

@end
