//
//  AppDelegate+JPush.h
//  wallet
//
//  Created by MacBookPro on 2018/5/30.
//  Copyright © 2018年 Linkpulse Guangdong Network Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (JPush)

- (void)JPushApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


-(void)JPushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

-(void)JPushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)JPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

- (void)JPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

-(void)JPushApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)JPushApplicationWillResignActive:(UIApplication *)application;
- (void)JPushApplication:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

@end
