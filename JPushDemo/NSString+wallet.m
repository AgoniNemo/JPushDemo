//
//  NSString+wallet.m
//  wallet
//
//  Created by Nemo on 2018/2/9.
//  Copyright © 2018年 Linkpulse Guangdong Network Technology Co., Ltd. All rights reserved.
//

#import "NSString+wallet.h"

@implementation NSString (wallet)

+(NSString *)getAmountInWords:(NSString *)money{
    if (money.length == 0) {
        return @"";
    }
    if (money.floatValue == 0) {
        return @"零圆整";
    }
    //大写数字
    NSArray *upperArray = @[ @"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖" ];
    /** 整数部分的单位 */
    NSArray *measureArray = @[ @"", @"拾", @"佰", @"仟"];
    /** 整数部分的单位 */
    NSArray *intUnit = @[@"圆", @"万", @"亿"];
    /** 小数部分的单位 */
    NSArray *floatUnitArray = @[ @"角", @"分" ];
    
    NSString *upIntNum = [NSString string];
    NSString *upFloatNum = [NSString string];
    NSArray *numArray = [money componentsSeparatedByString:@"."];
    
    NSString *str1 = [numArray objectAtIndex:0];
    NSInteger num1 = str1.integerValue;
    for (int i = 0; i < intUnit.count && num1 > 0; i++) {//这一部分就是单纯的转化
        NSString *temp = @"";
        int tempNum = num1%10000;
        if (tempNum != 0 || i == 0) {
            for (int j = 0; j < measureArray.count && num1 > 0; j++) {
                temp = [NSString stringWithFormat:@"%@%@%@", [upperArray objectAtIndex:num1%10], [measureArray objectAtIndex:j],temp];//每次转化最后一位数
                num1 = num1/10;//数字除以10
            }
            upIntNum = [[temp stringByAppendingString:[intUnit objectAtIndex:i]] stringByAppendingString:upIntNum];
        } else {
            num1 /= 10000;
            temp = @"零";
            upIntNum = [temp stringByAppendingString:upIntNum];
        }
        
    }
    
    for (int m = 1; m < measureArray.count; m++) { //把零佰零仟这种情况转为零
        NSString *lingUnit = [@"零" stringByAppendingString:[measureArray objectAtIndex:m]];
        upIntNum = [upIntNum stringByReplacingOccurrencesOfString:lingUnit withString:@"零"];
    }
    
    while ([upIntNum rangeOfString:@"零零"].location != NSNotFound) {//多个零相邻的保留一个零
        upIntNum = [upIntNum stringByReplacingOccurrencesOfString:@"零零" withString:@"零"];
    }
    for (int k = 0; k < intUnit.count * 2; k++) { //零万、零亿这种情况转化为万零
        NSString *unit = [intUnit objectAtIndex:k%intUnit.count];
        NSString *lingUnit = [@"零" stringByAppendingString:unit];
        upIntNum = [upIntNum stringByReplacingOccurrencesOfString:lingUnit withString:[unit stringByAppendingString:@"零"]];
    }
    
    if (numArray.count == 2) {//小数部分转化
        NSString *floatStr = [numArray objectAtIndex:1];
        for (NSInteger i = floatStr.length; i > 0; i--) {
            NSString *temp = [floatStr substringWithRange:NSMakeRange(floatStr.length - i, 1)];
            NSInteger tempNum = temp.integerValue;
            if (tempNum == 0) continue;
            NSString *upNum = [upperArray objectAtIndex:tempNum];
            NSString *unit = [floatUnitArray objectAtIndex:floatStr.length - i];
            if (i < floatStr.length && upFloatNum.length == 0 && upIntNum.length > 0) {
                upFloatNum = @"零";
            }
            upFloatNum = [NSString stringWithFormat:@"%@%@%@", upFloatNum, upNum, unit];
        }
    }
    if (upFloatNum.length == 0) {
        upFloatNum = @"整";
    }
    
    NSString *amountInWords = [NSString stringWithFormat:@"%@%@", upIntNum, upFloatNum];
    
    while ([amountInWords rangeOfString:@"零零"].location != NSNotFound) {//再次除去多余的零
        amountInWords = [amountInWords stringByReplacingOccurrencesOfString:@"零零" withString:@"零"];
    }
    
    if ([amountInWords rangeOfString:@"零整"].location != NSNotFound) {
        amountInWords = [amountInWords stringByReplacingOccurrencesOfString:@"零整" withString:@"整"];
    }
    
    return amountInWords;
    
}


@end
