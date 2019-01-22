//
//  LRDropDownMenu.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/16.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRDropDownMenu.h"
#import "LRDropDownMacro.h"
#import "LRDropDownIndexPath.h"
#import "LRTableView.h"
#import "LRTableViewDataSource.h"
#import "LRTableSection.h"
#import "LRDropMenuCell.h"

typedef struct {
    unsigned int numberOfRowsInColumn :1;
    unsigned int numberOfChildRowsInRow :1;
    unsigned int titleForRowAtIndexPath :1;
    unsigned int titleForChildRowsInRowAtIndexPath :1;
    unsigned int reddotCountForRowAtIndexPath :1;
    unsigned int detailTextForChildRowsInRowAtIndexPath :1;
    unsigned int accessoryViewForRowAtIndexPath :1;
}DataSourceFlags;

static inline DataSourceFlags DataSourceFlagsMake(unsigned int numberOfRowsInColumn, unsigned int numberOfChildRowsInRow, unsigned int titleForRowAtIndexPath, unsigned int titleForChildRowsInRowAtIndexPath, unsigned int reddotCountForRowAtIndexPath, unsigned int detailTextForChildRowsInRowAtIndexPath, unsigned int accessoryViewForRowAtIndexPath) {
    DataSourceFlags flag;
    flag.numberOfRowsInColumn                   = numberOfRowsInColumn;
    flag.numberOfChildRowsInRow                 = numberOfChildRowsInRow;
    flag.titleForRowAtIndexPath                 = titleForRowAtIndexPath;
    flag.titleForChildRowsInRowAtIndexPath      = titleForChildRowsInRowAtIndexPath;
    flag.reddotCountForRowAtIndexPath           = reddotCountForRowAtIndexPath;
    flag.detailTextForChildRowsInRowAtIndexPath = detailTextForChildRowsInRowAtIndexPath;
    flag.accessoryViewForRowAtIndexPath         = accessoryViewForRowAtIndexPath;
    return flag;
}

@interface LRDropDownMenu ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic,assign) DataSourceFlags dataSourceflags;

@property (nonatomic,strong) LRTableView           *leftTableView;
@property (nonatomic,strong) LRTableView           *rightTableView;
@property (nonatomic,strong) UIView                *backgroundView;

@property (nonatomic,copy)   NSArray             *titles;
@property (nonatomic,copy)   NSArray             *indicators;
@property (nonatomic,copy)   NSArray             *backLayers;

@property (nonatomic,retain) LRDropDownIndexPath *selectIndexPath; //当前选中的index
@property (nonatomic,assign) NSInteger           selectMenuIndex;//当前选中列

@property (nonatomic,assign) BOOL                show; //下拉框是否收起
@property (nonatomic,assign) BOOL                titleShowCenter;

@property (nonatomic,assign) CGPoint             origin;
@property (nonatomic,assign) NSInteger           menuNum;
@property (nonatomic,assign) CGFloat             tableViewHeight;

@end

@implementation LRDropDownMenu

#pragma mark - init

- (instancetype)initWithOrigin:(CGPoint)origin
                         width:(CGFloat)width
                        height:(CGFloat)height {
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, width, height)];
    if (self) {
        _origin                = origin;
        _selectMenuIndex       = -1;
        self.show              = NO;
        _fontSize              = 15;
        _separatorColor        = [UIColor lrLineColor];
        _titleColor            = [UIColor lrBlackColor];
        _titleSelectColor      = [UIColor lrOrangeColor];
        _detailTitleColor      = [UIColor lrMediumGrayColor];
        _detailTitleFont       = [UIFont  systemFontOfSize:13];
        _tableViewHeight       = 300;
        _dropDownListViewWidth = SCREENW;
        _titleShowCenter       = NO;

        CGSize dropDownListViewSize = CGSizeMake(_dropDownListViewWidth, SCREENH);
        _leftTableView         = ({
            LRTableView *view  = [[LRTableView alloc] initWithFrame:CGRectMake(origin.x, CGRectGetMaxY(self.frame), dropDownListViewSize.width, dropDownListViewSize.height) style:UITableViewStylePlain];
            view.rowHeight     = 44.0;
            view.delegate      = self;
            view.dataSource    = self;
            view.estimatedRowHeight = 0;
            view.separatorColor= [UIColor lrLineColor];
            view.separatorInset= UIEdgeInsetsZero;
            [view registerClass:[LRDropMenuCell class] forCellReuseIdentifier:[LRDropMenuCell reuseIdentifier]];
            view;
        });
        _rightTableView         = ({
            LRTableView *view   = [[LRTableView alloc] initWithFrame:CGRectMake(origin.x+_dropDownListViewWidth/2, CGRectGetMaxY(self.frame), dropDownListViewSize.width/2, 0) style:UITableViewStylePlain];
            view.rowHeight      = 44.0;
            view.delegate       = self;
            view.dataSource     = self;
            view.estimatedRowHeight = 0;
            view.separatorColor = [UIColor lrLineColor];
            view.separatorInset = UIEdgeInsetsZero;
            [view registerClass:[LRDropMenuCell class] forCellReuseIdentifier:[LRDropMenuCell reuseIdentifier]];
            view;
        });
        
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mentTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        _backgroundView          = ({
            UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y+height, dropDownListViewSize.width, dropDownListViewSize.height)];
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            view.opaque          = NO;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
            [view addGestureRecognizer:gesture];
            view;
        });
    }
    return self;
}

