//
//  PJFImageTitleMessageView.m
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "PJFImageTitleMessageView.h"

#if __has_include("PJFDataSource-Swift.h")
#import "PJFDataSource-Swift.h"
#else
#import <PJFDataSource/PJFDataSource-Swift.h>
#endif


#import "PJFAction.h"

@interface PJFImageTitleMessageView ()

@property (nonatomic) UIView *nonKeyboardAreaView;
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *actionButton;
@property (nonatomic) PJFKeyboardLayoutHelper *keyboardLayoutHelper;

@end


@implementation PJFImageTitleMessageView

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _nonKeyboardAreaView = [[UIView alloc] initWithFrame:CGRectZero];
    _nonKeyboardAreaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_nonKeyboardAreaView];
    
    _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing = 8.0;
    _stackView.alignment = UIStackViewAlignmentCenter;
    [_nonKeyboardAreaView addSubview:_stackView];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.hidden = YES;
    [_stackView addArrangedSubview:_imageView];
    [_stackView setCustomSpacing:16 afterView:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_stackView addArrangedSubview:_titleLabel];

    _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [_stackView addArrangedSubview:_messageLabel];

    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    _actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _actionButton.hidden = YES;
    [_stackView addArrangedSubview:_actionButton];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nonKeyboardAreaView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nonKeyboardAreaView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_nonKeyboardAreaView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    NSLayoutConstraint *bottomToKeyboardConstraint = [NSLayoutConstraint constraintWithItem:_nonKeyboardAreaView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self addConstraint:bottomToKeyboardConstraint];

    _keyboardLayoutHelper = [[PJFKeyboardLayoutHelper alloc] initWithView:self bottomConstraint:bottomToKeyboardConstraint];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_nonKeyboardAreaView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stackView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_nonKeyboardAreaView attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_nonKeyboardAreaView attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:_nonKeyboardAreaView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_nonKeyboardAreaView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_stackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_nonKeyboardAreaView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews;
{
    // TODO(mthole): This should be configuration via UI_APPEARANCE or similar.
    const CGFloat labelHorizontalInset = 40;
    
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - (labelHorizontalInset * 2);
    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - (labelHorizontalInset * 2);

    [super layoutSubviews];
}

#pragma mark - Public Methods

- (UIImage *)image;
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image;
{
    self.imageView.image = image;
    self.imageView.hidden = image == nil;
}

- (NSString *)title;
{
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title;
{
    self.titleLabel.text = title;
}

- (UIFont *)titleFont;
{
    return self.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)titleFont;
{
    self.titleLabel.font = titleFont;
}

- (UIColor *)titleColor;
{
    return self.titleLabel.textColor;
}

- (void)setTitleColor:(UIColor *)titleColor;
{
    self.titleLabel.textColor = titleColor;
}

- (NSString *)message;
{
    return self.messageLabel.text;
}

- (void)setMessage:(NSString *)message;
{
    self.messageLabel.text = message;
}

- (UIFont *)messageFont;
{
    return self.messageLabel.font;
}

- (void)setMessageFont:(UIFont *)messageFont;
{
    self.messageLabel.font = messageFont;
}

- (UIColor *)messageColor;
{
    return self.messageLabel.textColor;
}

- (void)setMessageColor:(UIColor *)messageColor;
{
    self.messageLabel.textColor = messageColor;
}

- (void)setAction:(PJFAction *)action;
{
    _action = action;
    
    [self.actionButton removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
    [self.actionButton addTarget:self action:@selector(_actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton setTitle:action.title forState:UIControlStateNormal];
    [self.actionButton setHidden:action == nil || action.title.length == 0];
}

- (void)setActionFont:(UIFont *)font;
{
    self.actionButton.titleLabel.font = font;
}

- (UIFont *)actionFont
{
    return self.actionButton.titleLabel.font;
}

- (void)setActionColor:(UIColor *)color forState:(UIControlState)state;
{
    [self.actionButton setTitleColor:color forState:state];
}

#pragma mark - Private Methods

- (void)_actionButtonPressed:(id)sender;
{
    SEL action = self.action.selector;
    id target = sender;
    
    while (target && ![target canPerformAction:action withSender:sender]) {
        target = [target nextResponder];
    }

    [[UIApplication sharedApplication] sendAction:action to:target from:sender forEvent:nil];
}

@end
