//
//  ATWebServiceAPI.h
//  AddThis
//
//  Created by Jithin Roy on 12/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATNConstants.h"

@protocol ATWebserviceDelegate;

@interface ATNWebServiceAPI : NSObject {
	
	id <ATWebserviceDelegate> delegate_;
	NSURLConnection *activeConnection_;
	NSArray *parsedContent_;
	NSMutableArray *feedContentsArray_;
	NSString *XMLRoot_;
	BOOL isConnected_, isJSON_;
	NSMutableData *receivedData_;
}

@property (nonatomic, assign) id <ATWebserviceDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *feedContentsArray;
@property (nonatomic, retain) NSURLConnection *activeConnection;
@property (readonly) BOOL isConnected, isJSON, isXML;

- (void)performRequestWithContents:(NSDictionary *)requestContent isJSON:(BOOL)json;
- (void)cancelConnection;

@end

@protocol ATWebserviceDelegate 

@optional
- (void)atConnectionDidFail:(ATNWebServiceAPI *)theConnection;
- (void)atConnectionDidFinish:(ATNWebServiceAPI *)theConnection;

@end