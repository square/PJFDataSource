//
//  PJFLoadingCoorindator.h
//  PJFDataSource
//
//  Created by Michael Thole on 8/11/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

@import UIKit;

@class PJFDataSource;
@class PJFLoadingState;
@class PJFContentWrapperView;
@class PJFLoadingCoordinator;


NS_ASSUME_NONNULL_BEGIN

typedef void (^PJFLoadingBlock)(PJFLoadingState *loadingState);


@interface PJFLoadingCoordinator : NSObject

- (instancetype)init NS_UNAVAILABLE;

// If specified, the loading coordinator will interact with the dataSource and it's contentWrapperView.
// A nil dataSource  may be used if you only want the PJFLoadingState invalidation.
- (instancetype)initWithDataSource:(nullable PJFDataSource *)dataSource NS_DESIGNATED_INITIALIZER;

- (void)loadContentWithBlock:(PJFLoadingBlock)block;
- (void)loadContentWithBlock:(PJFLoadingBlock)block allowingContentViewToRemain:(BOOL)allowContentViewToRemain;
- (void)loadContentDidFinishWithError:(nullable NSError *)error;

@end


@interface PJFLoadingState : NSObject

@property (atomic, readonly, getter=isValid) BOOL valid;

- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
