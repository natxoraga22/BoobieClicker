//
//  BoobieClickerViewController.m
//  BoobieClicker
//
//  Created by Natxo Raga on 01/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import "BoobieClickerViewController.h"
#import "BoobieClickerModel.h"
#import "BoobieImageView.h"
#import "BoobieImageViewDelegate.h"
#import "BoobieShopTableViewCell.h"
#import "BoobieShopManager.h"


@interface BoobieClickerViewController() <BoobieImageViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) BoobieClickerModel *model;
// IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *boobieCountLabel;
@property (weak, nonatomic) IBOutlet BoobieImageView *leftBoobie;
@property (weak, nonatomic) IBOutlet BoobieImageView *rightBoobie;
// BoobieShop
@property (weak, nonatomic) IBOutlet UIView *boobieShop;
@property (weak, nonatomic) IBOutlet UITableView *boobieShopTableView;
@property (weak, nonatomic) IBOutlet UILabel *usedSlotsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *boobieShopControl;
@end


@implementation BoobieClickerViewController

// Files
static NSString *const BOOBIE_SHOP_VIEW_NIB_NAME = @"BoobieShopView";
static NSString *const BOOBIE_SHOP_ITEM_VIEW_NIB_NAME = @"BoobieShopTableViewCell";
static NSString *const LEFT_BOOBIE_IMAGE_NAME = @"smallLeftBoobie";
static NSString *const RIGHT_BOOBIE_IMAGE_NAME = @"smallRightBoobie";

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // iAd
    if ([self respondsToSelector:@selector(canDisplayBannerAds)]) {
        self.canDisplayBannerAds = YES;
    }
    
    // Boobies setup
    self.leftBoobie.delegate = self;
    self.rightBoobie.delegate = self;
    
    // Starting where we left off
    [self.model reloadBoobieModifiers];
    [self setBoobieCount:[self.model getBoobieCount] boobiesPerSecond:[self.model getBoobiesPerSecond]];
    
    // Increment boobieCount every second depending on boobiesPerSecond
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(incrementBoobieCountByBoobiesPerSecond)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark - Getters

- (BoobieClickerModel *)model
{
    if (!_model) _model = [[BoobieClickerModel alloc] init];
    return _model;
}

static NSString *const BOOBIE_SHOP_ITEM_CELL_ID = @"BoobieShopItem";
static NSString *const BOOBIE_CLICKER_FONT = @"ChalkboardSE";
static CGFloat const BOOBIE_SHOP_CONTROL_FONT_SIZE = 18.0f;

