//
//  MyTableViewCell.m
//  cell点击下拉
//
//  Created by 徐茂怀 on 15/12/29.
//  Copyright © 2015年 徐茂怀. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc]init];
        [self.contentView addSubview:_label];
    }
    return self;
}

-(void)layoutSubviews
{
    _label.frame = CGRectMake(100, 15, 200, 15);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
