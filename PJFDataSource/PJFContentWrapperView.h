//
//  PJFContentWrapperView.h
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

@import UIKit;

@class PJFImageTitleMessageView;

@protocol PJFContentWrapperViewDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface PJFContentWrapperView : UIView

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, weak, nullable) id <PJFContentWrapperViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame contentView:(UIView *)contentView;

- (BOOL)isShowingContentView;

- (void)showContentView;
- (void)showLoadingPlaceholderView;
- (void)showNoContentPlaceholderView;
- (void)showErrorPlaceholderViewWithError:(NSError *)error;

@end


@protocol PJFContentWrapperViewDelegate <NSObject>
@optional
- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView willShowNoContentView:(PJFImageTitleMessageView *)placeholderView;
- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView willShowErrorView:(PJFImageTitleMessageView *)placeholderView withError:(NSError *)error;
- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView willShowContentView:(UIView *)contentView;

- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView didShowNoContentView:(PJFImageTitleMessageView *)placeholderView;
- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView didShowErrorView:(PJFImageTitleMessageView *)placeholderView;
- (void)contentWrapperView:(PJFContentWrapperView *)wrapperView didShowContentView:(UIView *)contentView;

@end

NS_ASSUME_NONNULL_END
