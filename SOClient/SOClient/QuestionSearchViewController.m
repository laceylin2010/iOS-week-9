//
//  QuestionSearchViewController.m
//  SOClient
//
//  Created by Lacey Vu on 3/28/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflow.h"
#import "JSONParser.h"
#import "Question.h"
#import "QuestionTableViewCell.h"

@interface QuestionSearchViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Question *> *questionsDataSource;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [StackOverflow searchWithTerm:@"iOS" withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"DATA: %@", data);
                self.questionsDataSource = [JSONParser questionsArrayFromDictionary:data];
                [self.tableView reloadData];
             
            }
    }];
    
    [self setupTableView];
    
}

-(void)setupTableView
{
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"QuestionCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+(NSString *)identifier
{
    return @"QuestionSearchViewController";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionsDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
    cell.questionTitleLabel.text = self.questionsDataSource[indexPath.row].title;
    
    if (self.questionsDataSource[indexPath.row].isAnswered) {
        cell.isAnsweredLabel.text = @"Answered: YES";
    } else {
        cell.isAnsweredLabel.text = @"Answered: NO";
    }

    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [StackOverflow searchWithTerm:searchBar.text withCompletion:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
        if (error == nil) {
            self.questionsDataSource = [JSONParser questionsArrayFromDictionary:data];
            [self.tableView reloadData];
        }
    }];
    
    [self resignFirstResponder];
}

@end
