//
//  MarkdownVC.m
//  WilsonDev
//
//  Created by Wilson on 6/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "MarkdownVC.h"
#import "WilsonDev-Swift.h"

@interface MarkdownVC ()

@end

@implementation MarkdownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    WilsonMarkdownView *view = [[WilsonMarkdownView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
