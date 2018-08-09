drain-kafka-topics
==================
A tracking service for when one clocks in or out

### Installation

* Install homebrew by running the following command:

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null`

#### Distributed streaming platform

* Run `brew install zookeeper`
* Run `brew install kafka`
* Run `brew services start zookeeper`
* Run `brew services start kafka`

### Running script

Once messages have been added to kafka topics, one can drain all topics of all messages with the following command:

`./drain-kafka-topics`

otherwise it is possible to drain chosen topics with:

`./drain-kafka-topics -t <topic1>,<topic2>`

For more commands use the help (-h) flag, like so:

`./drain-kafka-topics -h`

### License

See [LICENSE](LICENSE.md) for details.

### Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for details.

---

### Thanks to
* [@gedge](https://github.com/gedge)

