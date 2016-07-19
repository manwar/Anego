package Anego::Task::Diff;
use strict;
use warnings;
use utf8;
use SQL::Translator::Diff;

use Anego::Config;

sub diff {
    my ($class, $source, $target) = @_;
    my $config = Anego::Config->load;

    my $diff = SQL::Translator::Diff->new({
        output_db => $config->rdbms,
        source_schema => $source,
        target_schema => $target,
    })->compute_differences->produce_diff_sql;

    # ignore first line
    $diff =~ s/.*?\n//;

    return $diff =~ /\A\s*-- No differences found;\s*\z/ms ? undef : $diff;
}

1;
