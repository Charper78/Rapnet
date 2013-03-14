//
//  GetCountries.h
//  Rapnet
//
//  Created by Richa on 6/10/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol getCountryDelegate
-(void)webserviceCallFinished;

@end


@interface GetCountriesParser : NSObject <NSXMLParserDelegate>
{
	id<getCountryDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *countryID;
	NSMutableString *countryName;
	NSMutableString *countryPhoneCode;
	
}

@property(retain, nonatomic) id<getCountryDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetCountryName;
-(NSMutableArray*)getResults;




@end
