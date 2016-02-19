//
//  JZModelWaterfallFlowViewController.m
//  VideoShare
//
//  Created by IOS_Doctor on 13-10-15.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "JZWaterfallFlowViewController.h"

@interface JZWaterfallFlowViewController ()

@property (nonatomic, assign) NSUInteger cellCount;
@property (nonatomic, assign) NSUInteger cloumnNumber;

// addtional.
@property (nonatomic, assign) BOOL isHasHeader;
@property (nonatomic, assign) BOOL isHasFooter;

@property (nonatomic, assign) CGFloat lastWContentOffsetY;

@end

#define cell_tag 999

@implementation JZWaterfallFlowViewController

- (void)setHorizontalGapCount:(CGFloat)horizontalGapCount
{
    _horizontalGapCount = horizontalGapCount;
    [self reloadData];
}

- (void)setVerticalGap:(CGFloat)verticalGap
{
    _verticalGap = verticalGap;
    [self reloadData];
}

- (void)setTopOffset:(CGFloat)topOffset
{
    _topOffset = topOffset;
    [self startEachColumnMaxBottomWithInt:_topOffset];
    [self reloadData];
}

- (void)setWDataSource:(id<XBVSWaterfallFlowViewControllerDataSource>)WDataSource
{
    _WDataSource = WDataSource;
    [self reloadData];
}

- (void)setWDelegate:(id<XBVSWaterfallFlowViewControllerDelegate>)WDelegate
{
    _WDelegate = WDelegate;
    [self reloadData];
}

- (id)init
{
    if (self = [super init]) {
        
        self.delegate = self;
        _horizontalGapCount = 30;
        _cloumnNumber = 3;
        self.topOffset = 10;
        _verticalGap = [self getHorizontaolGap];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

// 每列的起点高
- (void)startEachColumnMaxBottomWithInt:(NSUInteger)start
{
    _dicEachColumnMaxBottom = [NSMutableDictionary new];
    NSUInteger startY = start;
    for (int i = 0; i < _cloumnNumber; i ++)
    {
        _dicEachColumnMaxBottom[[NSString stringWithFormat:@"%d",i]] = @(startY);
    }
}

- (CGFloat)getCellWith
{
    return (self.width - _horizontalGapCount) / _cloumnNumber;
}

- (CGFloat)getCellLeft
{
    CGFloat gap = [self getHorizontaolGap];
    return gap + (gap + [self getCellWith]) * [self getCurrentColumn];
}

- (CGFloat)getHorizontaolGap
{
    return _horizontalGapCount / (_cloumnNumber + 1);
}

- (NSUInteger)getCurrentColumn
{
    return [self getMinBottomOfColumn];
}

- (NSUInteger)getMinBottomOfColumn
{
    CGFloat MinOfsset =
    [_dicEachColumnMaxBottom[@"0"] floatValue];
    NSUInteger MinColumn = 0;
    for (NSUInteger i = 1; i < _cloumnNumber; i ++) {
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        if ([_dicEachColumnMaxBottom[key] floatValue] < MinOfsset)
        {
            MinColumn = i;
            MinOfsset = [_dicEachColumnMaxBottom[key] floatValue];
        }
    }
    return MinColumn;
}

- (CGFloat)getMaxBottom
{
    CGFloat MaxOfsset =
    [_dicEachColumnMaxBottom[@"0"] floatValue];
    for (NSUInteger i = 1; i < _cloumnNumber; i ++) {
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)i];
        if ([_dicEachColumnMaxBottom[key] floatValue] > MaxOfsset)
        {
            MaxOfsset = [_dicEachColumnMaxBottom[key] floatValue];
        }
    }
    if (_isHasFooter)
    {
        self.waterfallFlowFooterView.top = MaxOfsset;       // <加上footerView的高
        MaxOfsset += self.waterfallFlowFooterView.height;
    }
    if (MaxOfsset < self.height)
    {
        MaxOfsset = self.height + 0.5;                      // <控制最小的contentSize.height
    }
    return MaxOfsset;
}

