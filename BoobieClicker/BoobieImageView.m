//
//  BoobieImageView.m
//  BoobieClicker
//
//  Created by Natxo Raga on 01/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import "BoobieImageView.h"


@implementation BoobieImageView

#pragma mark - Initialization

static CGFloat const DEFAULT_CLICKED_SCALE = 0.9f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self setup];
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    self.clickedScale = DEFAULT_CLICKED_SCALE;
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    CGFloat radius = self.bounds.size.width/2.0f;
    CGPoint center = CGPointMake(self.bounds.origin.x + radius, self.bounds.origin.y + radius);
    CGFloat distance = hypotf(touchLocation.x - center.x, touchLocation.y - center.y);
    
    if (distance <= radius) {
        // Transformation
        self.layer.transform = CATransform3DMakeScale(DEFAULT_CLICKED_SCALE, DEFAULT_CLICKED_SCALE, 1.0f);
        
        // Tell the delegate
        [self.delegate boobieClicked:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Restore the transformation
    self.layer.transform = CATransform3DIdentity;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{}

@end