#pragma mark -  UIGestureRecognizer tap

- (void)mentTapped:(UITapGestureRecognizer *)gesture {
    if (_dataSource == nil) {
        return;
    }
    CGPoint touchPoint = [gesture locationInView:self];
    NSInteger tapIndex = touchPoint.x / (CGRectGetWidth(self.frame) / _menuNum);
    
    for (int i = 0; i < _menuNum; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
        }
    }
    
    if (tapIndex == _selectMenuIndex && _show) {
        [self animateIdicator:_indicators[_selectMenuIndex] backGround:_backgroundView tableView:_leftTableView title:_titles[_selectMenuIndex] forward:NO complete:^{
            self.selectMenuIndex = tapIndex;
            self.show            = NO;
        }];
    } else {
        _selectMenuIndex = tapIndex;
        [_leftTableView reloadData];
        if (_dataSource && _dataSourceflags.numberOfChildRowsInRow) {
            [_rightTableView reloadData];
        }
        [self animateIdicator:_indicators[_selectMenuIndex] backGround:_backgroundView tableView:_leftTableView title:_titles[_selectMenuIndex] forward:YES complete:^{
            self.show            = YES;
        }];
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)gesture {
    [self animateIdicator:_indicators[_selectMenuIndex] backGround:_backgroundView tableView:_leftTableView title:_titles[_selectMenuIndex] forward:NO complete:^{
        self.show = NO;
    }];
}

#pragma mark - public method

- (void)hiddenMenu {
    if (_show) {
        [self backgroundTapped:nil];
    }
}

- (void)selectIndexPath:(LRDropDownIndexPath *)indexPath
        triggerDelegate:(BOOL)trigger {
    if (!_dataSource || !_delegate) {
        return;
    }
    if (![_delegate respondsToSelector:@selector(downMenu:didSelectRowAtIndexPath:)]) {
        return;
    }
    if ([_dataSource numberOfColumnsInDownMenu:self] <= indexPath.column) {
        return;
    }
    if ([_dataSource downMenu:self numberOfRowsInColumn:indexPath.column] <= indexPath.row) {
        return;
    }
    CATextLayer *title = (CATextLayer *)_titles[indexPath.column];
    if (indexPath.childRow < 0) {
        BOOL condition1 = _dataSourceflags.numberOfChildRowsInRow;
        BOOL condition2 = [_dataSource downMenu:self numberOfChildRowsInRow:indexPath.row column:indexPath.column] > 0;
        if (condition1 && condition2) {
            title.string = [_dataSource downMenu:self titleForChildRowsInRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:indexPath.column row:indexPath.row childRow:0]];
            if (trigger) {
                [_delegate downMenu:self didSelectRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:indexPath.column row:indexPath.row childRow:indexPath.childRow]];
            }
        } else {
            title.string = [_dataSource downMenu:self titleForChildRowsInRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:indexPath.column row:indexPath.row]];
            if (trigger) {
                [_delegate downMenu:self didSelectRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:indexPath.column row:indexPath.row]];
            }
        }
    } else if (_dataSourceflags.numberOfChildRowsInRow &&
               [_dataSource downMenu:self numberOfChildRowsInRow:indexPath.row column:indexPath.column] > 0) {
        title.string = [_dataSource downMenu:self titleForChildRowsInRowAtIndexPath:indexPath];
        if (trigger) {
            [_delegate downMenu:self didSelectRowAtIndexPath:indexPath];
        }
    }
    //
    if (_currentSelectRowArr.count > indexPath.column) {
        _currentSelectRowArr[indexPath.column] = @(indexPath.row);
    }
    id indicator = _indicators[indexPath.column];
    [self configIndicator:indicator title:title];
    self.selectIndexPath = indexPath;
}

