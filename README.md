# TFYOCPanlModel

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS%20%7C%20ObjC%20%7C%20Swift-blue.svg" alt="platform"/>
  <img src="https://img.shields.io/badge/iOS-15%2B-orange.svg" alt="iOS"/>
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="license"/>
  <img src="https://img.shields.io/badge/language-Objective--C%20%7C%20Swift-blue.svg" alt="language"/>
  <img src="https://img.shields.io/badge/version-1.0.7-brightgreen.svg" alt="version"/>
</p>

<p align="center">
  <strong>TFYOCPanlModel：高扩展性OC弹窗组件，支持多种弹窗样式与交互，兼容iOS 15+，支持Swift调用。</strong>
</p>

<p align="center">
  <strong>A highly extensible Objective-C modal/pan modal component for iOS 15+, supporting multiple modal styles, custom interactions, and Swift integration.</strong>
</p>

---

## ✨ 核心特性 Core Features

### 🎯 弹窗样式 Modal Styles
- **底部弹窗** - 支持短/中/长三种高度状态
- **全屏弹窗** - 覆盖整个屏幕的弹窗
- **iPad Popover** - 专为iPad设计的弹出式弹窗
- **自定义弹窗** - 完全自定义的弹窗样式

### 🎨 视觉效果 Visual Effects
- **背景模糊** - 系统模糊效果、自定义模糊效果
- **背景遮罩** - 可调节透明度的背景遮罩
- **圆角阴影** - 自定义圆角半径和阴影效果
- **深色模式** - 完美支持iOS深色模式

### 🎮 交互体验 Interactive Experience
- **手势拖拽** - 支持拖拽关闭、拖拽切换状态
- **点击关闭** - 点击背景关闭弹窗
- **边缘滑动** - 支持屏幕边缘滑动关闭
- **键盘适配** - 自动处理键盘弹出和收起
- **防频繁点击** - 防止用户频繁点击触发多次弹窗

### 🔧 高度配置 Height Configuration
- **最大高度** - 弹窗最大显示高度
- **内容高度** - 根据内容自适应高度
- **顶部偏移** - 距离屏幕顶部的偏移量
- **安全区适配** - 自动适配安全区域

### 🎬 动画效果 Animation Effects
- **转场动画** - 自定义present/dismiss动画
- **状态切换** - 短/中/长状态间的平滑切换
- **父控制器动画** - 支持父控制器的动画效果
- **弹性动画** - 自然的弹性动画效果

---

## 🚀 安装 Installation

### CocoaPods (推荐)
```ruby
pod 'TFYOCPanlModel', '~> 1.0.7'
```

### 系统要求
- **iOS 15.0+**
- **Xcode 12.0+**
- **支持 Objective-C 和 Swift 项目**

### 新功能
- **防频繁点击功能** - 防止用户频繁点击触发多次弹窗
- **可配置时间间隔** - 支持自定义防频繁点击的时间间隔
- **实时状态反馈** - 提供防频繁点击状态的实时回调
- **自定义提示信息** - 支持自定义防频繁点击的提示文本

---

## 🛠️ 快速开始 Quick Start

### 1. 基础使用 Basic Usage

#### Objective-C
```objc
#import <TFYOCPanlModel/TFYOCPanlModel.h>

@interface DemoViewController : UIViewController <TFYPanModalPresentable>
@end

@implementation DemoViewController

// 实现协议方法
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 300);
}

- (BOOL)showDragIndicator {
    return YES;
}

@end

// 弹出弹窗
DemoViewController *vc = [[DemoViewController alloc] init];
[self presentPanModal:vc];
```

#### Swift
```swift
import TFYOCPanlModel

class DemoVC: UIViewController, TFYPanModalPresentable {
    
    func longFormHeight() -> PanModalHeight {
        return PanModalHeightMake(.topInset, 300)
    }
    
    func showDragIndicator() -> Bool {
        return true
    }
}

// 弹出弹窗
let vc = DemoVC()
presentPanModal(vc)
```

### 2. 高级配置 Advanced Configuration

