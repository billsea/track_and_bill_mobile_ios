//
//  InvoiceTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "ReaderViewController.h"
#import "Invoice.h"

@interface InvoiceTableViewController : UITableViewController<UITextFieldDelegate, ReaderViewControllerDelegate>

@property (nonatomic, retain) Project * selectedProject;
@property Invoice * nInvoice;

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (IBAction)newInvoiceSubmit:(id)sender;
- (void)dismissReaderViewController:(ReaderViewController *)viewController;
- (void)MakePDF:(Invoice *)newInvoice;
@end
