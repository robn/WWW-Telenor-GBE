package WebService::Telenor::GBE::Mail;

use namespace::sweep;

use Moo;
use Types::Standard qw(Str Bool Int Maybe);

has short_type => ( is => 'ro', isa => Str, default => 'mail' );

# XXX move these out to a role; most entities have them
has id   => ( is => 'ro', isa => Str, required => 1 );
has href => ( is => 'ro', isa => Str, required => 1 );

has address          => ( is => 'ro', isa => Str,  required => 1 );
has verified         => ( is => 'ro', isa => Bool, required => 1 );
has verificationCode => ( is => 'ro', isa => Maybe[Str] );
has priority         => ( is => 'ro', isa => Int,  required => 1 );

sub send_verification_mail {
  my ($self) = @_;
  $self->_error_check($self->_gbe->post($self->link->{sendverificationmail}), "send verification mail");
}

sub make_primary {
  my ($self) = @_;
  $self->_error_check($self->_gbe->post($self->link->{self}.'/makeprimary'), "make primary mail");
}

sub delete {
  my ($self) = @_;
  $self->_error_check($self->_gbe->delete($self->link->{self}), "delete mail");
}

with 'WebService::Telenor::GBE::Entity';

1;
