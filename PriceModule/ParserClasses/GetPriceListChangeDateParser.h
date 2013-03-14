//
//  GetPriceListChangeDateParser.h
//  Rapnet
//
//  Created by Itzik on 27/12/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetPriceListChangeDate.h"

@interface GetPriceListChangeDateParser : NSObject<NSXMLParserDelegate>
{
    NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSString *currentElement;
	
    NSString *roundFromDate;
    NSString *roundToDate;
    NSString *pearFromDate;
    NSString *pearToDate;
    NSMutableString *curShape;
    NSMutableString *curData;
    Boolean isCurShapeRound;

    GetPriceListChangeDate *priceListChangeDate;
}

@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSString *currentElement;


-(GetPriceListChangeDate*)getDates:(NSString*)ticket;
@end
