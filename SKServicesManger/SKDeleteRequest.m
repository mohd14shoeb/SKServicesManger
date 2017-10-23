//
//  SKDeleteRequest.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKDeleteRequest.h"
#import "SKSessionManger.h"

@implementation SKDeleteRequest
- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler
{
    self = [super  initWithPath:path method:DELETE headers:headers successHandler:successHandler failureHandler:failureHandler];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[SKSessionManger sharedSessionManger] baseUrl] ,self.getPath]];
    self.fullUrl = url;

    return self;
}


-(id)init{
    NSString* assertionReason = [NSString stringWithFormat:@"Please use %@ parameterized  initializer",self.class];
    NSAssert(false, assertionReason);
    return [self initWithPath:@"" headers:[NSDictionary new] successHandler:nil failureHandler:nil];
}


-(NSMutableURLRequest*) getMethodRequestObject{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.fullUrl];
    [request setHTTPMethod:@"DELETE"];
    
    [self.getHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    
    return request;
}

-(NSURL*)getURL{
    
    return self.fullUrl;
}

@end
