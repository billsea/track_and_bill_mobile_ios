//
//  Model.h
//  trackandbill_ios
//
//  Created by Loud on 3/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Invoice.h"
#import "Project.h"

@interface Model : NSObject
+ (NSMutableArray*)loadInvoicesWithSelected:(Invoice*)selectedInvoice andProject:(Project*)selectedProject andEdit:(BOOL)isEdit;
@end
