package WebService::Telenor::GBE::User;

use namespace::sweep;

use Moo;
use Types::Standard qw(Str Bool Maybe);

use WebService::Telenor::GBE::Mail;
use WebService::Telenor::GBE::Phone;
use WebService::Telenor::GBE::Subscription;

has short_type => ( is => 'ro', isa => Str, default => 'user' );

# XXX move these out to a role; most entities have them
has id   => ( is => 'ro', isa => Str, required => 1 );
has href => ( is => 'ro', isa => Str, required => 1 );

has username          => ( is => 'ro', isa => Str,  required => 1 );
has active            => ( is => 'ro', isa => Bool, required => 1 );
has realname          => ( is => 'ro', isa => Maybe[Str] );
has birthdate         => ( is => 'ro', isa => Maybe[Str] );
has username_verified => ( is => 'ro', isa => Bool, required => 1 );

# XXX simplify this style
sub get_by_userid {
  my ($class, $gbe, %args) = @_;
  $class->_required_args(\%args, qw(userid));
  my $res = $class->_error_check($gbe->get("user-identity", %args), "get user by id");
  return $class->new(_gbe => $gbe, %{$res->{data}});
}

sub get_by_username {
  my ($class, $gbe, %args) = @_;
  $class->_required_args(\%args, qw(username));
  my $res = $class->_error_check($gbe->get("user-lookup-by-username", %args), "get user by username");
  return $class->new(_gbe => $gbe, %{$res->{data}});
}

sub get_by_phone {
  my ($class, $gbe, %args) = @_;
  $class->_required_args(\%args, qw(phone));
  my $res = $class->_error_check($gbe->get("user-lookup-by-phone", %args), "get user by phone");
  return $class->new(_gbe => $gbe, %{$res->{data}});
}

sub create {
  my ($class, $gbe, %args) = @_;
  $class->_required_args(\%args, qw(username));
  my $res = $class->_error_check($gbe->post("users", \%args), "create user");
  return $class->new(_gbe => $gbe, %{$res->{data}});
}

# XXX and this style
sub delete {
  my ($self) = @_;
  $self->_error_check($self->_gbe->delete($self->link->{self}), "delete user");
}

sub accounts      { shift->_get_link("accounts", "account",      "WebService::Telenor::GBE::Account") }
sub mails         { shift->_get_link("mails",    "mail",         "WebService::Telenor::GBE::Mail") }
sub phones        { shift->_get_link("phones",   "phone",        "WebService::Telenor::GBE::Phone") }
sub rights        { shift->_get_link("rights",   "right",        "WebService::Telenor::GBE::Right") }
sub subscriptions { shift->_get_link("subs",     "subscription", "WebService::Telenor::GBE::Subscription") }

sub create_account {
  my ($self, %args) = @_;
  $self->_required_args(\%args, qw(type userid));
  my $res = $self->_error_check($self->_gbe->post($self->link->{accounts}, \%args), "create account");
  WebService::Telenor::GBE::Account->new(_gbe => $self->_gbe, %{$res->{data}});
}

sub create_mail {
  my ($self, %args) = @_;
  $self->_required_args(\%args, qw(address));
  my $res = $self->_error_check($self->_gbe->post($self->link->{mails}, \%args), "create mail");
  WebService::Telenor::GBE::Mail->new(_gbe => $self->_gbe, %{$res->{data}});
}

sub create_phone {
  my ($self, %args) = @_;
  $self->_required_args(\%args, qw(number type));
  my $res = $self->_error_check($self->_gbe->post($self->link->{phones}, \%args), "create phone");
  WebService::Telenor::GBE::Phone->new(_gbe => $self->_gbe, %{$res->{data}});
}

sub create_subscription {
  my ($self, %args) = @_;
  $self->_required_args(\%args, qw(grantorId timeSpec rightsSpec));
  my $res = $self->_error_check($self->_gbe->post($self->link->{subs}, \%args), "create subscription");
  WebService::Telenor::GBE::Subscription->new(_gbe => $self->_gbe, %{$res->{data}});
}

sub create_right {
  my ($self, %args) = @_;
  $self->_required_args(\%args, qw(grantorId timeSpec rightsSpec));
  my $res = $self->_error_check($self->_gbe->post($self->link->{subs}, \%args), "create subscription");
  WebService::Telenor::GBE::Subscription->new(_gbe => $self->_gbe, %{$res->{data}});
}

with 'WebService::Telenor::GBE::Entity';

1;
