//
//  WebLinkController.m
//  Rapnet
//
//  Created by NEHA SINGH on 03/08/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import "WebLinkController.h"


@implementation WebLinkController
@synthesize objWebView,indicatorView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


- (void)viewDidLoad 
{
	objWebView.scalesPageToFit=YES;
	indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 20, 20)];
	indicatorView.center = self.view.center;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicatorView ];
	
	NSString *urlAddress=[StoredData sharedData].strWebURL;
	NSURL *url=[NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj=[NSURLRequest requestWithURL:url];
	[objWebView loadRequest:requestObj];
	
    [super viewDidLoad];
}

-(IBAction)backBtn
{
	[[self navigationController] popViewControllerAnimated:YES];
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[objWebView release];
	[indicatorView release];
	
    [super dealloc];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{ 
	
    [indicatorView startAnimating];
}



@end
