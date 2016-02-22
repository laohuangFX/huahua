//
//  HATransparentView.m
//  HATransparentView
//
//  Created by Heberti Almeida on 13/09/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import "HATransparentView.h"

#define kDefaultBackground [UIColor colorWithWhite:0.0 alpha:0.9];

@interface HATransparentView ()

@property(nonatomic, retain) UIBlurEffect *blurEffect;
@property(nonatomic, retain) UIView *blurredView;
@property(nonatomic, assign) NSInteger statusBarStyle;

@end

@implementation HATransparentView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.opaque = NO;
        self.backgroundColor = kDefaultBackground;
        self.useBlur = NO;
        self.blurEffectStyle = UIBlurEffectStyleLight;
        self.hideCloseButton = NO;
        self.tapBackgroundToClose = NO;
    }
    return self;
}

- (void)tapBackgroundToClose:(BOOL)close {
    if (close) {
        [self addTapGestureRecognizer];
    }
}

- (void)blurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    if (self.blurredView != nil && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        if (self.blurredView.superview != nil) [self.blurredView removeFromSuperview];
        self.blurredView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffect];
        self.blurredView.frame = self.frame;
        [self insertSubview:self.blurredView atIndex:0];
    }
}

- (void)useBlur:(BOOL)useBlur {
    if (useBlur && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if (self.blurredView == nil) {
            self.blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
            self.blurredView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffect];
            self.blurredView.frame = self.frame;
            [self insertSubview:self.blurredView atIndex:0];
        } else if (self.blurredView.superview == nil) {
            [self insertSubview:self.blurredView atIndex:0];
        }
    } else if (self.blurredView != nil) {
        [self.blurredView removeFromSuperview];
    }
}

#pragma mark - Open Transparent View

- (void)open {
    // Get main window reference
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];

    // Get current statusBarStyle
    self.statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];

    // Close button
    if (!self.hideCloseButton) {
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        close.frame = CGRectMake(self.frame.size.width - 60, 26, 60, 30);
        [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:close];

		NSString *imageName = nil;
		UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;

		switch (self.style) {
			case HAStyleLight: {
				imageName = @"btn-close";
				statusBarStyle = UIStatusBarStyleLightContent;
				break;
			}
			case HAStyleBlack: {
				imageName = @"btn-close-black";
				statusBarStyle = UIStatusBarStyleDefault;
				break;
			}
		}

		UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

		[close setImage:image forState:UIControlStateNormal];
		[[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
    }

    // Animation
    CATransition *viewIn = [CATransition animation];
    [viewIn setDuration:0.4];
    [viewIn setType:kCATransitionReveal];
    [viewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self layer] addAnimation:viewIn forKey:kCATransitionReveal];

    [[[window subviews] objectAtIndex:0] addSubview:self];
}

#pragma mark - Close Transparent View

- (void)close {
    // Animation
    CATransition *viewOut = [CATransition animation];
    [viewOut setDuration:0.3];
    [viewOut setType:kCATransitionFade];
    [viewOut setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.superview layer] addAnimation:viewOut forKey:kCATransitionFade];

    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    [self removeFromSuperview];

    [self.delegate HATransparentViewDidClosed];
}

#pragma mark - UITapGestureRecognizer

- (void)addTapGestureRecognizer {
   // UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    //[self addGestureRecognizer:tapGesture];
}

- (void)close:(UITapGestureRecognizer *)sender {
    //[self close];
}

@end