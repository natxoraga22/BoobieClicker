//
//  BoobieClickerViewController.m
//  BoobieClicker
//
//  Created by Natxo Raga on 01/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import "BoobieClickerViewController.h"
#import "BoobieImageView.h"
#import "BoobieImageViewDelegate.h"


@interface BoobieClickerViewController() <BoobieImageViewDelegate>
@property (nonatomic) NSUInteger boobieCount;
@property (weak, nonatomic) IBOutlet UILabel *boobieCountLabel;
@property (weak, nonatomic) IBOutlet BoobieImageView *leftBoobie;
@property (weak, nonatomic) IBOutlet BoobieImageView *rightBoobie;
@end


@implementation BoobieClickerViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Boobies setup
    self.leftBoobie.delegate = self;
    self.rightBoobie.delegate = self;
    
    // TODO: Retrieve this number from NSUserDefaults
    self.boobieCount = 0;
    
    // TEST
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BoobieShop" ofType:@"plist"];
    NSArray *boobieShopItems = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@", boobieShopItems);
}

#pragma mark - Setters

- (void)setBoobieCount:(NSUInteger)boobieCount
{
    _boobieCount = boobieCount;
    self.boobieCountLabel.text = [NSString stringWithFormat:@"%d Boobies", _boobieCount];
}

#pragma mark - Click handling

- (void)boobieClicked:(BoobieImageView *)boobie
{
    self.boobieCount++;
    
    [self newMoreBoobiesLabelOnPosition:boobie.center];
    [self newFallingBoobie];
}

#pragma mark - Animated elements

static CGFloat const MORE_BOOBIES_LABEL_SIZE = 20.0f;
static CGFloat const MORE_BOOBIES_LABEL_X_OFFSET = 120.0f;
static CGFloat const MORE_BOOBIES_LABEL_ANIMATION_DURATION = 2.0f;
static CGFloat const MORE_BOOBIES_LABEL_ANIMATION_DISTANCE = 100.0f;

- (void)newMoreBoobiesLabelOnPosition:(CGPoint)startPosition
{
    // Random parameters
    CGFloat endingXOffset = arc4random_uniform(MORE_BOOBIES_LABEL_X_OFFSET) - MORE_BOOBIES_LABEL_X_OFFSET/2.0f;
    
    // Start position
    CGSize expectedSize = [@"+1" sizeWithFont:[UIFont systemFontOfSize:MORE_BOOBIES_LABEL_SIZE]];
    UILabel *moreBoobiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPosition.x - expectedSize.width/2.0f,
                                                                          startPosition.y - expectedSize.height/2.0f,
                                                                          expectedSize.width, expectedSize.height)];
    moreBoobiesLabel.text = @"+1";
    moreBoobiesLabel.font = [UIFont systemFontOfSize:MORE_BOOBIES_LABEL_SIZE];
    moreBoobiesLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:moreBoobiesLabel];
    
    // Animate
    [UIView animateWithDuration:MORE_BOOBIES_LABEL_ANIMATION_DURATION
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         moreBoobiesLabel.alpha = 0.0f;
                         moreBoobiesLabel.center = CGPointMake(moreBoobiesLabel.center.x + endingXOffset,
                                                               moreBoobiesLabel.center.y - MORE_BOOBIES_LABEL_ANIMATION_DISTANCE);
                     }
                     completion:^(BOOL finished) {
                         [moreBoobiesLabel removeFromSuperview];
                     }];
}

static CGFloat const FALLING_BOOBIE_SIZE = 50.0f;
static CGFloat const FALLING_BOOBIE_ANIMATION_DURATION_MIN = 4.0f;
static CGFloat const FALLING_BOOBIE_ANIMATION_DURATION_MAX = 6.0f;

- (void)newFallingBoobie
{
    // Random parameters
    CGFloat startingXPosition = arc4random_uniform(self.view.bounds.size.width);
    CGFloat endingXPosition = arc4random_uniform(self.view.bounds.size.width);
    CGFloat duration = arc4random_uniform(FALLING_BOOBIE_ANIMATION_DURATION_MAX - FALLING_BOOBIE_ANIMATION_DURATION_MIN);
    duration += FALLING_BOOBIE_ANIMATION_DURATION_MIN;
    
    // Start position
    UIImageView *fallingBoobie = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boobie"]];
    fallingBoobie.frame = CGRectMake(startingXPosition, 0.0f - FALLING_BOOBIE_SIZE, FALLING_BOOBIE_SIZE, FALLING_BOOBIE_SIZE);
    [self.view addSubview:fallingBoobie];
    
    // Animate
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         fallingBoobie.center = CGPointMake(endingXPosition, self.view.bounds.size.height + FALLING_BOOBIE_SIZE);
                     }
                     completion:^(BOOL finished) {
                         [fallingBoobie removeFromSuperview];
                     }];
}

@end
