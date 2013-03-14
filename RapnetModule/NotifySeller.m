//
//  NotifySeller.m
//  Rapnet
//
//  Created by Itzik on 26/11/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "NotifySeller.h"

@implementation NotifySeller

@synthesize xmlParser,webData;
@synthesize currentElement;

-(BOOL)notify:(NSString*)diamondIds
{
    return [self notify:diamondIds body:nil subject:nil reference:nil];
}

-(BOOL)notify:(NSString*)diamondIds body:(NSString*)body
{
    return [self notify:diamondIds body:body subject:nil reference:nil];
}

//-(NSString*)notify:(NSString*)diamondIds from:(NSString*)from body:(NSString*)body subject:(NSString*)subject reference:(NSString*)reference
-(BOOL)notify:(NSString*)diamondIds body:(NSString*)body subject:(NSString*)subject reference:(NSString*)reference
{
    
    NSString *ticket = [Functions getTicket:L_Rapnet];
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Header> \n"
                             "<AuthenticationTicketHeader xmlns=\"%@/\"> \n"
                             "<Ticket>%@</Ticket> \n"
                             "</AuthenticationTicketHeader> \n"
                             "</SOAP-ENV:Header> \n"
                             "<SOAP-ENV:Body> \n"
                             "<NotifySeller xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "<DiamondIDs>%@</DiamondIDs> \n"
                             //"%@"
                             "%@"
                             "%@"
                             "%@"
                             "</NotifySeller> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, BaseUrl, ticket, BaseUrl, SoftwareCode, diamondIds
                             //,[self getTagValue:@"From" val:from]
                             ,[self getTagValue:@"Body" val:body]
                             ,[self getTagValue:@"Subject" val:subject]
                             ,[self getTagValue:@"Reference" val:reference]];
    
    NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", RapnetUrl]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/NotifySeller", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    webData = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);

    
    [theXML release];
	[self connectToParser:webData];
    return res;
}
//
-(NSString*)getTagValue:(NSString*)tag val:(NSString*)val
{
    if (val != nil) {
        return [NSString stringWithFormat:@"<%@>%@</%@>", tag, val, tag];
    }
    
    return @"";
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
	
	if ([elementName isEqualToString:@"NotifySellerResult"])
	{
		if (data !=nil)
		{
			[data release];
			data = nil;
		}
		ReleaseObject(data)
		data= [[NSMutableDictionary alloc] init];
        resData = [[NSMutableString alloc] init];
	}
    
	
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"NotifySellerResult"])
		[resData  appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"NotifySellerResult"])
	{
        res = [[resData lowercaseString] isEqualToString:@"true"] ? true : false;
	}
    else if([elementName isEqualToString:@"NotifySellerResponse"])
    {
        ReleaseObject(resData);
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
    ReleaseObject(resData);
    
	[xmlParser release];
	[webData release];
	[data release];
	[strTicket release];
    
	[super dealloc];
}
@end
