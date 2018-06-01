# Capital One Investing Coding Test Solutions

Welcome to the solutions for the coding challenge documentation.
The instructions below assume you are running a "Unix-like" operating system or you have MinGW installed for Windows.

For optimal reading I suggest copy pasting this README.md file's contents to [https://dillinger.io/](https://dillinger.io/)
and using the live preview.

## Before you run the solutions code

I wrote the solutions for the coding challenge in Ruby; the current version installed on my system is 2.5.0.

`ruby 2.5.0p0 (2017-12-25 revision 61468) [x86_64-darwin17]`

There are various instructions on how to install Ruby; here are the most popular methods depending on your OS.

- MacOS [https://gorails.com/setup/osx/10.13-high-sierra](https://gorails.com/setup/osx/10.13-high-sierra)
- Ubuntu Linux [https://tecadmin.net/install-ruby-on-rails-on-ubuntu/](https://tecadmin.net/install-ruby-on-rails-on-ubuntu/)
- Windows [https://rubyinstaller.org/](https://rubyinstaller.org/)

I am using the following version of Git scm.

`git version 2.15.1 (Apple Git-101)`

I don't trust any other source except for the official documentation when it comes to install Git; in the link below you can find
instructions for your operating system.

- [https://git-scm.com/book/en/v2/Getting-Started-Installing-Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### How to run the solutions with examples

The solutions consists of two directories `cli_version` and `rest_api_version`.

After running the `cli_version` with the "seed" option the market_data directory will be populated with the Quandl stock pricing data.

```
.
├── README.md
├── cli_version
│   ├── Gemfile
│   ├── Gemfile.lock
│   ├── actions
│   │   ├── average_open_close_action.rb
│   │   ├── base_action.rb
│   │   ├── busy_days_action.rb
│   │   ├── losing_days_action.rb
│   │   └── max_daily_profits_action.rb
│   ├── app.rb
│   ├── main.rb
│   └── market_fetcher.rb
├── description.md
├── market_data
│   ├── cof_jan_june_2017_data.yml
│   ├── googl_jan_june_2017_data.yml
│   └── msft_jan_june_2017_data.yml
└── rest_api_version
    ├── Gemfile
    └── main.rb
```

## CLI Version

To run the `cli_version` you'll first need to open your terminal application and navigate to the `cli_version` directory.

```
$ cd cli_version
```

I am using two gems for the cli_version which are the following

- [https://github.com/quandl/quandl-ruby](https://github.com/quandl/quandl-ruby)
- [https://github.com/ahoward/main](https://github.com/ahoward/main)

To install them use the bundle command

```
$ bundle install
```

Next you can start the CLI version by running the `ruby` command and passing it the file name `main.rb`

```
$ ruby main.rb --help
```

Ignore the warning you'll see about "::Fixnum is deprecated", it is due to a file in the "main" gem that has not been patched by the author.
You should see the following output.

```
NAME
  main.rb

SYNOPSIS
  main.rb (seed) [options]+

PARAMETERS
  --action=[action], -a (1 ~> string(action=monthly-average)) 
      [monthly-average, max-daily-profit, busy-day, biggest-loser] 
  --help, -h
```

## Fetching Storing The Market Data From Quandl

Inside the `cli_version` run the "seed" command with your quandl api key as the command line parameter for "apikey="

```
$ ruby main.rb seed apikey=copy_paste_your_quandl_key_here
```

You should see the following output while the seeder runs and populates the `market_data` folder.

If you encounter an error make sure you installed the `quandl` gem correctly. If bundle gives you strange behavior then just install the gem
locally on your machine via `gem install quandl`.

```
Seeding Market Data from Quandl.
Fetching Quandl WIKI daily stock prices for stocks: COF, GOOGL, MSFT

Now fetching COF. Please wait... DONE!
Parsing COF data for Jan 2017 through Jun 2017. Please wait... DONE!
Now Saving to "../market_data/cof_jan_june_2017_data.yml" DONE!

Now fetching GOOGL. Please wait... DONE!
Parsing GOOGL data for Jan 2017 through Jun 2017. Please wait... DONE!
Now Saving to "../market_data/googl_jan_june_2017_data.yml" DONE!

Now fetching MSFT. Please wait... DONE!
Parsing MSFT data for Jan 2017 through Jun 2017. Please wait... DONE!
Now Saving to "../market_data/msft_jan_june_2017_data.yml" DONE!
```

With the market_data directory populated; we can now run our command line and rest api apps.

### CLI Version Examples

Let go through how to run through each of the tasks outlined in the `description.md` provided by CaptialOne.

1. Average Monthly Open and Close Prices

From the `cli_version` directory run the `main.rb` file with the command `monthly-average`.

Or

Just run the command without any parameters and the `monthly-average` will be the default action chosen

```
$ ruby main.rb --action=monthly-average
```

Truncated example output will be in the form of JSON.

```json
{
  "GOOGL": [
    {
      "month": "2017-01",
      "average_open": "829.85",
      "average_close": "$830.24"
    },
    {
      "month": "2017-02",
      "average_open": "836.15",
      "average_close": "$836.75"
    },
    {
      "month": "2017-03",
      "average_open": "853.85",
      "average_close": "$853.78"
    },
```

2. Maximum Daily Profit

You can see the maximum daily profit for each security for the day that would have generated the largest returns if purchased at the low and sold at the high.

For this example and the rest we will use the slighlty less verbose CLI parameter `-a ` followed by the action name.

```
$ ruby main.rb -a max-daily-profit
```

The output should resemble the following; please note that I am formatting the JSON for display purposes.

```json
{
  "max-daily-profits": [
    {
      "ticker": "GOOGL",
      "date": "2017-06-09",
      "profit": "$52.12"
    },
    {
      "ticker": "MSFT",
      "date": "2017-06-09",
      "profit": "$3.48"
    },
    {
      "ticker": "COF",
      "date": "2017-03-21",
      "profit": "$3.75"
    }
  ]
}
```

3. Busiest Day

The output is an array of each of the days for which a security was traded in volumes that were 10% higher than the calculated average volume
for the Jan through Jun 2017 trading window. Each average volume is per security.

```
$ ruby main.rb -a busy-day
```

Truncated output shown.

```json
[
  {
    "ticker": "GOOGL",
    "date": "2017-01-03",
    "volume": 1959033,
    "average_volume": 1632363.696
  },
  {
    "ticker": "GOOGL",
    "date": "2017-01-06",
    "volume": 2017097,
    "average_volume": 1632363.696
  },
  {
    "ticker": "GOOGL",
    "date": "2017-01-23",
    "volume": 2457377,
    "average_volume": 1632363.696
  },
  {
    "ticker": "GOOGL",
    "date": "2017-01-26",
    "volume": 3493251,
    "average_volume": 1632363.696
  },
  {
    "ticker": "GOOGL",
    "date": "2017-01-27",
    "volume": 3752497,
    "average_volume": 1632363.696
  },
```

4. Biggest Loser

Lastly the biggest loser was the security that had the most days where closing price was lower than the opening price.

```
$ ruby main.rb -a biggest-loser
```

## Rest API Version

To run the `rest_api_version` you'll first need to open your terminal application and navigate to the `rest_api_version` directory.
Assuming you are still in the `cli_version` directory you will need to go up one level.

```
$ cd ..
$ cd rest_api_version
```

Before running the rest api version you will need to install the Gemfile dependencies via bundle.

I am using a minimal web framework called `sinatra` to serve requests.

[https://github.com/sinatra/sinatra](https://github.com/sinatra/sinatra)

You can just install the `sinatra` gem system wide or use `bundle install`

```
$ gem install sinatra
```

or

```
$ bundle install
```

Once Sinatra has been installed, start the minimal web server by running ruby on the main.rb file; give it a few seconds and it should prompt that it is ready and listening.

THE DEFAULT PORT IS *localhost:4567*

```
$ ruby main.rb
== Sinatra (v2.0.1) has taken the stage on 4567 for development with backup from Puma
Puma starting in single mode...
* Version 3.11.4 (ruby 2.5.0-p0), codename: Love Song
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://localhost:4567
Use Ctrl-C to stop
```

To hit the `sinatra` service 

1. Open your web browser and go to [http://localhost:4567/monthly-average](http://localhost:4567/monthly-average)

2. Use a command line tool such as curl

```
curl -s http://localhost:4567/monthly-average
```

The API endpoints are as follows.

| VERB | PATH              |
|------|-------------------|
| GET  | /monthly-average  |
| GET  | /max-daily-profit |
| GET  | /busy-day         |
| GET  | /biggest-loser    |


# Code Design and Explainations

Why Ruby?

I am very familiar with Ruby and can quickly refactor, experiment and test code due to its rather forgiving syntax and dynamic type system.
Java is another great lanugage but I found that Quandl provided library support for both Python and Ruby and not Java(that I know of).

## CLI Design

| Filename                     | Summary                                      |
|------------------------------|----------------------------------------------|
| main.rb                      | Entry point, loads App instance takes params |
| app.rb                       | Handles CLT arguments runs actions           |
| market_fetcher.rb            | Issues requests to Quandl for market data    |
| average_open_close_action.rb | Calculates average open and close data       |
| busy_days_action.rb          | Calculates busy days data                    |
| losing_days_action.rb        | Calculates the number of losing days         |
| max_daily_profits_action.rb  | Calculates the maximum profit day            |
| base_action.rb               | Shared methods for actions                   |

## How I chose to handle the market data from Quandl

Initially I thought the task would involve many concurrent restful requests to the Quandl WIKI API in order to organize and store the stock market data for the months of January 2017 to June 2017. However after reading through the Quandl docs it became apparent that there are API call limits based on the level of your account. This meant that I needed to store the fetched results for later retrieval.

For security purposes the api_key is fed from the command line and not hardcoded into the MarketFetcher class.

```ruby
  def initialize(api_key)
    @quandl_api_key = api_key
  end
```

The bulk of the Quandl work is done in `market_fetcher.rb`, particulary in the method called `fetch_quandl_wiki_data_then_save_to_yaml_files`.

- Use Quandl gem to make a HTTP call to WIKI
- Filter the results for only Jan to June 2017
- Write the results to disk in YAML format

```ruby
  security_symbols.each do |security_symbol|
    print "Now fetching #{security_symbol}. Please wait... "

    # Fetch the security's data from Quandl
    security_data = Quandl::Dataset.get("WIKI/#{security_symbol}").data

    print "DONE!\nParsing #{security_symbol} data for Jan 2017 through Jun 2017. Please wait... "

    # Filter the security data by date between Jan 1 until end_month
    jan_june_security_data = security_data.select { |data_point|
      data_point.date.year == year and data_point.date.month < end_month }.reverse

    print "DONE!\nNow Saving to \"../market_data/#{security_symbol.downcase}_jan_june_2017_data.yml\" "

    # Export the security data to yaml formatted file
    File.open("../market_data/#{security_symbol.downcase}_jan_june_2017_data.yml", 'w') { |new_file|
      new_file.write jan_june_security_data.to_yaml }

    print "DONE!\n\n"
  end
```

The YAML file format was chosen as it allows for a direct translation into Ruby objects without the need for extra parsing to Ruby hashes and then into Ruby class objects such as with JSON.

## Why the CLI is Action Oriented?

The take home challenge description mentioned that the code should be something that you would probably use in production at some point or should be ready to be turned into production grade code. I took that into consideration when I asked myself the question;

*How could I design the command line app in order to make adding additional features very simple?*

The solution I came up with is to consider each "feature" a type of action that can be performed on the market dataset. Instead of merging every feature into a single file and just relying on method names I thought of how a developer could work in isolation on a feature without blocking any co-workers

In the file `app.rb` you'll notice that each action gets loaded into every new instance of App. This would potentially allow you to even go as far as "feature-toggle" different actions or provide additional logic such as "this action is only for the rest-api". Its a middle layer between the CLI and or Rest clients and the actions.

```ruby
require_relative './actions/base_action'
require_relative './actions/average_open_close_action'
require_relative './actions/busy_days_action'
require_relative './actions/losing_days_action'
require_relative './actions/max_daily_profits_action'

class App
  attr_reader :average_open_close_action, :busy_days_action
  attr_reader :losing_days_action, :max_daily_profits_action

  def initialize
    @average_open_close_action = AverageOpenCloseAction.new
    @busy_days_action = BusyDaysAction.new
    @losing_days_action = LosingDaysAction.new
    @max_daily_profits_action = MaxDailyProfitsAction.new
  end
```

## Whats in an Action?

To begin, the `base_action` was an idea that I had which could be a parent class that all actions inherit that could be the place to store shared methods. These shared methods could involve data munging and file system interaction that is useful for all actions.

In this simplified code base there is only one shared method but I believe the intention of a base action class is a good design choice.

```ruby
class BaseAction
  def load_security_data_for security_symbol
    YAML::load_file("../market_data/#{security_symbol}_jan_june_2017_data.yml")
  end
end
```

Ruby unfortunately lacks what Java/C++ developers refer to as interfaces but instead you can describe interfaces in code by sticking to "conventions". For every action I wanted just two methods, one method to extract data from the market data and one method for returning useful info from said extraction.

```ruby
class SomeAction < BaseAction

  def initialize
  end

  public

  def get_something security_symbols
    # stuff happens
    # stuff gets returned
  end

  private

  def calculate_something security_symbol
    # transforms market data
    # returns result of transformation
  end
end
```

Every action file follows the "convention", this will make it easier to debug, test, extend and possibly futher modularize our app since the "separation of concerns" principle is followed. You'll notice that actions don't care how they are presented. I am a strong believer of keeping the presentation and core logic in different sections of code.

## Rest API Design

I thought about how this CLI app could be extended to serve as an API backend to support a React or Angular javascript application. Although not particularly advanced the Rest API version takes into account some of the current design limitations.

- I am running a single instance of `App` instead of launching a new `App` per request.

The various actions are currently all blocking operations and not designed in an non-blocking and or threaded style.
As of such if multiple clients start hitting our little server we would need to quickly return to the Sinatra main loop.

My solution was to use a in-memory cache that stores the last request and automatically returns the cached response.
The `foo_bar_cache` is just a hashmap and doesn't have any fancy TTL or cache invalidation but as with the `base_action` class
the intention is to show that I am thinking about how to grow the application and handle multiple requests that ultimately return the same data.