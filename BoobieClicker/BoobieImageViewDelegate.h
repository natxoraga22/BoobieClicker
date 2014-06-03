//
//  BoobieImageViewDelegate.h
//  BoobieClicker
//
//  Created by Natxo Raga on 01/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoobieImageView.h"


@class BoobieImageView;


@protocol BoobieImageViewDelegate <NSObject>

@optional
- (void)boobieClicked:(BoobieImageView *)boobie;

@end
