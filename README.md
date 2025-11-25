# TFYOCPanlModel

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS%20%7C%20ObjC%20%7C%20Swift-blue.svg" alt="platform"/>
  <img src="https://img.shields.io/badge/iOS-15%2B-orange.svg" alt="iOS"/>
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="license"/>
  <img src="https://img.shields.io/badge/language-Objective--C%20%7C%20Swift-blue.svg" alt="language"/>
  <img src="https://img.shields.io/badge/version-1.8.4-brightgreen.svg" alt="version"/>
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

#### PanModal 弹窗系列
- **底部弹窗** - 支持短/中/长三种高度状态
- **全屏弹窗** - 覆盖整个屏幕的弹窗
- **iPad Popover** - 专为iPad设计的弹出式弹窗
- **自定义弹窗** - 完全自定义的弹窗样式

#### TFYPopup 弹窗框架 (New!)
- **居中弹窗** - 支持多种动画的居中弹窗
- **底部弹出框** - 支持手势交互的底部弹窗
- **全屏模式** - 全屏展示模式
- **自定义容器** - 灵活的容器尺寸配置
- **多种动画** - 淡入淡出、缩放、旋转、滑动等丰富动画效果

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

### Swift Package Manager (推荐) ⭐️

在 Xcode 中添加 Swift Package 依赖：

1. 打开 Xcode 项目
2. 选择 **File** → **Add Package Dependencies...**
3. 输入仓库 URL：
   ```
   https://github.com/13662049573/TFYOCPanModelDemo.git
   ```
4. 选择版本或分支（建议使用最新版本）
5. 点击 **Add Package** 完成添加


#### 使用 Package.swift
在 `Package.swift` 文件中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYOCPanModelDemo.git", from: "1.8.0")
]
```

### CocoaPods

在 `Podfile` 中添加：

```ruby
pod 'TFYOCPanlModel', '~> 1.8.0'
```

然后运行：

```bash
pod install
```

**注意**：从 1.6.3 版本开始，库已转换为 Pod 形式，所有头文件导入需要使用 `#import <TFYOCPanlModel/...>` 格式。

### 系统要求
- **iOS 15.0+**
- **Xcode 12.0+**
- **支持 Objective-C 和 Swift 项目**

### 🆕 版本 1.8.4 新功能 (New in v1.8.4)
- **🔧 修复 SPM modulemap 路径配置** - 修正所有 header 路径为相对于 modulemap 文件所在目录（include/），符合 Clang modulemap 规范
- **✅ 彻底解决头文件找不到的问题** - include 目录文件使用文件名，其他目录使用 `../` 相对路径，确保 SPM 能正确解析所有 47 个头文件
- **🚀 版本号更新** - 更新至 1.8.4

### 🆕 版本 1.8.3 新功能 (New in v1.8.3)
- **🔧 修复 SPM modulemap 路径解析问题** - 修改所有 header 路径为相对于 target 根目录的路径，与 Package.swift 中的 headerSearchPath 配置保持一致
- **✅ 彻底解决路径解析错误** - 使用 `include/TFYOCPanlModel.h`、`Tools/...`、`popController/...` 等格式，确保 SPM 能正确解析所有头文件路径
- **🚀 版本号更新** - 更新至 1.8.3

### 🆕 版本 1.8.2 新功能 (New in v1.8.2)
- **🔧 修复 SPM modulemap 配置** - 移除 umbrella header，直接列出所有头文件，彻底解决 "umbrella header not found" 错误
- **✅ 修复头文件路径问题** - 优化 module.modulemap 路径配置，确保 SPM 能正确找到所有 47 个头文件
- **🚀 兼容性优化** - 删除 module.modulemap.cocoapods（CocoaPods 使用自动生成的 modulemap），简化配置
- **📦 版本号更新** - 更新至 1.8.2

### 🆕 版本 1.8.0 新功能 (New in v1.8.0)
- **🔧 模块映射完善** - 补全 `module.modulemap.cocoapods`，包含所有库内部引用的头文件，解决SPM安装后"file not found"编译错误
- **✅ 头文件暴露优化** - 确保所有库内部 `.m` 文件引用的头文件都能被正确找到和导入
- **🚀 版本号更新** - 更新至 1.8.0

### 🆕 版本 1.7.9 新功能 (New in v1.7.9)
- **🚀 版本号更新** - 更新至 1.7.9 支持Swift Package

### 🆕 版本 1.5.6 新功能 (New in v1.5.6)
- **📁 文件夹结构重组** - 将库文件重新组织为四大类：Tools（工具类）、popController（控制弹出）、popView（pop弹出）、include（主头文件）
- **🔧 修复依赖关系** - 优化了 podspec 和 Package.swift 的依赖关系，避免循环依赖问题
- **✅ 完善 header_search_paths** - 修复了所有模块的头文件搜索路径，确保编译时能正确找到头文件
- **📦 优化模块组织** - 按照功能模块清晰分类，安装后头文件按文件夹结构分类展示
- **🚀 版本号更新** - 更新至 1.5.6


