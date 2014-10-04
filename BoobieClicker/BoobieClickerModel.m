//
//  BoobieClickerModel.m
//  BoobieClicker
//
//  Created by Natxo Raga on 04/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import "BoobieClickerModel.h"
#import "BoobieShopManager.h"


@implementation BoobieClickerModel

static NSString *const BOOBIE_COUNT_KEY = @"boobieCount";
static NSString *const BOOBIES_PER_SECOND_KEY = @"boobiesPerSecond";
static NSString *const BOOBIES_PER_CLICK_KEY = @"boobiesPerClick";
static NSString *const MAX_SLOTS_KEY = @"maxSlots";
static NSString *const USED_SLOTS_KEY = @"usedSlots";

static NSUInteger const DEFAULT_BOOBIES_PER_SECOND = 0;
static NSUInteger const DEFAULT_BOOBIES_PER_CLICK = 1;
static NSUInteger const DEFAULT_MAX_SLOTS = 20;
static NSUInteger const DEFAULT_USED_SLOTS = 0;

- (NSUInteger)getBoobieCount
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:BOOBIE_COUNT_KEY] unsignedIntegerValue];
}

- (NSUInteger)getBoobiesPerSecond
{
    NSNumber *boobiesPerSecond = [[NSUserDefaults standardUserDefaults] objectForKey:BOOBIES_PER_SECOND_KEY];
    return boobiesPerSecond ? [boobiesPerSecond unsignedIntegerValue] : DEFAULT_BOOBIES_PER_SECOND;
}

- (NSUInteger)getBoobiesPerClick
{
    NSNumber *boobiesPerClick = [[NSUserDefaults standardUserDefaults] objectForKey:BOOBIES_PER_CLICK_KEY];
    return boobiesPerClick ? [boobiesPerClick unsignedIntegerValue] : DEFAULT_BOOBIES_PER_CLICK;
}

- (NSUInteger)getMaxSlots
{
    NSNumber *maxSlots = [[NSUserDefaults standardUserDefaults] objectForKey:MAX_SLOTS_KEY];
    return maxSlots ? [maxSlots unsignedIntegerValue] : DEFAULT_MAX_SLOTS;
}

- (NSUInteger)getUsedSlots
{
    NSNumber *usedSlots = [[NSUserDefaults standardUserDefaults] objectForKey:USED_SLOTS_KEY];
    return usedSlots ? [usedSlots unsignedIntegerValue] : DEFAULT_USED_SLOTS;
}

- (NSUInteger)getItemCountOfName:(NSString *)itemName
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:itemName] unsignedIntegerValue];
}

- (void)incrementBoobieCountBy:(NSUInteger)increment
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getBoobieCount] + increment) forKey:BOOBIE_COUNT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)decrementBoobieCountBy:(NSUInteger)decrement
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getBoobieCount] - decrement) forKey:BOOBIE_COUNT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)incrementBoobiesPerSecondBy:(NSUInteger)increment
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getBoobiesPerSecond] + increment) forKey:BOOBIES_PER_SECOND_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)decrementBoobiesPerSecondBy:(NSUInteger)decrement
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getBoobiesPerSecond] - decrement) forKey:BOOBIES_PER_SECOND_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)incrementBoobiesPerClickBy:(NSUInteger)increment
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getBoobiesPerClick] + increment) forKey:BOOBIES_PER_CLICK_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)decrementBoobiesPerClickBy:(NSUInteger)decrement
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getBoobiesPerClick] - decrement) forKey:BOOBIES_PER_CLICK_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)incrementMaxSlotsBy:(NSUInteger)increment
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getMaxSlots] + increment) forKey:MAX_SLOTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)incrementUsedSlotsBy:(NSUInteger)increment
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getUsedSlots] + increment) forKey:USED_SLOTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)decrementUsedSlotsBy:(NSUInteger)decrement
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getUsedSlots] - decrement) forKey:USED_SLOTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)incrementItemCountOfName:(NSString *)itemName
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getItemCountOfName:itemName] + 1) forKey:itemName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)decrementItemCountOfName:(NSString *)itemName
{
    [[NSUserDefaults standardUserDefaults] setObject:@([self getItemCountOfName:itemName] - 1) forKey:itemName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reloadBoobieModifiers
{
    NSArray *powerUps = [BoobieShopManager getBoobieShopItems];
    
    NSUInteger boobiesPerSecond = DEFAULT_BOOBIES_PER_SECOND;
    NSUInteger boobiesPerClick = DEFAULT_BOOBIES_PER_CLICK;
    NSUInteger maxSlots = DEFAULT_MAX_SLOTS;
    NSUInteger usedSlots = DEFAULT_USED_SLOTS;
    
    for (NSDictionary *powerUp in powerUps) {
        NSNumber *numberItems = [[NSUserDefaults standardUserDefaults] objectForKey:powerUp[BOOBIE_SHOP_ITEM_NAME_KEY]];
        if (numberItems) {
            NSUInteger count = [numberItems unsignedIntegerValue];
            usedSlots += [powerUp[BOOBIE_SHOP_ITEM_SLOTS_KEY] unsignedIntegerValue]*count;
            switch ([powerUp[BOOBIE_SHOP_ITEM_EFFECT_TYPE_KEY] unsignedIntegerValue]) {
                case 0: boobiesPerSecond += [powerUp[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] unsignedIntegerValue]*count; break;
                case 1: boobiesPerClick += [powerUp[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] unsignedIntegerValue]*count; break;
                case 2: maxSlots += [powerUp[BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY] integerValue]*count; break;
                default: break;
            }
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(boobiesPerSecond) forKey:BOOBIES_PER_SECOND_KEY];
    [defaults setObject:@(boobiesPerClick) forKey:BOOBIES_PER_CLICK_KEY];
    [defaults setObject:@(maxSlots) forKey:MAX_SLOTS_KEY];
    [defaults setObject:@(usedSlots) forKey:USED_SLOTS_KEY];
    [defaults synchronize];
}

@end
