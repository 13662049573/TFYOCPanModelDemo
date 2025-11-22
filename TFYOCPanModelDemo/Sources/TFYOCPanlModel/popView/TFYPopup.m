//
//  TFYPopup.m
//  TFYOCPanModelDemo
//
//  Created by 田风有 on 2024/12/19.
//  用途：弹窗框架主实现文件，定义全局常量和函数
//

#import <TFYOCPanlModel/TFYPopup.h>

#pragma mark - Notification Names

NSNotificationName const TFYPopupWillAppearNotification = @"TFYPopupWillAppearNotification";
NSNotificationName const TFYPopupDidAppearNotification = @"TFYPopupDidAppearNotification";
NSNotificationName const TFYPopupWillDisappearNotification = @"TFYPopupWillDisappearNotification";
NSNotificationName const TFYPopupDidDisappearNotification = @"TFYPopupDidDisappearNotification";
NSNotificationName const TFYPopupCountDidChangeNotification = @"TFYPopupCountDidChangeNotification";

#pragma mark - Global Functions Implementation

NSInteger TFYPopupGetCurrentCount(void) {
    return [TFYPopupView currentPopupCount];
}

BOOL TFYPopupIsPresenting(void) {
    return TFYPopupGetCurrentCount() > 0;
}

NSArray<TFYPopupView *> * TFYPopupGetAllCurrentPopups(void) {
    return [TFYPopupView allCurrentPopups];
}

#pragma mark - Priority Functions Implementation

TFYPopupPriority TFYPopupGetCurrentHighestPriority(void) {
    return [TFYPopupView currentHighestPriority];
}

NSInteger TFYPopupGetWaitingQueueCount(void) {
    return [TFYPopupView waitingQueueCount];
}

void TFYPopupClearLowPriorityPopups(TFYPopupPriority threshold) {
    [TFYPopupView clearPopupsWithPriorityLowerThan:threshold];
}

void TFYPopupPausePriorityQueue(void) {
    [TFYPopupView pausePriorityQueue];
}

void TFYPopupResumePriorityQueue(void) {
    [TFYPopupView resumePriorityQueue];
}

void TFYPopupEnablePriorityDebugMode(BOOL enabled) {
    [TFYPopupPriorityManager enablePriorityDebugMode:enabled];
}

void TFYPopupLogPriorityQueue(void) {
    [TFYPopupView logPriorityQueue];
}

#pragma mark - Load Method
@implementation TFYPopup
@end
