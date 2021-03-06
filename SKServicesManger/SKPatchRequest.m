//
//  SKPatchRequest.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKPatchRequest.h"
#import "SKSessionManger.h"

@interface SKPatchRequest ()

@property  NSDictionary* parameters;

@end


@implementation SKPatchRequest
- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler parameters:(NSDictionary*)parameters {
    self = [super initWithPath:path method:PATCH headers:headers successHandler:successHandler failureHandler:failureHandler];
    self.parameters = parameters;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[SKSessionManger sharedSessionManger] baseUrl] ,self.getPath]];
    self.fullUrl = url;

    return self;
}


-(id)init{
    NSString* assertionReason = [NSString stringWithFormat:@"Please use %@ parameterized  initializer",self.class];
    NSAssert(false, assertionReason);
    return [self initWithPath:@"" headers:[NSDictionary new] successHandler:nil failureHandler:nil parameters:[NSDictionary new]];
}

-(NSMutableURLRequest*) getMethodRequestObject{

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.fullUrl];
    [request setHTTPMethod:@"PATCH"];
    
    NSString* parametersString = [self.parameters serializeParameters];
    NSData *parametersrData = [NSData dataWithBytes: [parametersString UTF8String] length: [parametersString length]];
    
    [self.getHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    [request setHTTPBody:parametersrData];
    
    
    return request;
}

-(NSURL*)getURL{
    
    return self.fullUrl;
}
@end
