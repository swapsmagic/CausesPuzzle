use LWP::Simple;

use lib '.';
use Node;
use SocialGraph;

print "Enter URL of word list: ";
my $url = <>; #'https://raw.github.com/causes/puzzles/master/word_friends/word.list';
my $input = get $url;
 

my @wordList = split(/\n/, $input);

# Generate Social Graph
my $socialGraph = new SocialGraph();
my $cnt = 0;
foreach my $word (@wordList){
	my $node = new Node($word);
	$socialGraph->addMember($node);
	$cnt++;
	if($cnt % 100 == 0){
		print ". ";
		if($cnt % 2000 == 0){
			print "\n";
		}
	}
}

print "\n ##### Done with graph generation ##### \n";

my %visistedMap;
my $neighbourQueue;

print "Enter the word to find it's network: ";
my $word = <>;
chomp($word);

my $result = $socialGraph->getConnections($word);
$neighbourQueue = $result;
$visitedMap{$word} = 1;

my $friendStr = "Friends' ";
while(scalar($neighbourQueue) > 0){
	my $tmpList = ();
	print $friendStr . ":";
	foreach $neighbour (@$neighbourQueue){
		if(!defined $visitedMap{$neighbour}) {
			print $neighbour . ", ";
			$visitedMap{$neighbour} = 1;
			$result = $socialGraph->getConnections($neighbour);
			push (@$tmpList, @$result);
		}
	}
	$neighbourQueue = $tmpList;
	print "\n";
	$friendStr .= "Friends' "; 
}
