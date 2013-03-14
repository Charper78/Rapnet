//
//  GetShapeParser.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetShapeParser.h"


@implementation GetShapeParser

@synthesize webData,xmlParser,results;//,delegate;

-(NSMutableArray*)GetShapeList{
    if(results == nil)
		results= [[NSMutableArray alloc] init];
	
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<GetShapes xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetShapes> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, SoftwareCode];
    
    // NSLog(@"%@", soapMessage);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/PricesWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetShapes", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    webData = [[NSMutableData alloc] initWithData: [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil]];
    
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
	
    [theXML release];
    
    [self connectToParser:webData];
    
    return results;
    //NSURLConnection *theConnection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self]autorelease];
    
   /* if( theConnection ){
		ReleaseObject(webData);
		webData = [[NSMutableData data] retain];
	}
	else{
		//NSLog(@"theConnection is NULL");
	}*/
}

/*
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
    //	NSLog(@"%@",theXML);
	[theXML release];
	[self connectToParser:webData];
		
}
*/
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
	
	if ([elementName isEqualToString:@"Table"]) 
	{
		ReleaseObject(data);
		ReleaseObject(shapeName);
        ReleaseObject(shapeTitle);
        ReleaseObject(shapeShortTitle);
		
		data      = [[NSMutableDictionary alloc] init];
		shapeName	 = [[NSMutableString alloc] init];	
        shapeTitle	 = [[NSMutableString alloc] init];	
        shapeShortTitle	 = [[NSMutableString alloc] init];	
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:@"ShapeID"]){
		[shapeName  appendString:string];
	}else if ([currentElement isEqualToString:@"ShapeTitle"]){
		[shapeTitle  appendString:string];
	}else if ([currentElement isEqualToString:@"ShapeShortTitle"]){
		[shapeShortTitle  appendString:string];
	}
	    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"Table"])
	{
		[data setObject:shapeName forKey:@"ShapeID"];	
        [data setObject:shapeTitle forKey:@"ShapeTitle"];	
        [data setObject:shapeShortTitle forKey:@"ShapeShortTitle"];	
		[results addObject:data];
	}		
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
   // [delegate webserviceCallShapeFinished];
}

/*-(NSMutableArray*)getResults
{
	return results;
}*/

- (void)dealloc 
{
    [shapeTitle release];
    [shapeShortTitle release];
	[shapeName release];
	[xmlParser release];
	[results release];
	[webData release];
	[data release];
	[currentElement release];
	[super dealloc];
}

@end
