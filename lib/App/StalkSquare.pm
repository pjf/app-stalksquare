package App::StalkSquare;
use v5.010;
use strict;
use warnings;
use autodie;
use File::Slurp qw(read_file);
use WWW::Mechanize;
use JSON::Any;
use Getopt::Std;

my %opts = (
    p   => undef,       # Phone
    e   => undef,       # email
    t   => undef,       # twitter
    f   => undef,       # Facebook
    n   => undef,       # Name
    T   => undef,       # Twitter source
);

my %search_type = (
    phone         => 'p',
    email         => 'e',
    twitter       => 't',
    twitterSource => 'T',
    fbid          => 'f',
    name          => 'n',
);

my $HOME = $ENV{HOME} || $ENV{UserProfile};

my $API_BASE = 'https://api.foursquare.com/v2';
my $token    = read_file("$HOME/.4sq_token");
chomp($token);
$token    = "oauth_token=$token&v=20121108";

my $SEARCH_BASE = $API_BASE . '/users/search?';

my $mech = WWW::Mechanize->new;
my $json = JSON::Any->new;

getopts('p:e:t:f:n:T:', \%opts);

while (my ($label,$short) = each %search_type) {
    next unless $opts{$short};

    # Otherwise, do call.

    my $url = $SEARCH_BASE."$label=$opts{$short}&$token";

    say "Fetching $url";

    $mech->get($url);

    use Data::Dumper;
    say Dumper $json->decode( $mech->content );

}

1;
