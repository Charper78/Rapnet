//
//  LoginMain.m
//  Rapnet
//
//  Created by Itzik on 18/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "LoginMain.h"

@implementation LoginMain

@synthesize xmlParser,webData,delegate;
@synthesize currentElement,strTicket;

-(void)login{
	
    if([StoredData sharedData].strRapnetTicket != nil && [StoredData sharedData].isUserAuthenticated)
    {
        [delegate loginCompleted:YES];
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *userName = [prefs stringForKey:@"UserName"];
	NSString *password = [prefs stringForKey:@"Password"]; 
    
	if (userName.length > 0 && userName.length > 0) 
    {
        NSString *soapMessage = [NSString stringWithFormat:
                                @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<Login xmlns=\"%@/\">"
                             "<Username>%@</Username>"
                             "<Password>%@</Password>"
                             "</Login>"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,userName, password];
    
    // NSLog(@"%@", soapMessage);
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/RapnetWebService.asmx", BaseUrl]];               
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
        [theRequest addValue:[NSString stringWithFormat:@"%@/Login", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
    if(strTicket != nil)
    {
        [StoredData sharedData].isUserAuthenticated=TRUE;
        NSMutableString *t = [[NSMutableString alloc] init];
        [t setString:strTicket];
		[StoredData sharedData].strRapnetTicket = t;	
        [delegate loginCompleted:YES];
    }
    else
    {
        [StoredData sharedData].isUserAuthenticated=FALSE;
		[StoredData sharedData].strRapnetTicket = nil;	
        [delegate loginCompleted:NO];
    }
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
