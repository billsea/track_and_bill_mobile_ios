//
//  CreditsViewController.h
//  trackandbill_ios
//
//  Created by Loud on 5/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditsViewController : UIViewController<UIWebViewDelegate>
	@property (weak, nonatomic) IBOutlet UIWebView *creditsWebView;
	@property(nonatomic) UIActivityIndicatorView* activityView;
@end
