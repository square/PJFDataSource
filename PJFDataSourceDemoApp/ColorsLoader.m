//
//  ColorsLoader.m
//  PJFTestApplication
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "ColorsLoader.h"

@implementation ColorsLoader

const NSTimeInterval loadingDelay = 1.0;

- (void)asyncLoadColorsWithSuccess:(void(^)(NSArray *colors))success error:(void(^)(NSError *))failure;
{
    switch (self.nextResponseType) {
            
        case ColorsLoaderNextResponseTypeSuccess: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(loadingDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *colors = [self randomVibrantColors];
                success(colors);
            });
            break;
        }
        case ColorsLoaderNextResponseTypeEmpty: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(loadingDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *colors = @[];
                success(colors);
            });
            break;
        }
        case ColorsLoaderNextResponseTypeError: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(loadingDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                failure([NSError errorWithDomain:@"SomeError" code:1 userInfo:nil]);
            });
            break;
        }
    }
}

#pragma mark - Private Methods

- (NSArray <UIColor *> *)randomVibrantColors;
{
    NSMutableArray <UIColor *> *colors = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 25; i++) {
        [colors addObject:[UIColor colorWithHue:arc4random_uniform(255) / 255.0
                                     saturation:(arc4random_uniform(128) + 127) / 255.0 // > 0.5 saturated
                                     brightness:(arc4random_uniform(128) + 127) / 255.0 // > 0.5 brightness
                                          alpha:1.0]];
    }
    
    return colors;
}

@end