- **🎭 TFYPopup 弹窗框架** - 全新的弹窗框架，支持更丰富的动画和配置
- **🎨 多种动画效果** - 支持淡入淡出、缩放、旋转、滑动、3D翻转等8种动画
- **📏 灵活的容器配置** - 支持固定、自动、比例、自定义四种尺寸类型
- **⌨️ 完善的键盘适配** - 智能键盘避让，支持多种适配模式
- **🎯 精准的布局系统** - 支持居中、顶部、底部、左右等多种布局方式
- **🌟 完整的 Swift 支持** - 所有 API 都提供 NS_SWIFT_NAME 映射
- **🔄 多弹窗管理** - 支持弹窗队列管理和批量操作
- **🎪 主题系统** - 支持浅色、深色、自定义主题
- **📢 通知系统** - 完整的生命周期通知机制

### 🔄 原有功能增强 (Enhanced Features)
- **防频繁点击功能** - 防止用户频繁点击触发多次弹窗
- **可配置时间间隔** - 支持自定义防频繁点击的时间间隔
- **实时状态反馈** - 提供防频繁点击状态的实时回调
- **自定义提示信息** - 支持自定义防频繁点击的提示文本

---

## 🛠️ 快速开始 Quick Start

### 1. PanModal 弹窗 Basic PanModal Usage

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

### 2. TFYPopup 弹窗 TFYPopup Usage

#### Objective-C
```objc
#import <TFYOCPanlModel/TFYOCPanlModel.h>

// 简单使用
UIView *contentView = [[UIView alloc] init];
// 添加你的内容...

[TFYPopupView showContentView:contentView animated:YES completion:nil];

// 高级配置
TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.dismissOnBackgroundTap = YES;
config.cornerRadius = 16;

[TFYPopupView showContentView:contentView
                configuration:config
                     animator:[[TFYPopupSpringAnimator alloc] init]
                     animated:YES
                   completion:^{
    NSLog(@"弹窗显示完成");
}];
```

#### Swift
```swift
import TFYOCPanlModel

// 简单使用
let contentView = UIView()
// 添加你的内容...

PopupView.show(contentView: contentView, animated: true, completion: nil)

// 高级配置
let config = PopupViewConfiguration()
config.dismissOnBackgroundTap = true
config.cornerRadius = 16

PopupView.show(contentView: contentView,
               configuration: config,
               animator: PopupSpringAnimator(),
               animated: true) {
    print("弹窗显示完成")
}
```

### 3. PanModal 高级配置 Advanced PanModal Configuration

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

### PanModal 使用场景 PanModal Use Cases

#### 1. 底部弹窗 Bottom Modal
```objc
// 简单的底部弹窗
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 400);
}
```

#### 2. 全屏弹窗 Full Screen Modal
```objc
// 全屏弹窗
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMax, 0);
}
```

#### 3. 模糊背景 Blur Background
```objc
// 系统模糊效果
- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}
```

#### 4. 自定义动画 Custom Animation
```objc
// 自定义转场动画
- (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
    return PresentingViewControllerAnimationStylePageSheet;
}
```

#### 5. 滚动视图 ScrollView Support
```objc
// 支持滚动视图
- (UIScrollView *)panScrollable {
    return self.tableView;
}

- (BOOL)isPanScrollEnabled {
    return YES;
}
```

#### 6. 防频繁点击 Frequent Tap Prevention
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

### TFYPopup 使用场景 TFYPopup Use Cases

#### 1. 消息提示弹窗 Message Alert
```objc
// 创建提示内容
UILabel *messageLabel = [[UILabel alloc] init];
messageLabel.text = @"操作成功！";
messageLabel.textAlignment = NSTextAlignmentCenter;

// 配置自动消失
TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.autoDismissDelay = 2.0;

[TFYPopupView showContentView:messageLabel
                configuration:config
                     animator:[[TFYPopupFadeInOutAnimator alloc] init]
                     animated:YES
                   completion:nil];
```

#### 2. 操作确认弹窗 Action Confirmation
```objc
// 创建确认视图
UIView *confirmView = [self createConfirmationView];

// 配置容器样式
TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
containerConfig.width = [TFYPopupContainerDimension fixed:280];
containerConfig.height = [TFYPopupContainerDimension automatic];
containerConfig.cornerRadius = 16;
containerConfig.shadowEnabled = YES;

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.containerConfiguration = containerConfig;
config.dismissOnBackgroundTap = NO; // 防止误操作

[TFYPopupView showContentView:confirmView
                configuration:config
                     animator:[[TFYPopupZoomInOutAnimator alloc] init]
                     animated:YES
                   completion:nil];
```

