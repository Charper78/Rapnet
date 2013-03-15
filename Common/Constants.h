
#define kGoogleAnalyticsAccount @"UA-38346425-2"
#define BaseUrl @"http://app13.rapaport.com"
#define NewsUrl @"http://app13.rapaport.com/NewsWebService.asmx"
#define PricesUrl @"http://app13.rapaport.com/PricesWebService.asmx"
#define RapnetUrl @"http://app13.rapaport.com/RapnetWebService.asmx"
#define GeneralActionsUrl @"http://app13.rapaport.com/GeneralActionsWebService.asmx"
#define PnsUrl @"http://10.0.0.10/pns/pns.asmx"
#define PnsBaseUrl @"http://10.0.0.10"
#define PnsNamespace @"http://pns.rapnet.com"
#define SoftwareCode @"Drf@eGyh463@dMVsqOp$sd"
#define NewsUserName @"75416"
#define NewsPassword @"RBone123"
#define kRoundPriceListDate @"kRoundPriceListDate"
#define kPearPriceListDate @"kPearPriceListDate"
#define kRoundShapeID 1
#define kPearShapeID 2
//#define RoundUrl @"https://technet.rapaport.com/HTTP/Prices/CSV2_Round.aspx"
//#define PearUrl @"https://technet.rapaport.com/HTTP/Prices/CSV2_Pear.aspx"
#define RoundUrl @"https://technet.rapaport.com/HTTP/Prices/CSV1_Round.aspx"
#define PearUrl @"https://technet.rapaport.com/HTTP/Prices/CSV1_Pear.aspx"
#define kTicketValidTimeInMinutes 60
#define kUse10crts @"use10crts"

#define kNotificationDateKey @"NotificationDate"
#define kNotificationAlertKey @"alert"
#define kNotificationApsKey @"aps"
#define kNotificationBadgeKey @"badge"
#define kNotificationSoundKey @"sound"
#define kNotificationsFile @"Notifications.txt"

#define SoapEnvelope @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><SOAP-ENV:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">"


#define	ReleaseObject(obj) if (obj != nil) { [obj release]; obj = nil; }

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
