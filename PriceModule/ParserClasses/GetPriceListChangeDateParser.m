//
//  GetPriceListChangeDateParser.m
//  Rapnet
//
//  Created by Itzik on 27/12/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "GetPriceListChangeDateParser.h"

@implementation GetPriceListChangeDateParser

@synthesize xmlParser,webData;
@synthesize currentElement;

-(GetPriceListChangeDate*)getDates:(NSString*)ticket
{
    //NSString *ticket = [Functions getTicket:L_Rapnet];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Header> \n"
                             "<AuthenticationTicketHeader xmlns=\"%@/\"> \n"
                             "<Ticket>%@</Ticket> \n"
                             "</AuthenticationTicketHeader> \n"
                             "</SOAP-ENV:Header> \n"
                             "<SOAP-ENV:Body> \n"
                             "<GetPriceChangeDates xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetPriceChangeDates> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, BaseUrl, ticket, BaseUrl, SoftwareCode];
    
    NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", PricesUrl]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetPriceChangeDates", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    webData = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
	
    [theXML release];
	[self connectToParser:webData];
    
    return priceListChangeDate;
}


-(void)connectToParser:(NSMutableData *)xmldata
{
	ReleaseObject(xmlParser);
	xmlParser = [[NSXMLParser alloc] initWithData: xmldata];
    
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if(nil != qName){
		elementName = qName;
	}
	self.currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"NewDataSet"])
	{
		if (data !=nil)
		{
			[data release];
			data = nil;
		}
		ReleaseObject(data)
		data= [[NSMutableDictionary alloc] init];
	}
    else if ([elementName isEqualToString:@"Shape"])
    {
        curShape = [[NSMutableString alloc] init];
    }
	else if ([elementName isEqualToString:@"FromDate"] || [elementName isEqualToString:@"ToDate"])
    {
        curData = [[NSMutableString alloc] init];
    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"Shape"]){
		[curShape  appendString:string];
	}else if ([currentElement isEqualToString:@"FromDate"] || [currentElement isEqualToString:@"ToDate"]){
		[curData  appendString:string];
    }    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Shape"])
    {
        isCurShapeRound = [[curShape lowercaseString] isEqualToString:@"round"] ? true : false;
    }
    else if ([elementName isEqualToString:@"FromDate"])
    {
        if (isCurShapeRound) {
            roundFromDate = [[NSString alloc] initWithString:curData];
        }
        else
            pearFromDate = [[NSString alloc] initWithString:curData];
        
        ReleaseObject(curData);
    }
    else if ([elementName isEqualToString:@"ToDate"])
    {
        if (isCurShapeRound) {
            roundToDate = [[NSString alloc] initWithString:curData];
        }
        else
            pearToDate = [[NSString alloc] initWithString:curData];
        
        ReleaseObject(curData);
    }
	else if ([elementName isEqualToString:@"NewDataSet"])
	{
        priceListChangeDate = [[GetPriceListChangeDate alloc] initWithDates:roundFromDate roundTo:roundToDate pearFrom:pearFromDate pearTo:pearToDate];
	}
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
}


- (void)dealloc
{
    ReleaseObject(roundFromDate);
    ReleaseObject(roundToDate);
    ReleaseObject(pearFromDate);
    ReleaseObject(pearToDate);
    ReleaseObject(curData);
    
	[xmlParser release];
	[webData release];
	[data release];
    
	[super dealloc];
}



@end