- (UIView *)boobieShop
{
    if (!_boobieShop) {
        _boobieShop = [[NSBundle mainBundle] loadNibNamed:BOOBIE_SHOP_VIEW_NIB_NAME owner:self options:nil][0];
        
        [self.boobieShopTableView registerNib:[UINib nibWithNibName:BOOBIE_SHOP_ITEM_VIEW_NIB_NAME
                                                             bundle:[NSBundle mainBundle]]
                       forCellReuseIdentifier:BOOBIE_SHOP_ITEM_CELL_ID];
        
        // Boobie Shop Control text
        NSString *fontName = [NSString stringWithFormat:@"%@-Regular", BOOBIE_CLICKER_FONT];
        UIFont *font = [UIFont fontWithName:fontName size:BOOBIE_SHOP_CONTROL_FONT_SIZE];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [self.boobieShopControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [self.boobieShopControl setContentPositionAdjustment:UIOffsetMake(0.0f, -2.0f) forSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
    }
    return _boobieShop;
}

#pragma mark - Setters

static CGFloat const BOOBIES_PER_SECOND_LABEL_FONT_SIZE = 18.0f;
static CGFloat const BOOBIE_COUNT_LABEL_LINE_SPACING = 0.75f;
static CGFloat const BOOBIE_COUNT_LABEL_PARAGRAPH_SPACING = 2.0f;

- (void)setBoobieCount:(NSUInteger)boobieCount boobiesPerSecond:(NSUInteger)boobiesPerSecond
{
    NSNumberFormatter *formatter = [self boobiesFormatter];
    NSString *boobiesString = [NSString stringWithFormat:@"%@ Boobies\n", [formatter stringFromNumber:@(boobieCount)]];
    NSString *boobiesPerSecondString = [NSString stringWithFormat:@"%@ boobies/second", [formatter stringFromNumber:@(boobiesPerSecond)]];
    
    NSMutableAttributedString *boobiesAttrString = [[NSMutableAttributedString alloc] initWithString:boobiesString];
    NSMutableAttributedString *boobiesPerSecondAttrString = [[NSMutableAttributedString alloc] initWithString:boobiesPerSecondString];
    
    // Chalkboard SE Light 18.0f Font
    NSString *fontName = [NSString stringWithFormat:@"%@-Light", BOOBIE_CLICKER_FONT];
    [boobiesPerSecondAttrString addAttribute:NSFontAttributeName
                                       value:[UIFont fontWithName:fontName size:BOOBIES_PER_SECOND_LABEL_FONT_SIZE]
                                       range:NSMakeRange(0, [boobiesPerSecondString length])];
    
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithAttributedString:boobiesAttrString];
    [resultString appendAttributedString:boobiesPerSecondAttrString];

    // 0'75 line spacing, 2 points space after paragraph
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.maximumLineHeight = 36.0f;
    paragraphStyle.lineSpacing = BOOBIE_COUNT_LABEL_LINE_SPACING;
    paragraphStyle.paragraphSpacing = BOOBIE_COUNT_LABEL_PARAGRAPH_SPACING;
    [resultString addAttribute:NSParagraphStyleAttributeName
                         value:paragraphStyle
                         range:NSMakeRange(0, [boobiesString length] + [boobiesPerSecondString length])];
    
    self.boobieCountLabel.attributedText = resultString;
}

#pragma mark - Click handling

- (void)boobieClicked:(BoobieImageView *)boobie
{
    NSUInteger boobiesPerClick = [self.model getBoobiesPerClick];
    [self.model incrementBoobieCountBy:boobiesPerClick];
    [self setBoobieCount:[self.model getBoobieCount] boobiesPerSecond:[self.model getBoobiesPerSecond]];
    
    [self newMoreBoobiesLabelOnPosition:boobie.center withNumber:boobiesPerClick];
    [self newFallingBoobie:boobie];
}

- (void)incrementBoobieCountByBoobiesPerSecond
{
    NSUInteger boobiesPerSecond = [self.model getBoobiesPerSecond];
    [self.model incrementBoobieCountBy:boobiesPerSecond];
    [self setBoobieCount:[self.model getBoobieCount] boobiesPerSecond:[self.model getBoobiesPerSecond]];
    
    [self.boobieShopTableView reloadData];
}

#pragma mark - UI Animated elements

static CGFloat const MORE_BOOBIES_LABEL_SIZE = 20.0f;
static CGFloat const MORE_BOOBIES_LABEL_X_OFFSET = 150.0f;
static CGFloat const MORE_BOOBIES_LABEL_ANIMATION_DURATION = 2.5f;
static CGFloat const MORE_BOOBIES_LABEL_ANIMATION_DISTANCE = 125.0f;

- (void)newMoreBoobiesLabelOnPosition:(CGPoint)startPosition withNumber:(NSUInteger)number
{
    // Random parameters
    CGFloat endingXOffset = arc4random_uniform(MORE_BOOBIES_LABEL_X_OFFSET) - MORE_BOOBIES_LABEL_X_OFFSET/2.0f;
    
    // Start position
    NSNumberFormatter *formatter = [self boobiesFormatter];
    NSString *labelText = [NSString stringWithFormat:@"+%@", [formatter stringFromNumber:@(number)]];
    UIFont *labelFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold", BOOBIE_CLICKER_FONT] size:MORE_BOOBIES_LABEL_SIZE];
    CGSize expectedSize = [labelText sizeWithFont:labelFont];
    UILabel *moreBoobiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPosition.x - expectedSize.width/2.0f,
                                                                          startPosition.y - expectedSize.height/2.0f,
                                                                          expectedSize.width, expectedSize.height)];
    moreBoobiesLabel.text = labelText;
    moreBoobiesLabel.font = labelFont;
    moreBoobiesLabel.textColor = [UIColor redColor];
    moreBoobiesLabel.backgroundColor = [UIColor clearColor];
    [self.view.subviews[0] addSubview:moreBoobiesLabel];
    
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

static CGFloat const FALLING_BOOBIE_MAX_SIZE = 60.0f;
static CGFloat const FALLING_BOOBIE_MIN_SIZE = 30.0f;
static CGFloat const FALLING_BOOBIE_ANIMATION_DURATION_MIN = 4.0f;
static CGFloat const FALLING_BOOBIE_ANIMATION_DURATION_MAX = 6.0f;

