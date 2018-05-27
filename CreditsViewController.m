//
//  CreditsViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_creditsWebView.delegate = self;
	NSURLRequest* req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://loudsoftware.com/trackandbill_ios/credits.html"]];
	[_creditsWebView loadRequest:req];
}

	- (void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		
		//show spinner
		if(_creditsWebView.loading){
			_activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			_activityView.center = CGPointMake(_creditsWebView.frame.size.width/ 2.0, _creditsWebView.frame.size.height/ 2.0);
			[_activityView startAnimating];
			[self.view addSubview:_activityView];
		}
	}
	
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
	
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[_activityView removeFromSuperview];
}


@end
