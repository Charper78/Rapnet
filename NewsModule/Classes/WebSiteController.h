//
//  WebSiteController.h
//  DailyExpenses
//
//  Created by shiva on 23/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebSiteController : UIViewController<UIWebViewDelegate>
{
	IBOutlet UIWebView *objWebView;
	UIActivityIndicatorView *indicatorView;
	//BOOL chkUrl;
    NSString *strUrl;
}

-(IBAction)backBtn;
@property (nonatomic, retain) IBOutlet UIWebView *objWebView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
//@property(nonatomic) BOOL chkUrl;
@property (nonatomic, retain) NSString * strUrl;
@end
