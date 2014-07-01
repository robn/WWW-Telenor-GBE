package WebService::Telenor::GBE::Event::Billing;

use Moo;
use Types::Standard qw(Str);

has short_type => ( is => 'ro', isa => Str, default => 'event.billable_event' );

has grantorId => ( is => 'ro', isa => Str, required => 1 );
has rightId   => ( is => 'ro', isa => Str, required => 1 );
has userId    => ( is => 'ro', isa => Str, required => 1 );
has sku       => ( is => 'ro', isa => Str, required => 1 );

with 'WebService::Telenor::GBE::Event';

1;
