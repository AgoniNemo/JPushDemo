//
//  VoiceBroadcast.h
//  wallet
//
//  Created by MacBookPro on 2018/5/31.
//  Copyright © 2018年 Linkpulse Guangdong Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceBroadcast : NSObject

/// 创建单例
+(instancetype)shareInstance;

/// 销毁单例
+ (void)destroyInstance;

/// 播报语音
- (void)syntheticVoice:(NSString *)string;
@end