- (void)selectIndexPath:(LRDropDownIndexPath *)indexPath {
    [self selectIndexPath:indexPath triggerDelegate:YES];
}

#pragma mark - config

- (void)configIndicator:(id)indicator title:(CATextLayer *)title {
    CGSize size   = [NSString calculateSize:title.string font:[UIFont systemFontOfSize:self.fontSize] maxW:SCREENW - 20 * 2];
    CGFloat sizeW = 0;
    if (size.width < (CGRectGetWidth(self.frame) / _menuNum) - 25 - kLRMargin) {
        sizeW = size.width;
    } else {
        sizeW = (CGRectGetWidth(self.frame) / _menuNum) - 25 - kLRMargin;
    }
    title.bounds = CGRectMake(0, 0, sizeW, size.height);
    CGRect indicatorFrame          = [(CAShapeLayer *)indicator frame];
    indicatorFrame.origin.x        = CGRectGetMaxX(title.frame) + kLRMargin;
    ((UIImageView *)indicator).frame  = indicatorFrame;
}

- (CALayer *)configBackLayer:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds   = CGRectMake(0, 0, CGRectGetWidth(self.frame) / _menuNum, CGRectGetHeight(self.frame) - 1);
    layer.backgroundColor = [UIColor lrBackGroundColor].CGColor;
    return layer;
}

- (CATextLayer *)configTextLayer:(NSString *)titleString position:(CGPoint)position {
    CGSize      size       = [NSString calculateSize:titleString font:[UIFont systemFontOfSize:self.fontSize] maxW:SCREENW - 20 * 2];
    CATextLayer *textLayer = [CATextLayer new];
    CGFloat     sizeW      = 0;
    if (size.width < (CGRectGetWidth(self.frame) / _menuNum - 25)) {
        sizeW = size.width;
    } else {
        sizeW = CGRectGetWidth(self.frame) / _menuNum - 25;
    }
    textLayer.bounds         = CGRectMake(0, 0, sizeW, size.height);
    textLayer.string         = titleString;
    textLayer.fontSize       = _fontSize;
    textLayer.alignmentMode  = kCAAlignmentCenter;
    textLayer.truncationMode = kCATruncationEnd;
    textLayer.foregroundColor= _titleColor.CGColor;
    textLayer.contentsScale  = [UIScreen mainScreen].scale;
    textLayer.position       = position;
    return textLayer;
}

- (CAShapeLayer *)configSeparatorLine:(CGPoint)position {
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGFloat      height = CGRectGetHeight(self.frame) - _separatorOffset * 2;
    UIBezierPath *path  = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160, 0)];
    [path addLineToPoint:CGPointMake(160, height)];
    layer.path          = path.CGPath;
    layer.lineWidth     = 1;
    layer.strokeColor   = _separatorColor.CGColor;
    CGPathRef bound     = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds        = CGPathGetBoundingBox(bound);
    layer.position      = position;
    CGPathRelease(bound);
    return layer;
}

- (BOOL)configMenuWithSelectRow:(NSInteger)row {
    _currentSelectRowArr[_selectMenuIndex] = @(row);
    CATextLayer *title = (CATextLayer *)_titles[_selectMenuIndex];
    if (_dataSourceflags.numberOfChildRowsInRow &&
        [_dataSource downMenu:self numberOfChildRowsInRow:row column:_selectMenuIndex] > 0) {
        title.string = [_dataSource downMenu:self titleForRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:row]];
        [self animateTitle:title show:YES complete:^{
            [_rightTableView reloadData];
        }];
        return NO;
    } else {
        title.string = [_dataSource downMenu:self titleForRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:row]];
        [self animateIdicator:_indicators[_selectMenuIndex] backGround:_backgroundView tableView:_leftTableView title:title forward:NO complete:^{
            self.show = NO;
        }];
        return YES;
    }
}

