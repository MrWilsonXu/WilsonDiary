//
//  LocalizableVC.m
//  WilsonDev
//
//  Created by Wilson on 19/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "LocalizableVC.h"
#import "Masonry.h"

@interface LocalizableVC ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *lab;

@property (nonatomic, copy) NSString *currentLanguage;

@end

@implementation LocalizableVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.lab];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"SelectLanguage", @"Wilson", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectLanguage)];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(200);
    }];
    
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(30);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.view);
    }];
    [self getOrUpdateSystemLanguage];
    [self setValueForView];
}

/**
 *  View assignment
 */
- (void)setValueForView {
    NSString *labText = [self getStringKey:@"SelectLanguage" tbl:@"Localizable"];
    self.lab.text = labText;
    
    NSBundle *bundle = [self bundlePath];
    NSString *file = [bundle pathForResource:@"girl" ofType:@"png"];
    self.imgView.image = [UIImage imageWithContentsOfFile:file];
    [self.navigationItem.rightBarButtonItem setTitle:[self getStringKey:@"SelectLanguage" tbl:@"Wilson"]];    
}

- (NSString *)getStringKey:(NSString *)key tbl:(NSString *)tbl {
    NSBundle *bundle = [self bundlePath];
    NSString *str = NSLocalizedStringFromTableInBundle(key, tbl, bundle, nil);
    return str;
}

- (NSBundle *)bundlePath {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.currentLanguage ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return bundle;
}

/**
 *  set/get system language
 */
- (void)getOrUpdateSystemLanguage {
    NSArray *lans = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSLog(@"Current Language %@",lans.firstObject);
    self.currentLanguage = lans.firstObject;
}

- (void)setSystemLanguage:(NSString *)language {
    if (language.length > 0) {
        NSArray *lans = @[language];
        [[NSUserDefaults standardUserDefaults] setObject:lans forKey:@"AppleLanguages"];
        [self getOrUpdateSystemLanguage];
        [self setValueForView];
    }
}

#pragma mark - Action

- (void)selectLanguage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedStringFromTable(@"AlertDes", @"Wilson", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    typeof(self) __weak weakSelf = self;
    UIAlertAction *English = [UIAlertAction actionWithTitle:NSLocalizedString(@"English", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setSystemLanguage:@"en"];
    }];
    UIAlertAction *Chinese = [UIAlertAction actionWithTitle:NSLocalizedString(@"Chinese", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setSystemLanguage:@"zh-Hans"];
    }];
    UIAlertAction *Japanese = [UIAlertAction actionWithTitle:NSLocalizedString(@"Japanese", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setSystemLanguage:@"ja"];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:English];
    [alert addAction:Chinese];
    [alert addAction:Japanese];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Getter

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

- (UILabel *)lab {
    if (!_lab) {
        self.lab = [[UILabel alloc] init];
    }
    return _lab;
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
