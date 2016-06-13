//
//  PJFImageTitleMessageView.h
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

@import UIKit;

@class PJFAction;


NS_ASSUME_NONNULL_BEGIN

@interface PJFImageTitleMessageView : UIView <UIAppearance>

@property (nonatomic, nullable) UIImage *image UI_APPEARANCE_SELECTOR;

@property (nonatomic, nullable) NSString *title;
@property (nonatomic) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *titleColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, nullable) NSString *message;
@property (nonatomic) UIFont *messageFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *messageColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, nullable) PJFAction *action;
@property (nonatomic) UIFont *actionFont UI_APPEARANCE_SELECTOR;
- (void)setActionColor:(UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
