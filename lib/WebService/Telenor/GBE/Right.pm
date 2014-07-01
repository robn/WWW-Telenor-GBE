package WebService::Telenor::GBE::Right;

use namespace::sweep;

use Moo;
use Types::Standard qw(Str Bool Maybe HashRef);

has short_type => ( is => 'ro', isa => Str, default => 'right' );

has rightId      => ( is => 'ro', isa => Str,  required => 1 );
has userId       => ( is => 'ro', isa => Str,  required => 1 );
has grantorId    => ( is => 'ro', isa => Str,  required => 1 );
has sku          => ( is => 'ro', isa => Str,  required => 1 );
has state        => ( is => 'ro', isa => Str,  required => 1 );
has used         => ( is => 'ro', isa => Bool, required => 1 );
has timeInterval => ( is => 'ro', isa => Str,  required => 1 );

sub terminate {
  my ($self) = @_;
  $self->_error_check($self->_gbe->delete($self->link->{self}), "terminate right");
}

with 'WebService::Telenor::GBE::Entity';

1;