- (void)reloadData
{
    if ([self.WDataSource respondsToSelector:@selector(numberOfColumnAtWaterfallFlow)]) {
        _cloumnNumber = [self.WDataSource numberOfColumnAtWaterfallFlow];
    }
    if ([self.WDataSource respondsToSelector:@selector(numberInWaterfallFlow)]) {
        _cellCount = [self.WDataSource numberInWaterfallFlow];
        [self recoredLastContentOffsetYBeforeReloadData];
        [self reloadDic];
        [self run];
        [self recoverLastContentOffsetAfterReloadData];
    }
}

- (void)recoredLastContentOffsetYBeforeReloadData
{
    if (self.contentOffset.y > 0)
    {
        self.lastWContentOffsetY = self.contentOffset.y;
    }
    else if (self.contentOffset.y + self.height > self.contentSize.height)
    {
        self.lastWContentOffsetY = self.contentSize.height;
    }
    else{
        self.lastWContentOffsetY = 0;
    }
}

- (void)recoverLastContentOffsetAfterReloadData
{
    [self setContentOffset:CGPointMake(0, self.lastWContentOffsetY)];
    if (self.contentOffset.y > self.contentSize.height) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height - self.height)];
    }
}

- (void)reloadDic
{
    [self deleteAllDic];
    [self createAllDic];
}

- (void)createAllDic
{
    if (_isHasHeader)
    {
        [self startEachColumnMaxBottomWithInt:_waterfallFlowHeaderView.height];
    }
    else{
        [self startEachColumnMaxBottomWithInt:_topOffset];
    }
    _dicCurrentDisplayCells = [NSMutableDictionary new];
    _dicEachCellY     = [NSMutableDictionary new];
    _dicEachCellLeft  = [NSMutableDictionary new];
    _dicEachCellBotom = [NSMutableDictionary new];
    _dicReuseCells    = [NSMutableDictionary new];
}

- (void)deleteAllDic
{
    [self _removeAllCell];
    
    [_dicCurrentDisplayCells removeAllObjects];
    [_dicEachCellBotom removeAllObjects];
    [_dicEachCellLeft removeAllObjects];
    [_dicEachCellY removeAllObjects];
    [_dicReuseCells removeAllObjects];
}

- (void)_removeAllCell
{
    for (int i = 0; i <[_dicCurrentDisplayCells count]; i ++) {
        NSString * key = [NSString stringWithFormat:@"%d",i];
        JZWaterfallFlowCell *cell = _dicCurrentDisplayCells[key];
        [cell removeFromSuperview];
    }
    
    /** remove all cells */
    UIView *views = [[UIView alloc] initWithFrame:CGRectZero];
    for (id subview in self.subviews) {
        if (![subview isKindOfClass:[JZWaterfallFlowCell class]]) {
            [views addSubview:subview];
        }
    }
    [self removeAllSubviews];
    [self addSubviews:views.subviews];
}

