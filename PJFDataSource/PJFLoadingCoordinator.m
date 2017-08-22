//
//  PJFLoadingCoorindator.m
//  PJFDataSource
//
//  Created by Michael Thole on 8/11/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "PJFLoadingCoordinator.h"

#import "PJFDataSource.h"
#import "PJFContentWrapperView.h"

@interface PJFLoadingCoordinator ()

@property (atomic) PJFLoadingState *loadingState;
@property (nonatomic, weak) PJFDataSource *dataSource;

@end

@interface PJFLoadingState ()

@property (atomic, readwrite) BOOL valid;

@end


@implementation PJFLoadingCoordinator

- (instancetype)init { @throw nil; }

- (instancetype)initWithDataSource:(PJFDataSource *)dataSource;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _dataSource = dataSource;
    
    return self;
}

#pragma mark - Public Methods

- (void)loadContentWithBlock:(PJFLoadingBlock)block;
{
    [self loadContentWithBlock:block allowingContentViewToRemain:NO];
}

- (void)loadContentWithBlock:(PJFLoadingBlock)block allowingContentViewToRemain:(BOOL)allowContentViewToRemain;
{
    [self.loadingState invalidate];
    self.loadingState = [PJFLoadingState new];
    self.loadingState.valid = YES;
    
    if ([self.dataSource.delegate respondsToSelector:@selector(dataSourceWillBeginLoading:)]) {
        [self.dataSource.delegate dataSourceWillBeginLoading:self.dataSource];
    }
    
    BOOL showingContentView = [[self _contentWrapperView] isShowingContentView];
    
    if (!showingContentView || !allowContentViewToRemain) {
        [[self _contentWrapperView] showLoadingPlaceholderView];
    }
    
    if (block) {
        block(self.loadingState);
    }
}

- (void)loadContentDidFinishWithError:(NSError *)error;
{
    if ([self.dataSource.delegate respondsToSelector:@selector(dataSourceDidFinishLoading:withError:)]) {
        [self.dataSource.delegate dataSourceDidFinishLoading:self.dataSource withError:error];
    }

    if (error) {
        [[self _contentWrapperView] showErrorPlaceholderViewWithError:error];
    } else if ([self.dataSource hasContent] == NO) {
        [[self _contentWrapperView] showNoContentPlaceholderView];
    } else {
        [[self _contentWrapperView] showContentView];
    }
}

#pragma mark - Private Methods

- (PJFContentWrapperView *)_contentWrapperView;
{
    id <PJFDataSourceDelegate> dataSourceDelegate = self.dataSource.delegate;
    PJFContentWrapperView *contentWrapperView = [dataSourceDelegate contentWrapperViewForDataSource:self.dataSource];
    return contentWrapperView;
}

@end


@implementation PJFLoadingState

- (void)invalidate;
{
    self.valid = NO;
}

@end
