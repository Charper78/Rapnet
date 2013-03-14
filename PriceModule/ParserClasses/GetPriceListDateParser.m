//
//  GetPriceListDateParser.m
//  Rapnet
//
//  Created by Itzik on 15/06/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "GetPriceListDateParser.h"

@implementation GetPriceListDateParser

@synthesize webData,xmlParser,delegate,iSRoundDate;

static NSString * const kMethodName = @"GetPriceListDate";


static NSString * const kPriceListDateResult = @"GetPriceListDateResult";

-(void)getDate:(bool)isRound{
	iSRoundDate = isRound;
    NSString *round = isRound ? @"true" : @"false";
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<%@ xmlns=\"%@/\"> \n"
                             "<IsMonthly>false</IsMonthly>"
                              "<IsRound>%@</IsRound>"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</%@> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, kMethodName, BaseUrl, round, SoftwareCode, kMethodName];
    
    //NSLog(@"%@", soapMessage);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/PricesWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/%@", BaseUrl, kMethodName] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self]autorelease];
    
    if( theConnection ){
		ReleaseObject(webData);
		webData = [[NSMutableData data] retain];
	}
	else{
		//NSLog(@"theConnection is NULL");
	}
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
	
	[webData appendData:mydata];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
	if(connection !=nil)
		ReleaseObject(connection);
	if(webData !=nil)
		ReleaseObject(webData);
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",theXML);
	[theXML release];
	[self connectToParser:webData];
    
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
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:kPriceListDateResult]) 
	{
		ReleaseObject(data);
		ReleaseObject(issueDate);
       
        
		data      = [[NSMutableDictionary alloc] init];
		issueDate	 = [[NSMutableString alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:kPriceListDateResult]){
		[issueDate  appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
}
    
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
   
    [delegate PriceListDateResult:issueDate isRound:iSRoundDate];	
}


- (void)dealloc 
{
    [issueDate release];
    [xmlParser release];
	[webData release];
	[data release];
	[currentElement release];
	[super dealloc];
}


@end
