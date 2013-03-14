//
//  SignUpParser.h
//  Rapnet
//
//  Created by NEHA SINGH on 19/06/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol signUpDelegate
-(void)webserviceCallFinished;

@end

@interface SignUpParser : NSObject<NSXMLParserDelegate> {

	id<signUpDelegate> delegate;
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	NSMutableString *signUpResult;
}

@property(retain, nonatomic) id<signUpDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)signUpService:(NSString*)regTo language:(NSString*)language business:(NSString*)business firstName:(NSString*)firstName password:(NSString*)password phoneArea:(NSString*)phoneArea phoneNo:(NSString*)phoneNo company:(NSString*)company lastName:(NSString*)lastName email:(NSString*)email countryID:(NSInteger)countryID;
-(NSMutableArray*)getResults;

@end