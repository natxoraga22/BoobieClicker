//
//  UILabel+SizeAdjuster.m
//  BoobieClicker
//
//  Created by Natxo Raga on 04/10/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import "UILabel+SizeAdjuster.h"


@implementation UILabel (SizeAdjuster)

- (CGFloat)requiredFontSizeWithFont:(UIFont *)font andText:(NSString *)text
{
    CGFloat fontSize = font.pointSize;
    
    BOOL found = NO;
    while (YES) {
        if (font.pointSize != fontSize) {
            font = [font fontWithSize:fontSize];
        }
        if ([self wouldThisFont:font workForThisLabel:self andThisText:text]) {
            found = YES;
            break;
        }
        fontSize -= 0.5;
        if (fontSize < (self.minimumScaleFactor * self.font.pointSize)) {
            break;
        }
    }
    return fontSize;
}

- (BOOL)wouldThisFont:(UIFont *)font workForThisLabel:(UILabel *)label andThisText:(NSString *)text
{
    NSDictionary *attributes = @{NSFontAttributeName : font};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGRect bounds = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(label.frame), CGFLOAT_MAX)
                                         options:0
                                         context:nil];
    return [self doesThisSize:bounds.size fitInThisSize:label.bounds.size];
}

- (BOOL)doesThisSize:(CGSize)firstSize fitInThisSize:(CGSize)secondSize
{
    if (firstSize.width > secondSize.width) return NO;
    if (firstSize.height > secondSize.height) return NO;
    return YES;
}

@end
