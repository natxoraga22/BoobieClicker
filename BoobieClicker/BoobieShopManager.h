//
//  BoobieShopManager.h
//  BoobieClicker
//
//  Created by Natxo Raga on 04/10/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BoobieShopManager : NSObject

extern NSString *const BOOBIE_SHOP_PLIST_NAME;
extern NSString *const BOOBIE_SHOP_ITEM_IMAGE_NAME_KEY;
extern NSString *const BOOBIE_SHOP_ITEM_NAME_KEY;
extern NSString *const BOOBIE_SHOP_ITEM_COST_KEY;
extern NSString *const BOOBIE_SHOP_ITEM_SLOTS_KEY;
extern NSString *const BOOBIE_SHOP_ITEM_EFFECT_TYPE_KEY;
extern NSString *const BOOBIE_SHOP_ITEM_EFFECT_NUMBER_KEY;

+ (NSArray *)getBoobieShopItems;
+ (NSDictionary *)getBoobieShopItemAtIndex:(NSUInteger)index;

@end
