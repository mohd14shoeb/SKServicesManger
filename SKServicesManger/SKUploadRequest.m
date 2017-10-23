//
//  SKUploadRequest.m
//  SKServicesManger
//
//  Created by sherif on 8/5/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKUploadRequest.h"
#import "SKSessionManger.h"

@interface SKUploadRequest ()

@property  NSData* fileData;

@end


@implementation SKUploadRequest
- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler fileData:(NSData*)fileData {
    self = [super initWithPath:path method:UPLOAD headers:headers successHandler:successHandler failureHandler:failureHandler];
    self.fileData = fileData;
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[SKSessionManger sharedSessionManger] baseUrl] ,self.getPath]];
    self.fullUrl = url;

    return self;
}


-(id)init{
    NSString* assertionReason = [NSString stringWithFormat:@"Please use %@ parameterized  initializer",self.class];
    NSAssert(false, assertionReason);
    return [self initWithPath:@"" headers:[NSDictionary new] successHandler:nil failureHandler:nil fileData:[NSData new]];
}


-(NSMutableURLRequest*) getMethodRequestObject{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.fullUrl];
    [request setHTTPMethod:@"POST"];

    return request;
}

-(NSData*)getFileData{
    return self.fileData;
}


-(NSURL*)getURL{
    
    return self.fullUrl;
}

@end
