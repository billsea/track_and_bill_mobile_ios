//
//  HelpViewController.h
//  trackandbill_ios
//
//  Created by Loud on 5/22/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionInfoViewController.h"

@interface HelpViewController : SessionInfoViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *helpWebView;
@property(nonatomic) NSString* helpUrlString;
@property(nonatomic) UIActivityIndicatorView* activityView;
@end