- (void)newFallingBoobie:(BoobieImageView *)boobie
{
    // Random parameters
    CGFloat startingXPosition = arc4random_uniform(self.view.bounds.size.width);
    CGFloat endingXPosition = arc4random_uniform(self.view.bounds.size.width);
    CGFloat size = arc4random_uniform(FALLING_BOOBIE_MAX_SIZE - FALLING_BOOBIE_MIN_SIZE);
    size += FALLING_BOOBIE_MIN_SIZE;
    CGFloat duration = arc4random_uniform(FALLING_BOOBIE_ANIMATION_DURATION_MAX - FALLING_BOOBIE_ANIMATION_DURATION_MIN);
    duration += FALLING_BOOBIE_ANIMATION_DURATION_MIN;
    
    // Start position
    NSString *boobieName = (boobie == self.leftBoobie) ? LEFT_BOOBIE_IMAGE_NAME : RIGHT_BOOBIE_IMAGE_NAME;
    UIImageView *fallingBoobie = [[UIImageView alloc] initWithImage:[UIImage imageNamed:boobieName]];
    fallingBoobie.frame = CGRectMake(startingXPosition, 0.0f - size, size, size);
    [self.view.subviews[0] insertSubview:fallingBoobie atIndex:1];
    
    // Animate
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         fallingBoobie.center = CGPointMake(endingXPosition, self.view.bounds.size.height + size);
                     }
                     completion:^(BOOL finished) {
                         [fallingBoobie removeFromSuperview];
                     }];
}

static CGFloat const PAYED_BOOBIES_LABEL_SIZE = 24.0f;
static CGFloat const PAYED_BOOBIES_LABEL_ANIMATION_DURATION = 2.0f;
static CGFloat const PAYED_BOOBIES_LABEL_ANIMATION_DISTANCE = 30.0f;

- (void)newPayedBoobiesLabelWithValue:(NSUInteger)value
{
    // Start position
    CGPoint startPosition = CGPointMake(self.boobieCountLabel.frame.origin.x + self.boobieCountLabel.frame.size.width/2.0f,
                                        self.boobieCountLabel.frame.origin.y + self.boobieCountLabel.frame.size.height/10.0f);
    
    NSNumberFormatter *formatter = [self boobiesFormatter];
    NSString *labelText = [NSString stringWithFormat:@"-%@ Boobies", [formatter stringFromNumber:@(value)]];
    UIFont *labelFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold", BOOBIE_CLICKER_FONT] size:PAYED_BOOBIES_LABEL_SIZE];
    CGSize expectedSize = [labelText sizeWithFont:labelFont];
    UILabel *payedBoobiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPosition.x - expectedSize.width/2.0f,
                                                                           startPosition.y - expectedSize.height/2.0f,
                                                                           expectedSize.width, expectedSize.height)];
    payedBoobiesLabel.text = labelText;
    payedBoobiesLabel.font = labelFont;
    payedBoobiesLabel.textColor = [UIColor redColor];
    payedBoobiesLabel.backgroundColor = [UIColor clearColor];
    [self.view.subviews[0] addSubview:payedBoobiesLabel];
    
    // Animate
    [UIView animateWithDuration:PAYED_BOOBIES_LABEL_ANIMATION_DURATION
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         payedBoobiesLabel.alpha = 0.0f;
                         payedBoobiesLabel.center = CGPointMake(payedBoobiesLabel.center.x,
                                                                payedBoobiesLabel.center.y - PAYED_BOOBIES_LABEL_ANIMATION_DISTANCE);
                     }
                     completion:^(BOOL finished) {
                         [payedBoobiesLabel removeFromSuperview];
                     }];
}

#pragma mark - Boobie Shop

static CGFloat const BOOBIE_SHOP_HEIGHT_SCALE_FACTOR = 0.7f;
static CGFloat const BOOBIE_SHOP_ANIMATION_DURATION = 0.5f;

