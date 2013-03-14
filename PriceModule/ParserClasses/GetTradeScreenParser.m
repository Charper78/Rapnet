//
//  GetTradeScreenParser.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetTradeScreenParser.h"


@implementation GetTradeScreenParser

@synthesize webData,xmlParser,results,delegate;

-(void)GetTradeScreenList:(NSString *)ticket ShapeID:(int)sID Weight:(float)w{
    if(results == nil)
		results= [[NSMutableArray alloc] init];
	
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Header> \n"
                             "<AuthenticationTicketHeader xmlns=\"%@/\"> \n"
                             "<Ticket>%@</Ticket> \n"
                             "</AuthenticationTicketHeader> \n"
                             "</SOAP-ENV:Header> \n"
                             "<SOAP-ENV:Body> \n"
                             "<GetTradeScreen xmlns=\"%@/\"> \n"
                             "<GridOption>BEST_AVG</GridOption> \n"
                             "<SearchParams>\n"                             
                             "<ShapeIDs>%i</ShapeIDs> \n"
                             "<WeightFrom>%f</WeightFrom> \n"
                             "<WeightFrom>%f</WeightFrom> \n"
                             "<LabIDs/> \n"
                             "<CuletSizeIDs/> \n"
                             "<TablePercentFrom xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             "<TablePercentTo xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             "<DepthPercentFrom xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             "<DepthPercentTo xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             "<RatioMin xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             "<RatioMax xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"true\"/> \n"
                             "</SearchParams>\n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetTradeScreen> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,ticket,BaseUrl, sID,w,w, SoftwareCode];
    
    // NSLog(@"%@", soapMessage);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/RapnetWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetTradeScreen", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
    //   NSLog(@"%@",theXML);
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
	
	if ([elementName isEqualToString:@"Table"]) 
	{
		ReleaseObject(data);
		//ReleaseObject(dic);
		
		data      = [[NSMutableDictionary alloc] init];
        //dic      = [[NSMutableDictionary alloc] init];
		
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:@"ColorTitle"]){
		[data setObject:string forKey:@"ColorTitle"];
        flag = TRUE;
	}else if (flag){
		[data setObject:string forKey:currentElement];
	}
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"Table"])
	{
        flag = FALSE;		
		[results addObject:data];
	}		
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
    [delegate webserviceCallTradeScreenFinished];	
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
	[super dealloc];
}


@end
