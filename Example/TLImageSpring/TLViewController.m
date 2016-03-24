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

    TLImageSpringDownloader *downloader=[[TLImageSpringDownloader alloc]init];
    [downloader startDownload];
}



@end
