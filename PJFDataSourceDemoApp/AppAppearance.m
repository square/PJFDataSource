//
//  AppAppearance.m
//  PJFTestApplication
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "AppAppearance.h"

#import "PJFLoadingView.h"
#import "PJFImageTitleMessageView.h"

@implementation AppAppearance

+ (void)applyAppearance;
{
    [[PJFLoadingView appearance] setLoadingImage:[UIImage imageNamed:@"Spinner"]];

    [[PJFImageTitleMessageView appearance] setImage:[UIImage imageNamed:@"SadFace"]];
    [[PJFImageTitleMessageView appearance] setTitleFont:[UIFont boldSystemFontOfSize:16.0]];
    [[PJFImageTitleMessageView appearance] setMessageFont:[UIFont systemFontOfSize:14.0]];
    [[PJFImageTitleMessageView appearance] setActionFont:[UIFont boldSystemFontOfSize:16.0]];
    [[PJFImageTitleMessageView appearance] setActionColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

@end