#### 3. 图片预览弹窗 Image Preview
```objc
// 创建图片预览视图
UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
imageView.contentMode = UIViewContentModeScaleAspectFit;

// 全屏展示
TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
containerConfig.width = [TFYPopupContainerDimension ratio:1.0];
containerConfig.height = [TFYPopupContainerDimension ratio:1.0];

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.containerConfiguration = containerConfig;
config.backgroundColor = [UIColor blackColor];

[TFYPopupView showContentView:imageView
                configuration:config
                     animator:[[TFYPopup3DFlipAnimator alloc] init]
                     animated:YES
                   completion:nil];
```

#### 4. 表单输入弹窗 Form Input
```objc
// 创建表单视图
UIView *formView = [self createFormView];

// 键盘适配配置
TFYPopupKeyboardConfiguration *keyboardConfig = [[TFYPopupKeyboardConfiguration alloc] init];
keyboardConfig.isEnabled = YES;
keyboardConfig.avoidingMode = TFYKeyboardAvoidingModeConstraint;
keyboardConfig.additionalOffset = 20;

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.keyboardConfiguration = keyboardConfig;

[TFYPopupView showContentView:formView
                configuration:config
                     animator:[[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromBottom]
                     animated:YES
                   completion:nil];
```

---

## 📁 项目结构 Project Structure

```
TFYOCPanModelDemo/
├── Package.swift                    # Swift Package Manager 配置文件
├── TFYOCPanlModel.podspec          # CocoaPods 配置文件
└── Sources/
    └── TFYOCPanlModel/              # 核心库源代码
        ├── include/                 # 主头文件目录
        │   ├── TFYOCPanlModel.h    # 主头文件
        │   └── module.modulemap     # 模块映射文件
        ├── Tools/                   # 工具类（无依赖）
        │   ├── KeyValueObserver.{h,m}
        │   ├── UIScrollView+Helper.{h,m}
        │   └── UIView+TFY_Frame.{h,m}
        ├── popController/           # 控制弹出模块（依赖 Tools）
        │   ├── TFYPanModalPresentable.h          # 核心协议
        │   ├── TFYPanModalHeight.h               # 高度配置
        │   ├── TFYPanModalPanGestureDelegate.h   # 手势代理
        │   ├── TFYPanModalFrequentTapPrevention.{h,m} # 防频繁点击
        │   ├── UIViewController+PanModalDefault.{h,m}
        │   ├── UIViewController+Presentation.{h,m}
        │   ├── UIViewController+PanModalPresenter.{h,m}
        │   ├── TFYPanModalPresentationController.{h,m}
        │   ├── TFYBackgroundConfig.{h,m}         # 背景配置
        │   ├── TFYDimmedView.{h,m}              # 背景遮罩
        │   ├── TFYPanModalShadow.{h,m}          # 阴影配置
        │   ├── TFYVisualEffectView.{h,m}        # 模糊效果
        │   ├── TFYPanModalAnimator.{h,m}        # 动画器
        │   └── ... (其他控制器相关文件)
        └── popView/                 # 弹窗框架模块（独立模块）
            ├── TFYPopup.h                        # 弹窗框架主头文件
            ├── TFYPopupView.{h,m}                # 弹窗视图主类
            ├── TFYPopupViewConfiguration.{h,m}   # 弹窗配置
            ├── TFYPopupViewAnimator.h            # 动画器协议
            ├── TFYPopupViewDelegate.h            # 弹窗代理
            ├── TFYPopupAnimators.{h,m}           # 基础动画器集合
            ├── TFYPopupBaseAnimator.{h,m}        # 基础动画器
            ├── TFYPopupBottomSheetAnimator.{h,m} # 底部弹出框动画器
            ├── TFYPopupAnimatorLayout.{h,m}      # 布局配置系统
            ├── TFYPopupBackgroundView.{h,m}      # 背景视图
            ├── TFYPopupContainerConfiguration.{h,m} # 容器配置
            └── TFYPopupKeyboardConfiguration.{h,m}   # 键盘配置
```

---

## 🎭 TFYPopup 弹窗框架 TFYPopup Framework (NEW!)

### 🌟 框架概述 Framework Overview

TFYPopup 是一个全新的弹窗框架，提供了更加灵活和强大的弹窗解决方案。它支持多种动画效果、灵活的容器配置、完善的键盘适配和丰富的交互体验。

### 🎯 核心组件 Core Components

#### 1. TFYPopupView - 主弹窗视图
```objc
// 基础使用
UIView *contentView = [[UIView alloc] init];
[TFYPopupView showContentView:contentView animated:YES completion:nil];

// 高级配置
TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.dismissOnBackgroundTap = YES;
config.enableDragToDismiss = YES;

[TFYPopupView showContentView:contentView
                configuration:config
                     animator:[[TFYPopupSpringAnimator alloc] init]
                     animated:YES
                   completion:nil];
```

