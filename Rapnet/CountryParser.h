//
//  LocationParser.h
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 appdev@diamonds.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Enums.h"
#import "LT_Const.h"
@protocol CountryDelegate
-(void)DownloadFinished:(LT_Tables)type result:(NSMutableArray*)result;
@end



@interface CountryParser : NSObject <NSXMLParserDelegate>{
    id<CountryDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *value;
    NSMutableString *description;
    NSMutableString *listOrder;
    
    NSInteger curListOrder;
}

@property(retain, nonatomic) id<CountryDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)startDownload;
-(NSMutableArray*)getResults;

@end