```objc
@interface AdvancedViewController : UIViewController <TFYPanModalPresentable>
@end

@implementation AdvancedViewController

#pragma mark - 高度配置
- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 200);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 400);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 600);
}

#pragma mark - 背景配置
- (TFYBackgroundConfig *)backgroundConfig {
    TFYBackgroundConfig *config = [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
    return config;
}

#pragma mark - 动画配置
- (NSTimeInterval)transitionDuration {
    return 0.5;
}

- (CGFloat)springDamping {
    return 0.8;
}

#pragma mark - 交互配置
- (BOOL)allowsDragToDismiss {
    return YES;
}

- (BOOL)allowsTapBackgroundToDismiss {
    return YES;
}

- (BOOL)showDragIndicator {
    return YES;
}

#pragma mark - 防频繁点击配置
- (BOOL)shouldPreventFrequentTapping {
    return YES;
}

- (NSTimeInterval)frequentTapPreventionInterval {
    return 1.0;
}

- (BOOL)shouldShowFrequentTapPreventionHint {
    return YES;
}

- (nullable NSString *)frequentTapPreventionHintText {
    return @"请稍后再试";
}

- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    // 处理防频繁点击状态变更
    if (isPrevented) {
        NSLog(@"防频繁点击中，剩余时间：%.1f秒", remainingTime);
    } else {
        NSLog(@"防频繁点击已解除");
    }
}

#pragma mark - 样式配置
- (BOOL)shouldRoundTopCorners {
    return YES;
}

- (CGFloat)cornerRadius {
    return 12.0;
}

- (TFYPanModalShadow *)contentShadow {
    return [[TFYPanModalShadow alloc] initWithColor:[UIColor blackColor] 
                                       shadowRadius:10 
                                       shadowOffset:CGSizeMake(0, 2) 
                                       shadowOpacity:0.3];
}

@end
```

---

## 📚 API 文档 API Documentation

### 核心协议 Core Protocol

#### `TFYPanModalPresentable`
弹窗内容控制器必须实现的协议，提供丰富的配置选项：

```objc
@protocol TFYPanModalPresentable <NSObject>

// 高度配置
- (PanModalHeight)shortFormHeight;
- (PanModalHeight)mediumFormHeight;
- (PanModalHeight)longFormHeight;
- (CGFloat)topOffset;

// 背景配置
- (TFYBackgroundConfig *)backgroundConfig;

// 动画配置
- (NSTimeInterval)transitionDuration;
- (CGFloat)springDamping;
- (UIViewAnimationOptions)transitionAnimationOptions;

// 交互配置
- (BOOL)allowsDragToDismiss;
- (BOOL)allowsTapBackgroundToDismiss;
- (BOOL)showDragIndicator;
- (BOOL)isUserInteractionEnabled;

// 防频繁点击配置
- (BOOL)shouldPreventFrequentTapping;
- (NSTimeInterval)frequentTapPreventionInterval;
- (BOOL)shouldShowFrequentTapPreventionHint;
- (nullable NSString *)frequentTapPreventionHintText;
- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime;

// 样式配置
- (BOOL)shouldRoundTopCorners;
- (CGFloat)cornerRadius;
- (TFYPanModalShadow *)contentShadow;

// 生命周期控制
- (BOOL)shouldEnableAppearanceTransition;

@end
```

### 高度类型 Height Types

```objc
typedef NS_ENUM(NSInteger, PanModalHeightType) {
    PanModalHeightTypeMax,                    // 顶部最大高度
    PanModalHeightTypeMaxTopInset,           // 顶部偏移高度
    PanModalHeightTypeContent,               // 内容高度（底部）
    PanModalHeightTypeContentIgnoringSafeArea, // 内容高度（忽略安全区）
    PanModalHeightTypeIntrinsic,             // 自适应高度
};
```

### 背景配置 Background Configuration

```objc
typedef NS_ENUM(NSUInteger, TFYBackgroundBehavior) {
    TFYBackgroundBehaviorDefault,            // 默认遮罩
    TFYBackgroundBehaviorSystemVisualEffect, // 系统模糊效果
    TFYBackgroundBehaviorCustomBlurEffect,   // 自定义模糊效果
};

@interface TFYBackgroundConfig : NSObject
@property (nonatomic, assign) TFYBackgroundBehavior backgroundBehavior;
@property (nonatomic, assign) CGFloat backgroundAlpha;
@property (nonatomic, strong, nullable) UIVisualEffect *visualEffect;
@property (nonatomic, strong, nullable) UIColor *blurTintColor;
@property (nonatomic, assign) CGFloat backgroundBlurRadius;
@end
```

### 阴影配置 Shadow Configuration

```objc
@interface TFYPanModalShadow : NSObject
@property (nonatomic, strong, nonnull) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowOpacity;
@end
```

---

## 🎯 使用场景 Use Cases

