//
//  BoobieShopManager.m
//  BoobieClicker
//
//  Created by Natxo Raga on 04/10/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import "BoobieShopManager.h"


@implementation BoobieShopManager

NSString *const BOOBIE_SHOP_PLIST_NAME = @"BoobieShop";
NSString *const BOOBIE_SHOP_ITEM_IMAGE_NAME_KEY = @"imageName";
NSString *const BOOBIE_SHOP_ITEM_NAME_KEY = @"name";
NSString *const BOOBIE_SHOP_ITEM_COST_KEY = @"cost";
NSString *const BOOBIE_SHOP_ITEM_SLOTS_KEY = @"slots";
NSString *const BOOBIE_SHOP_ITEM_EFFECT_TYPE_KEY = @"effectType";
NSString *const BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY = @"effectNumber";

+ (NSArray *)getBoobieShopItems
{
    NSString *path = [[NSBundle mainBundle] pathForResource:BOOBIE_SHOP_PLIST_NAME ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSDictionary *)getBoobieShopItemAtIndex:(NSUInteger)index
{
    NSString *path = [[NSBundle mainBundle] pathForResource:BOOBIE_SHOP_PLIST_NAME ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path][index];
}

@end
