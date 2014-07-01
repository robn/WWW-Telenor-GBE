package WebService::Telenor::GBE::Event::RightActive;

use Moo;
use Types::Standard qw(Str);

has short_type => ( is => 'ro', isa => Str, default => 'event.right_active' );

with 'WebService::Telenor::GBE::Event::Right';

1;