### 1. 底部弹窗 Bottom Modal
```objc
// 简单的底部弹窗
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 400);
}
```

### 2. 全屏弹窗 Full Screen Modal
```objc
// 全屏弹窗
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}
```

### 3. 模糊背景 Blur Background
```objc
// 系统模糊效果
- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}
```

### 4. 自定义动画 Custom Animation
```objc
// 自定义转场动画
- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
    return PresentingViewControllerAnimationStylePageSheet;
}
```

### 5. 滚动视图 ScrollView Support
```objc
// 支持滚动视图
- (UIScrollView *)panScrollable {
    return self.tableView;
}

- (BOOL)isPanScrollEnabled {
    return YES;
}
```

### 6. 防频繁点击 Frequent Tap Prevention
```objc
// 启用防频繁点击
- (BOOL)shouldPreventFrequentTapping {
    return YES;
}

// 设置防频繁点击时间间隔
- (NSTimeInterval)frequentTapPreventionInterval {
    return 1.0; // 1秒间隔
}

// 显示防频繁点击提示
- (BOOL)shouldShowFrequentTapPreventionHint {
    return YES;
}

// 自定义提示文本
- (nullable NSString *)frequentTapPreventionHintText {
    return @"请等待1秒后再试";
}

// 监听防频繁点击状态变更
- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    if (isPrevented) {
        NSLog(@"防频繁点击中，剩余时间：%.1f秒", remainingTime);
    } else {
        NSLog(@"防频繁点击已解除");
    }
}
```

---

## 📁 项目结构 Project Structure

```
TFYOCPanlModel/
├── Presentable/                    # 协议与分类
│   ├── TFYPanModalPresentable.h   # 核心协议
│   ├── TFYPanModalHeight.h        # 高度配置
│   ├── TFYPanModalPanGestureDelegate.h # 手势代理
│   ├── TFYPanModalFrequentTapPrevention.{h,m} # 防频繁点击
│   └── UIViewController+*.{h,m}   # 控制器分类
├── Controller/                     # 弹窗控制器
│   └── TFYPanModalPresentationController.{h,m}
├── View/                          # 视图组件
│   ├── TFYBackgroundConfig.{h,m}  # 背景配置
│   ├── TFYDimmedView.{h,m}        # 背景遮罩
│   ├── TFYPanModalShadow.{h,m}    # 阴影配置
│   ├── TFYVisualEffectView.{h,m}  # 模糊效果
│   └── PanModal/                  # 弹窗容器
├── Animator/                      # 动画与转场
│   ├── TFYPanModalPresentationAnimator.{h,m}
│   ├── TFYPanModalAnimator.{h,m}
│   └── PresentingVCAnimation/     # 父控制器动画
├── Presenter/                     # 弹窗展示器
│   ├── TFYPanModalPresenterProtocol.h
│   └── UIViewController+PanModalPresenter.{h,m}
├── Mediator/                      # 事件中介
│   └── TFYPanModalPresentableHandler.{h,m}
├── Delegate/                      # 转场代理
│   └── TFYPanModalPresentationDelegate.{h,m}
├── Category/                      # UIKit扩展
│   ├── UIScrollView+Helper.{h,m}
│   └── UIView+TFY_Frame.{h,m}
└── KVO/                          # KVO辅助
    └── KeyValueObserver.{h,m}
```

---

## 🔧 高级功能 Advanced Features

### 1. 生命周期控制 Lifecycle Control
```objc
// 控制是否触发viewDidAppear/viewDidDisappear
- (BOOL)shouldEnableAppearanceTransition {
    return NO; // 不触发外部生命周期方法
}
```

### 2. 事件穿透 Event Pass Through
```objc
// 允许事件穿透到下层视图
- (BOOL)allowsTouchEventsPassingThroughTransitionView {
    return YES;
}
```

### 3. 边缘交互 Edge Interaction
```objc
// 支持屏幕边缘滑动关闭
- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (CGFloat)maxAllowedDistanceToLeftScreenEdgeForPanInteraction {
    return 50;
}
```

### 4. 键盘适配 Keyboard Adaptation
```objc
// 自动处理键盘
- (BOOL)isAutoHandleKeyboardEnabled {
    return YES;
}

- (CGFloat)keyboardOffsetFromInputView {
    return 10;
}
```

---

## 🎨 自定义示例 Custom Examples

