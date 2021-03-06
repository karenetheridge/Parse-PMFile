use strict;
use warnings;
use Test::More;
use Parse::PMFile;
use File::Temp;

my $tmpdir = File::Temp->newdir(CLEANUP => 1);
plan skip_all => "tmpdir is not ready" unless -e $tmpdir && -w $tmpdir;

my $pmfile = "$tmpdir/Test.pm";

open my $fh, '>', $pmfile or plan skip_all => "Failed to create a pmfile";
print $fh "package " . "Parse::PMFile::Test;\n";
print $fh 'our $VERSION = "0.01";', "\n";
close $fh;

for (0..1) {
  no warnings 'once';
  local $Parse::PMFile::FORK = $_;
  my $parser = Parse::PMFile->new({
    no_index => {
      package => [qw/
        Parse::PMFile::Test
      /]
    }
  });
  my $info = $parser->parse($pmfile);

  ok !$info->{'Parse::PMFile::Test'};
  note explain $info;
}

done_testing;
