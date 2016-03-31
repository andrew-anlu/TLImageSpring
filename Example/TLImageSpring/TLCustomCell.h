//
//  TLCustomCell.h
//  TLImageSpring
//
//  Created by Andrew on 16/3/31.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLCustomCell : UITableViewCell
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UIImageView *iconIv;

-(void)setDataSource:(NSDictionary *)dict;
@end
