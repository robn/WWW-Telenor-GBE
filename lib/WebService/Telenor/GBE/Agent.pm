package WebService::Telenor::GBE::Agent;

use namespace::sweep;

use Moo::Role;
use Type::Utils qw(class_type);
use Carp;

has _gbe => ( is => 'ro', isa => class_type("WebService::Telenor::GBE"), required => 1 );

sub _required_args {
  my ($self, $args, @required) = @_;
  my @missing = grep { !exists $args->{$_} } @required;
  croak "missing required args: ".join(" ", @missing) if @missing;
}

sub _error_check {
  my ($self, $res, $text) = @_;
  croak "$text: [$res->{status} $res->{reason}] $res->{content}" unless $res->{success};
  return $res;
}

1;
