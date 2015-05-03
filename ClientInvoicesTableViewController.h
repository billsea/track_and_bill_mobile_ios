//
//  ClientInvoicesTableViewController.h
//  trackandbill_ios
//
//  Created by William Seaman on 5/3/15.
//  Copyright (c) 2015 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"

@interface ClientInvoicesTableViewController : UITableViewController

@property (nonatomic) Client * selClient;
@property (nonatomic) NSMutableArray * invoicesForClient;
@end
