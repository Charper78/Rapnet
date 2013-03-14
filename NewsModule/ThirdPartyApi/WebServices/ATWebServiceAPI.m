//
//  ATWebServiceAPI.m
//  AddThis
//
//  Created by Jithin Roy on 12/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATWebServiceAPI.h"
#import "ATNetworkActivity.h"
#import "JSON.h"
#import "ATWebServiceAPI.h"
#import "TouchXML.h"

@interface ATNWebServiceAPI(PrivateMethods)

- (void)parseXML;
- (void)parseJson;
- (void)fetchContents;

@end

@implementation ATNWebServiceAPI

@synthesize activeConnection	= activeConnection_;
@synthesize delegate			= delegate_;
@synthesize isConnected			= isConnected_;
@synthesize isXML				= isXML;
@synthesize isJSON				= isJSON_;
@synthesize feedContentsArray	= feedContentsArray_;

- (void) dealloc {
	if(parsedContent_)
		[parsedContent_ release];
	if(XMLRoot_)
		[XMLRoot_ release];
	if(receivedData_)
		[receivedData_ release];
	if(feedContentsArray_)
		[feedContentsArray_ release];
	[super dealloc];		  
}

//calls the webservice
- (void)performRequestWithContents:(NSDictionary *)requestContent
							isJSON:(BOOL)json {  
	
	isJSON_ = json;
	if(!json) {
		XMLRoot_ = [[NSString alloc]initWithString:[requestContent valueForKey:@"XMLRoot"]];
	}
	isConnected_ = NO;
	NSString *jsonPath = [requestContent objectForKey:@"feedPath"];
	NSURL *requestURL = [NSURL URLWithString:jsonPath];
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:requestURL];
	activeConnection_ = [NSURLConnection connectionWithRequest:theRequest delegate:self];
	if (activeConnection_ == nil) {
		return;
	}
	isConnected_ = YES;
	[ATNetworkActivity pushNetworkActivity];
}

#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {	
	isConnected_ = YES;
	if(receivedData_) {
		[receivedData_ release];
		receivedData_ = nil;
	}
	receivedData_ = [[NSMutableData alloc]init];
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	// Append the new data to the received data. 
    [receivedData_ appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	isConnected_ = NO;
	[ATNetworkActivity popNetworkActivity];
	[self.delegate atConnectionDidFail:self];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	isConnected_ = NO;
	[ATNetworkActivity popNetworkActivity];
	
	// Checks whether web content is in xml or json format
	if (!isJSON_) {
		[self parseXML];
	} 
	else {
		[self parseJson];
	}
	[ATNetworkActivity popNetworkActivity];
	[self fetchContents];
}

- (void)cancelConnection {
	[ATNetworkActivity popNetworkActivity];
	[activeConnection_ cancel];
	isConnected_ = NO;
	if(receivedData_) {
		[receivedData_ release];
		receivedData_ = nil;
	}
}

- (void)parseJson {
	
	//Parse with json framework
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSString *receivedString = [[NSString alloc] initWithData:receivedData_ 
													 encoding:NSUTF8StringEncoding];
	parsedContent_ = [[NSDictionary alloc]initWithDictionary:[parser objectWithString:receivedString]];
	[receivedString release];
	[parser release];
	
}


// Convert recieved data to array
- (void)parseXML{
	
	// Initialize the entries MutableArray
	NSMutableArray *entries = [[NSMutableArray alloc] init];	
	
	// Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
	// object that actually grabs and processes the RSS data
	CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithData:receivedData_ encoding:NSUTF8StringEncoding options:0 error:nil] autorelease];
	
	// Create a new Array object to be used with the looping of the results from the rssParser
	NSArray *resultNodes = NULL;
	
	// Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
	resultNodes = [rssParser nodesForXPath:[NSString stringWithFormat:@"//%@",XMLRoot_] error:nil];
	
	// Loop through the resultNodes to access each items actual data
	for (CXMLElement *resultElement in resultNodes) {
		
		// Create a temporary MutableDictionary to store the items fields in, 
		// which will eventually end up in entries
		NSMutableDictionary *entryItem = [[NSMutableDictionary alloc] init];
		
		// Create a counter variable as type "int"
		int counter;
		
		// Loop through the children of the current  node
		for(counter = 0; counter < [resultElement childCount]; counter++) {
			
			// Add each field to the blogItem Dictionary with the node name as key and node value as the value
			[entryItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
		}
		
		// Add the blogItem to the global blogEntries Array so that the view can access it.
		[entries addObject:entryItem];
		[entryItem release];
		entryItem = nil;
	}
	parsedContent_  = [[NSArray alloc]initWithArray:entries];
	[entries release];
	
}

@end
