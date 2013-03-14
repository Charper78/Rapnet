//
//  DiamondResultCell.h
//  Rapnet
//
//  Created by Itzik on 14/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiamondSearchResult.h"
@interface DiamondResultCell : UITableViewCell
{
    DiamondSearchResult *diamond;
    
    
}

-(void)setDiamond:(DiamondSearchResult*)d;

//@property (nonatomic,retain) DiamondSearchResult *diamond;
@end