#### 2. 动画器系统 Animator System
```objc
// 基础动画器
TFYPopupFadeInOutAnimator *fadeAnimator = [[TFYPopupFadeInOutAnimator alloc] init];
TFYPopupZoomInOutAnimator *zoomAnimator = [[TFYPopupZoomInOutAnimator alloc] init];
TFYPopupSpringAnimator *springAnimator = [[TFYPopupSpringAnimator alloc] init];
TFYPopupBounceAnimator *bounceAnimator = [[TFYPopupBounceAnimator alloc] init];

// 方向动画器
TFYPopupSlideAnimator *slideAnimator = [[TFYPopupSlideAnimator alloc] 
    initWithDirection:TFYPopupSlideDirectionFromTop];

// 底部弹出框动画器
TFYPopupBottomSheetAnimator *bottomSheetAnimator = [[TFYPopupBottomSheetAnimator alloc] init];
[bottomSheetAnimator enableGestures]; // 启用手势交互
```

#### 3. 容器配置系统 Container Configuration
```objc
TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];

// 固定尺寸
containerConfig.width = [TFYPopupContainerDimension fixed:300];
containerConfig.height = [TFYPopupContainerDimension fixed:200];

// 自动尺寸
containerConfig.width = [TFYPopupContainerDimension automatic];
containerConfig.height = [TFYPopupContainerDimension automatic];

// 比例尺寸
containerConfig.width = [TFYPopupContainerDimension ratio:0.8]; // 80%宽度
containerConfig.height = [TFYPopupContainerDimension ratio:0.6]; // 60%高度

// 自定义尺寸
containerConfig.width = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
    return MIN([UIScreen mainScreen].bounds.size.width * 0.9, 400);
}];

// 样式配置
containerConfig.cornerRadius = 16;
containerConfig.shadowEnabled = YES;
containerConfig.contentInsets = UIEdgeInsetsMake(20, 20, 20, 20);
```

#### 4. 布局系统 Layout System
```objc
// 居中布局
TFYPopupAnimatorLayoutCenter *centerLayout = 
    [TFYPopupAnimatorLayoutCenter layoutWithOffsetY:0 offsetX:0];
TFYPopupAnimatorLayout *layout = [TFYPopupAnimatorLayout centerLayout:centerLayout];

// 顶部布局
TFYPopupAnimatorLayoutTop *topLayout = 
    [TFYPopupAnimatorLayoutTop layoutWithTopMargin:100 offsetX:0];
TFYPopupAnimatorLayout *layout = [TFYPopupAnimatorLayout topLayout:topLayout];

// 底部布局
TFYPopupAnimatorLayoutBottom *bottomLayout = 
    [TFYPopupAnimatorLayoutBottom layoutWithBottomMargin:50 offsetX:0];
TFYPopupAnimatorLayout *layout = [TFYPopupAnimatorLayout bottomLayout:bottomLayout];
```

### 🎨 Swift 支持 Swift Support

框架完全支持 Swift 调用，所有类、方法、枚举都提供了 `NS_SWIFT_NAME` 映射：

```swift
import TFYOCPanlModel

// Swift 中的优雅调用
let contentView = UIView()

// 基础使用
PopupView.show(contentView: contentView, animated: true, completion: nil)

// 高级配置
let config = PopupViewConfiguration()
config.dismissOnBackgroundTap = true
config.enableDragToDismiss = true

PopupView.show(contentView: contentView, 
               configuration: config,
               animator: PopupSpringAnimator(),
               animated: true,
               completion: nil)

// 容器配置
let containerConfig = PopupContainerConfiguration()
containerConfig.width = PopupContainerDimension.ratio(0.8)
containerConfig.height = PopupContainerDimension.automatic()
containerConfig.cornerRadius = 16
```

### 🎪 使用场景 Use Cases

#### 1. 简单提示弹窗
```objc
UILabel *label = [[UILabel alloc] init];
label.text = @"操作成功！";
label.textAlignment = NSTextAlignmentCenter;

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.autoDismissDelay = 2.0; // 2秒后自动消失

[TFYPopupView showContentView:label
                configuration:config
                     animator:[[TFYPopupFadeInOutAnimator alloc] init]
                     animated:YES
                   completion:nil];
```

#### 2. 底部操作面板
```objc
UIView *actionPanel = [self createActionPanel];

TFYPopupBottomSheetConfiguration *bottomConfig = [[TFYPopupBottomSheetConfiguration alloc] init];
bottomConfig.defaultHeight = 300;
bottomConfig.enableGestures = YES;

TFYPopupBottomSheetAnimator *animator = [[TFYPopupBottomSheetAnimator alloc] 
    initWithConfiguration:bottomConfig];

[TFYPopupView showContentView:actionPanel
                configuration:[[TFYPopupViewConfiguration alloc] init]
                     animator:animator
                     animated:YES
                   completion:nil];
```

