//
//  BoobieShopTableViewCell.h
//  BoobieClicker
//
//  Created by Natxo Raga on 02/06/14.
//  Copyright (c) 2014 Ignacio Raga Llorens. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BoobieShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSlotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemEffectLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@end
