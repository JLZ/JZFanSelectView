//
//  JZFanView.h
//  SelectButton
//
//  Created by Jeremy Zedell on 5/4/13.
//  Copyright (c) 2013 Jeremy Zedell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZFanViewDelegate <NSObject>
- (void)fanViewSelectedWithIndex:(NSInteger)index;
@end

@interface JZFanView : UIView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, weak) id<JZFanViewDelegate> delegate;

- (void)buttonPressed:(id)sender;

@end
