//
//  WebServicesEngine.m
//  HoodHang
//
//  Created by Saurabh Verma on 21/02/11.
//  Copyright 2011 TechAhead. All rights reserved.
//

#import "WebServicesEngine.h"
#import "MoreViewC.h"

@implementation WebServicesEngine

+ (WebServicesEngine*) sharedInstance 
{
	static WebServicesEngine* singleton;
	if (!singleton) 
	{
		singleton = [[WebServicesEngine alloc] init];
		
	}
	return singleton;
}


#pragma mark - Authentication
-(void)authenticateWithUserName:(NSString*)userName password:(NSString*)password
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/Login", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
	{
		webData = [[NSMutableData data] retain];
		
	}
	else
	{
		//NSLog(@"theConnection is NULL");
	}
}



#pragma mark - News
-(void)getNewsTopics
{
    //Web Service Call
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
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
	{
		webData = [[NSMutableData data] retain];
		
	}
	else
	{
		//NSLog(@"theConnection is NULL");
	}
}





-(void)getNewsType
{
    //Web Service Call
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<GetNewsTypes xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetNewsTypes> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, SoftwareCode];
    
    //NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetNewsTypes", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
	{
		webData = [[NSMutableData data] retain];
		
	}
	else
	{
		//NSLog(@"theConnection is NULL");
	}
}



-(void)getNewsWithArticleId:(NSInteger)articleId;
{
    //Web Service Call
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<soap:Header> \n"
                             "<AuthenticationTicketHeader xmlns=\"%@/\"> \n"
                             "<Ticket>%@</Ticket> \n"
                             "</AuthenticationTicketHeader> \n"
                             "</soap:Header> \n"
                             "<SOAP-ENV:Body> \n"
                             "<GetArticle xmlns=\"%@/\"> \n"
                             "<ArticleID>%i</ArticleID> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetArticle> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,[Functions getTicket:L_News],BaseUrl, articleId, SoftwareCode];
							
    
   // NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetArticle", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

    if( theConnection )
	{
		webData = [[NSMutableData data] retain];
		
	}
	else
	{
		//NSLog(@"theConnection is NULL");
	}
}



-(void)getNewsWithSearchString:(NSInteger)startRow endRow:(NSInteger)endRow  articleType:(NSInteger)articleType articleTopic:(NSInteger)articleTopic languageId:(NSInteger)languageId

//-(void)getNewsWithSearchString:(NSString*)searchString author:(NSString*)author startRow:(NSInteger)startRow endRow:(NSInteger)endRow datePosted:(NSString*)datePosted articleType:(NSInteger)articleType articleTopic:(NSInteger)articleTopic languageId:(NSInteger)languageId
{
    //Web Service Call
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<GetArticles xmlns=\"%@/\">"
                             "<Params>"
                            // "<Search>%@</Search>"
                            /// "<Author>%@</Author>"
                             "<StartRow>%i</StartRow>"
                             "<EndRow>%i</EndRow>"
                            // "<DatePosted>%@</DatePosted>"
                             "<ArticleTypeID>%i</ArticleTypeID>"
                             "<TopicTypeID>%i</TopicTypeID>"
                             "<LanguageID>%i</LanguageID>"
                             "</Params>"
                             "<SoftwareCode>%@</SoftwareCode>"
                             "</GetArticles>"
                             "</SOAP-ENV:Body> \n"
							 "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, startRow, endRow, articleType, articleTopic, languageId, SoftwareCode];
                            // "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, searchString, author, startRow, endRow, datePosted, articleType, articleTopic, languageId, SoftwareCode];
    
   // NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];              
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetArticles", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
	{
		webData = [[NSMutableData data] retain];
		
	}
	else
	{
		//NSLog(@"theConnection is NULL");
	}
}



-(void)GetMostViewedArticles
{
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Body> \n"
                             "<GetMostViewedArticles xmlns=\"%@/\"> \n"
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetMostViewedArticles> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl, SoftwareCode];
    
   // NSLog(@"%@", soapMessage);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewsWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetMostViewedArticles", BaseUrl] forHTTPHeaderField:@"Soapaction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
	{
		webData = [[NSMutableData data] retain];
		
	}
	else
	{
		//NSLog(@"theConnection is NULL");
	}
}






#pragma mark - Connection delegates
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   // NSLog(@"%@", [response URL]);
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mydata
{
	
	[webData appendData:mydata];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  	if(connection !=nil)
		[connection release];
	if(webData !=nil)
		[webData release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	
	
    switch (requestType)
	{
        case RequestTypeNewsLogin:
            break;
        case RequestTypeGetNewsTopics:
            break;
        case RequestTypeGetNewsTypes:
            break;
        case RequestTypeGetNews:
            break;
        case RequestTypeGetNewsDetails:
            break;
        default:
            break;
    }
	//NSLog(@"theXML= %@",theXML);
	[theXML release];
}

@end
