//
//  UserSearchViewController.m
//  SOClient
//
//  Created by Lacey Vu on 3/28/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "UserSearchViewController.h"
#import "User.h"
#import "JSONParser.h"
#import "StackOverflow.h"

@interface UserSearchViewController ()<UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray<User *> *userDatasource;

@end

@implementation UserSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+(NSString *)identifier
{
    return @"UserSearchViewController";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userDatasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    cell.textLabel.text = self.userDatasource[indexPath.row].displayName;
    
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [StackOverflow searchUserWithTerm:searchBar.text withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        self.userDatasource = [JSONParser usersArrayFromDictionary:data];
        [self.tableView reloadData];
    }];
    
    [self resignFirstResponder];
    
}


@end
