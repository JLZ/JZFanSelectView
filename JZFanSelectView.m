//
//  JZFanSelectView.m
//  SelectButton
//
//  Created by Jeremy Zedell on 5/4/13.
//  Copyright (c) 2013 Jeremy Zedell. All rights reserved.
//

#import "JZFanSelectView.h"

static const NSInteger kMainButtonIndex = 999999;
static const CGFloat kFanAnimationTime = 0.2;
static const CGFloat kFanScaleAmount = 1.2;

@interface JZFanSelectView()
- (void)arrangeSubviews;
- (NSInteger)centerIndex;
- (UIView*)getBaseView;
- (void)cancelButtonPressed:(id)sender;
@end

@implementation JZFanSelectView

- (id)initWithFrame:(CGRect)frame title:(NSString*)title delegate:(id<JZFanSelectViewDelegate>)delegate
{
	self = [self initWithFrame:frame];
	if (self)
	{
		self.delegate = delegate;
		_title = title;
		self.mainButton.title = title;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//		self.autoresizesSubviews = NO;
//		self.clipsToBounds = NO;
		self.buttons = [[NSMutableArray alloc] init];
        self.mainButton = [[JZFanView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		self.mainButton.backgroundColor = [UIColor clearColor];
		self.mainButton.title = @"";
		self.mainButton.delegate = self;
		self.mainButton.index = kMainButtonIndex;
		[self addSubview:self.mainButton];
		
		self.cancelButton = [[UIButton alloc] init];
		self.cancelButton.backgroundColor = [UIColor clearColor];
		//[self.cancelButton setTitle:@"" forState:UIControlStateNormal];
		[self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		self.selectedIndex = -1;
		self.scaleAmount = -1;
    }
    return self;
}

- (void)addOptionWithTitle:(NSString *)title
{
	JZFanView *fv = [[JZFanView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	fv.title = title;
	fv.delegate = self;
	[self.buttons addObject:fv];
	fv.index = self.buttons.count - 1;
	
	if (self.font)
		fv.font = self.font;
	
	if (self.textColor)
		fv.textColor = self.textColor;
	
	if (self.shadowColor)
		fv.shadowColor = self.shadowColor;
	
	if (self.shadowOffset.width != 0 || self.shadowOffset.height != 0)
		fv.shadowOffset = self.shadowOffset;
		
	
	if ([self.delegate respondsToSelector:@selector(backgroundViewForIndex:)])
	{
		UIView *bg = [self.delegate backgroundViewForIndex:fv.index];
		if (bg)
			fv.backgroundView = bg;
	}
}

- (void)setFont:(UIFont *)font
{
	_font = font;
	[self.mainButton setFont:font];
	
	for (JZFanView *v in self.buttons)
	{
		[v setFont:font];
	}
}

- (void)setTextColor:(UIColor *)color
{
	_textColor = color;
	[self.mainButton setTextColor:color];
	
	for (JZFanView *v in self.buttons)
	{
		[v setTextColor:color];
	}
}

- (void)setShadowColor:(UIColor *)shadowColor
{
	_shadowColor = shadowColor;
	
	self.mainButton.shadowColor = shadowColor;
	
	for (JZFanView *f in self.buttons)
	{
		f.shadowColor = shadowColor;
	}
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
	_shadowOffset = shadowOffset;
	
	self.mainButton.shadowOffset = shadowOffset;
	
	for (JZFanView *f in self.buttons)
	{
		f.shadowOffset = shadowOffset;
	}
}

- (void)setTitle:(NSString *)title
{
	_title = title;
	self.mainButton.title = title;
}

- (void)setBackgroundView:(UIView *)backgroundView
{
	self.mainButton.backgroundView = backgroundView;
}

- (void)setOptions:(NSMutableArray *)options
{
	for (NSString *o in options)
	{
		if ([o isKindOfClass:[NSString class]])
		{
			[self addOptionWithTitle:o];
		}
	}
}

- (NSInteger)centerIndex
{
	return self.buttons.count % 2 == 0 ? (self.buttons.count / 2) - 1 : floor((double)self.buttons.count / 2);
}

- (UIView*)getBaseView
{
	return self.baseView ? self.baseView : [[UIApplication sharedApplication].delegate window];
}

- (void)arrangeSubviews
{
	UIView *v = [self getBaseView];
	NSInteger index = self.selectedIndex > -1 ? self.selectedIndex : [self centerIndex];
	// reset ordering of subviews so animation looks nice when fanning in
	JZFanView *f = self.buttons[index];
	
	[v insertSubview:self.cancelButton belowSubview:f];
	self.cancelButton.frame = CGRectMake(0, 0, self.baseView.frame.size.width, self.baseView.frame.size.height);

	for (NSInteger i = 0; i < index; ++i)
	{
		[v insertSubview:self.buttons[i] belowSubview:f];
	}
	
	for (NSUInteger i = self.buttons.count - 1; i > index; --i)
	{
		[v insertSubview:self.buttons[i] belowSubview:f];
	}
}

#pragma mark - Animation methods

- (void)fanOut
{
	if (self.buttons.count > 1)
	{
		UIView *v = [self getBaseView];
		NSInteger centerIndex = [self centerIndex];
		CGPoint centerPoint = [self.superview convertPoint:self.center toView:v];
		
		for (int i = 0; i < self.buttons.count; ++i)
		{
			JZFanView *f = self.buttons[i];
			f.alpha = 0;
			f.center = centerPoint;
			[v addSubview:f];
		}
		
		[self arrangeSubviews];
		
		NSInteger topIndex = self.selectedIndex > -1 ? self.selectedIndex : centerIndex;
		CGFloat scaleAmount = self.scaleAmount == -1 ? kFanScaleAmount : self.scaleAmount;
		
		[UIView animateWithDuration:0.1
						 animations:^{
							 ((JZFanView*)self.buttons[topIndex]).alpha = 1;
						 }
						 completion:^(BOOL finished) {
							 for (int i = 0; i < self.buttons.count; ++i)
							 {
								 if (i != topIndex)
									 ((JZFanView*)self.buttons[i]).alpha = 1;
							 }
							 
							 [UIView animateWithDuration:kFanAnimationTime delay:0
												 options:UIViewAnimationOptionCurveEaseOut
											  animations:^{
												  for (int i = 0; i < self.buttons.count; ++i)
												  {
													  JZFanView *f = self.buttons[i];
													  if (scaleAmount != 0)
														  f.transform = CGAffineTransformMakeScale(scaleAmount, scaleAmount);
													  
													  if (i != centerIndex)
													  {
														  NSInteger diff = i - centerIndex;
														  CGFloat newHeight = scaleAmount != 0 ? (self.frame.size.height * scaleAmount) : self.frame.size.height;
														  CGPoint newCenter = CGPointMake(centerPoint.x, centerPoint.y + (newHeight * diff));
														  f.center = newCenter;
													  }
												  }
											  } completion:^(BOOL finished) {
												  self.cancelButton.hidden = NO;
											  }];
						 }];
	}
}

- (void)fanIn
{
	if (self.buttons.count > 1)
	{
		self.cancelButton.hidden = YES;
		[self.cancelButton removeFromSuperview];
		UIView *v = [self getBaseView];
		CGPoint centerPoint = [self.superview convertPoint:self.center toView:v];
		
		[UIView animateWithDuration:kFanAnimationTime delay:0
							options:UIViewAnimationOptionAllowAnimatedContent
						 animations:^{
							 for (int i = 0; i < self.buttons.count; ++i)
							 {
								 JZFanView *f = self.buttons[i];
								 f.center = centerPoint;
								 f.transform = CGAffineTransformMakeScale(1, 1);
							 }
						 } completion:^(BOOL finished) {
							 for (int i = 0; i < self.buttons.count; ++i)
							 {
								 if (i != self.selectedIndex)
								 {
									 JZFanView *f = self.buttons[i];
									 f.alpha = 0;
								 }
							 }
							 
							 [UIView animateWithDuration:0.1
											  animations:^{
												  if (self.selectedIndex > -1)
													((JZFanView*)self.buttons[self.selectedIndex]).alpha = 0;
											} completion:^(BOOL finished) {
												  [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
											}];
						 }];
	}
}

- (void)cancelButtonPressed:(id)sender
{
	[self fanIn];
}

#pragma mark - JZFanViewDelegate methods

- (void)fanViewSelectedWithIndex:(NSInteger)index
{
	if (index == kMainButtonIndex)
	{
		// main button pressed
		[self arrangeSubviews];
		[self fanOut];
	}
	else
	{
		self.selectedIndex = index;
		[self arrangeSubviews];
		
		if ([self.delegate respondsToSelector:@selector(fanSelectViewSelectedIndex:)])
			[self.delegate fanSelectViewSelectedIndex:index];
		
		if ([self.delegate respondsToSelector:@selector(titleForIndex:)])
		{
			NSString *t = [self.delegate titleForIndex:index];
			if (t)
				self.mainButton.title = t;
			else
				self.mainButton.title = ((JZFanView*)self.buttons[index]).title;
		}
		else
		{
			self.mainButton.title = ((JZFanView*)self.buttons[index]).title;
		}
		
		[self fanIn];
	}
}

@end
