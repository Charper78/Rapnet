//
//  WorkAreaCustomCell.m
//  RapnetPriceModule
//
//  Created by Nikhil Bansal on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkAreaCustomCell.h"


@implementation WorkAreaCustomCell

@synthesize state;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    // NSLog(@"indent");
    
    self.contentView.frame = CGRectMake(0,                                          
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width, 
                                        self.contentView.frame.size.height);
    
    if (self.editing
        && ((self.state & UITableViewCellStateShowingEditControlMask)
            && !(self.state & UITableViewCellStateShowingDeleteConfirmationMask)) || 
        ((self.state & UITableViewCellStateShowingEditControlMask)
         && (self.state & UITableViewCellStateShowingDeleteConfirmationMask))) 
    {
        NSLog(@"indent");
        float indentPoints = self.indentationLevel * self.indentationWidth;
        
        self.contentView.frame = CGRectMake(indentPoints,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width - indentPoints, 
                                            self.contentView.frame.size.height);    
    }

    
}

-(void)willTransitionToState:(UITableViewCellStateMask)state{
    self.state = state;
    
    NSLog(@"trans");
    
    if (state==UITableViewCellStateShowingDeleteConfirmationMask) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 12, 12);
        button.frame = frame;
        [button setBackgroundImage:[UIImage imageNamed:@"red-arrow1X.png"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [self addSubview:button];
    }
    
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
