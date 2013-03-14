//
//  ActivityAlertView.h
//  PositionApp
//
//  Created by Riyaz Ahemad on 09/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityAlertView : UIAlertView
{
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityView;
-(void)close;

@end
