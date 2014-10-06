//
//  UILabel+SizeAdjuster.h
//  BoobieClicker
//
//  Created by Natxo Raga on 04/10/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel (SizeAdjuster)

- (CGFloat)requiredFontSizeWithFont:(UIFont *)font andText:(NSString *)text;

@end
