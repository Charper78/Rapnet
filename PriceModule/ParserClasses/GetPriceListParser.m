//
//  GetPriceList.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 12/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetPriceListParser.h"


@implementation GetPriceListParser

@synthesize webData,xmlParser,results,delegate;

-(void)GetPriceList:(NSString *)ticket ShapeType:(NSString *)sID GridSizeID:(int)ID{
    if(results == nil)
		results= [[NSMutableArray alloc] init];
	
    shapes = sID;
	
    NSString *soapMessage = [NSString stringWithFormat:
                             @"%@"
                             "<SOAP-ENV:Header> \n"
                             "<AuthenticationTicketHeader xmlns=\"%@/\"> \n"
                             "<Ticket>%@</Ticket> \n"
                             "</AuthenticationTicketHeader> \n"
                             "</SOAP-ENV:Header> \n"
                             "<SOAP-ENV:Body> \n"
                             "<GetPriceList xmlns=\"%@/\"> \n"
                             "<PriceListType>%@</PriceListType> \n"                                                          
                             "<GridSizeID>%i</GridSizeID> \n"                             
                             "<SoftwareCode>%@</SoftwareCode> \n"
                             "</GetPriceList> \n"
                             "</SOAP-ENV:Body> \n"
                             "</SOAP-ENV:Envelope>", SoapEnvelope, BaseUrl,ticket,BaseUrl, sID,ID, SoftwareCode];
    
    // NSLog(@"%@", soapMessage);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/PricesWebService.asmx", BaseUrl]];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue:[NSString stringWithFormat:@"%@/GetPriceList", BaseUrl] forHTTPHeaderField:@"Soapaction"];
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
	
	if ([currentElement isEqualToString:@"Color"]){
		[data setObject:string forKey:@"Color"];
        color = string;
        flag = TRUE;
	}else if ([currentElement isEqualToString:@"SizeGridID"]){
		[data setObject:string forKey:@"SizeGridID"];
        gridID = string;
	}else if ([currentElement isEqualToString:@"LowSize"]){
		[data setObject:string forKey:@"LowSize"];        
	}else if ([currentElement isEqualToString:@"HighSize"]){
		[data setObject:string forKey:@"HighSize"];        
	}else if (flag){
		[data setObject:string forKey:currentElement];
        
        NSArray *listItems = [color componentsSeparatedByString:@"-"];
        NSArray *listItems1 = [currentElement componentsSeparatedByString:@"-"];
        price = string;
        
        //NSLog(@"%@",color);
        
        NSMutableArray *colors = [[NSMutableArray alloc]init ];
        NSMutableArray *clarityList = [[NSMutableArray alloc]init ];
        
        if ([listItems count]==1) {
            [colors addObject:[listItems objectAtIndex:0]];
        }else{
            NSInteger index1 = [self checkIndex:1 :[listItems objectAtIndex:0]:1];
            NSInteger index2 = [self checkIndex:1 :[listItems objectAtIndex:1]:2];
            
            
            
            for (NSInteger j = index1; j<=index2; j++) {
                //NSLog(@"index1= %@",[[[StoredData sharedData].arrColors objectAtIndex:j]objectForKey:@"ColorTitle"]);
                [colors addObject:[[[StoredData sharedData].arrColors objectAtIndex:j]objectForKey:@"ColorTitle"]];
            }
        }
        
        if ([listItems1 count]==1) {
            
            
            NSString *item = [listItems1 objectAtIndex:0];
            
            if ([item isEqualToString:@"VVS"]) {
                
                for (NSInteger j = 1; j<=2; j++) {
                    //NSLog(@"index2= %@",[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]);
                    [clarityList addObject:[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]];
                }
                
            }else if ([item isEqualToString:@"VS"]) {
                for (NSInteger j = 3; j<=4; j++) {
                    //NSLog(@"index2= %@",[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]);
                    [clarityList addObject:[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]];
                }
            }else if ([item isEqualToString:@"SI"]) {
                for (NSInteger j = 5; j<=7; j++) {
                    //NSLog(@"index2= %@",[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]);
                    [clarityList addObject:[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]];
                }
            }else if ([item isEqualToString:@"I"]) {
                for (NSInteger j = 8; j<=10; j++) {
                    //NSLog(@"index2= %@",[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]);
                    [clarityList addObject:[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]];
                }
            }else{
                [clarityList addObject:item];
            }
            
        }else{
            NSInteger index1 = [self checkIndex:2 :[listItems1 objectAtIndex:0]:1];
            NSInteger index2 = [self checkIndex:2 :[listItems1 objectAtIndex:1]:2];
            
            for (NSInteger j = index1; j<=index2; j++) {
                //NSLog(@"index2= %@",[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]);
                [clarityList addObject:[[[StoredData sharedData].arrClarity objectAtIndex:j]objectForKey:@"ClarityTitle"]];
            }
        }
        
        
        for (int i = 0; i<[colors count]; i++) {
            //NSLog(@"\n%@\n",[colors objectAtIndex:i]);
            for (int j = 0; j<[clarityList count]; j++) {
                clarity = [clarityList objectAtIndex:j];
                NSString *tempColor = [colors objectAtIndex:i];
                //NSLog(@"index2= %@",clarity);
                
                [Database insertPricesWithGridSizeID:gridID Shape:shapes Color:tempColor Clarity:clarity Price:price];
            }
        }
        
        
        [colors removeAllObjects];
        [colors release];
        
        [clarityList removeAllObjects];
        [clarityList release];
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
    [delegate webserviceCallPriceListFinished:results];	
	[delegate finishedDownloading];
}

-(NSMutableArray*)getResults
{
	return results;
}

-(NSInteger)checkIndex:(NSInteger)type:(NSString *)item:(NSInteger)indexSearch{
    NSInteger index = -1;
    
    switch (type) {
        case 1:
            for (NSInteger i =0; i<[[StoredData sharedData].arrColors count]; i++) {
                if ([[[[StoredData sharedData].arrColors objectAtIndex:i] objectForKey:@"ColorTitle"] isEqualToString:item]) {
                    
                    return i;
                }
            }
            
            if ([item isEqualToString:@"N"]) {
                return [[StoredData sharedData].arrColors count]-1;
            }
            
            break;
            
        case 2:
            
            //NSLog(@"item= %@",item);
            for (NSInteger i =0; i<[[StoredData sharedData].arrClarity count]; i++) {
                if ([[[[StoredData sharedData].arrClarity objectAtIndex:i] objectForKey:@"ClarityTitle"] isEqualToString:item]) {
                    //NSLog(@"index1= %@",[[[StoredData sharedData].arrClarity objectAtIndex:i] objectForKey:@"ClarityTitle"]);
                    return i;
                }
            }
            
            if ([item isEqualToString:@"VVS"]) {
                if (indexSearch==1) {
                    return 1;
                }else{
                    return 2;
                }
            }
            
            if ([item isEqualToString:@"VS"]) {
                if (indexSearch==1) {
                    return 3;
                }else{
                    return 4;
                }
            }
            
            if ([item isEqualToString:@"SI"]) {
                if (indexSearch==1) {
                    return 5;
                }else{
                    return 7;
                }
            }
            
            if ([item isEqualToString:@"I"]) {
                if (indexSearch==1) {
                    return 8;
                }else{
                    return 10;
                }
            }
            
            break;
            
        default:
            break;
    }
    
    return index;
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