- (IBAction)boobieShopClicked
{
    self.boobieShop.frame = CGRectMake(0.0f,
                                       0.0f + self.view.bounds.size.height,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height*BOOBIE_SHOP_HEIGHT_SCALE_FACTOR);
    self.usedSlotsLabel.text = [NSString stringWithFormat:@"Slots used: %lu/%lu", (unsigned long)[self.model getUsedSlots],
                                                                                  (unsigned long)[self.model getMaxSlots]];
    [self.view addSubview:self.boobieShop];
    
    // Animate
    [UIView animateWithDuration:BOOBIE_SHOP_ANIMATION_DURATION
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.boobieShop.frame = CGRectMake(0.0f,
                                                            0.0f + self.view.bounds.size.height*(1.0f - BOOBIE_SHOP_HEIGHT_SCALE_FACTOR),
                                                            self.view.bounds.size.width,
                                                            self.view.bounds.size.height*BOOBIE_SHOP_HEIGHT_SCALE_FACTOR);
                     }
                     completion:^(BOOL finished) {
                         [self.boobieShopTableView flashScrollIndicators];
                     }];
}

- (IBAction)boobieShopBackClicked
{
    // Animate
    [UIView animateWithDuration:BOOBIE_SHOP_ANIMATION_DURATION
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.boobieShop.frame = CGRectMake(0.0f,
                                                            0.0f + self.view.bounds.size.height,
                                                            self.view.bounds.size.width,
                                                            self.view.bounds.size.height*BOOBIE_SHOP_HEIGHT_SCALE_FACTOR);
                     }
                     completion:^(BOOL finished) {
                         [self.boobieShop removeFromSuperview];
                     }];
}

- (IBAction)boobieShopControlChanged
{
    [self.boobieShopTableView reloadData];
}

#pragma mark - UITableView Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *path = [[NSBundle mainBundle] pathForResource:BOOBIE_SHOP_PLIST_NAME ofType:@"plist"];
    return [[NSArray arrayWithContentsOfFile:path] count];
}

static CGFloat const BOOBIE_SHOP_ITEM_CELL_HEIGHT = 64.0f;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BOOBIE_SHOP_ITEM_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoobieShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BOOBIE_SHOP_ITEM_CELL_ID forIndexPath:indexPath];
    
    NSDictionary *item = [BoobieShopManager getBoobieShopItemAtIndex:indexPath.row];
    
    cell.itemImageView.image = [UIImage imageNamed:item[BOOBIE_SHOP_ITEM_IMAGE_NAME_KEY]];
    cell.itemNameLabel.text = item[BOOBIE_SHOP_ITEM_NAME_KEY];
    NSNumberFormatter *formatter = [self boobiesFormatter];
    cell.itemCostLabel.text = [NSString stringWithFormat:@"Cost: %@ boobies", [formatter stringFromNumber:item[BOOBIE_SHOP_ITEM_COST_KEY]]];
    NSString *slots = [item[BOOBIE_SHOP_ITEM_SLOTS_KEY] integerValue] == 1 ? @"slot" : @"slots";
    cell.itemSlotsLabel.text = [NSString stringWithFormat:@"%@ %@", item[BOOBIE_SHOP_ITEM_SLOTS_KEY], slots];
    NSString *effectType = [self stringForEffectType:item[BOOBIE_SHOP_ITEM_EFFECT_TYPE_KEY]];
    cell.itemEffectLabel.text = [NSString stringWithFormat:@"%@: %@", effectType, item[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY]];
    NSUInteger itemCount = [self.model getItemCountOfName:item[BOOBIE_SHOP_ITEM_NAME_KEY]];
    cell.itemCountLabel.text = [NSString stringWithFormat:@"Items: %lu", (unsigned long)itemCount];
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(230.0/255.0) green:(200.0/255.0) blue:(185.0/255.0) alpha:1.0];
    cell.selectedBackgroundView = selectionColor;
    
    // Disable cell
    if ((self.boobieShopControl.selectedSegmentIndex == 0 &&
        [self.model getBoobieCount] < [item[BOOBIE_SHOP_ITEM_COST_KEY] integerValue]) ||
        ((self.boobieShopControl.selectedSegmentIndex == 1) &&
        [self.model getItemCountOfName:item[BOOBIE_SHOP_ITEM_NAME_KEY]] == 0)) {
        cell.userInteractionEnabled = NO;
        cell.itemNameLabel.enabled = NO;
        cell.itemCostLabel.enabled = NO;
        cell.itemSlotsLabel.enabled = NO;
        cell.itemEffectLabel.enabled = NO;
        cell.itemCountLabel.enabled = NO;
    }
    // Enable cell
    else {
        cell.userInteractionEnabled = YES;
        cell.itemNameLabel.enabled = YES;
        cell.itemCostLabel.enabled = YES;
        cell.itemSlotsLabel.enabled = YES;
        cell.itemEffectLabel.enabled = YES;
        cell.itemCountLabel.enabled = YES;
    }
    
    return cell;
}

