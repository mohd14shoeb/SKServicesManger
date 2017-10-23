//
//  SKBaseRquest.h
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+SerializeParameters.h"

typedef enum {
    GET, POST, PUT, DELETE, PATCH, DOWNLOAD, UPLOAD
}SKRequestMethodType;

typedef void(^handlerBlock)(NSData* responseData,NSURLResponse* urlResponse, NSError *error);


@interface SKBaseRquest : NSObject

@property NSURL* fullUrl;
- (id)initWithPath:(NSString*)path method:(SKRequestMethodType)method headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler;
-(NSMutableURLRequest*) getMethodRequestObject;


-(NSString*)getPath;
-(SKRequestMethodType)getRequestType;
-(NSDictionary*)getHeaders;
-(handlerBlock)getSuccessHandler;
-(handlerBlock)getFailureHandler;

-(NSURL*)getURL;

-(void)setTaskID:(NSUInteger)taskIdentifier;
-(NSUInteger)getTaskID;
@end