#### 3. 自定义尺寸弹窗
```objc
UIView *customView = [self createCustomView];

TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
containerConfig.width = [TFYPopupContainerDimension customWithHandler:^CGFloat(UIView *contentView) {
    // 根据内容动态计算宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return MIN(screenWidth * 0.9, 400);
}];
containerConfig.height = [TFYPopupContainerDimension fixed:250];
containerConfig.cornerRadius = 12;
containerConfig.shadowEnabled = YES;

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.containerConfiguration = containerConfig;

[TFYPopupView showContentView:customView
                configuration:config
                     animator:[[TFYPopupBounceAnimator alloc] init]
                     animated:YES
                   completion:nil];
```

#### 4. 键盘自适应弹窗
```objc
UIView *inputView = [self createInputView];

TFYPopupKeyboardConfiguration *keyboardConfig = [[TFYPopupKeyboardConfiguration alloc] init];
keyboardConfig.isEnabled = YES;
keyboardConfig.avoidingMode = TFYKeyboardAvoidingModeTransform;
keyboardConfig.additionalOffset = 10;

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.keyboardConfiguration = keyboardConfig;

[TFYPopupView showContentView:inputView
                configuration:config
                     animator:[[TFYPopupSlideAnimator alloc] initWithDirection:TFYPopupSlideDirectionFromBottom]
                     animated:YES
                   completion:nil];
```

### 🎬 动画类型 Animation Types

| 动画器 | 效果描述 | Swift 名称 |
|--------|----------|-----------|
| `TFYPopupFadeInOutAnimator` | 淡入淡出效果 | `PopupFadeInOutAnimator` |
| `TFYPopupZoomInOutAnimator` | 缩放动画 | `PopupZoomInOutAnimator` |
| `TFYPopup3DFlipAnimator` | 3D 翻转效果 | `Popup3DFlipAnimator` |
| `TFYPopupSpringAnimator` | 弹簧动画 | `PopupSpringAnimator` |
| `TFYPopupBounceAnimator` | 弹跳效果 | `PopupBounceAnimator` |
| `TFYPopupRotateAnimator` | 旋转动画 | `PopupRotateAnimator` |
| `TFYPopupSlideAnimator` | 滑动动画 | `PopupSlideAnimator` |
| `TFYPopupBottomSheetAnimator` | 底部弹出框 | `PopupBottomSheetAnimator` |

### 📐 容器尺寸类型 Container Dimension Types

| 类型 | 描述 | 使用示例 |
|------|------|----------|
| `Fixed` | 固定尺寸 | `[TFYPopupContainerDimension fixed:300]` |
| `Automatic` | 自动适配内容 | `[TFYPopupContainerDimension automatic]` |
| `Ratio` | 屏幕比例 | `[TFYPopupContainerDimension ratio:0.8]` |
| `Custom` | 自定义计算 | `[TFYPopupContainerDimension customWithHandler:block]` |

### 🎛️ 配置选项 Configuration Options

#### 主配置 Main Configuration
```objc
TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];

// 交互配置
config.isDismissible = YES;                    // 是否可消失
config.isInteractive = YES;                    // 是否可交互
config.dismissOnBackgroundTap = YES;           // 点击背景消失
config.enableDragToDismiss = YES;              // 拖拽消失
config.swipeToDismiss = YES;                   // 滑动消失

// 外观配置
config.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
config.cornerRadius = 12;
config.respectsSafeArea = YES;

// 自动消失
config.autoDismissDelay = 3.0;                 // 3秒后自动消失

// 触觉反馈
config.enableHapticFeedback = YES;

// 无障碍支持
config.enableAccessibility = YES;
```

#### 阴影配置 Shadow Configuration
```objc
// 阴影配置已整合到容器配置中
config.containerConfiguration.shadowEnabled = YES;
config.containerConfiguration.shadowColor = [UIColor blackColor];
config.containerConfiguration.shadowOpacity = 0.3;
config.containerConfiguration.shadowRadius = 10;
config.containerConfiguration.shadowOffset = CGSizeMake(0, 5);
```

### 🔧 高级特性 Advanced Features

#### 1. 多弹窗管理
```objc
// 获取当前弹窗数量
NSInteger count = [TFYPopupView currentPopupCount];

// 获取所有当前弹窗
NSArray<TFYPopupView *> *allPopups = [TFYPopupView allCurrentPopups];

// 关闭所有弹窗
[TFYPopupView dismissAllAnimated:YES completion:nil];

// 设置最大弹窗数量限制
config.maxPopupCount = 3;
```

#### 2. 主题支持
```objc
// 自动适配系统主题
config.theme = TFYPopupThemeDefault;

// 手动设置主题
config.theme = TFYPopupThemeDark;

// 自定义主题
config.theme = TFYPopupThemeCustom;
config.customThemeBackgroundColor = [UIColor systemBlueColor];
config.customThemeTextColor = [UIColor whiteColor];
```

