//
//  NotificationService.m
//  PushBroadcast
//
//  Created by MacBookPro on 2018/6/7.
//  Copyright © 2018年 Nemo. All rights reserved.
//

#import "NotificationService.h"
#import "NSString+wallet.h"
#import "VoiceBroadcast.h"
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    /**
     后端发送的JSON
     {"money":"179.8","ios":{"sound":"transferToAccount.mp3","badge":"0","content-available":1,"mutable-content":1}}
     */
    NSString *money = [NSString getAmountInWords:self.bestAttemptContent.userInfo[@"money"]];
    self.bestAttemptContent.sound = nil;
    [[VoiceBroadcast shareInstance] syntheticVoice:[NSString stringWithFormat:@"收款到账%@",money]];
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
