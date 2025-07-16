

Pod::Spec.new do |spec|

  spec.name         = "TFYOCPanlModel"

  spec.version      = "1.0.0"

  spec.summary      = "TFYOCPanlModel：高扩展性OC弹窗组件，支持多种弹窗样式与交互。"

  spec.description  = <<-DESC
    TFYOCPanlModel 是一套高扩展性的 Objective-C 弹窗组件，支持多种弹窗样式、交互动画与自定义扩展，适用于 iOS 各类弹窗场景。
  DESC

  spec.homepage     = "https://github.com/13662049573/TFYOCPanModelDemo"
  
  spec.platform     = :ios, "15.0"
  spec.ios.deployment_target = "15.0"

  spec.license      = "MIT"
  

  spec.author       = { "tianfengyou" => "420144542@qq.com" }
  
  spec.source       = { :git => "https://github.com/13662049573/TFYOCPanModelDemo.git", :tag => spec.version }

  # 源码文件递归所有.h/.m
  spec.source_files  = "TFYOCPanModelDemo/TFYOCPanlModel/**/*.{h,m}"

  # 公共头文件（主头文件及其import的所有头文件）
  spec.public_header_files = [
    "TFYOCPanModelDemo/TFYOCPanlModel/TFYOCPanlModel.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Presentable/TFYPanModalPresentable.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Presentable/TFYPanModalPanGestureDelegate.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Presentable/TFYPanModalHeight.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Presenter/TFYPanModalPresenterProtocol.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Presentable/UIViewController+PanModalDefault.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Presentable/UIViewController+Presentation.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Presenter/UIViewController+PanModalPresenter.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/Animator/TFYPresentingVCAnimatedTransitioning.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/View/TFYPanModalIndicatorProtocol.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/View/TFYPanIndicatorView.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/View/TFYDimmedView.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/View/PanModal/TFYPanModalContentView.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/View/TFYBackgroundConfig.h",
    "TFYOCPanModelDemo/TFYOCPanlModel/View/TFYPanModalShadow.h"
  ]

end
