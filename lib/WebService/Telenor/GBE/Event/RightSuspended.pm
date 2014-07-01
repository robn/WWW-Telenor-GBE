package WebService::Telenor::GBE::Event::RightSuspended;

use Moo;
use Types::Standard qw(Str);

has short_type => ( is => 'ro', isa => Str, default => 'event.right_suspended' );

with 'WebService::Telenor::GBE::Event::Right';

1;
