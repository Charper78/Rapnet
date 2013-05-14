//
//  DiamondResultsVC.h
//  Rapnet
//
//  Created by Itzik on 04/05/12.
//  Copyright (c) 2012 coolban@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiamondsSearchResultParser.h"
#import "DiamondResultsVC.h"
#import "AppDelegate.h"
#import "DiamondResultCell.h"
#import "DiamondSearchParams.h"
#import "DiamondSearchResult.h"
#import "DiamondDesultDetailsVC.h"
#import "DiamondSearchParams.h"
#import "Functions.h"
#import "MoreResultsCell.h"
#import "AnalyticHelper.h"
@interface DiamondResultsVC : UIViewController<UITableViewDelegate, UITableViewDataSource, getDiamondsSearchResultDelegate>
{
    DiamondsSearchResultParser *resultParser;
    NSMutableArray *results;
    
    DiamondResultCell *cell;
    MoreResultsCell *moreResults;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *lblMoreResultsTitle;
    
    UITableView *tblResults;
    IBOutlet UIButton *btnBack;
    
    
    IBOutlet UILabel *lblShapeVal;
    IBOutlet UILabel *lblSizeVal;
    IBOutlet UILabel *lblClarityVal;
    IBOutlet UILabel *lblPolishVal;
    IBOutlet UILabel *lblColorVal;
    IBOutlet UILabel *lblCutVal;
    IBOutlet UILabel *lblSymVal;
    IBOutlet UILabel *lblFluorVal;
    IBOutlet UILabel *lblLabVal;
    IBOutlet UILabel *lblCaratVal;
    IBOutlet UILabel *lblRapPercentVal;
    IBOutlet UILabel *lblLocVal;
    IBOutlet UILabel *lblTableVal;
    IBOutlet UILabel *lblDepthVal;
   
    IBOutlet UILabel *lblTitle;
    DiamondSearchParams *searchParams;
    NSInteger startRow;
    NSInteger endRow;
    NSInteger totalCount;
    //IBOutlet DiamondResultCell *resultCell;
}
@property(nonatomic, retain)IBOutlet UITableView* tblResults;
@property(nonatomic, retain)IBOutlet DiamondResultCell* resultCell;
@property(nonatomic, retain)IBOutlet MoreResultsCell* moreResultsCell;

-(IBAction)btnBackClicked:(id)sender;
-(void) search:(DiamondSearchParams*)params;
//-(void)changeTableHeight:(CGFloat)height;
@end
