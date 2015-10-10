//
//  ViewController.m
//  SpotlightSearchDemo
//
//  Created by Mr.LuDashi on 15/10/9.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import "ViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self supportSpotlightSearch];
}


- (void)supportSpotlightSearch {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        @try {
            NSArray *temp = @[@"宫崎骏-龙猫", @"宫崎骏-千与千寻", @"宫崎骏-天空之城"];
            
            //创建SearchableItems的数组
            NSMutableArray *searchableItems = [[NSMutableArray alloc] initWithCapacity:temp.count];
            
            for (int i = 0; i < temp.count; i ++) {
                
                //1.创建条目的属性集合
                CSSearchableItemAttributeSet * attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString*) kUTTypeImage];
                
                //2.给属性集合添加属性
                attributeSet.title = temp[i];
                attributeSet.contentDescription = [NSString stringWithFormat:@"宫崎骏与%@", temp[i]];
                attributeSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i+1]]);
                
                //3.属性集合与条目进行关联
                CSSearchableItem *searchableItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:[NSString stringWithFormat:@"%d", i+1] domainIdentifier:@"ZeluLi.SpotlightSearchDemo" attributeSet:attributeSet];
                
                //把该条目进行暂存
                [searchableItems addObject:searchableItem];
            }
            
            //4.吧条目数组与索引进行关联
            [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"%s, %@", __FUNCTION__, [error localizedDescription]);
                }
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"%s, %@", __FUNCTION__, exception);
        }
        @finally {
            
        }
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
