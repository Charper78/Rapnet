//
//  GetPricecalcParser.h
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol getPricecalcDelegate
-(void)webserviceCallPriceCalcFinished:(NSMutableArray *)results;

@end

@interface GetPricecalcParser : NSObject <NSXMLParserDelegate>{
    id<getPricecalcDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	float bestPrice,bestDiscount,avgPrice,avgDiscount,pricePerCarat,priceTotal,discount,rapPriceList;
    NSMutableString *shape,*clarity,*color;
    int diamondCount;
    
}

@property(retain, nonatomic) id<getPricecalcDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)GetPriceCalcWithTicket:(NSString *)ticket PricePerCarat:(float)ppc PriceTotal:(float)total Discount:(float)d RapPriceList:(float)rpl Weight:(float)w ShapeID:(int)sID ClarityID:(int)CLID ColorID:(int)CID UsePear:(BOOL)pearFlag;
-(NSMutableArray*)getResults;



@end
