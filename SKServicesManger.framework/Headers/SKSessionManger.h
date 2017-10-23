//
//  SKSessionManger.h
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNetworkConnectionStatusChecker.h"
#import "SKGetRequest.h"
#import "SKPutRequest.h"
#import "SKPostRequest.h"
#import "SKPatchRequest.h"
#import "SKDeleteRequest.h"
#import "SKDownloadRequest.h"
#import "SKUploadRequest.h"
#import "SKMultiPartFormUploadRequest.h"



@interface SKSessionManger : NSObject <NSURLSessionDelegate,NSURLSessionTaskDelegate>
+ (SKSessionManger *) sharedSessionManger;

@property NSString* baseUrl;
@property int maxActiveRequestsViaWiFi;
@property int maxActiveRequestsViaCellular;


-(void)addRequestToQueue:(SKBaseRquest*)request;
-(void)setBaseUrlValue:(NSString *)baseUrl;
-(void)setmaxWiFiTasks:(int)maxWiFiTasks;
-(void)setmaxCellularTasks:(int)maxCellularTasks;

@end
