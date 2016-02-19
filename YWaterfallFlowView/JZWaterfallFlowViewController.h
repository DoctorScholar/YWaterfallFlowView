//
//  JZModelWaterfallFlowViewController.h
//  VideoShare
//
//  Created by IOS_Doctor on 13-10-15.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JZWaterfallFlowViewController;
@class JZWaterfallFlowCell;

@protocol XBVSWaterfallFlowViewControllerDelegate <NSObject>

@optional

- (void)waterfallFalow:(JZWaterfallFlowViewController *)waterfallFlow // <在 reloadData (加载时) 有可能不会回调
       willDisplayCell:(JZWaterfallFlowCell *)cell                    //  滚动时一定会回调。
                 index:(NSUInteger)index;

- (void)waterfallFlow:(JZWaterfallFlowViewController *)waterfalFlow didSelectedAtIndex:(NSUInteger)index;

@end


@protocol XBVSWaterfallFlowViewControllerDataSource <NSObject>

@required

- (NSUInteger)numberOfColumnAtWaterfallFlow;
- (NSUInteger)numberInWaterfallFlow;

- (JZWaterfallFlowCell *)waterfallFlow:(JZWaterfallFlowViewController *)waterfallFlow
                       cellForRowAtIndex:(NSUInteger)index;
@optional

- (CGFloat)waterfallFlow:(JZWaterfallFlowViewController *)waterfallFlow aspectRatioForCellAtIndex:(NSUInteger)index;

@end

NS_CLASS_AVAILABLE_IOS(2_0) @interface JZWaterfallFlowViewController : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) NSMutableDictionary *dicEachColumnMaxBottom; // <WaterfallFlow 计算布局 dic.
@property (nonatomic, strong, readonly) NSMutableDictionary *dicCurrentDisplayCells; // <数据提供只读， 不建议直接
@property (nonatomic, strong, readonly) NSMutableDictionary *dicEachCellY;           // <引用改变。
@property (nonatomic, strong, readonly) NSMutableDictionary *dicEachCellLeft;
@property (nonatomic, strong, readonly) NSMutableDictionary *dicEachCellBotom;
@property (nonatomic, strong, readonly) NSMutableDictionary *dicReuseCells; // <cell 内存重用队列。


@property (nonatomic, assign) id <XBVSWaterfallFlowViewControllerDataSource> WDataSource;
@property (nonatomic, assign) id <XBVSWaterfallFlowViewControllerDelegate> WDelegate;

@property (nonatomic, assign) CGFloat horizontalGapCount;// <提供了基本的样式设置
@property (nonatomic, assign) CGFloat verticalGap;// <更多的样式可以通过 Inheritance category or other 扩展。
@property (nonatomic, assign) CGFloat topOffset;// <cell 的样式则通过继承 XBVSWaterfallFlowCell 扩展。

@property (nonatomic, strong) UIView  *waterfallFlowHeaderView;// <在滚动区域顶部和底部插入的视图
@property (nonatomic, strong) UIView  *waterfallFlowFooterView;// <同 UITableViewController 相似


- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)reloadData;

@end

@interface JZWaterfallFlowViewController (math)

- (CGFloat)getCellWith;

@end


@interface JZWaterfallFlowCell : UIButton

@property (nonatomic, copy) NSString *identifier;

- (id)initWithIdentifier:(NSString *)identifier;

- (void)layoutSubviewsW;

@end

/**
 UIView category relevant with frame
 */
@interface UIView (frame)

//sets frame.origin.x = left;
@property (nonatomic) CGFloat left;
//sets frame.origin.y = top;
@property (nonatomic) CGFloat top;
//sets frame.origin.x = right - frame.size.wigth;
@property (nonatomic) CGFloat right;
//sets frame.origin.y = botton - frmae.size.height;
@property (nonatomic) CGFloat bottom;
//sets frame.size.width = width;
@property (nonatomic) CGFloat width;
//sets frame.size.height = height;
@property (nonatomic) CGFloat height;
//sets center.x = centerX;
@property (nonatomic) CGFloat centerX;
//sets center.y = centerY;
@property (nonatomic) CGFloat centerY;
//frame.origin
@property (nonatomic) CGPoint origin;
//frame.size
@property (nonatomic) CGSize size;

- (void)removeAllSubviews;

- (void)addSubviews:(NSArray *)subviews;

@end