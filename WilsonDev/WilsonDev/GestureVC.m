//
//  GestureVC.m
//  WilsonDev
//
//  Created by Wilson on 2017/12/19.
//  Copyright © 2017年 Wilson. All rights reserved.
//

#import "GestureVC.h"

@interface GestureVC ()

@end

@implementation GestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureRecongizer];
}

- (void)addGestureRecongizer {
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    tap1.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
    tap2.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap2];
    /*
     *  当tap2手势触发失败时才会触发tap1手势
     *  若不这样操作，则两个手势都会触发
     */
    [tap1 requireGestureRecognizerToFail:tap2];
   
}

-(void)tap1:(UITapGestureRecognizer *)tap1 {
    NSLog(@"tap1手势触发");
}

-(void)tap2:(UITapGestureRecognizer *)tap2 {
    NSLog(@"tap2手势触发");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
