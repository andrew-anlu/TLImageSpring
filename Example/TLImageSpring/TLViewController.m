//
//  TLViewController.m
//  TLImageSpring
//
//  Created by Andrew on 03/24/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

#import "TLViewController.h"
#import <TLImageSpring/TLImageSpringDownloader.h>

@interface TLViewController ()
@property (nonatomic,strong) UIImageView *bgImgView;
@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _bgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 100, 200)];
    _bgImgView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:_bgImgView];
    
    
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 40)];
    [btn setTitle:@"开始下载图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

   
}

-(void)test{
    
    NSString *urlString=nil;
    //NSString *urlString=@"http://www.weather.com.cn/data/cityinfo/101010100.html";
    urlString=@"http://7xkxhx.com1.z0.glb.clouddn.com/QQ20151022-3.png";
    NSURL *url=[NSURL URLWithString:urlString];
    
    
    TLImageSpringDownloader *downloader=[TLImageSpringDownloader sharedInstance];
    
    [downloader downloadImgWithURL:url downloadOptions:TLImageSpringDownloadLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } finished:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if(finished){
            _bgImgView.image=image;
        }
    }];
}




@end
