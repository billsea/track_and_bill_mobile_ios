//
//  ProjectCollectionViewController.h
//  trackandbill_ios
//
//  Created by Loud on 3/25/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectCollectionViewController : UICollectionViewController
@property(nonatomic) Project *selectedProject;
@end