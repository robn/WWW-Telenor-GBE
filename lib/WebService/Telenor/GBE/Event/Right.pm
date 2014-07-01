package WebService::Telenor::GBE::Event::Right;

use Moo::Role;
use Types::Standard qw(Str);

has grantorId => ( is => 'ro', isa => Str, required => 1 );
has rightId   => ( is => 'ro', isa => Str, required => 1 );
has userId    => ( is => 'ro', isa => Str, required => 1 );
has sku       => ( is => 'ro', isa => Str, required => 1 );

with 'WebService::Telenor::GBE::Event';

1;
