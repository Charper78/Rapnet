//
//  LoginParser.m
//  Rapnet
//
//  Created by Itzik on 18/07/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "Login.h"

@implementation Login

@synthesize xmlParser,webData;
@synthesize currentElement,strTicket;

-(NSString*)login:(LoginTypes)l
{
    NSString *userName = [LoginHelper getUserName];
	NSString *password = [LoginHelper getPassword];
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<Login xmlns=\"%@/\">"
                             "<Username>%@</Username>"
                             "<Password>%@</Password>"
                             "</Login>"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,userName, password];
    soapMessage = [soapMessage stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self getUrl:l]]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/Login", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    webData = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
	
    [theXML release];
	[self connectToParser:webData];
    
    return strTicket;
}

-(NSString*)getUrl:(LoginTypes)l
{
    NSString *s = nil;
    
    switch (l) {
        case L_News:
            return NewsUrl;
        case L_Prices:
            return PricesUrl;
        case L_Rapnet:
            return RapnetUrl;
    }
    return s;
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
	
	if ([elementName isEqualToString:@"AuthenticationTicketHeader"])
	{
		if (data !=nil)
		{
			[data release];
			data = nil;
		}
		ReleaseObject(data)
		data= [[NSMutableDictionary alloc] init];
	}
    
	
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([self.currentElement isEqualToString:@"Ticket"])
	{
		self.strTicket=string;
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"AuthenticationTicketHeader"])
	{
		[data setObject:self.strTicket forKey:@"Ticket"];
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
	[xmlParser release];
	[webData release];
	[data release];
	[strTicket release];
    
	[super dealloc];
}

@end
