//
//  DashboardCollectionViewCell.h
//  trackandbill_ios
//
//  Created by Loud on 3/23/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dashboardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UISwitch *timerSwitch;


@end
