//
//  PJFLoadingView.h
//  PJFDataSource
//
//  Created by Michael Thole on 8/12/15.
//  Copyright (c) 2015-2016 Square, Inc. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface PJFLoadingView : UIView

@property (nonatomic, nullable) UIImage *loadingImage UI_APPEARANCE_SELECTOR;

- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
