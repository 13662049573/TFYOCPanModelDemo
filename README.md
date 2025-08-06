# TFYOCPanlModel

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS%20%7C%20ObjC%20%7C%20Swift-blue.svg" alt="platform"/>
  <img src="https://img.shields.io/badge/iOS-15%2B-orange.svg" alt="iOS"/>
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="license"/>
  <img src="https://img.shields.io/badge/language-Objective--C%20%7C%20Swift-blue.svg" alt="language"/>
</p>

---

> **TFYOCPanlModel：高扩展性OC弹窗组件，支持多种弹窗样式与交互，兼容iOS 15+，支持Swift调用。**  
> **A highly extensible Objective-C modal/pan modal component for iOS 15+, supporting multiple modal styles, custom interactions, and Swift integration.**

---

## ✨ 特性 Features

| 特性 Features                | 说明 Description                                      |
|-----------------------------|------------------------------------------------------|
| 多样弹窗样式                | 底部弹窗、全屏、iPad popover等                        |
| 丰富交互动画                | 支持自定义转场、手势交互、拖拽、圆角、阴影等          |
| 协议与分类                  | 详细协议，便于二次开发和扩展                          |
| 纯OC实现，Swift友好         | Objective-C实现，支持Swift项目直接调用                |
| 兼容iOS 15+                 | 适配最新系统，支持深色模式、iPad多窗口                |

---

## 🚀 安装 Installation

推荐使用 [CocoaPods](https://cocoapods.org/)：

```ruby
pod 'TFYOCPanlModel', '~> 1.0.6'
```

- **最低支持 iOS 15+**
- 支持 Objective-C 和 Swift 项目

---

## 🛠️ 快速开始 Quick Start

### Objective-C
```objc
#import <TFYOCPanlModel/TFYOCPanlModel.h>

// 假设你的ViewController已实现TFYPanModalPresentable协议
TFYDemoViewController *vc = [[TFYDemoViewController alloc] init];
[self presentPanModal:vc];
```

### Swift
```swift
import TFYOCPanlModel

class DemoVC: UIViewController, TFYPanModalPresentable {
    // ...实现协议方法
}

let vc = DemoVC()
presentPanModal(vc)
```

---

## 📁 目录结构 Structure

```text
TFYOCPanlModelDemo/TFYOCPanlModel/
├── Presentable/   # 协议与分类
├── Controller/    # 弹窗控制器
├── View/          # 视图与UI组件
├── Animator/      # 动画与转场
├── Delegate/      # 转场代理
├── Category/      # UIKit扩展
├── KVO/           # KVO辅助
├── Mediator/      # 事件中介
```

---

## 🌟 主要API Main API

- `TFYPanModalPresentable` 协议：自定义弹窗行为
- `presentPanModal:`/`presentPanModal(_: UIViewController)`：一行代码弹出
- 丰富的动画、手势、阴影、圆角等配置

---

## 🤝 贡献 Contributing
欢迎提交 Issue 和 PR，完善文档和功能。

---

## 📄 License
MIT License. See [LICENSE](./LICENSE) for details.

---

## 📬 联系方式 Contact
作者: tianfengyou  
邮箱: 420144542@qq.com

--- 