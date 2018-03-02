//
//  AppStoreTransitionVC.m
//  WilsonDev
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "TransitionMainVC.h"
#import "UIView+SDAutolayout.h"
#import "TransitionCustomVC.h"

typedef NS_ENUM(NSInteger, TransitionType){
    TransitionStyleCoverVertical,
    TransitionStyleFlipHorizontal,
    TransitionStyleCrossDissolve,
    TransitionStylePartialCurl,
    TransitionStyleAppStore
};

@interface TransitionTypeModel : NSObject

@property (strong, nonatomic) NSString *title;

@property (assign, nonatomic) NSInteger transitionType;

@end
@implementation TransitionTypeModel
@end

@interface TransitionMainVC ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSMutableArray *transitions;

@end

@implementation TransitionMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataSource];
    [self customViews];
}

- (void)createDataSource {
    TransitionTypeModel *modelVertical = [self createDataTitle:@"Vertical-system" transitionType:TransitionStyleCoverVertical];
    TransitionTypeModel *modelHorizontal = [self createDataTitle:@"Horizontal-system" transitionType:TransitionStyleFlipHorizontal];
    TransitionTypeModel *modelDissolve = [self createDataTitle:@"Dissolve-system" transitionType:TransitionStyleCrossDissolve];
    TransitionTypeModel *modelPartialCurl = [self createDataTitle:@"PartialCurl-system" transitionType:TransitionStylePartialCurl];
    TransitionTypeModel *modelAppStore = [self createDataTitle:@"Custom" transitionType:TransitionStyleAppStore];
    
    self.transitions = [NSMutableArray array];
    
    [self.transitions addObject:modelDissolve];
    [self.transitions addObject:modelPartialCurl];
    [self.transitions addObject:modelVertical];
    [self.transitions addObject:modelHorizontal];
    [self.transitions addObject:modelAppStore];
}

- (TransitionTypeModel *)createDataTitle:(NSString *)title
                          transitionType:(TransitionType)transitionType {
    
    TransitionTypeModel *model = [[TransitionTypeModel alloc] init];
    model.title = title;
    model.transitionType = transitionType;
    return model;
}

- (void)customViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    
    [self.view addSubview:stackView];
    stackView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    for (int i = 0; i < self.transitions.count; i++) {
        TransitionTypeModel *model = self.transitions[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i;
        [button setTitle:model.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [stackView addArrangedSubview:button];
    }
    
}

- (void)clickBtn:(UIButton *)sender {
    if (sender.tag <= self.transitions.count-1) {
        TransitionTypeModel *model = self.transitions[sender.tag];
        [self transitionWithType:model.transitionType title:model.title];
    }
}

- (void)transitionWithType:(TransitionType)type title:(NSString *)title {
    
    UIModalTransitionStyle modalTransitionStyle;
    
    BOOL systemTrans;
    
    switch (type) {
            case TransitionStyleCoverVertical:{
                modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                systemTrans = YES;
            }
            break;
            
            case TransitionStyleFlipHorizontal:{
                modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                systemTrans = YES;
            }
            break;
            
            case TransitionStyleCrossDissolve:{
                modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                systemTrans = YES;
            }
            break;
            
            case TransitionStylePartialCurl:{
                modalTransitionStyle = UIModalTransitionStylePartialCurl;
                systemTrans = YES;
            }
            break;
            
            case TransitionStyleAppStore:{
                modalTransitionStyle = UIModalTransitionStylePartialCurl;
                systemTrans = NO;
            }
            break;
            
        default:{
                systemTrans = NO;
                modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            }
            break;
    }
    
    if (systemTrans) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor yellowColor];
        vc.title = title;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"Back" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 30);
        [btn addTarget:self action:@selector(backVC:) forControlEvents:UIControlEventTouchUpInside];
        [vc.view addSubview:btn];
        vc.modalTransitionStyle = modalTransitionStyle;
        vc.transitioningDelegate = self;
        
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        TransitionCustomVC *vc = [[TransitionCustomVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backVC:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
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
