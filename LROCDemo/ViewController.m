//
//  ViewController.m
//  LROCDemo
//
//  Created by dalizi on 2018/12/24.
//  Copyright © 2018年 dalizi. All rights reserved.
//

#import "ViewController.h"
#import "LRMessageForward.h"
#import "LRAOPTest.h"
#import "LRGetAllvar.h"
#import "LREncodeModel.h"
#import "NSObject+UnrecognizeSelectorProtect.h"
#import "LRDropDownMenu.h"
#import "LRDropDownMacro.h"

static NSString *const kLREncodeDataArrayKey = @"kLREncodeDataArrayKey";

@interface ViewController ()
<LRDropDownMenuDelegate,
LRDropDownMenuDataSource>

@property (nonatomic, weak)   LRDropDownMenu  *menu;
@property (nonatomic, strong) NSArray         *array;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
    [self test2];
    [self test3];
    [self test4];
    [self test5];
    [self test6];
}

- (void)test1 {
    /*
     LRMessageForward *forward = [[LRMessageForward alloc] init:@"lr"];
     [forward eat];
     [forward sleep];
     [forward performSelector:@selector(developCoding)];
     [forward performSelector:@selector(developDebug)];
     */
}

- (void)test2 {
    /*
     NSDictionary *dict = @{
     @"name":@"LR",
     @"age":@"18",
     @"list":@[@"我",@"是",@"小",@"仙",@"女"]
     };
     LRAOPTest *model = [LRAOPTest modelWithDict:dict];
     NSLog(@"name:%@",model.name);
     NSLog(@"age:%@",model.age);
     if ([model.list isKindOfClass:[NSArray class]]) {
     [model.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     NSLog(@"obj:%@",obj);
     }];
     }
     */
}

- (void)test3 {
    /*
     LRGetAllvar *model = [LRGetAllvar new];
     [model getAllIvar];
     [model getAllMethod];
     [model invitePrivateProperty];
     */
}

- (void)test4 {
    /*
     NSString *arrayKey = [NSString stringWithFormat:@"%@_%@",kLREncodeDataArrayKey,@"1.0"];
     NSData   *data             = [[NSUserDefaults standardUserDefaults] objectForKey:arrayKey];
     NSMutableArray *storeArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     if (storeArray.count > 0) {
     [self showTest4Result:storeArray];
     }
     
     NSMutableArray *array = [NSMutableArray array];
     LREncodeModel *model  = ({
     LREncodeModel *model  = [LREncodeModel new];
     model.storeName       = @"小仙女";
     model.storeAge        = 18;
     model;
     });
     [array addObject:model];
     
     model  = ({
     LREncodeModel *model  = [LREncodeModel new];
     model.storeName       = @"哪吒";
     model.storeAge        = 3;
     model;
     });
     [array addObject:model];
     
     model  = ({
     LREncodeModel *model  = [LREncodeModel new];
     model.storeName       = @"太上老君";
     model.storeAge        = 999;
     model;
     });
     [array addObject:model];
     
     [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:array.copy] forKey:arrayKey];
     [[NSUserDefaults standardUserDefaults] synchronize];
     */
}

- (void)showTest4Result:(NSMutableArray *)storeArray {
    /*
     __block NSString *str = @"";
     [storeArray enumerateObjectsUsingBlock:^(LREncodeModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     NSLog(@"storeAge---%ld---storeName:%@",(long)obj.storeAge,obj.storeName);
     str = [str stringByAppendingString:[NSString stringWithFormat:@"storeAge:%ld--storeName:%@\n",(long)obj.storeAge,obj.storeName]];
     }];
     
     UILabel *label = ({
     UILabel *label      = [UILabel new];
     label.frame         = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20 * 2, [UIScreen mainScreen].bounds.size.height - 20 * 2);
     label.text          = str;
     label.numberOfLines = 0;
     label;
     });
     [self.view addSubview:label];
     */
}

- (void)test5 {
    /*
     UIButton *button1 = ({
     UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 200, 40)];
     [button setTitle:@"开启performSelector防护" forState:UIControlStateNormal];
     [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [button addTarget:self action:@selector(protect) forControlEvents:UIControlEventTouchUpInside];
     [button setBackgroundColor:[UIColor orangeColor]];
     button;
     });
     [self.view addSubview:button1];
     
     UIButton *button2 = ({
     UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button1.frame)+10, 200, 40)];
     [button setTitle:@"测试performSelector是否保护成功" forState:UIControlStateNormal];
     [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [button addTarget:self action:@selector(testProtect) forControlEvents:UIControlEventTouchUpInside];
     [button setBackgroundColor:[UIColor orangeColor]];
     button;
     });
     [self.view addSubview:button2];
     */
}
/*
 - (void)protect {
 [NSObject setUnrecognizeSelectorProtectEnable:YES];
 }
 
 - (void)testProtect {
 [self performSelector:sel_registerName("testNoProtectCrash")];
 }
 */

