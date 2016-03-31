//
//  TLViewController.m
//  TLImageSpring
//
//  Created by Andrew on 03/24/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

#import "TLViewController.h"
#import <TLImageSpring/TLImageSpringDownloader.h>
#import <TLImageSpring/TLImageSpringManager.h>
#import "TLTableController.h"

@interface TLViewController ()
@property (nonatomic,strong) UIImageView *bgImgView1;



#define NAVHeight 64
@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    _bgImgView1=[[UIImageView alloc]initWithFrame:CGRectMake(100, 10+NAVHeight, 100, 200)];
    _bgImgView1.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_bgImgView1];
    
    
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10+NAVHeight, 100, 40)];
    [btn setTitle:@"开始下载图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(managerTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    

    CGRect rect=CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_bgImgView1.frame)+10, 100, 40) ;
    
    UIButton *tableViewBtn=[self createBtn:rect title:@"表格显示图片"];
    [self.view addSubview:tableViewBtn];
    
    [tableViewBtn addTarget:self action:@selector(tableAction:) forControlEvents:UIControlEventTouchUpInside];
                 

}

-(UIButton *)createBtn:(CGRect)rect title:(NSString *)title{
    UIButton *btn=[[UIButton alloc]initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    return btn;
}

-(void)test{
    
    NSString *urlString=nil;
    //NSString *urlString=@"http://www.weather.com.cn/data/cityinfo/101010100.html";
    urlString=@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-3.png";
    NSURL *url=[NSURL URLWithString:urlString];
    
    
    TLImageSpringDownloader *downloader=[TLImageSpringDownloader sharedInstance];
    
    [downloader downloadImgWithURL:url downloadOptions:TLImageSpringDownloadLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } finished:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if(error){
            NSLog(@"出错了:%@",error.description);
        }else{
          _bgImgView1.image=image;
        }
    }];
}

-(void)managerTest{
    NSString *urlString=nil;
    urlString=@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-3.png";
    NSURL *url=[NSURL URLWithString:urlString];
    
    TLImageSpringManager *manager=[TLImageSpringManager sharedInstance];
    
    [manager downloadImageWithURL:url options:TLImageSpringRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, TLImageCatchType cacheType, BOOL finished, NSURL *imageUrl) {
        if(error){
            NSLog(@"出错了:%@",error.description);
        }else{
            
            _bgImgView1.image=image;
            
           // NSLog(@"缓存策略是:%@,imageUrl=%@",cacheType,imageUrl);
        }
    }];
}

-(void)tableAction:(UIButton *)btn{
    TLTableController *tableVc=[[TLTableController alloc]init];
    [self.navigationController pushViewController:tableVc animated:YES];
}






@end
