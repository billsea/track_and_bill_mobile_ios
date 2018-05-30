//
//  HelpViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/22/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController (){
	bool _didLoad;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:NavBarImage]]];
	
	_helpWebView.delegate = self;
	_didLoad = false;
	NSURLRequest* req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_helpUrlString]];
	[_helpWebView loadRequest:req];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//show spinner
	if(!_didLoad){
		_activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.center = CGPointMake(_helpWebView.frame.size.width/ 2.0, _helpWebView.frame.size.height/ 2.0);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
