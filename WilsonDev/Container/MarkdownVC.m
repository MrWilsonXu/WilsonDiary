//
//  MarkdownVC.m
//  WilsonDev
//
//  Created by Wilson on 6/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "MarkdownVC.h"
#import "WilsonDev-Swift.h"
#import <MMMarkdown/MMMarkdown.h>
#import <WebKit/WebKit.h>

@interface MarkdownVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation MarkdownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *markdownPath = [[NSBundle mainBundle] pathForResource:@"demoMarkdown" ofType:@"md"];
    NSString *markdown = [NSString stringWithContentsOfFile:markdownPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"html"];
    NSString *htmlTest = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    //注意：使用MMMarkdown转义之后会自动填充\n,在需要的情况下，可以手动删除
    NSError  *error;
    NSString *mString = [MMMarkdown HTMLStringWithMarkdown:markdown extensions:MMMarkdownExtensionsGitHubFlavored error:&error];
    NSString *htmlString = [mString substringToIndex:mString.length-1];
    NSString *htmlStr = [self getHTMLString:htmlString];
          
    [self.view addSubview:self.webview];
    [self.webview loadHTMLString:htmlTest baseURL:nil];

}

// 识别数学公式替换
- (NSString *)getHTMLString:(NSString *)code {
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SPLatex"
                                                                                        ofType:@"html"]
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    NSString *rep = [NSString stringWithFormat:@"render(\"%@\"",code];
    html = [html stringByReplacingOccurrencesOfString:@"render(\"\"" withString:rep];
    html = [html stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    NSLog(@"HTML Code is : %@",code);
    NSLog(@"HTML String is : %@",html);
    return html;
}

#pragma mark - Getter
- (WKWebView *)webview {
    if (!_webview) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        if (@available(iOS 10.0, *)) {
            config.mediaTypesRequiringUserActionForPlayback = YES;
        } else {
            // Fallback on earlier versions
        }//把手动播放设置NO ios(8.0, 9.0)
        config.allowsInlineMediaPlayback = YES;//是否允许内联(YES)或使用本机全屏控制器(NO)，默认是NO。
        config.allowsAirPlayForMediaPlayback = YES;//允许播放，iOS(8.0, 9.0)
        // 自适应屏幕宽度js
        NSString *jSString = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=%d, maximum-scale=%d, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);",1,1];
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString
                                                            injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                         forMainFrameOnly:YES];
        // 添加自适应屏幕宽度js调用的方法
        [config.userContentController addUserScript:wkUserScript];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webview.navigationDelegate = self;
        _webview.allowsBackForwardNavigationGestures = YES;
        _webview.scrollView.bounces = NO;
    }
    return _webview;
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
