# Travis::Blink1

`travis-blink1` is a simple sign by blink(1).

When you specify a repository travis-blink1 checks your pull request and it shows signal by Travis CI is passed or not.
Of course gree sign is passed and red is not.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'travis-blink1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install travis-blink1

## Usage

When you specify `git remote` address on github.com at your repository root,
try simply like this.

```sh
travis-blink1
```

You can also specify repository name.

```sh
travis-blink1 your_name/your_repository
```


## Contributing

1. Fork it ( https://github.com/katsuma/travis-blink1/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
