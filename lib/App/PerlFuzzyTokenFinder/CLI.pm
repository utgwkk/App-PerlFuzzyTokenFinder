package App::PerlFuzzyTokenFinder::CLI;
use strict;
use warnings;

use App::PerlFuzzyTokenFinder;

sub new {
    my ($class) = @_;
    bless +{
        find_tokens => undef,
    }, $class;
}

sub find_tokens { shift->{find_tokens} }
sub set_find_tokens_from_string {
    my ($self, $find_tokens_str) = @_;

    my $find_tokens = App::PerlFuzzyTokenFinder->tokenize($find_tokens_str);
    die "Parse `$find_tokens_str` failed" unless $find_tokens;
    
    $self->{find_tokens} = $find_tokens;
}

1;
