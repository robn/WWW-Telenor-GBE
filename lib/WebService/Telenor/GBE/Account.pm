package WebService::Telenor::GBE::Account;

use namespace::sweep;

use Moo;
use Types::Standard qw(Str Maybe);

has short_type => ( is => 'ro', isa => Str, default => 'account' );

# XXX move these out to a role; most entities have them
has id   => ( is => 'ro', isa => Str, required => 1 );
has href => ( is => 'ro', isa => Str, required => 1 );

has userid   => ( is => 'ro', isa => Str, required => 1 );
has type     => ( is => 'ro', isa => Str, required => 1 );
has password => ( is => 'ro', isa => Maybe[Str] );
has secret   => ( is => 'ro', isa => Maybe[Str] );

sub disconnect {
  my ($self) = @_;
  $self->_error_check($self->_gbe->delete($self->link->{self}), "disconnect account");
}

with 'WebService::Telenor::GBE::Entity';

1;
