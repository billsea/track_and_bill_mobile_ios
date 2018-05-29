//
//  CreditsViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/27/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController (){
	bool _didLoad;
}

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
	_creditsWebView.delegate = self;
	_didLoad = false;
	NSURLRequest* req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://loudsoftware.com/trackandbill_ios/credits.html"]];
	[_creditsWebView loadRequest:req];
}

	- (void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
		
		//show spinner
		if(!_didLoad){
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
	_didLoad = true;
	[_activityView removeFromSuperview];
}


@end
