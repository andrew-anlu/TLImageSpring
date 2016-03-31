//
//  TLCustomCell.m
//  TLImageSpring
//
//  Created by Andrew on 16/3/31.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLCustomCell.h"
#import "GlobalConfig.h"
#import <TLImageSpring/TLImageSpringManager.h>

@implementation TLCustomCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        CGRect rect=CGRectMake(10, 10, 100, 20);
        
        _namelb=[[UILabel alloc]initWithFrame:rect];
        [self addSubview:_namelb];
        
        rect=CGRectMake(SCREEN_WIDTH-150, 10, 140, 150);
        _iconIv=[[UIImageView alloc]initWithFrame:rect];
        [self addSubview:_iconIv];
    }
    
    return self;
}

-(void)setDataSource:(NSDictionary *)dict{
    NSString *url=[dict[@"url"] description];
    
    NSString *name=[dict[@"name"] description];
    _namelb.text=name;
    TLImageSpringManager *manager=[TLImageSpringManager sharedInstance];
    
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:TLImageSpringLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
        if(image && !error){
            _iconIv.image=image;
        }
    }];
    
}






@end
