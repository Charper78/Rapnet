//
//  SetReadMessagesRead.m
//  Rapnet
//
//  Created by Home on 6/3/13.
//  Copyright (c) 2013 coolban@gmail.com. All rights reserved.
//

#import "SetReadMessagesRead.h"

@implementation SetReadMessagesRead

static NSString * const kDataElementName = @"Data";
static NSString * const kResultElementName = @"Result";

-(void)setReadMessagesRead:(NSString*)deviceID ids:(NSArray*)ids
{
    notificationIds = ids;
    NSMutableString *sIds = [[NSMutableString alloc] init];
    
    for (NSInteger i = 0; i<ids.count; i++) {
        [sIds appendString:[NSString stringWithFormat:@"<int>%@</int>", [ids objectAtIndex:i]]];
    }
    
    NSString *soapAction = @"SetReadMessages";
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<%@ xmlns=\"%@/\"> \n"
                             "<token>%@</token> \n"
                             "<messageIDS>%@</messageIDS> \n"
                             "</%@> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>"
                             ,SoapEnvelope, soapAction, PnsNamespace, deviceID,
                             sIds, soapAction];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", PnsUrl]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:[NSString stringWithFormat:@"%@/%@", PnsNamespace, soapAction] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@",soapMessage);
    
    NSURLConnection *theConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self]autorelease];
    
    if( theConnection ){
		ReleaseObject(_webData);
		_webData = [[NSMutableData data] retain];
	}
	else{
		//NSLog(@"theConnection is NULL");
	}
    
    /*NSMutableData *data = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    NSString *theXML = [[NSString alloc] initWithBytes: [data mutableBytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
    */
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[_webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
	
	[_webData appendData:mydata];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",theXML);
	[theXML release];
	[self connectToParser:_webData];
    
}

-(void)connectToParser:(NSMutableData *)xmldata
{
	ReleaseObject(_xmlParser);
	_xmlParser = [[NSXMLParser alloc] initWithData: xmldata];
    
	[_xmlParser setDelegate: self];
	[_xmlParser setShouldResolveExternalEntities: YES];
	[_xmlParser parse];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if(nil != qName){
		elementName = qName;
	}
    
	_currentElement = [elementName copy];
	
    if ([elementName isEqualToString:kDataElementName])
    {
        result = [[NSMutableString alloc] init];
        data = [[NSMutableString alloc] init];
    }
	
    
	
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([_currentElement isEqualToString:kDataElementName]){
		[data  appendString:string];
    }
    else if ([_currentElement isEqualToString:kResultElementName]){
		[result  appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
    NSString * localizedDescription = parseError.localizedDescription;
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
    //NSMutableArray *arr = [self getResults];
    
    if([data isEqualToString:@"true"])
        [_delegate setReadMessagesReadFinished:notificationIds];
    
}


- (void)dealloc
{
    ReleaseObject(result);
    ReleaseObject(data);
    
    
	[_xmlParser release];
	[_webData release];
	//[data release];
    
	[super dealloc];
}


@end