- (void)run
{
    for (int i = 0; i < self.cellCount; i ++)
    {
        NSString * key = [NSString stringWithFormat:@"%d",i];
        
        NSString *cellY = _dicEachCellY[key];
        NSString *cellBottom = _dicEachCellBotom[key];
        if ((cellBottom && [cellBottom floatValue] < self.contentOffset.y) || (cellY && [cellY floatValue] > self.contentOffset.y + self.height))
        {
            JZWaterfallFlowCell *cell = _dicCurrentDisplayCells[key];
            [cell removeFromSuperview];
            [_dicCurrentDisplayCells removeObjectForKey:key];
            continue;
        }
        if (_dicCurrentDisplayCells[key])
        {
            continue;
        }
        JZWaterfallFlowCell *cell;
        if (self.WDataSource)
        {
            if ([self.WDataSource respondsToSelector:@selector(waterfallFlow:cellForRowAtIndex:)])
            {
                cell = [self.WDataSource waterfallFlow:self cellForRowAtIndex:i];
                // set cell's frame.
                NSUInteger currentColumn            = [self getCurrentColumn];
                NSString *curentColumnKey           = [NSString stringWithFormat:@"%lu", (unsigned long)currentColumn];
                CGFloat currentColumnLastMaxOffsetY = [_dicEachColumnMaxBottom[curentColumnKey] floatValue];
                
                if (_dicEachCellY[key]) {
                    cell.top  = [_dicEachCellY[key] floatValue];// <scroll join.
                    cell.left = [_dicEachCellLeft[key] floatValue];
                }
                else{
                    cell.top  = currentColumnLastMaxOffsetY;// <reload join.
                    cell.left = [self getCellLeft];
                }
                cell.width = [self getCellWith];
                
                CGFloat WHeight = [self getCellWith];   // < default value same with.
                if ([self.WDataSource respondsToSelector:@selector(waterfallFlow:aspectRatioForCellAtIndex:)])
                {
                    CGFloat aspectRetio = [self.WDataSource waterfallFlow:self aspectRatioForCellAtIndex:i];
                    WHeight = cell.width * aspectRetio;
                }
                cell.height = WHeight;
                
                // set gesture recognizer.
                [self cellGestureRecognizer:cell index:i];
                
                if (cellBottom)                        // <in here is specific implement after
                {                                      //  reloadData of frist run no jion.
                    [self cellAddtional:cell index:i]; // < need in here.
                }
                
                // display cell.
                [self addSubview:cell];
                
                // cell layoutSubviews.
                [cell layoutSubviewsW];
                
                // <in here need specific implement _cloumnNumber is equel 1 , _dicEachColumnMaxBottom has only
                //  addting operations. deprecated subtract operation. reason is noknown. analyse : _cloumnNumber
                //  is greater than 1 , _dicEachColumnMaxBottom so need has only addting operations and also
                //  deprecated subtract operations. but when _clumnNumber greater than 1 without appear issou. if
                //  has issou after today , the solution : in here has only addting operation. be careful : any
                //  time.  <the message from qingshan yan.>
                if ((_cloumnNumber == 1
                     && [_dicEachColumnMaxBottom[curentColumnKey] floatValue] < cell.top + WHeight + _verticalGap)
                    || _cloumnNumber != 1)
                {
                    // set refresh max offset y  and  current index.
                    _dicEachColumnMaxBottom[curentColumnKey] = @(cell.top + WHeight + _verticalGap);
                }
                
                _dicEachCellY[key]     = @(cell.top);    // <each cell bottom and cell y and cell left
                _dicEachCellLeft[key]  = @(cell.left);   // add to each cell bottom and cell y and cell left of
                _dicEachCellBotom[key] = @(cell.bottom); // dictionary.
                
                // add cell to current cells dictionary.
                _dicCurrentDisplayCells[key] = cell;
                
                self.contentSize = CGSizeMake(self.width, [self getMaxBottom]);
            }
        }
        if ((cell.bottom < self.contentOffset.y) || (cell.top > self.contentOffset.y + self.height))
        {
            [self addCellToReuseQueue:cell];
        }
        if (i == self.cellCount - 1)
        {
            [_dicReuseCells removeAllObjects];
        }
    }
    if (_cellCount == 0)
    {
        [self getMaxBottom];
    }
}

// cell的重用
- (JZWaterfallFlowCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    if (identifier == nil || identifier.length == 0)
    {
        return nil;
    }
    NSMutableArray *arrIndentifier = [_dicReuseCells objectForKey:identifier];
    
    if (arrIndentifier && [arrIndentifier isKindOfClass:[NSArray class]] && arrIndentifier.count > 0)
    {
        JZWaterfallFlowCell *cell = [arrIndentifier lastObject];
        [arrIndentifier removeLastObject];
        return cell;
    }
    return nil;
}

