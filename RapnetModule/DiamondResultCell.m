//
//  DiamondResultCell.m
//  Rapnet
//
//  Created by Itzik on 14/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import "DiamondResultCell.h"

@interface DiamondResultCell ()

@end

@implementation DiamondResultCell

//@synthesize diamond;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        
        
    }
    return self;
}

-(void)setDiamond:(DiamondSearchResult*)d
{
    diamond = d;
    
}

@end
