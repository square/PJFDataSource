//
//  ColorsLoader.h
//  PJFTestApplication
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, ColorsLoaderNextResponseType) {
    ColorsLoaderNextResponseTypeSuccess,
    ColorsLoaderNextResponseTypeEmpty,
    ColorsLoaderNextResponseTypeError
};

NS_ASSUME_NONNULL_BEGIN

@interface ColorsLoader : NSObject

@property (nonatomic) ColorsLoaderNextResponseType nextResponseType;

- (void)asyncLoadColorsWithSuccess:(void(^)(NSArray *colors))success error:(void(^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
