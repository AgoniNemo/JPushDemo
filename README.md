# JPushDemo
由于项目要做类似支付宝的后台语音播报功能，所以抽个时间研究了下，也踩过好多坑。

#### 后台播报功能分析（以下情况为app进入后台，远程推送）

```
1.iOS 10以下播报语音是固定的。（语音：支付宝到账一笔）
2.iOS 10以上播报语音“支付宝到账xxx元xx角x分”。
```

#### 准备工作
```
1.真机一台（推送所需）
2.把真机上要调试的app删除（这点很重要，博主就在这里中踩了坑）
3.极光推送（推送证书上传好）
```

#### iOS 10以下
只需要在后端推送时把`sound设置为你准备好的语音（比如Demo中的transferToAccount.mp3）`，你可以在极光官网设置，参数如下：

![6](https://github.com/AgoniNemo/JPushDemo/blob/master/imge/6.jpg?raw=true)
![5](https://github.com/AgoniNemo/JPushDemo/blob/master/imge/5.jpg?raw=true)

#### iOS 10以上

###### 第一步：创建通知扩展target
![1](https://github.com/AgoniNemo/JPushDemo/blob/master/imge/1.png?raw=true)

###### 第二步：选择通知扩展
![2](https://github.com/AgoniNemo/JPushDemo/blob/master/imge/2.png?raw=true)

###### 输入完成名字后，会在TARGETS里能看到，如下图：
![3](https://github.com/AgoniNemo/JPushDemo/blob/master/imge/3.jpg?raw=true)

###### 第三步：写代码
```
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler 
每次收到推送之后，app弹出推送通知前，都会调用上面的方法，直接在上面的方法里写播报代码就好
```

PS：需要Demo可以点[这里](https://github.com/AgoniNemo/JPushDemo)
