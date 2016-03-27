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

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *urlString=@"http://www.weather.com.cn/data/cityinfo/101010100.html";
    NSURL *url=[NSURL URLWithString:urlString];
    
    
    TLImageSpringDownloader *downloader=[TLImageSpringDownloader sharedInstance];
    [downloader downloadImgWithURL:url progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } isFinished:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
    }];
    
    [downloader downloadImgWithURL:url progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } isFinished:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
    }];
    
    [downloader downloadImgWithURL:url progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } isFinished:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
    }];
}




@end
