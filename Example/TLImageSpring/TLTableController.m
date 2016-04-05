//
//  TLTableController.m
//  TLImageSpring
//
//  Created by Andrew on 16/3/31.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "TLTableController.h"
#import "GlobalConfig.h"
#import "TLCustomCell.h"

#import <TLImageSpring/TLImageSpringManager.h>
#import <TLImageSpring/UIImageView+UIActivityIndicatorForTLImageSpring.h>


@interface TLTableController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,strong)UITableView *tableview;
@end

@implementation TLTableController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self initData];
    [self initTabelView];
    [self initView];
}

-(void)initData{
    _arrayData=@[@{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/1432799466416554.jpeg"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151012-0.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-0.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-1.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-3.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-6.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-7.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-6.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20160303-0.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/closureReferenceCycle01_2x.png"},
                 @{@"name":@"张三",
                   @"url":@"http://7xkxhx.com1.z0.glb.clouddn.com/IMG_5853.jpg"}
                 ];
}



-(void)initTabelView{

    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self.view addSubview:_tableview];
}

-(void)cancelAllAction:(UIButton *)btn{
    TLImageSpringManager *manager=[TLImageSpringManager sharedInstance];
    [manager cancelAll];
    
    NSLog(@"取消下载了");
}

-(void)initView{
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 80, 40)];
    [btn setTitle:@"取消下载" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:btn];
    
    [btn addTarget:self action:@selector(cancelAllAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CELLID   = @"cellIdentity";
    
    TLCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:CELLID];
    if(!cell){
        cell=[[TLCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    
    if(_arrayData && _arrayData.count>0){
        NSDictionary *dict=_arrayData[indexPath.row];
        
        NSString *name=dict[@"name"];
        name=[name stringByAppendingFormat:@"%ld",(long)indexPath.row];
        cell.namelb.text=name;
        
        [cell setDataSource:dict];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
@end















