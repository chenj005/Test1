//
//  ViewController.m
//  cell点击下拉
//
//  Created by 徐茂怀 on 15/12/29.
//  Copyright © 2015年 徐茂怀. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *sectionArray;//section标题
@property(nonatomic, strong)NSMutableArray *rowInSectionArray;//section中的cell个数
@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击
@property(nonatomic, strong)NSMutableArray *titleArray;//cell的标题
@property(nonatomic, assign)NSInteger flag;
@end
@interface ViewController ()

@end

@implementation ViewController

-(void)loadView
{
    [super loadView];
    _flag = 0;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 ,20 , self.view.frame.size.width, self.view.frame.size.height)style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionArray = [NSMutableArray arrayWithObjects:@"First",@"Second", nil];//每个分区的标题
    _rowInSectionArray = [NSMutableArray arrayWithObjects:@"3",@"2", nil];//每个分区中cell的个数
    _selectedArray = [NSMutableArray arrayWithObjects:@"0",@"0", nil];//这个用于判断展开还是缩回当前section的cell
    _titleArray = [NSMutableArray arrayWithObjects:@"标题1",@"标题2",@"标题3", nil];
}
#pragma mark cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_flag == 1 ){
        if ( indexPath.section == 0 && (indexPath.row == 2 || indexPath.row == 3)) {
            static NSString *identifier = @"cell";
            MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.label.text = _titleArray[indexPath.row];
            return cell;
            
        }
        else
        {
            static NSString *identifier1 = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            }
            cell.textLabel.text = _titleArray[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    else
    {
        static NSString *identifier2 = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    }
}
#pragma mark cell的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断section的标记是否为1,如果是说明为展开,就返回真实个数,如果不是就说明是缩回,返回0.
    if ([_selectedArray[section] isEqualToString:@"1"])
    {
        return [_rowInSectionArray[section]integerValue];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1 && _flag == 0) {
        /**当点击第二行时,刷新数据出现新的行*/
        _rowInSectionArray = [NSMutableArray arrayWithObjects:@"5",@"2", nil];
        _titleArray = [NSMutableArray arrayWithObjects:@"标题1",@"标题2",@"标题2的分支1",@"标题2的分支2",@"标题3", nil];
        [_tableView reloadData];
        _flag = 1;
    }
    else if(indexPath.section == 0 && indexPath.row == 1 && _flag == 1)
    {
        /**当点击第二行时,删除第3和第四行,并伴随动画*/
        _rowInSectionArray = [NSMutableArray arrayWithObjects:@"3",@"2", nil];
        _titleArray = [NSMutableArray arrayWithObjects:@"标题1",@"标题2",@"标题3", nil];
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *path2 = [NSIndexPath indexPathForRow:3 inSection:0];
        [_tableView deleteRowsAtIndexPaths:@[path1,path2] withRowAnimation:UITableViewRowAnimationFade];
        _flag = 0;
    }
}

#pragma mark section的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionArray.count;
}

#pragma cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - section内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //每个section上面有一个button,给button一个tag值,用于在点击事件中改变_selectedArray[button.tag - 1000]的值
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 40)];
    sectionView.backgroundColor = [UIColor redColor];
    UIButton *sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionButton.frame = sectionView.frame;
    [sectionButton setTitle:[_sectionArray objectAtIndex:section] forState:UIControlStateNormal];
    [sectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    sectionButton.tag = 1000 + section;
    [sectionView addSubview:sectionButton];
    return sectionView;
}
#pragma mark button点击方法
-(void)buttonAction:(UIButton *)button
{
    if ([_selectedArray[button.tag - 1000] isEqualToString:@"0"]) {
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"0"];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        //        _rowInSectionArray = [NSMutableArray arrayWithObjects:@"3",@"2", nil];
        //        _titleArray = [NSMutableArray arrayWithObjects:@"标题1",@"标题2",@"标题3", nil];
        //        _flag = 0;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
