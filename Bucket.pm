package Bucket;

sub new {
	my $class = shift;
	my $self = {
		_Bucket => {},
	};
	bless $self, $class;
	return $self;
}

sub addToBucket{
	my ($self, $bucketId, $data) = @_;
	my $dataList;
	if(defined $self->{_Bucket}->{$bucketId}){
		$dataList = $self->{_Bucket}->{$bucketId};
	} else {
		$dataList = [];
		$self->{_Bucket}->{$bucketId} = $dataList;
	}
	push($dataList, $data);
	return;
}

sub getBucket{
	my ($self, $bucketId) = @_;
	my $dataList = $self->{_Bucket}->{$bucketId};
	return $dataList;
}

1;