//
//  TFYFormInputPanModalView.m
//  TFYPanModalDemo
//
//  Created by admin on 2025/1/16.
//

#import "TFYFormInputPanModalView.h"
#import <Masonry/Masonry.h>

@interface TFYFormInputPanModalView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation TFYFormInputPanModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"联系表单";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor darkTextColor];
    [self addSubview:self.titleLabel];
    
    // 姓名输入框
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.placeholder = @"请输入姓名";
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nameTextField];
    
    // 邮箱输入框
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.placeholder = @"请输入邮箱";
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.font = [UIFont systemFontOfSize:16];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self addSubview:self.emailTextField];
    
    // 消息输入框
    self.messageTextView = [[UITextView alloc] init];
    self.messageTextView.font = [UIFont systemFontOfSize:16];
    self.messageTextView.layer.borderWidth = 1.0;
    self.messageTextView.layer.borderColor = [UIColor systemGray4Color].CGColor;
    self.messageTextView.layer.cornerRadius = 8.0;
    self.messageTextView.text = @"请输入消息内容...";
    self.messageTextView.textColor = [UIColor systemGrayColor];
    [self addSubview:self.messageTextView];
    
    // 提交按钮
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor systemBlueColor];
    self.submitButton.layer.cornerRadius = 8.0;
    [self.submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
    
    // 取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelButton setTitleColor:[UIColor systemGrayColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@30);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@44);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextField.mas_bottom).offset(15);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@44);
    }];
    
    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTextField.mas_bottom).offset(15);
        make.left.right.equalTo(self).inset(20);
        make.height.equalTo(@100);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageTextView.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@50);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitButton.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Actions

- (void)submitAction {
    // 这里可以添加表单验证逻辑
    NSLog(@"提交表单");
    [self dismissAnimated:YES completion:^{}];
}

- (void)cancelAction {
    [self dismissAnimated:YES completion:^{}];
}

#pragma mark - TFYPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 400);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 500);
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 600);
}

- (CGFloat)topOffset {
    return self.safeAreaInsets.top + 21;
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}

- (CGFloat)cornerRadius {
    return 16.0;
}

- (PresentationState)originPresentationState {
    return PresentationStateMedium;
}

- (CGFloat)springDamping {
    return 0.8;
}

- (BOOL)isAutoHandleKeyboardEnabled {
    return YES;
}

- (CGFloat)keyboardOffsetFromInputView {
    return 10;
}

- (TFYBackgroundConfig *)backgroundConfig {
    return [TFYBackgroundConfig configWithBehavior:TFYBackgroundBehaviorDefault];
}

@end
