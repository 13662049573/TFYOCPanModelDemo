# TFYOCPanlModel

TFYOCPanlModel 是一套高扩展性的 Objective-C 弹窗组件，支持多种弹窗样式、交互动画与自定义扩展，适用于 iOS 各类弹窗场景。

## 主要特性

- 🎯 **多种弹窗样式**：支持全屏、半屏、购物车等多种弹窗样式
- 🎨 **丰富的交互动画**：提供流畅的手势交互和动画效果
- 🔧 **高度可定制**：支持自定义UI组件和交互逻辑
- 📱 **iOS 15.0+**：支持最新的iOS系统版本
- ♻️ **完整的生命周期管理**：自动管理弹窗的显示和隐藏
- 🌙 **深色模式支持**：完美适配系统的深色模式
- 🚀 **Framework架构**：重构为framework架构，提升性能和稳定性

## 系统要求

- iOS 15.0+
- Xcode 13.0+
- Objective-C

## 安装方法

### CocoaPods

```ruby
pod 'TFYOCPanlModel', '~> 1.0.9'
```

### 手动安装

1. 下载 `TFYOCPanlModel.framework`
2. 将framework添加到你的Xcode项目中
3. 在Build Settings中设置Framework Search Paths
4. 链接framework到你的target

## 快速开始

### 基本使用

```objc
#import <TFYOCPanlModel/TFYOCPanlModel.h>

// 创建弹窗视图控制器
UIViewController *modalVC = [[UIViewController alloc] init];
modalVC.view.backgroundColor = [UIColor whiteColor];

// 使用PanModal展示
[modalVC presentPanModal:modalVC animated:YES completion:nil];
```

### 自定义弹窗样式

```objc
// 实现TFYPanModalPresentable协议
@interface MyCustomViewController : UIViewController <TFYPanModalPresentable>
@end

@implementation MyCustomViewController

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 300);
}

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 200);
}

@end
```

## 架构说明

TFYOCPanlModel采用模块化设计，主要包含以下组件：

- **Presentable**: 弹窗内容协议和实现
- **Presenter**: 弹窗展示器
- **Controller**: 弹窗控制器
- **Animator**: 动画控制器
- **View**: UI组件
- **Category**: 分类扩展

## 示例项目

项目包含丰富的示例代码，展示各种弹窗样式的实现：

- Alert弹窗
- 购物车弹窗
- 全屏弹窗
- 自定义动画弹窗
- 嵌套滚动弹窗
- 频繁点击防护

## 更新日志

### 1.0.9
- 修复podspec配置，支持framework架构
- 解决验证问题，提升兼容性

### 1.0.8
- 重构项目为framework结构
- 更新podspec配置，支持iOS 15.0+

### 1.0.7 及更早版本
- 基础弹窗功能实现
- 多种弹窗样式支持

## 许可证

MIT License

## 联系方式

- 作者：tianfengyou
- 邮箱：420144542@qq.com
- GitHub：[https://github.com/13662049573/TFYOCPanModelDemo](https://github.com/13662049573/TFYOCPanModelDemo)

## 贡献

欢迎提交Issue和Pull Request来帮助改进这个项目！ 