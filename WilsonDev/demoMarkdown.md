**LLDB是个开源的内置于XCode的调试工具，结果为在xcode下验证所得，可能与其它平台有所误差**

####一、打印值、修改值、调用方法
#####1.1 p、po 打印值
```打印相关的命令有：p、po。
p 和 po 的区别在于使用 po 只会输出对应的值，而 p 则会返回值的类型以及命令结果的引用名。

(lldb) p width
(CGFloat) $10 = 70
(lldb) po width
70
(lldb) p endTime
(__NSCFString *) $14 = 0x0000608000437660 @"08-11 11:43"
(lldb) po endTime
08-11 11:43
对比结果:

po：输出值
p：输出值+值类型+引用名+内存地址(xcode中有内存地址，其它平台不确定)
除此之外，p还隐藏了一个有意思的功能，常量的进制转换:

//默认打印为10进制
(lldb) p 100
(int) $8 = 100
//转16进制
(lldb) p/x 100
(int) $9 = 0x00000064
//转8进制
(lldb) p/o 100
(int) $10 = 0144
//转二进制
(lldb) p/t 100
(int) $2 = 0b00000000000000000000000001100100
//字符转10进制数字
(lldb) p/d 'A'
(char) $7 = 65
//10进制数字转字符
(lldb) p/c 66
(int) $10 = B\0\0\0
```
#####1.2 expression 修改参数值
```
感觉exp命令是调试过程中最有价值有命令了，它可以打印值、修改值。

//expression打印值
(lldb) expression width
(CGFloat) $5 = 67
//expression修改值
(lldb) expression width = 80
(CGFloat) $6 = 80
//打印修改后结果
(lldb) p width
(CGFloat) $7 = 80
(lldb)
expression：同样可以输出值+值类型+引用名，但其一般用于修改。
```
#####1.3 call 方法调用
```
在断点调用某个方法，并输出此方法的返回值。

(lldb) call width
(CGFloat) $12 = 70
(lldb) call endTime
(__NSCFString *) $16 = 0x0000608000437660 @"08-11 11:43"
call：同样为输出值+值类型+引用名
```
####二、Thread
#####2.1 堆栈打印 thread backtrace
```
如果嫌堆栈打印太长，可以加一个值限制，如bt 10，只打印

(lldb) bt 10
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
  * frame #0: 0x00000001005e4906 DiDi`-[FW_HomeCell_HotBill setDataSource:](self=0x00007fd3938a7800, _cmd="setDataSource:", dataSource=0x00006080001c8bb0) at FW_HomeCell.m:357
    frame #1: 0x00000001009a9fd7 DiDi`-[FW_MyHomeTableView tableView:cellForRowAtIndexPath:](self=0x00007fd3921fec00, _cmd="tableView:cellForRowAtIndexPath:", tableView=0x00007fd3921fec00, indexPath=0xc000000000000316) at FW_MyHomeTableView.m:247
    frame #2: 0x00000001055a2ab2 UIKit`-[UITableView _createPreparedCellForGlobalRow:withIndexPath:willDisplay:] + 750
    frame #3: 0x00000001055a2cf8 UIKit`-[UITableView _createPreparedCellForGlobalRow:willDisplay:] + 74
    frame #4: 0x0000000105577639 UIKit`-[UITableView _updateVisibleCellsNow:isRecursive:] + 2845
    frame #5: 0x00000001055abccc UIKit`-[UITableView _performWithCachedTraitCollection:] + 111
    frame #6: 0x0000000105592e7a UIKit`-[UITableView layoutSubviews] + 233
    frame #7: 0x00000001054f955b UIKit`-[UIView(CALayerDelegate) layoutSublayersOfLayer:] + 1268
    frame #8: 0x0000000105114904 QuartzCore`-[CALayer layoutSublayers] + 146
    frame #9: 0x0000000105108526 QuartzCore`CA::Layer::layout_if_needed(CA::Transaction*) + 370
```
#####2.2 thread return 跳出当前方法的执行
```
Debug的时候，也许会因为各种原因，我们不想让代码执行某个方法，或者要直接返回一个想要的值。这时候就该thread return上场了。
有返回值的方法里，如：numberOfSectionsInTableView:，直接thread return 10，就可以直接跳过方法执行，返回10.

//跳出方法
(lldb) thread return
//让带有返回int值的方法直接跳出，并返回值10
(lldb) thread return 10
```

#####2.3 流程控制
```
实际上使用xcode自带的可视化工具来控制“继续”“暂停”“下一步”“进入”“跳出”更简单

继续：continue, c
下一步：next, n
进入：step, s
跳出：finish, f
```
#####2.4 跳帧 frame select N
```
2.1中打印有10帧，如果我想跳转到第1帧：frame select 1

