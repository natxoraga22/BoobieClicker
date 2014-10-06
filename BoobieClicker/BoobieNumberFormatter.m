//
//  BoobieNumberFormatter.m
//  BoobieClicker
//
//  Created by Natxo Raga on 06/10/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import "BoobieNumberFormatter.h"


@implementation BoobieNumberFormatter

+ (NSString *)stringFromNumber:(NSNumber *)number
{
    NSNumberFormatter *formatter = [self boobiesFormatter];
    return [formatter stringFromNumber:number];
}

+ (NSNumberFormatter *)boobiesFormatter
{
    // Number formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.groupingSeparator = @".";
    formatter.groupingSize = 3;
    formatter.usesGroupingSeparator = YES;
    
    return formatter;
}

@end
