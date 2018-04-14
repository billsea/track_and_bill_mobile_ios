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
#import "InlineDateAndNumberPickerViewController.h"

@interface InvoiceTableViewController
    : InlineDateAndNumberPickerViewController <ReaderViewControllerDelegate,UITextFieldDelegate> {
}

@property(nonatomic) id projectObjectId;
@property(nonatomic, retain) Invoice *selectedInvoice;
@property(strong, nonatomic) NSMutableArray *userData;

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
- (void)dismissReaderViewController:(ReaderViewController *)viewController;
- (void)MakePDF:(Invoice *)newInvoice;
@end
