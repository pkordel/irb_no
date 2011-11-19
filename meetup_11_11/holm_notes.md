# IRB.no - 17th November

Notes by Magnus Holm from the Ruby meetup held at Skalar in November.

Files: <https://github.com/pkordel/irb_no/tree/master/meetup_11_11>

## Decisions

It was decided that there will be a Ruby meetup **last thursday** every month.

## Faker in Norwegian

Katrina talked about implementing Faker in Norwegian. Faker is a gem which
generates random seed data; e.g. random names, addresses, phone numbers, login
names; perfect for filling up your database for a demo! However, most of the
names are pretty American, which doesn't look good in Norwegian apps that you
want to show to clients.

Therefore Katrina forked Faker and implemented localization. It has now been
pulled into the main gem and is available at rubygems.org (although there might
be some bugfixes that isn't pulled in yet).

Example code available in faker/

See also: https://github.com/stympy/faker/pull/32

## What can we learn from Perl?

After some food, I continued with a talk about what we can learn from Perl.

Perl has the concept of a "package" which it takes fully advantage of. In Ruby,
we *require* files into the the runtime. We look at it as "bringing the content
of the file into the runtime". In Perl on the other hand, you bring different
packages into your own package. The moment a package is included into another
package, it can execute some code (like the #inherited and #included hooks in
Ruby). This gives the package a great deal of flexibility of what it means to
"use this package":

    package SolarBeam;
    
    use Mojo::Base -base;
    # Mojo::Base will now give us `has` (which works just like
    # `attr_accessor`) and a sensible constructor.
    
    # Example of an attribute with a default value:
    has user_agent => sub { Mojo::UserAgent->new }

    use Mojo::UserAgent;
    # Mojo::UserAgent is just a regular library, so this does nothing else than
    # giving us access to the Mojo::UserAgent-package.
    
    use Mojo::Util 'html_escape';
    # Mojo::Util will now export the html_escape-function (and that
    # function only) into our package. We can now use the function both
    # in instance- and class methods
    
    use sort 'stable';
    # This will make sure that the sort-function is stable (i.e. that if
    # two objects are considered equal, they will keep their ordering)
    # which is pretty crucial if you e.g. want to first sort on rating
    # and then on a timestamp. Without a stable sort, the sorting on timestamp
    # might ruin the sorting on the rating.
    
    use v5.10;
    # This simply says "give me a Perl with all the modern features introduced
    # after v5.10". Yes, you can also say `use feature "say"` if you want to
    # enable just one specific feature.

The last two are good examples of how Perl deals with backwards-compatibility:
By default the Perl runtime gives a stable, less-featured and quirky version,
and you must explicitly enable the features you need. This makes it possible to
more easily upgrade to newer Perl versions (to take advantage of performance
improvements etc.) without worrying so much about "will my code still run".

It also means that programmers can specify the exact requirements in the code,
so it will fail fast (and with a sensible error message) if someone tries to
run it on an old version of Perl.

Another consequence of the packages is that you become more aware of not
introducing global state. A good example is the Active Record pattern. You
*could* implement ActiveRecord in Perl and it would look something like this:

    # This is done in an initializer:
    Model::Base->establist_connection(…)
    
    # And you invoke it like this:
    my $users = Model::User->all

However, this breaks the encapsulation of packages. Remember that in Perl you
think of "bringing other packages into this pacakge" and with this in mind it
feels pretty weird to "bring in a package in order to change what happens when
others bring other packages in"; we are bringing in Model::Base in our
initializer, why should that change how the Model::User package behave in our
controller?

In Perl you would rather do something like this:

    use App::DB;
    
    my $conn = App::DB->new;
    $conn->all('users');
    # or maybe even:
    $conn->users->all;

Then you just need to make sure that an instance of App::DB is available in all
your controllers.

Finally, there's a nicely (web) framework called Mojolicious, which also
happens to implement nearly everything you need in your web applications. It
essentially replaces these gems in Ruby: Rails, Sinatra, Unicorn, Nokogiri,
json, ERB, EventMachine, net/http, uri; *and* it has built-in support for
WebSockets. All in pure, sensible Perl. In only 11k lines of code (no comments
or whitespace). In comparison, ActiveSupport + ActionPack is 22k lines of Ruby
code...

Mojolicious really shows the beauty of a consistently designed toolkit, at the
price of reinventing the wheels...

Slides available at what-can-we-learn-from-perl.pdf

## Useful testing tool

Peter talked the importance of having a fast and solid test suite, and
presented two tools that you can easily integrate into your stack to make
testing easier and faster.

Example code is available in testing/

### VCR

VCR is a simple tool which records (it's a VCR after all) the responses to all
HTTP requests you make. So the first time you run your tests it hits the
server, but the second time you'll get a "cached" response from the first time.
This means you *don't* have to mock all your HTTP requests, but can rather just
hit the server as usual. VCR will take care of the mocking for you, and any
time you want to hit the real servers again, you just delete the
cache-directory (called a "cassette" of course).

Dead simple to integrate with your tests (if they already hit the server) and
it makes your tests way faster!

### Timecop

Timecop allows you to travel through time in Ruby. Let's say you have a
subscribtion model and want to test what happens when the customer doesn't pay.
With Timecop you can easily travel one month into the future and verify that
the customer *actually* can't do anything.

You can also *freeze* time, but that's kinda dangerous. Many libraries depends
on timeouts and if time is frozen, nothing will time out!

Once again, just a `require` away to integrate!

## CloudFoundry

Trym presented CloudFoundry, an open-source cloud stack that does pretty much
the same as Heroku. However, you can use CloudFoundy everywhere; EC2,
Rackspace, dedicated hardware, you name it! It already supports more
languages/frameworks than Heroku, and because it's open-source it's pretty easy
to extend it.

It also has a command line tool (called `vmc`) which lets you manage your
application. Trym showed how easy it was to deploy a Rails application (using
MongoDB as datastore). The command `vmc push` sets up a new application and lets
you configure services (MongoDB, Redis, RabbitMQ etc). It took less than five
minutes to deploy a fresh application, and most of that time was waiting for
the services to start. Pretty cool!

CloudFoundry only works at the app-level, so it won't e.g. provision servers in
the cloud for you. You'll need to set up the servers yourself (hopefully using
automatic tools like Chef or Puppet) and then connect it to your cloud. Then
CloudFoundry takes care of everything else. That way CloudFoundry doesn't try
to replace everything, but neatly integrates with other tools.

## How to refactor?

Katrina mentioned earlier that one way to make the tests run faster is to
refactor code out of the Rails stack. That way you can run the tests without
loading Rails and all your gems, plugins and dependencies.

Someone asked later: "Could you give an example of how to do that?", so she
showed us a real life example of how she refactored.

## Ruby's Object Model

Finally, I held *another* talk, but this time about Ruby. More specifically,
about Ruby's object model. It was maybe a bit more philosophical than
practical, but I feel it's important to discuss what we all take for granted
(What is an object? What's the purpose of classes?) once in a while.

Notes and diagrams available in object_model/

