package WebService::Telenor::GBE::Event::RightDeleted;

use Moo;
use Types::Standard qw(Str);

has short_type => ( is => 'ro', isa => Str, default => 'event.right_deleted' );

with 'WebService::Telenor::GBE::Event::Right';

1;
