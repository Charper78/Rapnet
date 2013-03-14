//
//  ForgotPasswordParser.m
//  Rapnet
//
//  Created by NEHA SINGH on 22/06/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import "ForgotPasswordParser.h"

@implementation ForgotPasswordParser
@synthesize webData,xmlParser,delegate;

-(void)GetForgotPassword:(NSString*)email
{
	if(results==nil)
	{  
		results= [[NSMutableArray alloc] init];
	}
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<ForgotPassword xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
							 "<Email>%@</Email> \n"
                             "</ForgotPassword> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, SoftwareCode,email];
    
	// NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/GeneralActionsWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/ForgotPassword", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
	[delegate serviceCallFinished];
	
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
	
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"ForgotPasswordResult"]) 
	{
		ReleaseObject(data);
		ReleaseObject(strSucceed);
		ReleaseObject(strMsg);
		data      = [[NSMutableDictionary alloc] init];
		strSucceed = [[NSMutableString alloc] init];
		strMsg = [[NSMutableString alloc] init];
	}
}



-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:@"Succeed"]){
		[strSucceed  appendString:string];
	}
	else if ([currentElement isEqualToString:@"Message"]){
		[strMsg  appendString:string];
	}
}



-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"ForgotPasswordResult"])
	{
		[data setObject:strSucceed forKey:@"Succeed"];
		[data setObject:strMsg forKey:@"Message"];
		[results addObject:data];
	}	
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	
}

-(NSMutableArray*)getResults
{
	return results;
}

- (void)dealloc 
{
	[strSucceed release];
	[strMsg release];
	[webData release];
	[xmlParser release];
	[data release];
	[results release];
	[currentElement release];
	[super dealloc];
}

@end
