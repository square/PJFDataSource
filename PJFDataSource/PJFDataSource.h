//
//  PJFDataSource.h
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

@import UIKit;

#import "PJFLoadingCoordinator.h"
#import "PJFContentWrapperView.h"
#import "PJFImageTitleMessageView.h"
#import "PJFLoadingView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PJFDataSourceDelegate;


@interface PJFDataSource : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id <PJFDataSourceDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)loadContent;

- (BOOL)hasContent;

@property (nonatomic, readonly, weak, nullable) id <PJFDataSourceDelegate> delegate;
@property (nonatomic, readonly) PJFLoadingCoordinator *loadingCoordinator;

@end


@protocol PJFDataSourceDelegate <NSObject>

- (PJFContentWrapperView *)contentWrapperViewForDataSource:(PJFDataSource *)dataSource;

@optional
- (void)dataSourceWillBeginLoading:(PJFDataSource *)dataSource;
- (void)dataSourceDidFinishLoading:(PJFDataSource *)dataSource withError:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
