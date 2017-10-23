//
//  SKSessionManger.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKSessionManger.h"
#import "SKBaseRquest.h"
#import <UIKit/UIKit.h>


@interface SKSessionManger ()
{
    int activeRequestsNumber;
    NSMutableArray* pendingRequestQueue;
    NSMutableArray* activeUploadingRequests;
    NSMutableArray* activeDownloadingRequests;
    NSMutableArray* activeUploadRequestData;
}

@property (readonly) NSURLSession *backgroundSession;

@end

@implementation SKSessionManger
static SKSessionManger *sharedObject = nil;

+ (SKSessionManger *) sharedSessionManger
{
    if (! sharedObject) {
        sharedObject = [[SKSessionManger alloc] init];
        sharedObject.maxActiveRequestsViaWiFi = 6;
        sharedObject.maxActiveRequestsViaCellular = 2;
        sharedObject.baseUrl = @"";
        
    }
    
    return sharedObject;
}

- (id)init
{
    if (!sharedObject) {
        sharedObject = [super init];
    }
    return sharedObject;
}

-(void)setBaseUrlValue:(NSString *)baseUrl{
    sharedObject.baseUrl = baseUrl;
}

-(void)setmaxWiFiTasks:(int)maxWiFiTasks{
    if (maxWiFiTasks > 0) {
        self.maxActiveRequestsViaWiFi = maxWiFiTasks;
    }
}

-(void)setmaxCellularTasks:(int)maxCellularTasks{
    if (maxCellularTasks > 0) {
        self.maxActiveRequestsViaCellular = maxCellularTasks;
    }
}

-(NSURLSession*) backgroundSession {
    
    static dispatch_once_t onceToken;
    static NSURLSessionConfiguration *backgroundSessionConfiguration;
    static NSURLSession *backgroundSession;
    dispatch_once(&onceToken, ^{
        backgroundSessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"SKServicesManger"];//To make unit testing work and request respond to the failure handler and activate it in the framework deployment
        
//        backgroundSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];//To make unit testing work and request respond to the success handler

        backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfiguration delegate:self delegateQueue:nil];
    });
    
    return backgroundSession;
}


-(void)addRequestToQueue:(SKBaseRquest*)request {
    if (activeDownloadingRequests == nil) {
        [self setupClassInstanceVariables];
    }
    
    SKNetworkConnectionState networkState = [SKNetworkConnectionStatusChecker checkCurrentNetworkConnectionState];
    NSError* error;
    switch (networkState) {
        case UNKNOWN:
        case NotReachable:
            error = [NSError errorWithDomain:@"com.Sherif-Khaled.SKServicesManger" code:400 userInfo:[NSDictionary dictionaryWithObject:@"Network failure error" forKey:NSLocalizedDescriptionKey]];
            request.getFailureHandler([NSData new],[NSURLResponse new],error);
            return;
        case WIFI:
            [self checkRequest:request CanRunnConcurentlyWithMaxConcurentTasksCount:self.maxActiveRequestsViaWiFi];
            break;
        case CELLULAR:
            [self checkRequest:request CanRunnConcurentlyWithMaxConcurentTasksCount:self.maxActiveRequestsViaCellular];
            break;
        default:
            break;
    }
}

-(void)setupClassInstanceVariables{
    activeRequestsNumber = 0;
    activeDownloadingRequests = [NSMutableArray new];
    activeUploadingRequests = [NSMutableArray new];
    activeUploadRequestData = [NSMutableArray new];
    pendingRequestQueue = [NSMutableArray new];
}

-(void)checkRequest:(SKBaseRquest*)request CanRunnConcurentlyWithMaxConcurentTasksCount:(int)maxActiveQueueTasks{
    if (activeRequestsNumber >= maxActiveQueueTasks) {
        [pendingRequestQueue addObject:request];
    }else{
        [self activateRequest:request];
    }
}

