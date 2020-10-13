# expert_search_tool
An app to create users, connect with other users and search for experts in a topic via mutual friends.

### Prerequisites
1. Ruby
2. PostgreSQL
3. NPM/Yarn
4. Redis

### Installation
1. Install RVM and ruby: https://rvm.io/rvm/install
2. Install PostgreSQL for Ubuntu using the following [guide](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-18-04).
Refer the following [guide](https://www.postgresql.org/download/macosx/) for installation procedure for Mac.
3. Please refer the following [guide](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) to install NodeJS and NPM.
You can also install Yarn with the help of this [page](https://classic.yarnpkg.com/en/docs/install/#debian-stable)
4. Install redis server using this [guide](https://redis.io/topics/quickstart).
5. Clone the repository

### Setup

1. On terminal, change directory to expert_search_tool and run command `bundle install`. This will install all the gems required to run the application.
2. In the project's `config/database.yml` file, change the username, password, hostname to the PSQL server setup on your local machine.
```
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # https://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV["DEV_DB_HOSTNAME"] || 'localhost' %>
  username: <%= ENV["DEV_DB_USERNAME"] || 'expert_search_admin' %>
  password: <%= ENV["DEV_DB_PASSWORD"] || 'password' %>

development:
  <<: *default
  database: <%= ENV["DEV_DB_NAME"] || 'expert_search_backend_development' %>
```
3. Once done, run the following commands:
a. `rake db:create` to create the development database.
b. `rake db:migrate` to create the `users`, `friendships` and `expert_topics` tables.
4. Make sure the **BITLY_TOKEN** environment variable is set on your machine.
5. Once all of these steps are performed, start the server using the command: `rails s`
d. On another terminal, run the following command to start sidekiq: `bundle exec sidekiq`<br/>
(Note: Make sure, redis server is up and running before starting sidekiq server.)
6. Try hitting `http://localhost:3000` from your browser to check if app has started successfully.

### Usage
The tool provides multiple APIs to perform the following actions: create users, create friendships and search experts.
Details of each API is given below.

#### Users
1. Create user: This endpoint is used to create a user based on user's first_name, last_name and website url.<br/>
Endpoint: POST: `/users`<br/>
Required Parameters: first_name, web_url<br/>
Request body:
```
{
  "first_name": "<First Name>",
  "last_name": "<Last Name>",
  "web_url": "<personal website url>"
}
```
A sample request looks something like this:
```
POST http://localhost:3000/users

{
  "first_name": "John",
  "last_name": "Doe",
  "web_url": "johndoe.com"
}
```

A sample JSON response will look something like this: 
```
{
    "id": 7,
    "first_name": "John",
    "last_name": "Doe",
    "web_url": "johndoe.com",
    "created_at": "2020-10-13T05:59:42.125Z",
    "updated_at": "2020-10-13T05:59:42.125Z",
    "url": "http://localhost:3000/users/7.json",
    "topics": [],
    "friends": []
}
```

2. List users: This endpoint returns a list of users along with each user's short web url,  friend count.
Endpoint: GET: `/users`<br/>

A sample request looks something like this:
```
GET http://localhost:3000/users
```

A sample JSON response will look something like this: 
```
[
    {
        "id": 7,
        "first_name": "John",
        "last_name": "Doe",
        "web_url": "johndoe.com,
        "short_url": "https://bit.ly/3lBcUTh",
        "friend_count": 2,
        "created_at": "2020-10-12T05:35:47.075Z",
        "updated_at": "2020-10-12T05:35:48.624Z",
        "url": "http://localhost:3000/users/7.json"
    }
]
```

3. Get single user: This endpoint returns a user based on its id and returns user details along with list of topics the user is an expert in and list of friend profile links.
Endpoint: GET: `/users/:id`<br/>

A sample request looks something like this:
```
GET http://localhost:3000/users/1
```

A sample JSON response will look something like this: 
```
{
    "id": 1,
    "first_name": "Pushkar",
    "last_name": "Chitale",
    "web_url": "facebook.com",
    "short_url": "https://bit.ly/34N1Hbx",
    "created_at": "2020-10-12T05:12:28.562Z",
    "updated_at": "2020-10-12T05:20:35.281Z",
    "url": "http://localhost:3000/users/1.json",
    "topics": [
        {
            "id": 1,
            "user_id": 1,
            "topic": "Connect with friends and the world around you on Facebook.",
            "created_at": "2020-10-12T05:12:54.621Z",
            "updated_at": "2020-10-12T05:12:54.621Z",
            "url": "http://localhost:3000/expert_topics/1.json"
        }
    ],
    "friends": [
        {
            "id": 1,
            "request_sender_id": 1,
            "request_receiver_id": 2,
            "created_at": "2020-10-13T03:47:27.996Z",
            "updated_at": "2020-10-13T03:47:27.996Z",
            "friend_profile_url": "http://localhost:3000/users/2",
            "url": "http://localhost:3000/friendships/1.json"
        },
        {
            "id": 3,
            "request_sender_id": 1,
            "request_receiver_id": 3,
            "created_at": "2020-10-13T03:47:34.288Z",
            "updated_at": "2020-10-13T03:47:34.288Z",
            "friend_profile_url": "http://localhost:3000/users/3",
            "url": "http://localhost:3000/friendships/3.json"
        },
        {
            "id": 7,
            "request_sender_id": 1,
            "request_receiver_id": 6,
            "created_at": "2020-10-13T05:25:56.723Z",
            "updated_at": "2020-10-13T05:25:56.723Z",
            "friend_profile_url": "http://localhost:3000/users/6",
            "url": "http://localhost:3000/friendships/7.json"
        }
    ]
}
```

#### Friendships
This API provides us with the functionality to connect any 2 users in the app.
1. Create friends: An endpoint to connect two users. The request sender and request receiver ids should be passed in order to create a friendship record.
Endpoint: POST: `/friendships`<br/>
Required Parameters: request_sender_id, request_receiver_id<br/>
Request body:
```
{
    "request_sender_id": <user1_id>,
    "request_receiver_id": <user2_id>
}
```

A sample request looks something like this:
```
POST http://localhost:3000/friendships

{
    "request_sender_id": 1,
    "request_receiver_id": 6
}
```

A sample JSON response will look something like this: 
```
{
    "id": 7,
    "request_sender_id": 1,
    "request_receiver_id": 6,
    "created_at": "2020-10-13T05:25:56.723Z",
    "updated_at": "2020-10-13T05:25:56.723Z",
    "friend_profile_url": "http://localhost:3000/users/6",
    "url": "http://localhost:3000/friendships/7.json"
}
```

#### Expert search
This API provides a user to search for experts in a particular topic who are not direct friends with the user but are connected via a mutual friend.
Endpoint: GET: `/search_experts`<br/>
Required parameters: user_id(User who wants to search for experts), query(String containing expert topic keyword)

A sample request looks something like this:
```
GET http://localhost:3000/search_experts?user_id=1&query=video
```

A sample JSON response will look something like this: 
```
[
    "Sourabh->Vikas->Say it with video"
]
```
The API returns a list of search results in the following format: **Mutual friend of expert -> Expert in the searched topic -> Topic of expertise**

### Background jobs
The API performs the following 2 tasks in the background during user creation with the help of Sidekiq.
1. **ScrapeWebHeadingsWorker**: This worker scrapes heading tags(h1, h2 and h3) from the created user's web url and saves it to the expert_topics DB as the user's topic of expertise.
2. **WebUrlShortener**: This worker shortens user's web urls with the help of (Bitly APIs)[https://github.com/philnash/bitly]

### Future enhancements
1. Adding authorization and authentication mechanism.
2. Pagination for all listing APIs.
3. Adding unit tests.