### 防频繁点击示例 Frequent Tap Prevention Example
```objc
@interface FrequentTapPreventionViewController : UIViewController <TFYPanModalPresentable>
@end

@implementation FrequentTapPreventionViewController

// 启用防频繁点击
- (BOOL)shouldPreventFrequentTapping {
    return YES;
}

// 设置防频繁点击时间间隔
- (NSTimeInterval)frequentTapPreventionInterval {
    return 1.5; // 1.5秒间隔
}

// 显示防频繁点击提示
- (BOOL)shouldShowFrequentTapPreventionHint {
    return YES;
}

// 自定义提示文本
- (nullable NSString *)frequentTapPreventionHintText {
    return @"操作过于频繁，请稍后再试";
}

// 监听防频繁点击状态变更
- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isPrevented) {
            // 更新UI显示防频繁点击状态
            self.statusLabel.text = [NSString stringWithFormat:@"防频繁点击中，剩余 %.1f 秒", remainingTime];
            self.statusLabel.textColor = [UIColor redColor];
        } else {
            // 恢复正常状态
            self.statusLabel.text = @"可以正常操作";
            self.statusLabel.textColor = [UIColor greenColor];
        }
    });
}

@end
```

### 购物车样式 Shopping Cart Style
```objc
@interface ShoppingCartViewController : UIViewController <TFYPanModalPresentable>
@end

@implementation ShoppingCartViewController

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 500);
}

- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
    return PresentingViewControllerAnimationStyleShoppingCart;
}

- (TFYBackgroundConfig *)backgroundConfig {
    TFYBackgroundConfig *config = [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorCustomBlurEffect];
    config.backgroundBlurRadius = 15;
    return config;
}

@end
```

### 分享面板样式 Share Panel Style
```objc
@interface SharePanelViewController : UIViewController <TFYPanModalPresentable>
@end

@implementation SharePanelViewController

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 300);
}

- (BOOL)showDragIndicator {
    return YES;
}

- (CGFloat)cornerRadius {
    return 16.0;
}

- (TFYPanModalShadow *)contentShadow {
    return [[TFYPanModalShadow alloc] initWithColor:[UIColor blackColor] 
                                       shadowRadius:20 
                                       shadowOffset:CGSizeMake(0, 4) 
                                       shadowOpacity:0.2];
}

@end
```

---

## 🐛 常见问题 FAQ

### Q: 如何禁用拖拽关闭？
```objc
- (BOOL)allowsDragToDismiss {
    return NO;
}
```

### Q: 如何自定义弹窗高度？
```objc
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 400);
}
```

### Q: 如何添加模糊背景？
```objc
- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}
```

### Q: 如何支持滚动视图？
```objc
- (UIScrollView *)panScrollable {
    return self.tableView;
}
```

### Q: 如何控制生命周期方法？
```objc
- (BOOL)shouldEnableAppearanceTransition {
    return NO; // 不触发外部viewDidAppear/viewDidDisappear
}
```

### Q: 如何启用防频繁点击功能？
```objc
// 启用防频繁点击
- (BOOL)shouldPreventFrequentTapping {
    return YES;
}

// 设置时间间隔
- (NSTimeInterval)frequentTapPreventionInterval {
    return 1.0; // 1秒间隔
}

// 显示提示
- (BOOL)shouldShowFrequentTapPreventionHint {
    return YES;
}
```

---

## 🤝 贡献指南 Contributing

我们欢迎所有形式的贡献！

### 提交 Issue
- 使用清晰的标题描述问题
- 提供详细的复现步骤
- 包含设备信息和系统版本

### 提交 PR
- 遵循现有的代码风格
- 添加必要的注释和文档
- 确保所有测试通过

### 开发环境
- Xcode 14.0+
- iOS 15.0+
- CocoaPods

---

## 📄 开源协议 License

本项目采用 MIT 协议开源，详见 [LICENSE](./LICENSE) 文件。

---

## 📬 联系我们 Contact

