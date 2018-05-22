//
//  HelpViewController.m
//  trackandbill_ios
//
//  Created by Loud on 5/22/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	NSURLRequest* req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://loudsoftware.com/?page_id=506"]];
	[_helpWebView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
