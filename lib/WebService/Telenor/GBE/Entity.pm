package WebService::Telenor::GBE::Entity;

use namespace::sweep;

use Moo::Role;
use Types::Standard qw(Str HashRef);
use Carp;

requires 'short_type';

has link => (
  is => 'ro',
  isa => HashRef,
  default => sub { {} },
  coerce => sub {
    ref $_[0] eq "ARRAY" ? { map { $_->{rel} => $_->{href} } @{$_[0]} } : $_[0];
  }
);

sub _get_link {
  my ($self, $name, $key, $class) = @_;
  my $res = $self->_error_check($self->_gbe->get($self->link->{$name}), "get $name for ".$self->short_type);
  eval "require $class" or die $@;
  return map { $class->new(_gbe => $self->_gbe, %$_) } @{$res->{data}->{$key}};
}

with 'WebService::Telenor::GBE::Agent';

1;
