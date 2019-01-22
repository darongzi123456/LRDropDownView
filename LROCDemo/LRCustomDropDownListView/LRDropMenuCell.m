//
//  LRDropMenuCell.m
//  LROCDemo
//
//  Created by dalizi on 2019/1/21.
//  Copyright © 2019年 dalizi. All rights reserved.
//

#import "LRDropMenuCell.h"
#import "Masonry.h"
#import "LRDropDownListCellView.h"

@interface LRDropMenuCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation LRDropMenuCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        LRDropDownListCellView *background = [[LRDropDownListCellView alloc]init];
        background.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = background;
        
        self.titleLabel    = ({
            UILabel *label = [UILabel new];
            label;
        });
        self.detailLabel   = ({
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentRight;
            label;
        });
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15);
            make.width.mas_equalTo(@(100));
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).mas_offset(-15);
            make.width.mas_equalTo(@(100));
        }];
    }
    return self;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.titleLabel.textColor = self.textColor;
}

- (void)setFontSize:(NSInteger)fontSize {
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
}

- (void)setDetailTextFont:(UIFont *)detailTextFont {
    _detailTextFont = detailTextFont;
    self.detailLabel.font = detailTextFont;
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
    _detailTextColor = detailTextColor;
    self.detailLabel.textColor = self.detailTextColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = self.title;
}

- (void)setDetailTitle:(NSString *)detailTitle {
    _detailTitle = detailTitle;
    self.detailLabel.text = self.detailTitle;
}

- (void)setCustomAccessoryView:(UIView *)customAccessoryView {
    _customAccessoryView = customAccessoryView;
    self.accessoryView = customAccessoryView;
}

- (void)setTitleShowCenter:(BOOL)titleShowCenter {
    _titleShowCenter = titleShowCenter;
    if (titleShowCenter == NO) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15);
            make.width.mas_equalTo(@(100));
        }];
    } else {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(15);
            make.right.equalTo(self.contentView).mas_offset(-15);
        }];
    }
}

@end