- (NSString *)stringForEffectType:(NSNumber *)type
{
    switch ([type integerValue]) {
        case 0: return @"BPS"; break;
        case 1: return @"BPC"; break;
        case 2: return @"Slots"; break;
        default: return @""; break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.boobieShopControl.selectedSegmentIndex == 0) [self buyItemAtIndexPath:indexPath];
    else if (self.boobieShopControl.selectedSegmentIndex == 1) [self removeItemAtIndexPath:indexPath];
}

- (void)buyItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [BoobieShopManager getBoobieShopItemAtIndex:indexPath.row];
    
    // Check if we have enough space or boobies for the new item
    NSUInteger availableSlots = [self.model getMaxSlots] - [self.model getUsedSlots];
    if (availableSlots >= [item[BOOBIE_SHOP_ITEM_SLOTS_KEY] integerValue] &&
        [self.model getBoobieCount] >= [item[BOOBIE_SHOP_ITEM_COST_KEY] integerValue]) {
        
        // Apply item effect
        switch ([item[BOOBIE_SHOP_ITEM_EFFECT_TYPE_KEY] integerValue]) {
            case 0: [self.model incrementBoobiesPerSecondBy:[item[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] integerValue]]; break;
            case 1: [self.model incrementBoobiesPerClickBy:[item[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] integerValue]]; break;
            case 2: [self.model incrementMaxSlotsBy:[item[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] integerValue]]; break;
            default: break;
        }
        // Decrease boobie count ("Pay")
        [self.model decrementBoobieCountBy:[item[BOOBIE_SHOP_ITEM_COST_KEY] integerValue]];
        // Increase used slots
        [self.model incrementUsedSlotsBy:[item[BOOBIE_SHOP_ITEM_SLOTS_KEY] integerValue]];
        // Increase item count
        [self.model incrementItemCountOfName:item[BOOBIE_SHOP_ITEM_NAME_KEY]];
        
        // Show payed label
        [self newPayedBoobiesLabelWithValue:[item[BOOBIE_SHOP_ITEM_COST_KEY] integerValue]];
        
        // Update labels
        [self setBoobieCount:[self.model getBoobieCount] boobiesPerSecond:[self.model getBoobiesPerSecond]];
        self.usedSlotsLabel.text = [NSString stringWithFormat:@"Slots used: %lu/%lu", (unsigned long)[self.model getUsedSlots],
                                    (unsigned long)[self.model getMaxSlots]];
        
        // Reload cell
        //[self.boobieShopTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        // Reload table
        [self.boobieShopTableView reloadData];
    }
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [BoobieShopManager getBoobieShopItemAtIndex:indexPath.row];

    // Check if we have some items of this type and the item is not an slot power-up
    if ([item[BOOBIE_SHOP_ITEM_EFFECT_TYPE_KEY] integerValue] != 2 &&
        [self.model getItemCountOfName:item[BOOBIE_SHOP_ITEM_NAME_KEY]] > 0) {
        
        // Revert item effect
        switch ([item[BOOBIE_SHOP_ITEM_EFFECT_TYPE_KEY] integerValue]) {
            case 0: [self.model decrementBoobiesPerSecondBy:[item[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] integerValue]]; break;
            case 1: [self.model decrementBoobiesPerClickBy:[item[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] integerValue]]; break;
            default: break;
        }
        // Decrease used slots
        [self.model decrementUsedSlotsBy:[item[BOOBIE_SHOP_ITEM_SLOTS_KEY] integerValue]];
        // Decrease item count
        [self.model decrementItemCountOfName:item[BOOBIE_SHOP_ITEM_NAME_KEY]];
        
        // Update labels
        [self setBoobieCount:[self.model getBoobieCount] boobiesPerSecond:[self.model getBoobiesPerSecond]];
        self.usedSlotsLabel.text = [NSString stringWithFormat:@"Slots used: %lu/%lu", (unsigned long)[self.model getUsedSlots],
                                    (unsigned long)[self.model getMaxSlots]];
        
        // Reload cell
        //[self.boobieShopTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        // Reload table
        [self.boobieShopTableView reloadData];
    }
}

#pragma mark - Utility methods

- (NSNumberFormatter *)boobiesFormatter
{
    // Number formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.groupingSeparator = @".";
    formatter.groupingSize = 3;
    formatter.usesGroupingSeparator = YES;
    
    return formatter;
}

@end
