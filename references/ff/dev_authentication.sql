update oauth_clients
set secret = 'xlogsecret',
personal_access_client = 0,
password_client = 1
where id = 1;
