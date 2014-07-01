package WebService::Telenor::GBE::Subscription;

use namespace::sweep;

use Moo;
use Types::Standard qw(Str ArrayRef HashRef);

has short_type => ( is => 'ro', isa => Str, default => 'subscription' );

has subscriptionId    => ( is => 'ro', isa => Str,               required => 1 );
has userId            => ( is => 'ro', isa => Str,               required => 1 );
has grantorId         => ( is => 'ro', isa => Str,               required => 1 );
has origTimeSpec      => ( is => 'ro', isa => Str,               required => 1 );
has effectiveTimeSpec => ( is => 'ro', isa => Str,               required => 1 );
has state             => ( is => 'ro', isa => Str,               required => 1 );
has rightsSpec        => ( is => 'ro', isa => ArrayRef[HashRef], required => 1 );

sub terminate {
  my ($self) = @_;
  $self->_error_check($self->_gbe->delete($self->link->{self}), "terminate subscription");
}

with 'WebService::Telenor::GBE::Entity';

1;
