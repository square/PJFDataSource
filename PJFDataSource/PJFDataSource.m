//
//  PJFDataSource.m
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "PJFDataSource.h"

#import "PJFLoadingCoordinator.h"


@implementation PJFDataSource

- (instancetype)init { @throw nil; }

- (instancetype)initWithDelegate:(id <PJFDataSourceDelegate>)delegate;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _delegate = delegate;
    _loadingCoordinator = [[PJFLoadingCoordinator alloc] initWithDataSource:self];
    
    return self;
}

#pragma mark - Public Methods

- (void)loadContent;
{
    // For subclasses.
}

- (BOOL)hasContent;
{
    // For subclasses.
    return NO;
}

@end
