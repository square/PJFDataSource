//
//  PJFLoadingView.m
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "PJFLoadingView.h"

@interface PJFLoadingView ()

@property (nonatomic) UIImageView *loadingImageView;

@end


@implementation PJFLoadingView

static NSString *rotationKeyPath = @"transform.rotation";

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _loadingImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_loadingImageView];
    
    [self _setUpConstraints];
    
    return self;
}

#pragma mark - UIView

- (void)didMoveToWindow;
{
    [super didMoveToWindow];

    if (self.window) {
        [self startAnimating];
    }
}

#pragma mark - Public  Methods

- (UIImage *)loadingImage;
{
    return self.loadingImageView.image;
}

- (void)setLoadingImage:(UIImage *)loadingImage;
{
    self.loadingImageView.image = loadingImage;
}

- (void)startAnimating;
{
    CAKeyframeAnimation *rotation = [CAKeyframeAnimation animationWithKeyPath:rotationKeyPath];
    rotation.duration = 0.8;
    rotation.values = @[@0.0f, @(2.0 * M_PI)];
    rotation.repeatCount = FLT_MAX;
    [self.loadingImageView.layer addAnimation:rotation forKey:rotationKeyPath];
    self.loadingImageView.hidden = NO;
}

- (void)stopAnimating;
{
    [self.loadingImageView.layer removeAnimationForKey:rotationKeyPath];
    self.loadingImageView.hidden = YES;
}

#pragma mark - Private Methods

- (void)_setUpConstraints;
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