(lldb) frame select 1
frame #1: 0x0000000105e91c3c DiDi`-[FW_HomeViewController tableView:cellForRowAtIndexPath:](self=0x00007fbf9f73b410, _cmd="tableView:cellForRowAtIndexPath:", tableView=0x00007fbfa11dc400, indexPath=0xc000000000a00316) at FW_HomeViewController.m:597
   594                  break;
   595                  
   596                  case 3: {
-> 597                      cell.[4md[0mataSource = _hotBills[indexPath.row];
   598                      cell.textSelect = ^(UITextField *text) {
   599                          weakSelf.curruntText = text;
   600                      };
```
#####2.5 查看帧变量 frame variable
```
(lldb) frame variable
(FW_HomeViewController *) self = 0x00007faccbf587d0
(SEL) _cmd = "tableView:cellForRowAtIndexPath:"
(UITableView *) tableView = 0x00007faccd09b400
(NSIndexPath *) indexPath = 0xc000000000000316
(FW_HomeViewController *) weakSelf = 0x00007faccbf587d0
(FW_HomeCell_HotBill *) cell = 0x00007faccc101a00
(UIView *) model = 0x00007fff52c13d90
(FW_HomeCell_HotBill *) billCell = 0x00000001124e99f6
```
####三、Image

#####3.1 image lookup -address 查找崩溃位置
```
当你遇见数组崩溃，你又没有找到崩溃的位置，只扔给你一堆报错信息，这时候image lookup来帮助你。如下

0   CoreFoundation                      0x0000000103209b0b __exceptionPreprocess + 171
    1   libobjc.A.dylib                     0x00000001079db141 objc_exception_throw + 48
    2   CoreFoundation                      0x000000010313effb -[__NSArrayM objectAtIndex:] + 203
    3   DiDi                                0x00000001009a9f3a -[FW_MyHomeTableView tableView:cellForRowAtIndexPath:] + 1322
    4   UIKit                               0x00000001055a2ab2 -[UITableView _createPreparedCellForGlobalRow:withIndexPath:willDisplay:] + 750
    5   UIKit                               0x00000001055a2cf8 -[UITableView _createPreparedCellForGlobalRow:willDisplay:] + 74
    6   UIKit                               0x0000000105577639 -[UITableView _updateVisibleCellsNow:isRecursive:] + 2845
    7   UIKit                               0x00000001055abccc -[UITableView _performWithCachedTraitCollection:] + 111
    8   UIKit                               0x0000000105592e7a -[UITableView layoutSubviews] + 233
    9   UIKit                               0x00000001054f955b -[UIView(CALayerDelegate) layoutSublayersOfLayer:] + 1268
    10  QuartzCore                          0x0000000105114904 -[CALayer layoutSublayers] + 146
寻找自己项目的标识，看到frame3位置，你只需这样查找位置：

image lookup -a 0x00000001009a9f3a
      Address: DiDi[0x0000000100609f3a] (DiDi.__TEXT.__text + 6323194)
      Summary: DiDi`-[FW_MyHomeTableView tableView:cellForRowAtIndexPath:] + 1322 at FW_MyHomeTableView.m:243
项目中FW_MyHomeTableView.m:243，perfect!
```
#####3.2 image lookup -name 查找方法来源
```
此命令可以用来查找方法的来源。包括在第三方SDK中的方法，也能被查到。
例：查找transformOtherModelToSuit:

(lldb) image lookup -n transformOtherModelToSuit:
1 match found in /Users/xxx/Library/Developer/Xcode/DerivedData/DiDi-cwpbvvyvqmeijmcjnneothzuthsy/Build/Products/Debug-iphonesimulator/DiDi.app/DiDi:
        Address: DiDi[0x0000000100293d60] (DiDi.__TEXT.__text + 2693664)
        Summary: DiDi`+[FW_BetFunction transformOtherModelToSuit:] at FW_BetFunction.m:107
```
#####3.3 image lookup –type 查看成员
```
查看某个class的所有属性和成员变量。不过貌似frameWork库中文件不能查看。

(lldb) image lookup -t MatchEvent
1 match found in /Users/xxxx/Library/Developer/Xcode/DerivedData/DiDi-cwpbvvyvqmeijmcjnneothzuthsy/Build/Products/Debug-iphonesimulator/DiDi.app/DiDi:
id = {0x00433d32}, name = "MatchEvent", byte-size = 48, decl = MatchEvent.h:11, compiler_type = "@interface MatchEvent : NSObject{
    BOOL _isHome;
    NSString * _playerName;
    NSString * _timePoint;
    NSString * _eventType;
    NSString * _eventDesc;
}
@property ( getter = isHome,setter = setIsHome:,assign,readwrite,nonatomic ) BOOL isHome;
@property ( getter = playerName,setter = setPlayerName:,readwrite,copy,nonatomic ) NSString * playerName;
@property ( getter = timePoint,setter = setTimePoint:,readwrite,copy,nonatomic ) NSString * timePoint;
@property ( getter = eventType,setter = setEventType:,readwrite,copy,nonatomic ) NSString * eventType;
@property ( getter = eventDesc,setter = setEventDesc:,readwrite,copy,nonatomic ) NSString * eventDesc;
@end"
```
####四、Breakpoint
断点可以不需要使用命令行输入，界面操作即可实现大部分功能

#####结语：
有了这些命令，调试起来肯定就得心应手了。总结下常用的，供多看几遍加深回忆：

堆栈相关：bt查看堆栈、frame select跳帧、frame variable查看帧参数、thread return跳出当前执行、【step/finish/next/continue】进入/跳出/下一步/跳出本断点

断点相关：breakpoint set -f -l -c条件断点、breakpoint set -n方法断点、breakpoint delete断点移除、breakpoint list断点列表

image命令：image lookup -address崩溃定位、image lookup -name方法来源、 image lookup –type 查看成员

参考：[iOS之LLDB常用调试命令](https://www.cnblogs.com/hjltonyios/p/8878959.html)

