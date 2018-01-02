//
//  PJFContentWrapperView.m
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "PJFContentWrapperView.h"

#import "PJFLoadingView.h"
#import "PJFImageTitleMessageView.h"


@interface PJFContentWrapperView ()

@property (nonatomic) UIView *contentView;

@property (nonatomic, weak) PJFLoadingView *loadingPlaceholderView;
@property (nonatomic, weak) PJFImageTitleMessageView *noContentPlaceholderView;
@property (nonatomic, weak) PJFImageTitleMessageView *errorPlaceholderView;

@end


@implementation PJFContentWrapperView

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView;
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _contentView = contentView;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self _showOnlySubview:_contentView animated:NO];
    
    return self;
}

#pragma mark - Public Methods

- (BOOL)isShowingLoadingView;
{
    return [self _isShowingOnlySubview:self.loadingPlaceholderView];
}

- (BOOL)isShowingContentView;
{
    return [self _isShowingOnlySubview:self.contentView];
}

- (void)showContentView;
{
    if ([self isShowingContentView]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:willShowContentView:)]) {
        [self.delegate contentWrapperView:self willShowContentView:self.contentView];
    }
    
    [self _showOnlySubview:self.contentView animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:didShowContentView:)]) {
        [self.delegate contentWrapperView:self didShowContentView:self.contentView];
    }
}

- (void)showLoadingPlaceholderView;
{
    PJFLoadingView *loadingView = [self _lazyLoadingPlaceholderView];
    
    if ([self _isShowingOnlySubview:loadingView]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:willShowLoadingView:)]) {
        [self.delegate contentWrapperView:self willShowLoadingView:loadingView];
    }
    
    [self _showOnlySubview:loadingView animated:YES];
    [loadingView startAnimating];
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:didShowLoadingView:)]) {
        [self.delegate contentWrapperView:self didShowLoadingView:loadingView];
    }
}

- (void)showNoContentPlaceholderView;
{
    PJFImageTitleMessageView *placeholderView = [self _lazyNoContentPlaceholderView];
    
    if ([self _isShowingOnlySubview:placeholderView]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:willShowNoContentView:)]) {
        [self.delegate contentWrapperView:self willShowNoContentView:placeholderView];
    }
    
    [self _showOnlySubview:placeholderView animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:didShowNoContentView:)]) {
        [self.delegate contentWrapperView:self didShowNoContentView:placeholderView];
    }
}

- (void)showErrorPlaceholderViewWithError:(NSError *)error;
{
    PJFImageTitleMessageView *placeholderView = [self _lazyErrorPlaceholderView];
    
    if ([self _isShowingOnlySubview:placeholderView]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:willShowErrorView:withError:)]){
        [self.delegate contentWrapperView:self willShowErrorView:placeholderView withError:error];
    }
    
    [self _showOnlySubview:placeholderView animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(contentWrapperView:didShowErrorView:)]) {
        [self.delegate contentWrapperView:self didShowErrorView:placeholderView];
    }
}

#pragma mark - Private Methods

- (BOOL)_isShowingOnlySubview:(UIView *)subview;
{
    if (!subview) {
        return false;
    }
    return [self.subviews isEqualToArray:@[subview]];
}

- (void)_showOnlySubview:(UIView *)subviewToShow animated:(BOOL)animated;
{
    if (![self window]) {
        animated = NO;
    }
    
    [self addSubview:subviewToShow];
    [self sendSubviewToBack:subviewToShow];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subviewToShow]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subviewToShow)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subviewToShow]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subviewToShow)]];
    [self layoutIfNeeded];
    
    dispatch_block_t animations = ^{
        for (UIView *subview in self.subviews) {
            if (subview != subviewToShow) {
                [subview removeFromSuperview];
            }
        }
    };
    
    if (animated) {
        [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:animations completion:nil];
    } else {
        animations();
    }
}

- (PJFLoadingView *)_lazyLoadingPlaceholderView;
{
    if (self.loadingPlaceholderView) {
        return self.loadingPlaceholderView;
    }
    
    PJFLoadingView *view = [[PJFLoadingView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.loadingPlaceholderView = view;
    
    return self.loadingPlaceholderView;
}


- (PJFImageTitleMessageView *)_lazyNoContentPlaceholderView;
{
    if (self.noContentPlaceholderView) {
        return self.noContentPlaceholderView;
    }
    
    PJFImageTitleMessageView *view = [[PJFImageTitleMessageView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    view.title = NSLocalizedString(@"Oops!", @"Generic no content placeholder view title");
    view.message = NSLocalizedString(@"It doesn’t look like there is anything here.", @"Generic no content placeholder view message");
    
    self.noContentPlaceholderView = view;
    
    return self.noContentPlaceholderView;
}

- (PJFImageTitleMessageView *)_lazyErrorPlaceholderView;
{
    if (self.errorPlaceholderView) {
        return self.errorPlaceholderView;
    }
    
    PJFImageTitleMessageView *view = [[PJFImageTitleMessageView alloc] initWithFrame:CGRectZero];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    view.title = NSLocalizedString(@"Oops!", @"Generic error placeholder view title");
    view.message = NSLocalizedString(@"Sorry, something went wrong.", @"Generic error placeholder view message");
    
    self.errorPlaceholderView = view;
    
    return self.errorPlaceholderView;
}

@end
