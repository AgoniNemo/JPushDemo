//
//  AppDelegate+JPush.m
//  wallet
//
//  Created by MacBookPro on 2018/5/30.
//  Copyright © 2018年 Linkpulse Guangdong Network Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "VoiceBroadcast.h"
#import "NSString+wallet.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


#define APPKEY @"6f5e4a9296eac38f8a060c1c1"

@interface AppDelegate ()<JPUSHRegisterDelegate>


@end

@implementation AppDelegate (JPush)

-(void)JPushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (launchOptions) {
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
            [self didReceiveRemoteNotification:userInfo];
        }
    }
    
    [self registerRemoteNotification];
    
    
    // 注册JPush
    [self initJPushNotificationOptions:launchOptions];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    /// JPush登录成功
    [defaultCenter addObserver:self selector:@selector(didLoginNotification) name:kJPFNetworkDidLoginNotification object:nil];
    /// JPush自定义消息
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
}


// 初始化JPush推送
- (void)initJPushNotificationOptions:(NSDictionary *)launchOptions{
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    BOOL production = NO;
#if DEBUG
    production = NO;
#else
    production = YES;
    [JPUSHService setLogOFF];
#endif
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:APPKEY
                          channel:@"com.linkyuyu.wallet"
                 apsForProduction:production
            advertisingIdentifier:advertisingId];
    
    
}

// 注册本地推送
- (void)registerRemoteNotification{
    
    NSLog(@"%s",__func__);
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0 && [UIDevice currentDevice].systemVersion.floatValue < 10.0) {
        if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
            [application registerUserNotificationSettings:settings];
        }
        
    }else if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0){
        
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            //请求获取通知权限（角标，声音，弹框）
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    //获取用户是否同意开启通知
                    NSLog(@"用户已经开启通知!");
                }
            }];
        }
    }
    
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        //iOS7....
        UIRemoteNotificationType notificationTypes =
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
        
    }
#endif
}

// 打印收到的apns信息(从通知栏点击进入的)
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"收到的apns信息:%@",str);
    
}

-(void)didLoginNotification{
    
    NSString *alias = @"fdsavewrffdsagdsfewq";

    if (alias == nil) {
        [self performSelector:@selector(didLoginNotification) withObject:nil afterDelay:3];
        return;
    }
    
    [JPUSHService setTags:[NSSet set] alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        
        if (iResCode == 0) {
            NSLog(@"设置成功！");
        }
    }];
}
//iOS 10以下收到本地消息通知
-(void)JPushApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    if (application.applicationState == UIApplicationStateInactive )
    {
        NSLog(@"app not running");
    }else if(application.applicationState == UIApplicationStateActive )
    {
        NSLog(@"app running");
    }
     NSLog(@"iOS 10以下收到本地消息通知");
}

-(void)JPushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //正确写法
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSLog(@"注册deviceToken：%@",deviceString);
    
}
- (void)JPushApplicationWillResignActive:(UIApplication *)application{
    
    NSLog(@"app进入后台！");
    
}


-(void)JPushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSLog(@"iOS10 收到远程通知:%@", userInfo);
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionSound);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"iOS 10 userInfo:%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

// 自定义消息推送回调方法（JPush自定义消息）
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"自定义消息:%@",userInfo);
}

- (void)JPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS 7推送内容aps:%@",userInfo);
    /**
     后端发送的JSON
     {"money":"179.8","ios":{"sound":"transferToAccount.mp3","badge":"0","content-available":1,"mutable-content":1}}
     */
    NSString *money = userInfo[@"money"];
    if (money && application.applicationState == UIApplicationStateActive) {
        
        [[VoiceBroadcast shareInstance] syntheticVoice:[NSString stringWithFormat:@"收款到账%@",[NSString getAmountInWords:money]]];
    }
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}
- (void)JPushApplication:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
{
    NSLog(@"注册:%lu",(unsigned long)notificationSettings.types);
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionSound+UNAuthorizationOptionBadge)completionHandler:^(BOOL granted,NSError*_Nullableerror){
             
             if(granted){
                 // 重点是这句话，在用户允许通知以后，手动执行regist方法。
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
             }
         }];
    }
}
- (void)JPushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"iOS6推送内容aps:%@",userInfo);
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
}

@end
