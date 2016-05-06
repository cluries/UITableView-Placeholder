# UITableView-Placeholder
UITableView+Placeholder

当UITableView数据为空的时候，给出占位的提示,默认是一行文字提醒，可以自定义提提醒文字或者整个自定义占位的View.

支持占位提示点击刷新。

使用简单，添加进入项目后，只需一行代码：

```
self.tableView.ephEnable = YES;
```

### 自定义文字和样式:

```
self.tableView.ephPlaceholderText = @"没数据，点击刷新";
self.tableView.ephPlaceholderBackgroundColor = [UIColor blueColor];
self.tableView.ephPlaceholderTextColor = [UIColor greenColor];
```

### 默认提示文字点击后回调(可以实现在tableView中，也可以在tableView的delegate中)

```
- (void) ephDefaultPlaceholderTouched:(UIButton*) sender;
```

### 自定义占位样式

方法一:

直接设置 `self.tableView.ephPlaceholderView = xxxx`

方法二:

在你的tableView中或者tableView的delegate中实现方法 `- (UIView*) ephMakePlaceholder;`


### 其他

```
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
```