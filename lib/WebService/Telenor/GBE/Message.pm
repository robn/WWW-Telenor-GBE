package WebService::Telenor::GBE::Message;

use namespace::sweep;

use Moo;
use Types::Standard qw(Str HashRef);
use Type::Utils qw(role_type);

use WebService::Telenor::GBE::Event;

has short_type => ( is => 'ro', isa => Str, default => 'message' );

has messageId => ( is => 'ro', isa => Str, required => 1 );
has receiptId => ( is => 'ro', isa => Str, required => 1 );

has queue_name => ( is => 'ro', isa => Str, required => 1 );

has _raw_event => (
    is => 'ro',
    isa => HashRef,
    required => 1,
    init_arg => 'event',
);
has _event => (
    is => 'lazy',
    isa => role_type("WebService::Telenor::GBE::Event"),
    reader => 'event',
);
sub _build__event {
    my ($self) = @_;
    WebService::Telenor::GBE::Event->from_hash(_gbe => $self->_gbe, %{$self->_raw_event});
}

sub ack {
  my ($self) = @_;
  $self->_error_check($self->_gbe->post("eventqueue-ack", queuename => $self->queue_name, receiptId => $self->receiptId), "acknowledge message");
}

with 'WebService::Telenor::GBE::Entity';

1;


