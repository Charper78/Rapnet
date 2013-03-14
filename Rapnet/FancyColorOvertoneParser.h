//
//  FancyColorOvertoneParser.h
//  Rapnet
//
//  Created by Itzik on 18/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.



#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Enums.h"
#import "LT_Const.h"
@protocol FancyColorOvertoneDelegate
-(void)DownloadFinished:(LT_Tables)type result:(NSMutableArray*)result;
@end



@interface FancyColorOvertoneParser : NSObject <NSXMLParserDelegate>{
    id<FancyColorOvertoneDelegate> delegate;
	
	NSMutableData *webData;
	NSXMLParser *xmlParser;
	NSMutableDictionary *data;
	NSMutableArray *results;
	NSMutableString *currentElement;
	
	NSMutableString *value;
    NSMutableString *description;
    NSMutableString *listOrder;
}

@property(retain, nonatomic) id<FancyColorOvertoneDelegate> delegate;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableArray *results;

-(void)connectToParser:(NSMutableData *)xmldata;
-(void)startDownload;
-(NSMutableArray*)getResults;

@end


