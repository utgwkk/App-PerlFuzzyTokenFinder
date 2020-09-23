package App::PerlFuzzyTokenFinder::CLI;
use strict;
use warnings;

use PPI;

use App::PerlFuzzyTokenFinder;
use App::PerlFuzzyTokenFinder::MatchedPosition;

sub new {
    my ($class) = @_;
    bless +{
        find_tokens => undef,
        target_files => undef,
    }, $class;
}

sub find_tokens { shift->{find_tokens} }
sub set_find_tokens_from_string {
    my ($self, $find_tokens_str) = @_;

    my $find_tokens = App::PerlFuzzyTokenFinder->tokenize($find_tokens_str);
    die "Parse `$find_tokens_str` failed" unless $find_tokens;
    
    $self->{find_tokens} = $find_tokens;
}

sub target_files { shift->{target_files} }
sub set_target_files {
    my ($self, $target_files) = @_;
    
    $self->{target_files} = $target_files;
}

sub find {
    my $self = shift;
    my $find_tokens = $self->find_tokens;

    my $found = 0;

    for my $file (@{$self->target_files}) {
        my $doc = PPI::Document->new($file);
        die "Parse $file failed" unless $doc;

        my $stmts = $doc->find('PPI::Statement');
        next unless $stmts;

        for my $stmt (@$stmts) {
            my $target_tokens = [ $stmt->children ];
            if (App::PerlFuzzyTokenFinder->matches($target_tokens, $find_tokens)) {
                my $matched = App::PerlFuzzyTokenFinder::MatchedPosition->new(
                    filename    => $file,
                    line_number => $stmt->line_number,
                    statement   => $stmt->clone,
                );
                print $matched->format_for_print, "\n";
                $found = 1;
            }
        }
    }

    if ($found) {
        return 0;
    } else {
        return 1;
    }
}

1;
