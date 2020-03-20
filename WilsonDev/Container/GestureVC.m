//
//  GestureVC.m
//  WilsonDev
//
//  Created by Wilson on 2017/12/19.
//  Copyright © 2017年 Wilson. All rights reserved.
//

#import "GestureVC.h"
#import "SDAutolayout.h"

@interface GestureVC ()

@property (nonatomic, strong) UIScrollView *scrollview;

@end

@implementation GestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSubviews];
    [self addGestureRecongizer];
}

- (void)customSubviews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollview];
    self.scrollview.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    CGFloat height = CGRectGetHeight(self.view.frame) / 5.0;
    UIView *lastView = self.scrollview;
    
    for (int i = 0; i < 5; i++) {
        NSInteger random = arc4random() % 255;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:random / 255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self.scrollview addSubview:view];
        
        view.sd_layout
        .topSpaceToView(lastView, 0)
        .leftSpaceToView(self.scrollview, 0)
        .rightSpaceToView(self.scrollview, 0)
        .heightIs(height);
        
        lastView = view;
    }
    
    [self.scrollview setupAutoContentSizeWithBottomView:lastView bottomMargin:0];
    
}

#pragma mark - TapGesture exclusive
- (void)addGestureRecongizer {
    NSString *content = @"1：tap1 and tap2 both are not Synchronized execution when called 'requireGestureRecognizerToFail'. click the green area below to start test, check log ";

    const CGFloat titleH = 50;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, titleH, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
    topView.backgroundColor = [UIColor colorWithRed:29/255.0 green:150/255.0 blue:45/255.0 alpha:1];
    [self.view addSubview:topView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-20, titleH)];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.lineBreakMode = NSLineBreakByCharWrapping;
    titleLab.numberOfLines = 0;
    titleLab.text = content;
    [titleLab sizeToFit];
    [titleLab layoutSubviews];
    [self.view addSubview:titleLab];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
    tap1.numberOfTapsRequired = 1;
    [topView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
    tap2.numberOfTapsRequired = 2;
    [topView addGestureRecognizer:tap2];
    
    [tap1 requireGestureRecognizerToFail:tap2];
   
}

-(void)tap1:(UITapGestureRecognizer *)tap1 {
    NSLog(@"tap1 action");
}

-(void)tap2:(UITapGestureRecognizer *)tap2 {
    NSLog(@"tap2 action");
}

- (UIScrollView *)scrollview {
    if (!_scrollview) {
        self.scrollview = [[UIScrollView alloc] init];
    }
    return _scrollview;
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