- (void)configMenuWithSelectChildRow:(NSInteger)childRow {
    CATextLayer *title = (CATextLayer *)_titles[_selectMenuIndex];
    NSInteger currentSelectMenuRow = [_currentSelectRowArr[_selectMenuIndex] integerValue];
    title.string = [_dataSource downMenu:self titleForChildRowsInRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:currentSelectMenuRow childRow:childRow]];
    [self animateIdicator:_indicators[_selectMenuIndex] backGround:_backgroundView tableView:_leftTableView title:_titles[_selectMenuIndex] forward:NO complete:^{
        self.show = NO;
    }];
}
#pragma mark - animate

- (void)animateIndicator:(UIImageView *)indicator forward:(BOOL)forward complete:(void(^)(void))complete {
    if (forward) {
        indicator.image     = [UIImage imageNamed:@"comm_page_icon_jt_s"];
    } else {
        indicator.image     = [UIImage imageNamed:@"comm_page_icon_jt_x"];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)(void))complete {
    CGSize  size  = [NSString calculateSize:title.string font:[UIFont systemFontOfSize:self.fontSize] maxW:SCREENW - 20*2];
    CGFloat sizeW = 0;
    if (size.width < (CGRectGetWidth(self.frame) / _menuNum - 25)) {
        sizeW = size.width;
    } else {
        sizeW = (CGRectGetWidth(self.frame) / _menuNum - 25);
    }
    title.bounds = CGRectMake(0, 0, sizeW, size.height);
    if (!show) {
        title.foregroundColor = _titleColor.CGColor;
    } else {
        title.foregroundColor = _titleSelectColor.CGColor;
    }
    complete();
}