#### 3. 全局函数
```objc
// 检查是否有弹窗正在显示
BOOL isPresenting = TFYPopupIsPresenting();

// 设置全局调试模式
TFYPopupSetDebugMode(YES);

// 获取调试模式状态
BOOL debugEnabled = TFYPopupGetDebugMode();
```

#### 4. 通知系统
```objc
// 监听弹窗生命周期
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(popupWillAppear:)
                                             name:TFYPopupWillAppearNotification
                                           object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(popupDidAppear:)
                                             name:TFYPopupDidAppearNotification
                                           object:nil];
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

### PanModal 常见问题 PanModal FAQ

#### Q: 如何禁用拖拽关闭？
```objc
- (BOOL)allowsDragToDismiss {
    return NO;
}
```

#### Q: 如何自定义弹窗高度？
```objc
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 400);
}
```

#### Q: 如何添加模糊背景？
```objc
- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorSystemVisualEffect];
}
```

#### Q: 如何支持滚动视图？
```objc
- (UIScrollView *)panScrollable {
    return self.tableView;
}
```

#### Q: 如何控制生命周期方法？
```objc
- (BOOL)shouldEnableAppearanceTransition {
    return NO; // 不触发外部viewDidAppear/viewDidDisappear
}
```

#### Q: 如何启用防频繁点击功能？
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

### TFYPopup 常见问题 TFYPopup FAQ

#### Q: 如何创建简单的提示弹窗？
```objc
UILabel *label = [[UILabel alloc] init];
label.text = @"提示信息";

[TFYPopupView showContentView:label animated:YES completion:nil];
```

#### Q: 如何设置弹窗自动消失？
```objc
TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.autoDismissDelay = 3.0; // 3秒后自动消失

[TFYPopupView showContentView:contentView configuration:config animator:nil animated:YES completion:nil];
```

#### Q: 如何禁用背景点击关闭？
```objc
TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.dismissOnBackgroundTap = NO;
```

#### Q: 如何自定义弹窗尺寸？
```objc
TFYPopupContainerConfiguration *containerConfig = [[TFYPopupContainerConfiguration alloc] init];
containerConfig.width = [TFYPopupContainerDimension fixed:300];
containerConfig.height = [TFYPopupContainerDimension fixed:200];

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.containerConfiguration = containerConfig;
```

#### Q: 如何使用底部弹出框？
```objc
TFYPopupBottomSheetAnimator *animator = [[TFYPopupBottomSheetAnimator alloc] init];
[animator enableGestures]; // 启用手势交互

[TFYPopupView showContentView:contentView 
                configuration:[[TFYPopupViewConfiguration alloc] init]
                     animator:animator
                     animated:YES
                   completion:nil];
```

#### Q: 如何关闭所有弹窗？
```objc
[TFYPopupView dismissAllAnimated:YES completion:^{
    NSLog(@"所有弹窗已关闭");
}];
```

#### Q: 如何监听弹窗生命周期？
```objc
// 通过回调
popup.willDisplayCallback = ^{
    NSLog(@"弹窗即将显示");
};

popup.didDismissCallback = ^{
    NSLog(@"弹窗已经消失");
};

// 通过通知
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(popupDidAppear:)
                                             name:TFYPopupDidAppearNotification
                                           object:nil];
```

#### Q: 如何在 Swift 中使用？
```swift
// 基础用法
PopupView.show(contentView: myView, animated: true, completion: nil)

// 高级配置
let config = PopupViewConfiguration()
config.dismissOnBackgroundTap = true

PopupView.show(contentView: myView,
               configuration: config,
               animator: PopupSpringAnimator(),
               animated: true,
               completion: nil)
```

#### Q: 如何处理键盘遮挡？
```objc
TFYPopupKeyboardConfiguration *keyboardConfig = [[TFYPopupKeyboardConfiguration alloc] init];
keyboardConfig.isEnabled = YES;
keyboardConfig.avoidingMode = TFYKeyboardAvoidingModeConstraint;

TFYPopupViewConfiguration *config = [[TFYPopupViewConfiguration alloc] init];
config.keyboardConfiguration = keyboardConfig;
```

#### Q: 如何使用 Swift Package Manager 安装？
1. 在 Xcode 中，选择 **File** → **Add Package Dependencies...**
2. 输入仓库 URL：`https://github.com/13662049573/TFYOCPanModelDemo.git`
3. 选择版本或分支
4. 点击 **Add Package** 完成添加

#### Q: 如何删除并重新导入 Swift Package Manager 依赖？

**删除 SPM 依赖（按顺序执行）：**

**步骤 1：先从所有 Target 中移除包**

