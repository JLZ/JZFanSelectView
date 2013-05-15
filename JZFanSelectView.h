//
//  JZFanSelectView.h
//  SelectButton
//
//  Created by Jeremy Zedell on 5/4/13.
//  Copyright (c) 2013 Jeremy Zedell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZFanView.h"

@protocol JZFanSelectViewDelegate <NSObject>
@optional
- (NSString*)titleForIndex:(NSInteger)index;
- (void)fanSelectViewSelectedIndex:(NSInteger)index;
- (UIView*)backgroundViewForIndex:(NSInteger)index;
@end

@interface JZFanSelectView : UIView <JZFanViewDelegate>

@property (nonatomic, strong) JZFanView *mainButton;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) BOOL isFanned;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, assign) CGFloat scaleAmount;
@property (nonatomic, weak) id<JZFanSelectViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString*)title delegate:(id<JZFanSelectViewDelegate>)delegate;
- (void)addOptionWithTitle:(NSString*)title;
- (void)setFont:(UIFont*)font;
- (void)setTextColor:(UIColor*)color;
- (void)fanOut;
- (void)fanIn;

@end
