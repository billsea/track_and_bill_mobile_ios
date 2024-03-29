//
//  Invoice.h
//  TrackAndBill_OSX
//
//  Created by Bill on 11/18/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface Invoice : NSObject <NSCoding> {
  NSNumber *invoiceNumber;
  NSString *projectName;
  NSString *clientName;
  NSDate *startDate;
  NSDate *endDate;
  NSDate *invoiceDate;
  NSString *totalTime;
  NSNumber *projectID;
  NSNumber *clientID;
  NSString *checkNumber;
  NSString *approvalName;
  NSString *invoiceTerms;
  NSString *invoiceNotes;
  NSString *invoiceMaterials;
  float materialsTotal;
  NSString *SmaterialsTotal; // materials total as string value
  float invoiceDeposit;
  NSString *SinvoiceDeposit;
  float totalDue;
  NSString *StotalDue;
  double invoiceRate;
  NSString *SinvoiceRate;
  double grandTotal;
  NSString *SgrandTotal;
  NSNumber *milage;
  NSNumber *milageRate;
}

- (NSNumber *)invoiceNumber;
- (NSString *)projectName;
- (NSString *)clientName;
- (NSDate *)startDate;
- (NSDate *)endDate;
- (NSDate *)invoiceDate;
- (NSString *)totalTime;
- (NSNumber *)projectID;
- (NSNumber *)clientID;
- (NSString *)checkNumber;
- (NSString *)approvalName;
- (NSString *)invoiceTerms;
- (NSString *)invoiceNotes;
- (NSString *)invoiceMaterials;
- (float)materialsTotal;
- (NSString *)SmaterialsTotal; // materials total as string value
- (float)invoiceDeposit;
- (NSString *)SinvoiceDeposit;
- (float)totalDue;
- (NSString *)StotalDue;
- (double)invoiceRate;
- (NSString *)SinvoiceRate;
- (double)grandTotal;
- (NSString *)SgrandTotal;
- (NSNumber *)milage;
- (NSNumber *)milageRate;

- (void)setProjectName:(NSString *)projName;
- (void)setClientName:(NSString *)cName;
- (void)setStartDate:(NSDate *)sDate;
- (void)setEndDate:(NSDate *)eDate;
- (void)setInvoiceDate:(NSDate *)iDate;
- (void)setTotalTime:(NSString *)tTime;
- (void)setProjectID:(NSNumber *)pID;
- (void)setClientID:(NSNumber *)cID;

- (void)setInvoiceNumber:(NSNumber *)iNumber;
- (void)setTotalDue:(float)totDue;
- (void)setStotalDue:(NSString *)Sdue;
- (void)setInvoiceRate:(double)sRate;
- (void)setSinvoiceRate:(NSString *)Srate;
- (void)setCheckNumber:(NSString *)checkNum;

- (void)setApprovalName:(NSString *)appName;
- (void)setInvoiceTerms:(NSString *)iTerms;
- (void)setInvoiceNotes:(NSString *)iNotes;
- (void)setInvoiceMaterials:(NSString *)iMaterials;
- (void)setMaterialsTotal:(double)mTotal;
- (void)setSmaterialsTotal:(NSString *)SmatTotal;
- (void)setMilage:(NSNumber *)miles;
- (void)setMilageRate:(NSNumber *)miRate;

//- (void)setInvoiceScale:(NSString *)iScale;
- (void)setInvoiceDeposit:(double)iDeposit;
- (void)setSinvoiceDeposit:(NSString *)Sdep;
- (void)computeTotalDue;
- (int)getDateFormatSetting;
- (void)setGrandTotal;
- (void)setSgrandTotal:(NSString *)grdTotal;
@end