1. 在 Xcode 项目导航器中，选择项目文件（最顶部的蓝色图标）
2. 选择你的 **每个 Target**（如果有多个）
3. 切换到 **General** 标签页
4. 在 **Frameworks, Libraries, and Embedded Content** 部分
5. 找到 `TFYOCPanlModel`，点击 **减号 (-)** 删除
6. 重复此步骤，确保从**所有 Target** 中移除

**步骤 2：从 Package Dependencies 中移除**

1. 选择项目文件（最顶部的蓝色图标）
2. 切换到 **Package Dependencies** 标签页
3. 找到 `TFYOCPanModelDemo` 或 `TFYOCPanlModel` 包
4. 点击包名称左侧的 **减号 (-)** 按钮，或者右键点击选择 **Remove Package**
5. 在弹出的确认对话框中点击 **Remove Package**

**如果删除按钮不可用或删除失败：**

**方法 1：清理缓存后重试**
1. 关闭 Xcode
2. 在终端执行：
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/
   rm -rf ~/Library/Caches/org.swift.swiftpm/
   ```
3. 重新打开 Xcode
4. 重复步骤 1 和 2

**方法 2：手动删除 Package.resolved**
1. 关闭 Xcode
2. 在项目根目录找到 `Package.resolved` 文件
3. 删除该文件
4. 重新打开 Xcode
5. 重复步骤 1 和 2

**方法 3：手动编辑项目文件（最后手段）**
1. 关闭 Xcode
2. 在项目根目录找到 `.xcodeproj` 文件
3. 右键点击 → **显示包内容**
4. 打开 `project.pbxproj` 文件（建议先备份）
5. 搜索 `TFYOCPanModelDemo` 或 `TFYOCPanlModel`
6. 删除所有包含该包的行（包括 `packageProductDependency`、`packageReferences` 等）
7. 保存文件
8. 重新打开 Xcode

**清理缓存（推荐在删除前执行）：**

1. 在 Xcode 中：
   - **Product** → **Clean Build Folder** (Shift + Cmd + K)
   - **File** → **Packages** → **Reset Package Caches**
2. 关闭 Xcode
3. 删除以下目录：
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/
   rm -rf ~/Library/Caches/org.swift.swiftpm/
   ```
4. 重新打开 Xcode

**重新导入：**

按照上面的安装步骤重新添加即可。

#### Q: 如何更新到新版本（如从 1.5.3 更新到 1.5.6）？

**方法 1：通过 Xcode 更新（推荐）**

1. 在 Xcode 中，选择项目文件（最顶部的蓝色图标）
2. 切换到 **Package Dependencies** 标签页
3. 找到 `TFYOCPanModelDemo` 包
4. 右键点击包，选择 **Update to Latest Package Versions**
5. 或者点击包右侧的版本号，选择新版本（如 1.5.6）

**如果更新按钮不可用或无法更新：**

**方法 2：强制更新（清理缓存后重新解析）**

1. 在 Xcode 中：
   - **File** → **Packages** → **Reset Package Caches**
   - **File** → **Packages** → **Resolve Package Versions**
   - **Product** → **Clean Build Folder** (Shift + Cmd + K)

2. 如果还是不行，关闭 Xcode，在终端执行：
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/
   rm -rf ~/Library/Caches/org.swift.swiftpm/
   ```

3. 重新打开 Xcode，重复方法 1 的步骤

**方法 3：删除后重新添加（最彻底）**

1. 按照上面的删除步骤完全移除旧版本
2. 清理缓存（见方法 2）
3. 重新添加包，选择新版本（如 1.5.6）

**方法 4：手动指定版本（在 Package.swift 中）**

如果你的项目使用 `Package.swift`，直接修改版本号：
```swift
dependencies: [
    .package(url: "https://github.com/13662049573/TFYOCPanModelDemo.git", from: "1.5.6")
]
```
然后在 Xcode 中：**File** → **Packages** → **Update to Latest Package Versions**

#### Q: Swift Package Manager 和 CocoaPods 有什么区别？
- **Swift Package Manager**：Apple 官方依赖管理工具，集成在 Xcode 中，无需额外安装
- **CocoaPods**：第三方依赖管理工具，需要单独安装，功能更丰富
- 两者功能相同，选择任意一种即可

#### Q: 如何在 Swift Package Manager 项目中导入？
```swift
import TFYOCPanlModel
```

```objc
// 导入主头文件（推荐）
#import <TFYOCPanlModel/TFYOCPanlModel.h>

// 或者导入具体的头文件
#import <TFYOCPanlModel/TFYPanModalPresentable.h>
#import <TFYOCPanlModel/TFYPopup.h>
```

**注意**：从 1.6.3 版本开始，所有头文件导入必须使用 `#import <TFYOCPanlModel/...>` 格式，不再支持相对路径导入。

#### Q: 出现 "No such module 'TFYOCPanlModel'" 错误怎么办？

