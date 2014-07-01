package WebService::Telenor::GBE::Queue;

use namespace::sweep;

use WebService::Telenor::GBE::Message;

use Moo;
use Types::Standard qw(Str);

has name => ( is => 'ro', isa => Str, required => 1 );

sub next_message {
  my ($self, %args) = @_;
  my $res = $self->_error_check($self->_gbe->post("eventqueue-next", queuename => $self->name), "get next message");
  return if $res->{status} == 204;
  return WebService::Telenor::GBE::Message->new(_gbe => $self->_gbe, queue_name => $self->name, %{$res->{data}});
}

with 'WebService::Telenor::GBE::Agent';

1;
