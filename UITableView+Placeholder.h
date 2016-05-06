//
//  UITableView+Placeholder.h
//  Aircraft
//
//  Created by cluries on 15/4/21.
//  Copyright © 2015年 cluries. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlaceholderTableViewDelegate <NSObject>

@optional
- (UIView*) ephMakePlaceholder;
- (void) ephDefaultPlaceholderTouched:(UIButton*) sender;


@end

@interface UITableView (EmptyPlaceholder)

@property (nonatomic, assign) BOOL  ephEnable;
@property (nonatomic, assign) BOOL  ephScrollEnabled;
@property (nonatomic, assign) BOOL  ephTableviewScrollEnabled;
@property (nonatomic, assign) float ephMaskviewTopOffset;
@property (nonatomic, strong) UIView *ephPlaceholderView;

@property (nonatomic, copy)   NSString* ephPlaceholderText;
@property (nonatomic, strong) UIColor* ephPlaceholderBackgroundColor;
@property (nonatomic, strong) UIColor* ephPlaceholderTextColor;

@end