- (void)animateBackgroundView:(UIView *)view show:(BOOL)show complete:(void(^)(void))complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)(void))complete {
    BOOL haveChildRow = NO;
    if (_dataSource) {
        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        for (NSInteger i = 0; i < num; i++) {
            if (_dataSourceflags.numberOfChildRowsInRow &&
                [_dataSource downMenu:self numberOfChildRowsInRow:i column:_selectMenuIndex] > 0) {
                haveChildRow = YES;
                break;
            }
        }
    }
    
    if (show) {
        if (haveChildRow) {
            _leftTableView.frame  = CGRectMake(self.origin.x, CGRectGetMaxY(self.frame), _dropDownListViewWidth / 2, 0);
            _rightTableView.frame = CGRectMake(CGRectGetMaxX(_leftTableView.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(_leftTableView.frame), CGRectGetHeight(_leftTableView.frame));
            _titleShowCenter      = NO;
            [self.superview addSubview:_leftTableView];
            [self.superview addSubview:_rightTableView];
        } else {
            _leftTableView.frame  = CGRectMake(self.origin.x, CGRectGetMaxY(self.frame), _dropDownListViewWidth, 0);
            _titleShowCenter      = YES;
            [self.superview addSubview:_leftTableView];
        }
        NSInteger num = [_leftTableView numberOfRowsInSection:0];
        CGFloat   tableViewheight = num * 44.0 > _tableViewHeight ? _tableViewHeight: num * 44.0;
        [UIView animateWithDuration:0.2 animations:^{
            _leftTableView.height  = tableViewheight;
            if (haveChildRow) {
                _rightTableView.height = tableViewheight;
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if (haveChildRow) {
                _leftTableView.frame  = CGRectMake(self.origin.x, CGRectGetMaxY(self.frame), _dropDownListViewWidth / 2, 0);
                _rightTableView.frame = CGRectMake(CGRectGetMaxX(_leftTableView.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(_leftTableView.frame), CGRectGetHeight(_leftTableView.frame));
                _titleShowCenter      = NO;
            } else {
                _leftTableView.frame  = CGRectMake(self.origin.x, CGRectGetMaxY(self.frame), _dropDownListViewWidth, 0);
                _titleShowCenter      = YES;
            }
        } completion:^(BOOL finished) {
            if (_rightTableView.superview) {
                [_rightTableView removeFromSuperview];
            }
            [_leftTableView removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateIdicator:(UIImageView *)indicator backGround:(UIView *)background tableView:(LRTableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complete:(void(^)(void))complete {
    [self configIndicator:indicator title:title];
    [self animateIndicator:indicator forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackgroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                    
                }];
            }];
        }];
    }];
    complete();
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor lrBackGroundColor];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView: (UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor lrBackGroundColor];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_leftTableView == tableView) {
        _selectIndexPath = [LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:indexPath.row];
        BOOL haveChildRow = [self configMenuWithSelectRow:indexPath.row];
        if (haveChildRow && _delegate && [_delegate respondsToSelector:@selector(downMenu:didSelectRowAtIndexPath:)]) {
            [self.delegate downMenu:self didSelectRowAtIndexPath:self.selectIndexPath];
        }
        [self.leftTableView reloadData];
    } else if (_rightTableView == tableView)  {
        NSInteger currentSelectMenuRow = [_currentSelectRowArr[_selectMenuIndex] integerValue];
        _selectIndexPath = [LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:currentSelectMenuRow childRow:indexPath.row];
        [self configMenuWithSelectChildRow:indexPath.item];
        if (self.delegate && [_delegate respondsToSelector:@selector(downMenu:didSelectRowAtIndexPath:)]) {
            [self.delegate downMenu:self didSelectRowAtIndexPath:self.selectIndexPath];
        }
        [self.rightTableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_leftTableView == tableView) {
        if (_dataSourceflags.numberOfRowsInColumn) {
            return [_dataSource downMenu:self numberOfRowsInColumn:_selectMenuIndex];
        } else {
            return 0;
        }
    } else if (_rightTableView == tableView) {
        if (_dataSourceflags.numberOfChildRowsInRow) {
            NSInteger currentSelectMenuRow = [_currentSelectRowArr[_selectMenuIndex] integerValue];
            return [_dataSource downMenu:self numberOfChildRowsInRow:currentSelectMenuRow column:_selectMenuIndex];
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LRDropMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:[LRDropMenuCell reuseIdentifier] forIndexPath:indexPath];
    cell.fontSize = _fontSize;
    if (_dataSourceflags.detailTextForChildRowsInRowAtIndexPath) {
        cell.detailTextColor = _detailTitleColor;
        cell.detailTextFont  = _detailTitleFont;
    }
    if (_leftTableView == tableView) {
        cell.titleShowCenter = _titleShowCenter;
        if (_dataSourceflags.titleForRowAtIndexPath) {
            cell.title = [_dataSource downMenu:self titleForRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:indexPath.row]];
        } else {
            cell.title = @"";
        }
        NSInteger currentSelectMenuRow = [_currentSelectRowArr[_selectMenuIndex] integerValue];
        if (indexPath.row == currentSelectMenuRow) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            cell.textColor = _titleSelectColor;
        } else {
            cell.textColor = _titleColor;
        }
        if (_dataSourceflags.accessoryViewForRowAtIndexPath) {
            cell.customAccessoryView = [_dataSource downMenu:self accessoryViewForRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:indexPath.row]];
        } else {
            if (_dataSourceflags.numberOfChildRowsInRow &&
                [_dataSource downMenu:self numberOfChildRowsInRow:indexPath.row column:_selectMenuIndex]) {
                cell.customAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chose_arrow_normal"] highlightedImage:[UIImage imageNamed:@"icon_chose_arrow_select"]];
            } else {
                cell.customAccessoryView = nil;
            }
        }
    } else if (_rightTableView == tableView) {
        cell.titleShowCenter = NO;
        NSInteger currentSelectMenuRow = [_currentSelectRowArr[_selectMenuIndex] integerValue];
        if (_dataSourceflags.titleForChildRowsInRowAtIndexPath) {
            cell.title = [_dataSource downMenu:self titleForChildRowsInRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:currentSelectMenuRow childRow:indexPath.row]];
            if (_dataSourceflags.detailTextForChildRowsInRowAtIndexPath) {
                cell.detailTitle = [_dataSource downMenu:self detailTextForChildRowsInRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:currentSelectMenuRow childRow:indexPath.row]];
            } else {
                cell.detailTitle = @"";
            }
        }
        NSString *titleString = [(CATextLayer *)[_titles objectAtIndex:_selectMenuIndex] string];
        if ([cell.title isEqualToString:titleString]) {
            [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelectMenuRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [_rightTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            cell.textColor = _titleSelectColor;
        } else {
            cell.textColor = _titleColor;
        }
        if (_dataSourceflags.accessoryViewForRowAtIndexPath) {
            cell.customAccessoryView = [_dataSource downMenu:self accessoryViewForRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:_selectMenuIndex row:indexPath.row]];
        } else {
            cell.customAccessoryView = nil;
        }
    }
    return cell;
}

#pragma mark - setter

