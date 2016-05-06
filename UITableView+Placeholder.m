//
//  UITableView+Placeholder.m
//  Aircraft
//
//  Created by cluries on 16/4/21.
//  Copyright © 2016年 cluries. All rights reserved.
//

#import "UITableView+Placeholder.h"
#import <objc/runtime.h>

@implementation UITableView (EmptyPlaceholder)

+ (void) load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(reloadData);
        SEL swizzledSelector = @selector(ephReloadData);
        
        Class  class = [self class];
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        
        BOOL didAddMethod = class_addMethod(class, originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (BOOL) ephScrollEnabled {
    NSNumber *scrollEnabledObjectValue = objc_getAssociatedObject(self, @selector(ephScrollEnabled));
    return [scrollEnabledObjectValue boolValue];
}



- (void) setEphScrollEnabled:(BOOL) scrollEnabled {
    NSNumber *scrollEnabledObjectValue = [NSNumber numberWithBool:scrollEnabled];
    objc_setAssociatedObject(self,
                             @selector(ephScrollEnabled),
                             scrollEnabledObjectValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) ephTableviewScrollEnabled
{
    NSNumber *scrollEnabledObjectValue = objc_getAssociatedObject(self, @selector(ephTableviewScrollEnabled));
    return [scrollEnabledObjectValue boolValue];
}

- (void) setEphTableviewScrollEnabled:(BOOL)ephTableviewScrollEnabled
{
    NSNumber *scrollEnabledObjectValue = [NSNumber numberWithBool:ephTableviewScrollEnabled];
    objc_setAssociatedObject(self,
                             @selector(ephTableviewScrollEnabled),
                             scrollEnabledObjectValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (UIView*) ephPlaceholderView
{
    return objc_getAssociatedObject(self, @selector(ephPlaceholderView));
}

- (void) setEphPlaceholderView:(UIView*) placeholderView
{
    objc_setAssociatedObject(self,
                             @selector(ephPlaceholderView),
                             placeholderView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL) ephEnable
{
    NSNumber *enableObjectValue = objc_getAssociatedObject(self, @selector(ephEnable));
    return [enableObjectValue boolValue];
}

- (void) setEphEnable:(BOOL) ephEnable
{
    NSNumber* enableObjectValue = [NSNumber numberWithBool:ephEnable];
    objc_setAssociatedObject(self,
                             @selector(ephEnable),
                             enableObjectValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*) ephPlaceholderText
{
    return objc_getAssociatedObject(self, @selector(ephPlaceholderText));
}

- (void) setEphPlaceholderText:(NSString *)placeholderText
{
    objc_setAssociatedObject(self,
                             @selector(ephPlaceholderText),
                             placeholderText,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (float) ephMaskviewTopOffset
{
    NSNumber* maskviewTopOffset = objc_getAssociatedObject(self, @selector(ephMaskviewTopOffset));
    return [maskviewTopOffset floatValue];
}

- (void) setEphMaskviewTopOffset:(float)ephMaskviewTopOffset
{
    NSNumber* maskviewTopOffsetObject = [NSNumber numberWithFloat:ephMaskviewTopOffset];
    objc_setAssociatedObject(self, @selector(ephMaskviewTopOffset), maskviewTopOffsetObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*) ephPlaceholderBackgroundColor
{
    return objc_getAssociatedObject(self, @selector(ephPlaceholderBackgroundColor));
}

- (void) setEphPlaceholderBackgroundColor:(UIColor *)placeholderBackgroundColor
{
    objc_setAssociatedObject(self, @selector(ephPlaceholderBackgroundColor), placeholderBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*) ephPlaceholderTextColor
{
    return objc_getAssociatedObject(self, @selector(ephPlaceholderTextColor));
}

- (void) setEphPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    objc_setAssociatedObject(self, @selector(ephPlaceholderTextColor), placeholderTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) ephReloadData
{
    
    [self ephReloadData];

    if (self.ephEnable) {
        [self ephCheckEmpty];
    }
}

- (BOOL) isEmptyTableview
{
    NSInteger sections = 1;
    if ([self.dataSource respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sections = [self.dataSource numberOfSectionsInTableView:self];
    }

    BOOL empty = YES;
    
    for (int i = 0; i < sections; ++i) {
        NSInteger rowsCount = [self.dataSource tableView:self numberOfRowsInSection:i];
        if (rowsCount > 0) {
            empty = NO;
            break;
        }
    }
    
    return empty;
}

- (void) ephCheckEmpty
{
    
    BOOL empty  = [self isEmptyTableview];
    
    if (empty){
        if (self.ephPlaceholderView == nil) {
            self.ephTableviewScrollEnabled = self.scrollEnabled;
            
            self.scrollEnabled = self.ephScrollEnabled;
            
            if ([self respondsToSelector:@selector(ephMakePlaceholder)]) {
                self.ephPlaceholderView = [self performSelector:@selector(ephMakePlaceholder)];
            } else if ([self.delegate respondsToSelector:@selector(ephMakePlaceholder)]) {
                self.ephPlaceholderView = [self.delegate performSelector:@selector(ephMakePlaceholder)];
            } else {
                self.ephPlaceholderView = [self ephDefaultPlaceHolderView];
            }
            
            self.ephPlaceholderView.frame = CGRectMake(0, self.ephMaskviewTopOffset, self.bounds.size.width, self.bounds.size.height-self.ephMaskviewTopOffset);
            [self addSubview:self.ephPlaceholderView];
        } else {
            [self.ephPlaceholderView removeFromSuperview];
            [self addSubview:self.ephPlaceholderView];
            self.scrollEnabled = self.ephScrollEnabled;
        }
        
    } else {
        if (self.ephPlaceholderView != nil) {
            self.scrollEnabled = self.ephTableviewScrollEnabled;
            [self.ephPlaceholderView removeFromSuperview];
            self.ephPlaceholderView = nil;
        }
    }
    
}

- (UIView*) ephDefaultPlaceHolderView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = self.ephPlaceholderBackgroundColor ? : [UIColor whiteColor];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    UIColor* textColor = self.ephPlaceholderTextColor ? : [UIColor grayColor];
    NSDictionary* attributes = @{NSForegroundColorAttributeName: textColor,
                                 NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    NSString* text = self.ephPlaceholderText ? : @"该列表暂无数据,点击刷新" ;
    NSAttributedString* attributeString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [button setAttributedTitle:attributeString forState:UIControlStateNormal];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:button];
    [button addTarget:self
               action:@selector(onDefaultPlaceholderViewSubButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [NSLayoutConstraint constraintWithItem:button
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                  constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:button
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:button
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:-22].active = YES;
    
    [NSLayoutConstraint constraintWithItem:button
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:20].active = YES;
    

    return view;
}

- (void) onDefaultPlaceholderViewSubButtonClicked:(UIButton*) button
{
    if ([self respondsToSelector:@selector(ephDefaultPlaceholderTouched:)]) {
        [self performSelector:@selector(ephDefaultPlaceholderTouched:) withObject:button];
    } else if([self.delegate respondsToSelector:@selector(ephDefaultPlaceholderTouched:)]) {
        [self.delegate performSelector:@selector(ephDefaultPlaceholderTouched:) withObject:button];
    }
}

@end
