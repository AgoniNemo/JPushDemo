//
//  VoiceBroadcast.m
//  wallet
//
//  Created by MacBookPro on 2018/5/31.
//  Copyright © 2018年 Linkpulse Guangdong Network Technology Co., Ltd. All rights reserved.
//

#import "VoiceBroadcast.h"
#import <MediaPlayer/MediaPlayer.h>

static VoiceBroadcast *_instance;
static dispatch_once_t onceToken;

@interface VoiceBroadcast()<AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end

@implementation VoiceBroadcast

-(instancetype)init{
    
   if (self == [super init]) {
       _synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return self;
}

+(instancetype)shareInstance{
    
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
            _instance = [[VoiceBroadcast alloc] init];
    });
    return _instance;
}

//保证copy时相同
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

+(void)destroyInstance
{
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
    _instance = nil;
}
- (void)syntheticVoice:(NSString *)string{
    
    NSLog(@"语音合成文字:%@",string);
    
    _synthesizer = [[AVSpeechSynthesizer alloc] init];
    _synthesizer.delegate = self;
    
    AVSpeechUtterance *speechUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
    //设置语言类别（不能被识别，返回值为nil）
    speechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    
    //播放音量[0-1]默认1;
    speechUtterance.volume = 1;
    //设置语速快慢
    speechUtterance.rate = 0.5f;
    /**
    MPMusicPlayerController* musicController = [MPMusicPlayerController applicationMusicPlayer];
    ////0.0~1.0
    musicController.volume = 0.5f;
    */
    //语音合成器会生成音频
    [_synthesizer speakUtterance:speechUtterance];
}

#pragma mark ----AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"----开始播放");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    NSLog(@"---完成播放");
}

-(void)dealloc{
    _synthesizer.delegate = nil;
}

@end
