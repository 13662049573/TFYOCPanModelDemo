# TFYOCPanlModel

高扩展性OC弹窗组件，支持多种弹窗样式与交互。

A highly extensible Objective-C modal/pan modal component for iOS, supporting multiple modal styles and custom interactions.

## 特性 Features
- 支持多种弹窗样式（底部弹窗、全屏、iPad popover等）
- 丰富的交互动画与自定义扩展
- 详细的协议与分类，便于二次开发
- 兼容iOS 11+
- 纯OC实现，易于集成

## 安装 Installation

推荐使用 [CocoaPods](https://cocoapods.org/)：

```ruby
pod 'TFYOCPanlModel', '~> 1.0.0'
```

## 快速开始 Quick Start

```objc
#import <TFYOCPanlModel/TFYOCPanlModel.h>

// 假设你的ViewController已实现TFYPanModalPresentable协议
TFYDemoViewController *vc = [[TFYDemoViewController alloc] init];
[self presentPanModal:vc];
```

## 目录结构 Structure

- TFYOCPanlModel/Presentable/   协议与分类
- TFYOCPanlModel/Controller/    弹窗控制器
- TFYOCPanlModel/View/          视图与UI组件
- TFYOCPanlModel/Animator/      动画与转场
- TFYOCPanlModel/Delegate/      转场代理
- TFYOCPanlModel/Category/      UIKit扩展
- TFYOCPanlModel/KVO/           KVO辅助
- TFYOCPanlModel/Mediator/      事件中介

## 贡献 Contributing
欢迎提交Issue和PR，完善文档和功能。

## License
MIT

## 联系方式 Contact
作者: tianfengyou  
邮箱: 420144542@qq.com

---

TFYOCPanlModel is released under the MIT license. See [LICENSE](./LICENSE) for details. 