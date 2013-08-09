Ruby gem to communicate with new Basecamp API.

[![Gem Version](https://badge.fury.io/rb/logan.png)](http://badge.fury.io/rb/logan)

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

###To do
* use Basecamp's HTTP caching
* implement other Basecamp APIs

If there is something you're looking for from the gem, please open up an issue and let me know!

###Logan?
Mount Logan is the highest mountain in Canada and the second-highest peak in North America, after Mount McKinley.