这是常见的 SPM 导入问题，按以下步骤排查：

**1. 检查包是否正确添加**
- 在 Xcode 项目导航器中，确认能看到 `Package Dependencies` 下的 `TFYOCPanlModel`
- 如果看不到，重新添加包依赖

**2. 检查 Target 链接**
- 选择项目文件 → 选择你的 Target
- 切换到 **General** 标签页
- 在 **Frameworks, Libraries, and Embedded Content** 中确认有 `TFYOCPanlModel`
- 如果没有，点击 **+** 添加

**3. 清理并重新构建**
```bash
# 在终端中执行
cd 你的项目目录
rm -rf ~/Library/Developer/Xcode/DerivedData/
rm -rf ~/Library/Caches/org.swift.swiftpm/
```
然后在 Xcode 中：
- **Product** → **Clean Build Folder** (Shift + Cmd + K)
- **File** → **Packages** → **Reset Package Caches**
- **File** → **Packages** → **Update to Latest Package Versions**

**4. 检查导入语句**
- **Swift 项目**：使用 `import TFYOCPanlModel`
- **Objective-C 项目**：使用 `#import <TFYOCPanlModel/TFYOCPanlModel.h>`

**5. 检查平台版本**
- 确保项目的最低部署目标 ≥ iOS 15.0
- 在 Target 的 **General** → **Deployment Info** 中检查

**6. 重新解析包**
- **File** → **Packages** → **Resolve Package Versions**
- 等待解析完成后再构建

**7. 如果仍然不行，删除并重新添加**
- 按照上面的删除步骤移除包
- 清理缓存
- 重新添加包依赖

#### Q: 出现 "Could not build Objective-C module 'TFYOCPanlModel'" 错误怎么办？

这个错误通常出现在以下情况：

**1. 在 macOS 上使用命令行构建**
- ❌ **错误**：在终端使用 `swift build` 构建 iOS 库
- ✅ **解决**：必须在 **Xcode 中构建**，因为这是 iOS 库，需要 iOS SDK

**2. 模块映射问题（umbrella header not found）** ✅ 已修复
- ❌ **错误原因**：SPM 的 Clang 依赖扫描器会读取 `module.modulemap` 文件，即使它在 `exclude` 中
- ✅ **解决方案**：已将 `module.modulemap` 重命名为 `module.modulemap.cocoapods`
- ✅ **结果**：SPM 会自动生成模块映射，不再读取手动创建的 `module.modulemap`
- 如果仍然出现此错误，清理缓存并重新解析包：
  ```bash
  rm -rf ~/Library/Developer/Xcode/DerivedData/
  rm -rf ~/Library/Caches/org.swift.swiftpm/
  ```
  然后在 Xcode 中：
  - **File** → **Packages** → **Reset Package Caches**
  - **File** → **Packages** → **Resolve Package Versions**
  - **Product** → **Clean Build Folder** (Shift + Cmd + K)

**3. 头文件导入问题**
- 确保所有头文件的路径正确
- 检查是否有循环依赖

**4. 平台配置问题**
- 确保 Package.swift 中设置了正确的平台：`platforms: [.iOS(.v15)]`
- 确保项目的部署目标 ≥ iOS 15.0

**5. 清理并重新构建**
```bash
# 清理 SPM 缓存
rm -rf ~/Library/Developer/Xcode/DerivedData/
rm -rf ~/Library/Caches/org.swift.swiftpm/

# 在 Xcode 中
# Product → Clean Build Folder (Shift + Cmd + K)
# File → Packages → Reset Package Caches
```

**重要提示**：
- ✅ **正确**：在 Xcode 中打开项目并构建
- ❌ **错误**：在终端使用 `swift build`（iOS 库必须在 Xcode 中构建）

#### Q: 为什么在 Xcode 中看到 Demo 项目和其他文件？
这是 **Swift Package Manager 的正常行为**。Xcode 会显示整个 Git 仓库的文件树，但**实际编译和使用的只有 Package.swift 中定义的库文件**。

**重要说明**：
- ✅ **会被编译和使用**：`TFYOCPanModelDemo/Sources/TFYOCPanlModel/` 目录下的所有库文件
- ❌ **不会被编译和使用**：Demo 项目、测试项目、Podfile、Pods 等其他文件

Package.swift 中的 `path: "TFYOCPanModelDemo/Sources/TFYOCPanlModel"` 配置确保了：
- 只有库的源代码会被编译和链接到你的项目中
- Demo 项目、测试项目等**完全不会影响**你的项目
- 你可以安全地忽略 Xcode 中显示的其他文件

**这是 SPM 的设计特性**：它会显示整个仓库结构，但只使用 Package.swift 中指定的文件。虽然看起来有很多文件，但实际上只有库文件会被使用。

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
- Xcode 12.0+
- iOS 15.0+
- CocoaPods 或 Swift Package Manager

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