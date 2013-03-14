//
//  GetPriceListDateParser.h
//  Rapnet
//
//  Created by Itzik on 15/06/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol getPriceListDateDelegate
-(void)PriceListDateResult:(NSString*)date isRound:(BOOL)isRound;

@end

@interface GetPriceListDateParser : NSObject <NSXMLParserDelegate>{
    id<getPriceListDateDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	
	NSMutableString *currentElement;
	NSMutableString *issueDate;
    BOOL iSRoundDate;
}

@property(retain, nonatomic) id<getPriceListDateDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic) BOOL iSRoundDate;
-(void)connectToParser:(NSMutableData *)xmldata;
-(void)getDate:(bool)isRound;

@end
