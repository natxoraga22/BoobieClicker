//
//  BoobieClickerModel.h
//  BoobieClicker
//
//  Created by Natxo Raga on 04/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BoobieClickerModel : NSObject

- (NSUInteger)getBoobieCount;
- (NSUInteger)getBoobiesPerSecond;
- (NSUInteger)getBoobiesPerClick;
- (NSUInteger)getMaxSlots;
- (NSUInteger)getUsedSlots;
- (NSUInteger)getItemCountOfName:(NSString *)itemName;

- (void)incrementBoobieCountBy:(NSUInteger)increment;
- (void)decrementBoobieCountBy:(NSUInteger)decrement;
- (void)incrementBoobiesPerSecondBy:(NSUInteger)increment;
- (void)decrementBoobiesPerSecondBy:(NSUInteger)decrement;
- (void)incrementBoobiesPerClickBy:(NSUInteger)increment;
- (void)decrementBoobiesPerClickBy:(NSUInteger)decrement;
- (void)incrementMaxSlotsBy:(NSUInteger)increment;
- (void)incrementUsedSlotsBy:(NSUInteger)increment;
- (void)decrementUsedSlotsBy:(NSUInteger)decrement;
- (void)incrementItemCountOfName:(NSString *)itemName;
- (void)decrementItemCountOfName:(NSString *)itemName;

- (void)reloadBoobieModifiers;

@end
