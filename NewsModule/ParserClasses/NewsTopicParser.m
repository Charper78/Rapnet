//
//  NewsTopicParser.m
//  Rapnet
//
//  Created by NEHA SINGH on 17/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "NewsTopicParser.h"


@implementation NewsTopicParser
@synthesize xmlParser,webData,delegate;

#pragma mark - News
-(void)getNewsTopics
{
	if(results==nil)
	{  
		results= [[NSMutableArray alloc] init];	
	}
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<GetNewsTopics xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetNewsTopics> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, SoftwareCode];
    
   // NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetNewsTopics", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
	if(nil != qName){
		elementName = qName;
	}
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"KeyValueOfstringint"]) 
	{
		
		if (data !=nil){
			[data release];
			data = nil;
		}
		ReleaseObject(data);
		ReleaseObject(strkey);
		ReleaseObject(strValue);
		data= [[NSMutableDictionary alloc] init];
		strkey=[[NSMutableString alloc] init];
		strValue=[[NSMutableString alloc] init];
		
	}
	
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:@"Key"]){
		[strkey  appendString:string];
	}
	else if ([currentElement isEqualToString:@"Value"]){
		[strValue appendString:string];
	} 
	
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"KeyValueOfstringint"])
	{
		[data setObject:strkey forKey:@"Key"];
		[data setObject:strValue forKey:@"Value"];
		[results addObject:data];
		
	}	
}


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
    [delegate webserviceCallFinished];	
}

-(NSMutableArray*)getResults
{
	return results;
}

- (void)dealloc 
{
	[xmlParser release];
	[results release];
	[webData release];
	[data release];
	[currentElement release];
	[strkey release];
	[strValue release];
	[super dealloc];
}

@end
