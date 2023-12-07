import json
import os
from github import Github, Auth
import boto3


def check_merged(data):
    if "closed" in data["action"] and data["pull_request"]["merged"] == True : 
        merged = True
    else:
        merged = False
    return merged


def get_pr_info(data):
    number = data["number"]
    repo = data["repository"]["id"]
    repo_name = data["repository"]["name"]
    time_merged = data["pull_request"]["merged_at"]
    pr_data = {"repo_id": repo, "pr_number": number, "repo_name": repo_name, "time_merged": time_merged}
    return pr_data


def get_pr_files(access_token, repo, pr_number):
    git = Github(auth=access_token)
    repo = git.get_repo(repo)
    pr_files = repo.get_pull(pr_number).get_files()
    git.close()
    return pr_files


def log_changes(s3_file, files_changed):
    
    bucket_name = os.environ['bucket_name']
    files_changed_list = []
    
    s3_path = s3_file

    for i in range(0, files_changed.totalCount):
        files_changed_list.append(files_changed[i].filename)

    files_changed_list = "\n".join(files_changed_list)

    try:
        s3 = boto3.client("s3")
        s3.put_object(Bucket=bucket_name, Key=s3_path, Body=str(files_changed_list))

        print("Upload Successful", s3_path)
        return s3_path
    except FileNotFoundError:
        print("The file was not found")
        return None
    except NoCredentialsError:
        print("Credentials not available")
        return None


def lambda_handler(event, context):
    access_token = Auth.Token(os.environ["github_access_token"])
    
    data = json.loads(event['body'])

    if check_merged(data) == False:
        return None

    pr_data = get_pr_info(data)

    pr_num = pr_data["pr_number"]
    repo_id = pr_data["repo_id"]
    repo_name = pr_data["repo_name"]
    time_merged = pr_data["time_merged"]


    pr_modified_files = get_pr_files(access_token,repo=repo_id, pr_number=pr_num)

    log_changes(s3_file=f"{repo_name}/{pr_num}-{time_merged}-changes.txt", files_changed=pr_modified_files)

    return None