//
//  GetUserPermissionsParser.m
//  Rapnet
//
//  Created by Itzik on 04/08/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "GetUserPermissionsParser.h"

@implementation GetUserPermissionsParser

@synthesize xmlParser,webData;
@synthesize currentElement,strTicket;

-(GetUserPermissions*)hasPermissions:(NSString*)ticket
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
                             "<GetUserPermissions xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetUserPermissions> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, BaseUrl, ticket, BaseUrl, SoftwareCode];
    
    NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", GeneralActionsUrl]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetUserPermissions", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    webData = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
	
    [theXML release];
	[self connectToParser:webData];
    
    return userPermissions;
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
	
	if ([elementName isEqualToString:@"TablePermissions"])
	{
		if (data !=nil)
		{
			[data release];
			data = nil;
		}
		ReleaseObject(data)
		data= [[NSMutableDictionary alloc] init];
        rapnet = [[NSMutableString alloc] init];
        weeklyPrices = [[NSMutableString alloc] init];
        monthlyPrices = [[NSMutableString alloc] init];
        individual = [[NSMutableString alloc] init];
	}
    
	
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"Auth_RapNet"]){
		[rapnet  appendString:string];
	}else if ([currentElement isEqualToString:@"Auth_WeeklyPrices"]){
		[weeklyPrices  appendString:string];
    }else if ([currentElement isEqualToString:@"Auth_MonthlyPrices"]){
		[monthlyPrices  appendString:string];
    }else if ([currentElement isEqualToString:@"Auth_Individual"]){
		[individual  appendString:string];
    }

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"TablePermissions"])
	{
		bool rapnetRes = [[rapnet lowercaseString] isEqualToString:@"true"] ? true : false;
        bool weeklyPricesRes = [[weeklyPrices lowercaseString] isEqualToString:@"true"] ? true : false;
        bool monthlyPricesRes = [[monthlyPrices lowercaseString] isEqualToString:@"true"] ? true : false;
        bool individualRes = [[individual lowercaseString] isEqualToString:@"true"] ? true : false;
        
        userPermissions = [[GetUserPermissions alloc] initWithRapnet:rapnetRes weeklyPrices:weeklyPricesRes monthlyPrices:monthlyPricesRes individual:individualRes];
	}
    else if([elementName isEqualToString:@"Permissions"])
    {
        ReleaseObject(rapnet);
        ReleaseObject(weeklyPrices);
        ReleaseObject(monthlyPrices);
        ReleaseObject(individual);
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
    ReleaseObject(rapnet);
    ReleaseObject(weeklyPrices);
    ReleaseObject(monthlyPrices);
    ReleaseObject(individual);
    
	[xmlParser release];
	[webData release];
	[data release];
	[strTicket release];
    
	[super dealloc];
}

@end