// 将要移除屏幕的cell添加到可重用列表中
- (void)addCellToReuseQueue:(JZWaterfallFlowCell *)cell
{
    if (cell.identifier.length == 0)
    {
        return ;
    }
    if (_dicReuseCells == nil) {
        _dicReuseCells = [NSMutableDictionary dictionaryWithCapacity:3];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:cell];
        [_dicReuseCells setObject:arr forKey:cell.identifier];
    }
    else
    {
        NSMutableArray *arr = [_dicReuseCells objectForKey:cell.identifier];
        if (arr == nil) {
            arr = [NSMutableArray arrayWithObject:cell];
            [_dicReuseCells setObject:arr forKey:cell.identifier];
        }
        else
        {
            [arr addObject:cell];
        }
    }
}

#pragma mark - Scroll Vc Delegate Methods.

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([self.WDelegate  conformsToProtocol:@protocol(UIScrollViewDelegate)]
       && [self.WDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [(id<UIScrollViewDelegate>) self.WDelegate  scrollViewDidEndDecelerating:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self run];
    
    if([self.WDelegate  conformsToProtocol:@protocol(UIScrollViewDelegate)]
       && [self.WDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [(id<UIScrollViewDelegate>) self.WDelegate  scrollViewDidScroll:self];
    }
}

#pragma mark - Cell Addtional.

- (void)cellAddtional:(JZWaterfallFlowCell *)cell index:(NSUInteger)idx
{
    if (self.WDelegate)
    {
        if ([self.WDelegate respondsToSelector:@selector(waterfallFalow:willDisplayCell:index:)]) {
            [self.WDelegate waterfallFalow:self willDisplayCell:cell index:idx];
        }
    }
}

- (void)cellGestureRecognizer:(JZWaterfallFlowCell *)cell index:(NSUInteger)idx
{
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTapped:)];
    cell.tag = cell_tag + idx;
    [cell addGestureRecognizer:tap];
}

- (void)cellTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.WDelegate respondsToSelector:@selector(waterfallFlow:didSelectedAtIndex:)])
    {
        [self.WDelegate waterfallFlow:self didSelectedAtIndex:gestureRecognizer.view.tag - cell_tag];
    }
}

#pragma mark - WaterfallFlow Addtional Methods.

- (void)setWaterfallFlowHeaderView:(UIView *)waterfallFlowHeaderView
{
    [_waterfallFlowHeaderView removeFromSuperview];
    if (waterfallFlowHeaderView)
    {
        _waterfallFlowHeaderView = waterfallFlowHeaderView;
        [self addSubview:_waterfallFlowHeaderView];
        _isHasHeader = YES;
        _waterfallFlowHeaderView.top = _topOffset;
    }
    else{
        _waterfallFlowHeaderView = nil;
        _isHasHeader = NO;
        [self startEachColumnMaxBottomWithInt:_topOffset];
    }
}

- (void)setWaterfallFlowFooterView:(UIView *)waterfallFlowFooterView
{
    [_waterfallFlowFooterView removeFromSuperview];
    if (waterfallFlowFooterView)
    {
        _waterfallFlowFooterView = waterfallFlowFooterView;
        [self addSubview:_waterfallFlowFooterView];
        _isHasFooter = YES;
    }
    else{
        _waterfallFlowFooterView = nil;
        _isHasFooter = NO;
    }
}



@end


@interface JZWaterfallFlowCell ()

@end

@implementation JZWaterfallFlowCell

- (void)dealloc
{

}

- (id)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        self.identifier = identifier;
    }
    return self;
}

- (void)layoutSubviewsW
{
    // should subviews implement.
}

@end

@implementation UIView (frame)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)removeAllSubviews
{
    while (self.subviews.count > 0) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)addSubviews:(NSArray *)subviews
{
    for (UIView *subview in subviews) {
        [self addSubview:subview];
    }
}


@end
