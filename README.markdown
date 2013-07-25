Ruby gem to communicate with new Basecamp API.

###Documentation
Documentation is [here](http://rubydoc.info/github/birarda/logan/).

###Examples
```ruby
basecamp_ID = "12345678"
username = "username"
password = "password"
user_agent = "LoganUserAgent (email@example.com)"

logan = Logan::Client.new(basecamp_ID, username, password, user_agent)

basecamp_projects = logan.projects
````

###Logan?
Mount Logan is the highest mountain in Canada and the second-highest peak in North America, after Mount McKinley.