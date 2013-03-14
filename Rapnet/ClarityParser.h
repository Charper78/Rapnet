//
//  ClarityParser.h
//  Rapnet
//
//  Created by Itzik on 11/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Enums.h"
#import "LT_Const.h"
@protocol ClarityDelegate
-(void)DownloadFinished:(LT_Tables)type result:(NSMutableArray*)result;
@end



@interface ClarityParser : NSObject <NSXMLParserDelegate>{
    id<ClarityDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *value;
    NSMutableString *description;
    NSMutableString *listOrder;
}

@property(retain, nonatomic) id<ClarityDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)startDownload;
-(NSMutableArray*)getResults;

@end