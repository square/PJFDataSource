//
//  PJFAction.h
//  PJFDataSource
//
//  Created by James Hu on 8/24/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PJFAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title selector:(SEL)selector;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) SEL selector;

@end

NS_ASSUME_NONNULL_END
