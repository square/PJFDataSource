//
//  PJFImageTitleMessageView.m
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

#import "PJFImageTitleMessageView.h"
#import "PJFAction.h"

@interface PJFImageTitleMessageView ()

@property (nonatomic) UIView *containerView;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *actionButton;

@end


@implementation PJFImageTitleMessageView

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _containerView = [[UIView alloc] initWithFrame:CGRectZero];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_containerView];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:_titleLabel];

    _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _messageLabel.numberOfLines = 0;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:_messageLabel];
    
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    _actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_containerView addSubview:_actionButton];
    
    [self _setUpConstraints];

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

- (void)_setUpConstraints;
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _titleLabel, _messageLabel, _actionButton);
    
    // Image, title, and message views are contained within the container view.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]-16-[_titleLabel]-8-[_messageLabel]-8-[_actionButton]-20-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_imageView]->=0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_messageLabel]|" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_actionButton]->=0-|" options:0 metrics:nil views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
