//
//  LabelCustomAlignment.h
//  Rapnet
//
//  Created by NEHA SINGH on 05/07/11.
//  Copyright 2011 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	VerticalAlignmentTop = 0, // default
	VerticalAlignmentMiddle,
	VerticalAlignmentBottom,
} VerticalAlignment;

@interface LabelCustomAlignment : UILabel
{
    @private
	VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;
@end
