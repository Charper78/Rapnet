//
//  ATNWebServiceContents.m
//  AddThisNewsFeed
//
//  Created by Jithin Roy on 02/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ATNWebServiceContents.h"


@implementation ATNWebServiceContents

- (void)fetchFeedsFromPath:(NSString *)newPath {
	
	NSDictionary *requestContent = [NSDictionary dictionaryWithObjectsAndKeys:
									newPath,@"feedPath",
									@"item",@"XMLRoot",
									nil];
	[self performRequestWithContents:requestContent
							  isJSON:NO];
	
}

- (void)fetchContents {
	
	if(feedContentsArray_) {
		[feedContentsArray_ release];
		feedContentsArray_ = nil;
	}
	
	feedContentsArray_ = [[NSMutableArray alloc] init];
	
	// Fetch title and link from parsedContent_ array into a dictionary
	// This dictionary is added  to feedContentsArray
	for (NSDictionary *newDictionary in parsedContent_) {
		
		NSMutableDictionary *feedContents = [[NSMutableDictionary alloc] init];
		[feedContents setObject:[newDictionary objectForKey:@"title"] forKey:@"title"];
		[feedContents setObject:[newDictionary objectForKey:@"link"] forKey:@"link"];
		[feedContentsArray_ addObject:feedContents];
		[feedContents release];
	
	}
	
	[delegate_ atConnectionDidFinish:self];
}

@end
