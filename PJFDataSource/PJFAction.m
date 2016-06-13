//
//  PJFAction.m
//  PJFDataSource
//
//  Created by James Hu on 8/24/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "PJFAction.h"

@interface PJFAction ()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) SEL selector;

@end

@implementation PJFAction

+ (instancetype)actionWithTitle:(NSString *)title selector:(SEL)selector
{
    PJFAction *action = [[self alloc] init];
    action.title = title;
    action.selector = selector;
    return action;
}

@end
