//
//  SKGetRequest.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKGetRequest.h"
#import "SKSessionManger.h"


@interface SKGetRequest ()

@property  NSString* urlParameters;

@end

@implementation SKGetRequest

- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler urlParameters:(NSString*)urlParameters {
    self = [super initWithPath:path method:GET headers:headers successHandler:successHandler failureHandler:failureHandler];
    self.urlParameters = urlParameters;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",[[SKSessionManger sharedSessionManger] baseUrl] ,self.getPath,self.urlParameters]];
    self.fullUrl = url;

    return self;
}

-(id)init{
    NSString* assertionReason = [NSString stringWithFormat:@"Please use %@ parameterized  initializer",self.class];
    NSAssert(false, assertionReason);
    return [self initWithPath:@"" headers:[NSDictionary new] successHandler:nil failureHandler:nil urlParameters:@"" ];
}

-(NSMutableURLRequest*) getMethodRequestObject{
    self.urlParameters = [self.urlParameters stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.fullUrl];
    [request setHTTPMethod:@"GET"];
    
    [self.getHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    
    return request;
}

-(NSURL*)getURL{
    
    return self.fullUrl;
}


@end
