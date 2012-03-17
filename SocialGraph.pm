package SocialGraph;

use lib '.';
use Bucket;
use Node;
use Data::Dumper;

sub new {
	my $class = shift;
	
	my $self = {
		_MemberList => [],
		_MemberHash => {},
		_Bucket      => new Bucket,
	};
	
	bless $self, $class;
	return $self;
}


sub addMember {
	my ( $self, $newMember ) = @_;
	my $len = length($newMember->{'_data'});
	my $newMemberIndex = push(@{$self->{'_MemberList'}}, $newMember) - 1;
	$self->{'_MemberHash'}->{$newMember->{'_data'}} = \$newMember;
	#Fetch bucket of same length and check for distance
	my $memberList = $self->{'_Bucket'}->getBucket($len);
	
	foreach my $index (@$memberList){
		if($index eq $newMemberIndex) {
			next;
		}
		my $memberObj = $self->{'_MemberList'}[$index];
		if($self->isFriend($newMember->{'_data'}, $memberObj->{'_data'}) eq true) {
			$newMember->addNeighbour($index);
			$memberObj->addNeighbour($newMemberIndex);
		}
	}
	
	#Fetch bucket of length - 1 and check for distance
	$memberList = $self->{'_Bucket'}->getBucket($len-1);
	foreach my $index (@$memberList){
		if($index eq $newMemberIndex) {
			next;
		}
		my $memberObj = $self->{'_MemberList'}[$index];
		if($self->isFriend($newMember->{'_data'}, $memberObj->{'_data'}) eq true) {
			$newMember->addNeighbour($index);
			$memberObj->addNeighbour($newMemberIndex);
		}
	}
	#Fetch Bucket of length + 1 and check for distance
	$memberList = $self->{'_Bucket'}->getBucket($len+1);
	foreach my $index (@$memberList){
		if($index eq $newMemberIndex) {
			next;
		}
		my $memberObj = $self->{'_MemberList'}->[$index];
		if($self->isFriend($newMember->{'_data'}, $memberObj->{'_data'}) eq true) {
			$newMember->addNeighbour($index);
			$memberObj->addNeighbour($newMemberIndex);
		}
	}
	
	#Add to the member list
	$self->{_Bucket}->addToBucket($len, $newMemberIndex);
	
}

sub isFriend {
	my ($self, $member1, $member2) = @_;
	my $distance = $self->distance($member1, $member2);
	#my $distance = $self->distance1($member1, $member2);
	if($distance == 1) {
		return true;
	}
	return false;
}

#faster algorithm
sub distance {
	my ($self, $word1, $word2) = @_;
	my $distance = -1;
	my $i;
	my $j;
	my $m = length($word1);
	my $n = length($word2);
	
	if($m > $n){
		$tmp = $word1;
		$word1 = $word2;
		$word2 = $tmp;
		
		$tmp = $m;
		$m = $n;
		$n = $tmp;
	}

	my $k = 1;
	my $limit = 2*$k+1;
	for($i = 0; $i < $limit ; $i++) {
		$d[$i][0] = $i;
		if($i != $m && substr($word1, $i) eq substr($word2, $i)){
			return $i;
		}
	}
	for($j = 0; $j < $limit ; $j++) {
		$d[0][$j] = $j;
		if($j != $n && substr($word1, $j) eq substr($word2, $j)){
			return $j;
		}
	}
	
	my $l = 1;
	
	for($i = 1; $i <= $m; $i++) {
		my $w = substr($word1, $i-1, 1);
		for($j = $l-$k; $j <= $l + $k && $j <= $n; $j++){
			if($w eq substr($word2, $j-1, 1)){
				$d[$i][$j] = $d[$i-1][$j-1];
			} else {
				if($i == $j) {
					$d[$i][$j] = minimum($d[$i-1][$j], $d[$i][$j-1], $d[$i-1][$j-1]) + 1;
				} else {
					if($i < $j) {
						$d[$i][$j] = min($d[$i][$j-1] , $d[$i-1][$j-1]) + 1;
					} else {
						$d[$i][$j] = min($d[$i-1][$j] , $d[$i-1][$j-1]) + 1;
					}
				}
			}
		}
		$l++;
	}
	return $d[$m][$n];
}

sub min{
	my ($val1, $val2) = @_;
	if($val1 < $val2){
		return $val1;
	}
	return $val2;
}

#slower algorithm
sub distance1 {
	my ($self, $word1, $word2) = @_;
	my $distance = -1;
	my $i;
	my $j;
	my $m = length($word1);
	my $n = length($word2);
	for($i = 0; $i <= $m; $i++) {
		$d[$i][0] = $i;
		if($i != $m && substr($word1, $i) eq substr($word2, $i)){
			return $i;
		}
	}
	for($j = 0; $j <= $n; $j++) {
		$d[0][$j] = $j;
		if($j ne $n && substr($word1, $j) eq substr($word2, $j)){
			return $j;
		}
	}
	
	for($i = 1; $i <= $m; $i++) {
		my $w = substr($word1, $i, 1);
		for($j = 1; $j <= $n; $j++){
			if($w eq substr($word2, $j, 1)){
				$d[$i][$j] = $d[$i-1][$j-1];
			} else {
				$d[$i][$j] = minimum($d[$i-1][$j], $d[$i][$j-1], $d[$i-1][$j-1]) + 1;
			}
		}
	}
	
	return $d[$m][$n];
}

sub minimum{
	my ($val1 , $val2, $val3) = @_;
	if(defined $val1 && $val1 < $val2){
		if(!defined $val3 || $val1 < $val3){
			return $val1;
		} else {
			return $val3;
		}
	} else {
		if(!defined $val3 || $val2 < $val3){
			return $val2;
		} else  {
			return $val3;
		}
	}
}

sub getConnections {
	my ($self, $data) = @_;
	my $memberList = $self->{'_MemberList'};
	my $member = $self->{'_MemberHash'}->{$data};
	my @neighbours;
	
	if(defined $member) {
		my $neighbourHash = ${$member}->getNeighbours();
		
		foreach $index (keys %$neighbourHash){
			push (@neighbours, $memberList->[$index]->{'_data'});
		}
	}
	
	return \@neighbours;
}

1;