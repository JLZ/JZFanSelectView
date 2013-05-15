//
//  JZFanView.m
//  SelectButton
//
//  Created by Jeremy Zedell on 5/4/13.
//  Copyright (c) 2013 Jeremy Zedell. All rights reserved.
//

#import "JZFanView.h"

@implementation JZFanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [[UIButton alloc] initWithFrame:frame];
		[self.button setBackgroundColor:[UIColor clearColor]];
		[self.button setTitle:@"" forState:UIControlStateNormal];
		[self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self addSubview:self.button];
		[self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		self.button.autoresizesSubviews = NO;
    }
    return self;
}

- (void)buttonPressed:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(fanViewSelectedWithIndex:)])
		[self.delegate fanViewSelectedWithIndex:self.index];
}

- (void)setTitle:(NSString *)title
{
	_title = title;
	[self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
	if (self.backgroundView && self.backgroundView.superview)
	{
		[self.backgroundView removeFromSuperview];
		_backgroundView = nil;
	}
	
	_backgroundView = backgroundView;
	[self addSubview:self.backgroundView];
	[self bringSubviewToFront:self.button];
//	[self insertSubview:self.backgroundView belowSubview:self.button];
}

- (void)setFont:(UIFont *)font
{
	self.button.titleLabel.font = font;
}

- (void)setTextColor:(UIColor *)color
{
	[self.button setTitleColor:color forState:UIControlStateNormal];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
	[self.button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
	self.button.titleLabel.shadowOffset = shadowOffset;
}

@end
