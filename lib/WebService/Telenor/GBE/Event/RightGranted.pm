package WebService::Telenor::GBE::Event::RightGranted;

use Moo;
use Types::Standard qw(Str);

has short_type => ( is => 'ro', isa => Str, default => 'event.right_granted' );

with 'WebService::Telenor::GBE::Event::Right';

1;
