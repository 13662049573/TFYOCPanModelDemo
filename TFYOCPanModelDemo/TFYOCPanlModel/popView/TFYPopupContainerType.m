//
//  TFYPopupContainerType.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗容器类型实现
//

#import "TFYPopupContainerType.h"

#pragma mark - TFYPopupContainerInfo

@implementation TFYPopupContainerInfo

- (instancetype)initWithType:(TFYPopupContainerType)type
                containerView:(UIView *)containerView
                         name:(NSString *)name
            containerDescription:(NSString *)containerDescription
                   isAvailable:(BOOL)isAvailable
                      priority:(NSInteger)priority {
    self = [super init];
    if (self) {
        _type = type;
        _containerView = containerView;
        _name = [name copy];
        _containerDescription = [containerDescription copy];
        _isAvailable = isAvailable;
        _priority = priority;
    }
    return self;
}

+ (instancetype)windowContainer:(UIWindow *)window {
    NSString *name = [NSString stringWithFormat:@"Window_%p", window];
    NSString *description = [NSString stringWithFormat:@"UIWindow container (Level: %.0f)", window.windowLevel];
    return [[self alloc] initWithType:TFYPopupContainerTypeWindow
                        containerView:window
                                 name:name
                    containerDescription:description
                           isAvailable:window != nil && !window.hidden
                              priority:100];
}

+ (instancetype)viewContainer:(UIView *)view name:(NSString *)name {
    NSString *description = [NSString stringWithFormat:@"UIView container (%@)", NSStringFromClass([view class])];
    return [[self alloc] initWithType:TFYPopupContainerTypeView
                        containerView:view
                                 name:name
                    containerDescription:description
                           isAvailable:view != nil && view.window != nil
                              priority:50];
}

+ (instancetype)viewControllerContainer:(UIViewController *)viewController {
    NSString *name = [NSString stringWithFormat:@"ViewController_%p", viewController];
    NSString *description = [NSString stringWithFormat:@"UIViewController container (%@)", NSStringFromClass([viewController class])];
    UIView *containerView = viewController.view;
    
    // 检查是否在主线程，如果是则直接检查window，否则假设可用
    BOOL isAvailable = containerView != nil;
    if ([NSThread isMainThread]) {
        isAvailable = isAvailable && containerView.window != nil;
    }
    
    return [[self alloc] initWithType:TFYPopupContainerTypeViewController
                        containerView:containerView
                                 name:name
                    containerDescription:description
                           isAvailable:isAvailable
                              priority:75];
}

@end

#pragma mark - TFYPopupDefaultContainerSelector

@implementation TFYPopupDefaultContainerSelector

- (instancetype)initWithStrategy:(TFYPopupContainerSelectionStrategy)strategy {
    self = [super init];
    if (self) {
        _strategy = strategy;
        _preferWindowContainer = YES;
        _preferCurrentViewController = YES;
    }
    return self;
}

- (void)selectContainerFromAvailableContainers:(NSArray<TFYPopupContainerInfo *> *)availableContainers
                                    completion:(TFYPopupContainerSelectionCallback)completion {
    if (!availableContainers || availableContainers.count == 0) {
        NSError *error = [NSError errorWithDomain:@"TFYPopupContainerError"
                                             code:1001
                                         userInfo:@{NSLocalizedDescriptionKey: @"没有可用的容器"}];
        if (completion) completion(nil, error);
        return;
    }
    
    // 过滤可用容器
    NSArray<TFYPopupContainerInfo *> *validContainers = [availableContainers filteredArrayUsingPredicate:
        [NSPredicate predicateWithFormat:@"isAvailable == YES"]];
    
    if (validContainers.count == 0) {
        NSError *error = [NSError errorWithDomain:@"TFYPopupContainerError"
                                             code:1002
                                         userInfo:@{NSLocalizedDescriptionKey: @"没有可用的有效容器"}];
        if (completion) completion(nil, error);
        return;
    }
    
    TFYPopupContainerInfo *selectedContainer = nil;
    
    switch (self.strategy) {
        case TFYPopupContainerSelectionStrategyAuto:
            selectedContainer = [self selectContainerAutomatically:validContainers];
            break;
        case TFYPopupContainerSelectionStrategyManual:
            selectedContainer = [self selectContainerManually:validContainers];
            break;
        case TFYPopupContainerSelectionStrategySmart:
            selectedContainer = [self selectContainerSmartly:validContainers];
            break;
        case TFYPopupContainerSelectionStrategyCustom:
            selectedContainer = [self selectContainerCustomly:validContainers];
            break;
    }
    
    if (completion) completion(selectedContainer, nil);
}

- (BOOL)supportsContainerType:(TFYPopupContainerType)type {
    return type != TFYPopupContainerTypeCustom;
}

