//
//  UIImageView+AsyncImageDownloader.m
//  SKServicesManger
//
//  Created by sherif on 8/7/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import "UIImageView+AsyncImageDownloader.h"

@implementation UIImageView (AsyncImageDownloader)
-(void)setImageWithUrl:(NSString*)imageUrl activtyIndicatorTintColor:(UIColor*)tintColor failureImage:(UIImage*)failureImage{
    NSString* oldBaseUrlValue = [[SKSessionManger sharedSessionManger] baseUrl];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setCenter: self.center];
    [activityIndicator startAnimating];
    [activityIndicator setColor:tintColor];
    [self addSubview:activityIndicator];

    [[SKSessionManger sharedSessionManger] setBaseUrlValue:@""];
    
    SKDownloadRequest* downloadRequest = [[SKDownloadRequest alloc] initWithPath:imageUrl headers:[NSDictionary new] successHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [[SKSessionManger sharedSessionManger] setBaseUrl:oldBaseUrlValue];
        if (response != nil) {
            UIImage* image = [UIImage imageWithData:data];
            if (image != nil) {
                self.image = image;
            }else{
                self.image = failureImage;
            }
        }else{
            self.image = failureImage;
        }
    } failureHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[SKSessionManger sharedSessionManger] setBaseUrl:oldBaseUrlValue];
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        self.image = failureImage;
    }];
    
    
    [[SKSessionManger sharedSessionManger] addRequestToQueue:downloadRequest];
}
@end
