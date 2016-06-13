//
//  ColorsDataSource.h
//  PJFTestApplication
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

@import UIKit;

#import "PJFDataSource.h"
#import "ColorsLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorsDataSource : PJFDataSource <UITableViewDataSource>

- (instancetype)initWithDelegate:(id <PJFDataSourceDelegate>)delegate colorsLoader:(ColorsLoader *)colorsLoader;

@property (nonatomic) NSArray *colors;

@end

NS_ASSUME_NONNULL_END
