//
//  InvoiceTableViewController.h
//  TrackandBill_iOSversion
//
//  Created by William Seaman on 3/17/15.
//  Copyright (c) 2015 Loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project+CoreDataClass.h"
#import "ReaderViewController.h"
#import "Invoice+CoreDataClass.h"

@interface InvoiceTableViewController : UITableViewController <ReaderViewControllerDelegate,UITextFieldDelegate>
@property(nonatomic) id projectObjectId;
@property(nonatomic) Project *selectedProject;
@property(nonatomic) NSMutableArray *userData;
@property(nonatomic) BOOL isArchive;

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (void)dismissReaderViewController:(ReaderViewController *)viewController;
- (void)MakePDF:(Invoice *)newInvoice;
@end