-(void)activateRequest:(SKBaseRquest*)baseRequest {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if ([baseRequest isKindOfClass:[SKUploadRequest class]]){
        SKUploadRequest* request = (SKUploadRequest*) baseRequest;
        NSURLSessionUploadTask* task = [[self backgroundSession] uploadTaskWithRequest:[request getMethodRequestObject] fromData:[request getFileData]];
        [task resume];
        [baseRequest setTaskID:task.taskIdentifier];
        [activeUploadingRequests addObject:request];
        [activeUploadRequestData addObject:[NSMutableData new]];
    }else{
        NSURLSessionDownloadTask* task = [[self backgroundSession] downloadTaskWithRequest:[baseRequest getMethodRequestObject]];
        [task resume];
        [baseRequest setTaskID:task.taskIdentifier];
        [activeDownloadingRequests addObject:baseRequest];
        
    }
    activeRequestsNumber++;
}


#pragma mark -
#pragma mark NSURLSession (Download/Upload) Progress notification delegates

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    if ([dataTask isKindOfClass:[NSURLSessionUploadTask class]]) {
        int index = [self searchForRequestTask:dataTask InArray:activeUploadingRequests];
        
        if (index != -1) {
            NSMutableData *responseData = activeUploadRequestData[index];
            [responseData appendData:data];
            activeUploadRequestData[index] = responseData;
        }
    }
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    
    if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        
        int index = [self searchForRequestTask:task InArray:activeUploadingRequests];
        
        if (index != -1) {
            SKBaseRquest* currentRequest = activeUploadingRequests[index];
            [self checkRequestSuuccededOrFailed:currentRequest task:task data:(NSData*)activeUploadRequestData[index]];
            [activeUploadRequestData removeObjectAtIndex:index];
            [activeUploadingRequests removeObjectAtIndex:index];
        }
        [self addrequestFromPendingQueue];
    }
    else{
        if (error != nil) {
            int index = [self searchForRequestTask:task InArray:activeDownloadingRequests];
            
            if (index != -1) {
                SKBaseRquest* currentRequest = activeDownloadingRequests[index];
                [self checkRequestSuuccededOrFailed:currentRequest task:task data:nil];
                [activeDownloadingRequests removeObjectAtIndex:index];
            }
            [self addrequestFromPendingQueue];
        }
    }
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    int index = [self searchForRequestTask:downloadTask InArray:activeDownloadingRequests];
    
    if (index != -1) {
        SKBaseRquest* currentRequest = activeDownloadingRequests[index];
        NSData* data = [NSData dataWithContentsOfURL:location];
        [self checkRequestSuuccededOrFailed:currentRequest task:downloadTask data:data];
        [activeDownloadingRequests removeObjectAtIndex:index];
        [self addrequestFromPendingQueue];
    }
    
}

-(int)searchForRequestTask:(NSURLSessionTask*)task InArray:(NSMutableArray*)Request {
    int index = -1;
    
    for (SKBaseRquest* request in Request) {
        index++;

        if (request.getTaskID == task.taskIdentifier) {
            return  index;
        }
    }
    return index;
}

-(void)checkRequestSuuccededOrFailed:(SKBaseRquest*)currentRequest task:(NSURLSessionTask*)task data:(NSData*)data{
    if (task.error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            currentRequest.getFailureHandler(data,task.response,task.error);
        });
    }else{
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *) task.response statusCode];
            if (statusCode > 400) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    currentRequest.getFailureHandler(data,task.response,task.error);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    currentRequest.getSuccessHandler(data,task.response,task.error);
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                currentRequest.getSuccessHandler(data,task.response,task.error);
            });
        }
    }
}


-(void)addrequestFromPendingQueue{
    
    activeRequestsNumber--;
    if (pendingRequestQueue.count > 0) {
        [self addRequestToQueue:pendingRequestQueue[0]];
        [pendingRequestQueue removeObjectAtIndex:0];
    }
    
    if (activeRequestsNumber == 0 && pendingRequestQueue.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });

    }
    
}



@end
