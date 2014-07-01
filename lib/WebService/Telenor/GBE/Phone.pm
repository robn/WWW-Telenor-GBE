package WebService::Telenor::GBE::Phone;

use namespace::sweep;

use Moo;
use Types::Standard qw(Str Bool Int Maybe);

has short_type => ( is => 'ro', isa => Str, default => 'phone' );

# XXX move these out to a role; most entities have them
has id   => ( is => 'ro', isa => Str, required => 1 );
has href => ( is => 'ro', isa => Str, required => 1 );

has number           => ( is => 'ro', isa => Str,  required => 1 );
has type             => ( is => 'ro', isa => Str,  required => 1 );
has verified         => ( is => 'ro', isa => Bool, required => 1 );
has verificationCode => ( is => 'ro', isa => Maybe[Str] );
has priority         => ( is => 'ro', isa => Int,  required => 1 );

sub delete {
  my ($self) = @_;
  $self->_error_check($self->_gbe->delete($self->link->{self}), "delete phone");
}

with 'WebService::Telenor::GBE::Entity';

1;

