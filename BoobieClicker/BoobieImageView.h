//
//  BoobieImageView.h
//  BoobieClicker
//
//  Created by Natxo Raga on 01/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoobieImageViewDelegate.h"


@interface BoobieImageView : UIImageView

@property (strong, nonatomic) id<BoobieImageViewDelegate> delegate;
@property (nonatomic) CGFloat clickedScale;

@end