- (void)test6 {
    self.array = @[
                       @{
                           @"list" : @[
                                   @{
                                       @"list" : @[
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"豆浆",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"油条",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"包子",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"胡辣汤",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"煎饼",
                                                   }
                                               ],
                                       @"title" : @"早餐",
                                       },
                                   @{
                                       @"list" : @[
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"煲仔饭",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"牛肉拉面",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"炒菜",
                                                   },
                                               ],
                                       @"title" : @"午餐",
                                       },
                                   @{
                                       @"list" : @[
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"西餐",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"中餐",
                                                   },
                                               @{
                                                   @"condition" : @"",
                                                   @"title" : @"小团圆",
                                                   },
                                               ],
                                       @"title" : @"晚餐",
                                       }
                                   ],
                           @"title" : @"一日三餐",
                           },
                       @{
                           @"list" : @[
                                   @{
                                       @"list" :@[],
                                       @"title" : @"莫干山",
                                       },
                                   @{
                                       @"list" : @[],
                                       @"title" : @"黄山",
                                       },
                                   @{
                                       @"list" : @[],
                                       @"title" : @"泰山",
                                       },
                                   @{
                                       @"list" : @[],
                                       @"title" : @"西湖",
                                       }
                                   ],
                           @"title" : @"游山玩水",
                           },
                       @{
                           @"list" : @[
                                   @{
                                       @"list" : @[],
                                       @"title" : @"默认排序",
                                       },
                                   @{
                                       @"list" : @[],
                                       @"title" : @"离我最近",
                                       },
                                   @{
                                       @"list" : @[],
                                       @"title" : @"好评优先",
                                       },
                                   @{
                                       @"list" : @[],
                                       @"title" : @"人气优先",
                                       },
                                   @{
                                       @"list" : @[],
                                       @"title" : @"最新发布",
                                       }
                                   ],
                           @"title" : @"默认排序",
                           }
                       ];
    LRDropDownMenu *menu = [[LRDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) width:SCREENW height:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    _menu = menu;
    _menu.collapseDropDownMenuBlock = ^(LRDropDownIndexPath *indexPath) {
        if (indexPath.childRow >= 0) {
            NSLog(@"收起:点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.childRow);
        } else {
            NSLog(@"收起:点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        }
    };
    
    [menu selectIndexPath:[LRDropDownIndexPath indexPathWithColumn:0 row:0 childRow:0]];
}

- (NSInteger)numberOfColumnsInDownMenu:(LRDropDownMenu *)downMenu {
    return self.array.count;
}

- (NSInteger)downMenu:(LRDropDownMenu *)downMenu numberOfRowsInColumn:(NSInteger)column {
    NSDictionary *data = self.array[column];
    NSArray *list = data[@"list"];
    return list.count;
}

- (NSString *)downMenu:(LRDropDownMenu *)downMenu titleForRowAtIndexPath:(LRDropDownIndexPath *)indexPath {
    NSDictionary *data = self.array[indexPath.column];
    NSArray *list = data[@"list"];
    NSDictionary *listData = list[indexPath.row];
    NSString *title = listData[@"title"];
    return title;
}

- (NSString *)downMenu:(LRDropDownMenu *)downMenu detailTextForChildRowsInRowAtIndexPath:(LRDropDownIndexPath *)indexPath {
    return [@(arc4random()%1000) stringValue];
}

- (NSInteger)downMenu:(LRDropDownMenu *)downMenu numberOfChildRowsInRow:(NSInteger)row column:(NSInteger)column {
    NSDictionary *data = self.array[column];
    NSArray *list = data[@"list"];
    NSDictionary *listData = list[row];
    NSArray *listArray = listData[@"list"];
    return listArray.count;
}

- (NSString *)downMenu:(LRDropDownMenu *)downMenu titleForChildRowsInRowAtIndexPath:(LRDropDownIndexPath *)indexPath {
    NSDictionary *data = self.array[indexPath.column];
    NSArray *list = data[@"list"];
    NSDictionary *listData = list[indexPath.row];
    NSArray *listDataArray = listData[@"list"];
    NSDictionary *listDataArrayData = listDataArray[indexPath.childRow];
    NSString *title = listDataArrayData[@"title"];
    return title;
}

- (NSInteger)downMenu:(LRDropDownMenu *)downMenu reddotCountForRowAtIndexPath:(LRDropDownIndexPath *)indexPath {
    return 0;
}

- (void)downMenu:(LRDropDownMenu *)downMenu didSelectRowAtIndexPath:(LRDropDownIndexPath *)indexPath {
    if (indexPath.childRow >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.childRow);
    } else {
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
