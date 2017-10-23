//
//  SKMultiPartFormUploadRequest.m
//  backgroundSessionTest
//
//  Created by sherif on 8/7/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "SKMultiPartFormUploadRequest.h"
#import "SKSessionManger.h"
@import MobileCoreServices;

@interface SKMultiPartFormUploadRequest ()

@property NSString* filePath;
@property NSString* fieldName;

@end

@implementation SKMultiPartFormUploadRequest

- (id)initWithPath:(NSString*)path headers:(NSDictionary*)headers successHandler:(handlerBlock)successHandler failureHandler:(handlerBlock)failureHandler parameters:(NSDictionary*)parameters filePath:(NSString*)filePath  fieldName:(NSString*)fieldName{
    self = [super initWithPath:path headers:headers successHandler:successHandler failureHandler:failureHandler parameters:parameters];
    self.filePath = filePath;
    self.fieldName = fieldName;
    
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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.fullUrl];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [self generateBoundaryString];
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:[self getParameters] paths:self.filePath fieldName:self.fieldName];
    
    request.HTTPBody = httpBody;
    
    [self.getHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    return request;
}


- (NSData *)createBodyWithBoundary:(NSString *)boundary parameters:(NSDictionary *)parameters paths:(NSString *)path fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    
    NSString *filename  = [path lastPathComponent];
    NSData   *data      = [NSData dataWithContentsOfFile:path];
    NSString *mimetype  = [self mimeTypeForPath:path];
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}


- (NSString *)mimeTypeForPath:(NSString *)path {
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

@end
