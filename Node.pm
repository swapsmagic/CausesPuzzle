package Node;

sub new {
	my $class = shift;
	my $self = {
		_data => shift,
		_neighbourHash => {}, 
	};
	bless $self, $class;
	return $self;
}


sub addNeighbour {
	my ($self, $neighbour) = @_;
	
	if($self->hasNeighbour($neighbour) eq false) {
		my $neighbourHash = $self->{_neighbourHash};
		$neighbourHash->{$neighbour} = 1;
	}
	return;
}

sub hasNeighbour {
	my ($self, $neighbour) = @_;
	my $neighbourHash = $self->{_neighbourHash};
	if(exists $neighbourHash->{$neighbour}){
		return true;
	}
	return false;
}

sub getNeighbours {
	my ($self) = @_;
	my $neighbourHash = $self->{_neighbourHash};
	return $neighbourHash;
}

1;