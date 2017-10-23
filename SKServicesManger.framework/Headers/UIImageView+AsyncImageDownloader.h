//
//  UIImageView+AsyncImageDownloader.h
//  SKServicesManger
//
//  Created by sherif on 8/7/17.
//  Copyright © 2017 Sherif Khaled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSessionManger.h"

@interface UIImageView (AsyncImageDownloader)
-(void)setImageWithUrl:(NSString*)imageUrl activtyIndicatorTintColor:(UIColor*)tintColor failureImage:(UIImage*)failureImage;
@end