- (void)setDataSource:(id<LRDropDownMenuDataSource>)dataSource {
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInDownMenu:)]) {
        _menuNum = [_dataSource numberOfColumnsInDownMenu:self];
    } else {
        _menuNum = -1;
    }
    
    [self.titles     makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.backLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.indicators makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    _currentSelectRowArr = [NSMutableArray arrayWithCapacity:_menuNum];
    for (NSInteger i = 0; i < _menuNum; i++) {
        [_currentSelectRowArr addObject:@(0)];
    }
    
    _dataSourceflags = DataSourceFlagsMake([_dataSource respondsToSelector:@selector(downMenu:numberOfRowsInColumn:)],
                                           [_dataSource respondsToSelector:@selector(downMenu:numberOfChildRowsInRow:column:)],
                                           [_dataSource respondsToSelector:@selector(downMenu:titleForRowAtIndexPath:)],
                                           [_dataSource respondsToSelector:@selector(downMenu:titleForChildRowsInRowAtIndexPath:)],
                                           [_dataSource respondsToSelector:@selector(downMenu:reddotCountForRowAtIndexPath:)],
                                           [_dataSource respondsToSelector:@selector(downMenu:detailTextForChildRowsInRowAtIndexPath:)],
                                           [_dataSource respondsToSelector:@selector(downMenu:accessoryViewForRowAtIndexPath:)]);
    CGFloat textLayerSpace     = CGRectGetWidth(self.frame) / (_menuNum * 2);
    CGFloat separatorSpace     = CGRectGetWidth(self.frame) / _menuNum;
    CGFloat textBackLayerSpace = CGRectGetWidth(self.frame) / _menuNum;
    CGFloat lineW              = 0.5;
    NSMutableArray *titles     = [NSMutableArray arrayWithCapacity:_menuNum];
    NSMutableArray *indicators = [NSMutableArray arrayWithCapacity:_menuNum];
    NSMutableArray *backLayers = [NSMutableArray arrayWithCapacity:_menuNum];
    for (NSInteger i = 0; i < _menuNum; i++) {
        //
        CGPoint backLayerCenter  = CGPointMake((i+lineW)*textBackLayerSpace, CGRectGetHeight(self.frame)/2);
        CALayer *backLayer       = [self configBackLayer:backLayerCenter];
        [self.layer addSublayer:backLayer];
        [backLayers addObject:backLayer];
        //
        CGPoint  titleCenter  = CGPointMake((i * 2 + 1)*textLayerSpace, CGRectGetHeight(self.frame) / 2);
        NSString *titleString = @"";
        if (_dataSourceflags.numberOfChildRowsInRow && [_dataSource downMenu:self numberOfChildRowsInRow:0 column:i] > 0) {
            titleString = [_dataSource downMenu:self titleForChildRowsInRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:i row:0 childRow:0]];
        } else {
            titleString = [_dataSource downMenu:self titleForRowAtIndexPath:[LRDropDownIndexPath indexPathWithColumn:i row:0]];
        }
        CATextLayer *title = [self configTextLayer:titleString position:titleCenter];
        [self.layer addSublayer:title];
        [titles addObject:title];
        //
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(title.frame) + 1, CGRectGetHeight(self.frame) / 2, 8, 4)];
        UIImage *image  = [UIImage imageNamed:@"comm_page_icon_jt_x"];
        CGRect  frame   = imageView.frame;
        frame.size      = image.size;
        frame.origin.y  = (CGRectGetHeight(self.frame) - image.size.height) / 2;
        imageView.frame = frame;
        imageView.image = image;
        imageView.tag       = i;
        [self addSubview:imageView];
        [indicators addObject:imageView];
        // 分割线
        if (i != _menuNum - 1) {
            CGPoint      separatorCenter = CGPointMake(ceilf((i + 1) * separatorSpace - 1), CGRectGetHeight(self.frame) / 2);
            CAShapeLayer *separatorLayer = [self configSeparatorLine:separatorCenter];
            [self.layer addSublayer:separatorLayer];
        }
    }
    _titles     = [titles copy];
    _indicators = [indicators copy];
    _backLayers = [backLayers copy];
}

- (void)setShow:(BOOL)show {
    _show = show;
    if (show == NO && _selectIndexPath != nil) {
        if (self.collapseDropDownMenuBlock) {
            self.collapseDropDownMenuBlock(self.selectIndexPath);
        }
    }
}

@end
