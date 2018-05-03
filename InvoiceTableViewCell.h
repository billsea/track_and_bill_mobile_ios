//
//  InvoiceTableViewCell.h
//  trackandbill_ios
//
//  Created by Loud on 5/2/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *invoiceNumber;
@property (weak, nonatomic) IBOutlet UILabel *invoiceDate;
@property (weak, nonatomic) IBOutlet UILabel *invoiceProject;
@property (weak, nonatomic) IBOutlet UILabel *invoiceClient;

@end
