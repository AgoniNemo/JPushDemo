//
//  AppDelegate.m
//  JPushDemo
//
//  Created by MacBookPro on 2018/6/7.
//  Copyright © 2018年 Nemo. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+JPush.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self JPushApplication:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

# pragma mark -- JPush

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self JPushApplicationWillResignActive:application];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self JPushApplication:application didReceiveRemoteNotification:userInfo];
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self JPushApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self JPushApplication:application didReceiveLocalNotification:notification];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self JPushApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self JPushApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [self JPushApplication:application didRegisterUserNotificationSettings:notificationSettings];
}

@end
