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
#import <TLImageSpring/UIImageView+TLSpring.h>
#import "GlobalConfig.h"
#import <TLImageSpring/TLImageCatch.h>


#define IMGURL @"http://7xkxhx.com1.z0.glb.clouddn.com/IMG_5686.jpg"

@interface TLViewController ()
@property (nonatomic,strong) UIImageView *bgImgView1;



#define NAVHeight 64
@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    _bgImgView1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150, 10+NAVHeight, 150, 200)];
    _bgImgView1.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_bgImgView1];
    
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10+NAVHeight, 100, 40)];
    [btn setTitle:@"开始下载图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:btn];
    
    
    CGRect rect=CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame)+10, btn.frame.size.width, 40);
    UIButton *cancelBtn=[self createBtn:rect title:@"取消下载"];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    rect=CGRectMake(btn.frame.origin.x, CGRectGetMaxY(cancelBtn.frame)+10, btn.frame.size.width, 40);
    UIButton *clearBtn=[self createBtn:rect title:@"清空图片"];
    [clearBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    

    rect=CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_bgImgView1.frame)+10, 100, 40) ;
    
    UIButton *tableViewBtn=[self createBtn:rect title:@"表格显示图片"];
    [self.view addSubview:tableViewBtn];
    
    [tableViewBtn addTarget:self action:@selector(tableAction:) forControlEvents:UIControlEventTouchUpInside];
                 

}

-(UIButton *)createBtn:(CGRect)rect title:(NSString *)title{
    UIButton *btn=[[UIButton alloc]initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:13];
    return btn;
}

-(void)test{
    
    NSString *urlString=@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-3.png";
    NSURL *url=[NSURL URLWithString:urlString];
    [_bgImgView1 TL_setImageWithURL:url
                   placeholderImage:[UIImage imageNamed:@"map"]];
    
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

-(void)cancelAction:(UIButton *)btn{
    NSLog(@"%s",__FUNCTION__);
    [_bgImgView1 TL_cancelCurrentImageDownload];
}


-(void)clearAction:(UIButton *)btn{
    TLImageCatch *cache=[TLImageCatch sharedInstance];
    
    [cache removeImageForKey:IMGURL];
    
    _bgImgView1.image=nil;
}





@end
