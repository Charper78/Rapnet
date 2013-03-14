//
//  SearchParser.m
//  Rapnet
//
//  Created by NEHA SINGH on 18/05/11.
//  Copyright 2011 TechAhead. All rights reserved.
//


#import "SearchParser.h"

@implementation SearchParser
@synthesize webData,xmlParser,delegate;

-(void)getNewsWithSearchString:(NSString *)searchStr startRow:(NSInteger)startRow endRow:(NSInteger)endRow  articleType:(NSInteger)articleType languageId:(NSInteger)languageId
{
	if(results==nil)
	{  
	  results= [[NSMutableArray alloc] init];		
	}
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<GetArticles xmlns=\"%@/\">"
                             "<Params>"
							 "<Search>%@</Search>"
                             "<StartRow>%i</StartRow>"
                             "<EndRow>%i</EndRow>"
                             "<ArticleTypeID>%i</ArticleTypeID>"
                            // "<TopicTypeID>%i</TopicTypeID>"
                             "<LanguageID>%i</LanguageID>"
                             "</Params>"
                             "<SoftwareCode>%@</SoftwareCode>"
                             "</GetArticles>"
                             "</SOAP-ENV:Body> \n"
							 "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,searchStr, startRow, endRow, articleType, languageId, SoftwareCode];
    
   // NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];              
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetArticles", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
	
	if ([elementName isEqualToString:@"ArticleResult"]) 
	{
		
		data      = [[NSMutableDictionary alloc] init];
		title	 = [[NSMutableString alloc] init];
		articleTxt= [[NSMutableString alloc] init];
		author	 = [[NSMutableString alloc] init];
		date		 = [[NSMutableString alloc] init];
		articleTyp= [[NSMutableString alloc] init];
		imageURL	  = [[NSMutableString alloc] init];
		articleID = [[NSMutableString alloc] init];
		IsAuthenticated=[[NSMutableString alloc]init];
		articleURL=[[NSMutableString alloc]init];
	}
}



-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if ([currentElement isEqualToString:@"Title"]){
		[title  appendString:string];
	}
	else if ([currentElement isEqualToString:@"ArticleID"]){
		[articleID  appendString:string];
	}
	else if ([currentElement isEqualToString:@"ArticleText"]){
		[articleTxt appendString:string];
	}
	else if ([currentElement isEqualToString:@"Author"]){
		[author appendString:string];
	} 
	else if ([currentElement isEqualToString:@"DatePosted"]){
		[date appendString:string];
	} 
	else if ([currentElement isEqualToString:@"ArticleTypeText"]){
		[articleTyp appendString:string];
	}
	else if ([currentElement isEqualToString:@"ImageURL"]){
		[imageURL appendString:string];
	}
	else if ([currentElement isEqualToString:@"IsAuthenticated"]){
		[IsAuthenticated appendString:string];
	}
	
	else if ([currentElement isEqualToString:@"ArticleURL"]){
		[articleURL appendString:string];
	}
}



-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"ArticleResult"])
	{
		/*ReleaseObject(data);
		ReleaseObject(articleID);
		ReleaseObject(thumbID);
		ReleaseObject(title);
		ReleaseObject(subTitle);
		ReleaseObject(articleTxt);
		ReleaseObject(author);
		ReleaseObject(date);
		ReleaseObject(articleTyp);
		ReleaseObject(imageURL);
		ReleaseObject(IsAuthenticated);
		ReleaseObject(articleURL);*/
		
		[data setObject:title forKey:@"Title"];
		[data setObject:articleTxt forKey:@"ArticleText"];
		[data setObject:author forKey:@"Author"];
		[data setObject:date forKey:@"DatePosted"];
		[data setObject:articleTyp forKey:@"ArticleTypeText"];
		[data setObject:imageURL forKey:@"ImageURL"];
		[data setObject:articleID forKey:@"ArticleID"];
		[data setObject:IsAuthenticated forKey:@"IsAuthenticated"];
		[data setObject:articleURL forKey:@"ArticleURL"];
		[results addObject:data];
	}		
}


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	//NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]];
	//NSLog(@"error parsing XML: %@", errorString);	
}


-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"xml ended");
    [delegate searchServiceCallFinished];	
}

-(NSMutableArray*)getResults
{
	return results;
	//NSLog(@"Results%@",results);
}

- (void)dealloc 
{
	[IsAuthenticated release];
	[title release];
	[articleID release];
	[articleTxt release];
	[author release];
	[date release];
	[articleTyp release];
	[imageURL release];
	[articleURL release];
	[xmlParser release];
	[results release];
	[webData release];
	[data release];
	[super dealloc];
}
@end