- **作者**: tianfengyou
- **邮箱**: 420144542@qq.com
- **GitHub**: [TFYOCPanlModel](https://github.com/tianfengyou/TFYOCPanlModel)

---

## 🙏 致谢 Acknowledgments

感谢所有为这个项目做出贡献的开发者！

---

## 🛡️ 防频繁点击功能 Frequent Tap Prevention

### 功能概述
防频繁点击功能可以有效防止用户频繁点击触发多次弹窗，提升用户体验和应用稳定性。

### 核心特性
- **智能防抖** - 基于时间间隔的智能防抖机制
- **可配置间隔** - 支持0.5-10秒的自定义时间间隔
- **实时反馈** - 提供防频繁点击状态的实时回调
- **自定义提示** - 支持自定义提示文本和显示方式
- **状态监听** - 实时监听防频繁点击状态变更

### 使用方法

#### 1. 基础配置
```objc
@interface MyViewController : UIViewController <TFYPanModalPresentable>
@end

@implementation MyViewController

// 启用防频繁点击
- (BOOL)shouldPreventFrequentTapping {
    return YES;
}

// 设置防频繁点击时间间隔（秒）
- (NSTimeInterval)frequentTapPreventionInterval {
    return 1.0; // 1秒间隔
}

// 是否显示防频繁点击提示
- (BOOL)shouldShowFrequentTapPreventionHint {
    return YES;
}

// 自定义提示文本
- (nullable NSString *)frequentTapPreventionHintText {
    return @"请稍后再试";
}

// 监听防频繁点击状态变更
- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    if (isPrevented) {
        NSLog(@"防频繁点击中，剩余时间：%.1f秒", remainingTime);
        // 更新UI状态
        self.button.enabled = NO;
    } else {
        NSLog(@"防频繁点击已解除");
        // 恢复UI状态
        self.button.enabled = YES;
    }
}

@end
```

#### 2. 高级配置
```objc
@implementation AdvancedViewController

// 动态调整防频繁点击间隔
- (NSTimeInterval)frequentTapPreventionInterval {
    // 根据用户操作历史动态调整
    if (self.userOperationCount > 5) {
        return 2.0; // 频繁操作时增加间隔
    }
    return 1.0; // 正常间隔
}

// 自定义提示显示逻辑
- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isPrevented) {
            // 显示自定义提示UI
            [self showCustomPreventionHint:remainingTime];
        } else {
            // 隐藏提示UI
            [self hideCustomPreventionHint];
        }
    });
}

- (void)showCustomPreventionHint:(NSTimeInterval)remainingTime {
    // 显示自定义提示UI
    self.hintLabel.text = [NSString stringWithFormat:@"请等待 %.1f 秒", remainingTime];
    self.hintLabel.hidden = NO;
}

- (void)hideCustomPreventionHint {
    // 隐藏提示UI
    self.hintLabel.hidden = YES;
}

@end
```

### 最佳实践

#### 1. 合理设置时间间隔
```objc
// 根据操作类型设置不同的间隔
- (NSTimeInterval)frequentTapPreventionInterval {
    switch (self.operationType) {
        case OperationTypeLight:
            return 0.5; // 轻量操作
        case OperationTypeNormal:
            return 1.0; // 普通操作
        case OperationTypeHeavy:
            return 2.0; // 重量操作
        default:
            return 1.0;
    }
}
```

#### 2. 提供用户友好的提示
```objc
- (nullable NSString *)frequentTapPreventionHintText {
    switch (self.currentOperation) {
        case OperationTypeSubmit:
            return @"提交过于频繁，请稍后再试";
        case OperationTypeRefresh:
            return @"刷新过于频繁，请稍后再试";
        case OperationTypeShare:
            return @"分享过于频繁，请稍后再试";
        default:
            return @"操作过于频繁，请稍后再试";
    }
}
```

#### 3. 实时状态反馈
```objc
- (void)panModalFrequentTapPreventionStateChanged:(BOOL)isPrevented remainingTime:(NSTimeInterval)remainingTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isPrevented) {
            // 更新按钮状态
            [self.submitButton setTitle:[NSString stringWithFormat:@"请等待 %.0f 秒", remainingTime] forState:UIControlStateDisabled];
            self.submitButton.enabled = NO;
            
            // 显示进度指示器
            [self showProgressIndicator];
        } else {
            // 恢复按钮状态
            [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
            self.submitButton.enabled = YES;
            
            // 隐藏进度指示器
            [self hideProgressIndicator];
        }
    });
}
```

### 注意事项

1. **时间间隔设置** - 建议根据操作类型设置合理的时间间隔，避免影响用户体验
2. **提示信息** - 提供清晰、友好的提示信息，帮助用户理解当前状态
3. **UI反馈** - 通过UI状态变化提供直观的视觉反馈
4. **性能考虑** - 防频繁点击功能对性能影响很小，但建议在复杂场景下进行测试

---

<p align="center">
  <strong>如果这个项目对你有帮助，请给我们一个 ⭐️</strong>
</p> 