- (NSInteger)priorityForContainer:(TFYPopupContainerInfo *)containerInfo {
    if (self.customPriorityCalculator) {
        return self.customPriorityCalculator(containerInfo);
    }
    
    // 默认优先级计算
    NSInteger basePriority = containerInfo.priority;
    
    // 根据偏好调整优先级
    if (self.preferWindowContainer && containerInfo.type == TFYPopupContainerTypeWindow) {
        basePriority += 50;
    }
    
    if (self.preferCurrentViewController && containerInfo.type == TFYPopupContainerTypeViewController) {
        basePriority += 25;
    }
    
    return basePriority;
}

#pragma mark - Private Methods

- (TFYPopupContainerInfo *)selectContainerAutomatically:(NSArray<TFYPopupContainerInfo *> *)containers {
    // 自动选择：根据用户偏好选择容器
    if (self.preferWindowContainer) {
        // 优先选择UIWindow（默认行为）
        for (TFYPopupContainerInfo *container in containers) {
            if (container.type == TFYPopupContainerTypeWindow) {
                return container;
            }
        }
    }
    
    if (self.preferCurrentViewController) {
        // 其次选择UIViewController（用户明确偏好时）
        for (TFYPopupContainerInfo *container in containers) {
            if (container.type == TFYPopupContainerTypeViewController) {
                return container;
            }
        }
    }
    
    // 如果偏好设置都没有找到，按默认优先级选择
    for (TFYPopupContainerInfo *container in containers) {
        if (container.type == TFYPopupContainerTypeWindow) {
            return container;
        }
    }
    
    for (TFYPopupContainerInfo *container in containers) {
        if (container.type == TFYPopupContainerTypeViewController) {
            return container;
        }
    }
    
    return containers.firstObject;
}

- (TFYPopupContainerInfo *)selectContainerManually:(NSArray<TFYPopupContainerInfo *> *)containers {
    // 手动选择：返回优先级最高的容器
    return [containers sortedArrayUsingComparator:^NSComparisonResult(TFYPopupContainerInfo *obj1, TFYPopupContainerInfo *obj2) {
        NSInteger priority1 = [self priorityForContainer:obj1];
        NSInteger priority2 = [self priorityForContainer:obj2];
        return priority1 > priority2 ? NSOrderedAscending : NSOrderedDescending;
    }].firstObject;
}

- (TFYPopupContainerInfo *)selectContainerSmartly:(NSArray<TFYPopupContainerInfo *> *)containers {
    // 智能选择：综合考虑多种因素
    TFYPopupContainerInfo *bestContainer = nil;
    NSInteger bestScore = NSIntegerMin;
    
    for (TFYPopupContainerInfo *container in containers) {
        NSInteger score = [self calculateSmartScore:container];
        if (score > bestScore) {
            bestScore = score;
            bestContainer = container;
        }
    }
    
    return bestContainer ?: containers.firstObject;
}

- (TFYPopupContainerInfo *)selectContainerCustomly:(NSArray<TFYPopupContainerInfo *> *)containers {
    // 自定义选择：使用自定义优先级计算
    return [containers sortedArrayUsingComparator:^NSComparisonResult(TFYPopupContainerInfo *obj1, TFYPopupContainerInfo *obj2) {
        NSInteger priority1 = [self priorityForContainer:obj1];
        NSInteger priority2 = [self priorityForContainer:obj2];
        return priority1 > priority2 ? NSOrderedAscending : NSOrderedDescending;
    }].firstObject;
}

- (NSInteger)calculateSmartScore:(TFYPopupContainerInfo *)container {
    NSInteger score = container.priority;
    
    // 根据用户偏好调整基础分数
    if (self.preferWindowContainer && container.type == TFYPopupContainerTypeWindow) {
        score += 150; // 用户偏好UIWindow，大幅加分（默认行为）
    } else if (self.preferCurrentViewController && container.type == TFYPopupContainerTypeViewController) {
        score += 120; // 用户偏好UIViewController，加分
    } else {
        // 根据容器类型加分（默认优先级）
        switch (container.type) {
            case TFYPopupContainerTypeWindow:
                score += 100; // UIWindow优先级最高
                break;
            case TFYPopupContainerTypeViewController:
                score += 75;  // UIViewController次之
                break;
            case TFYPopupContainerTypeView:
                score += 50;  // UIView最低
                break;
            case TFYPopupContainerTypeCustom:
                score += 25;  // 自定义容器
                break;
        }
    }
    
    // 根据容器状态加分
    if (container.containerView.window.isKeyWindow) {
        score += 30; // 当前key window
    }
    
    if (container.containerView.window.windowLevel == UIWindowLevelNormal) {
        score += 20; // 正常级别窗口
    }
    
    // 根据容器大小加分（更大的容器优先）
    if (container.containerView) {
        CGSize size = container.containerView.bounds.size;
        CGFloat area = size.width * size.height;
        score += (NSInteger)(area / 10000); // 每10000像素加1分
    }
    
    return score;
}

@end
