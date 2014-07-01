package WebService::Telenor::GBE::Event;

use namespace::sweep;

use Moo::Role;
use Types::Standard qw(Str Int);
use Carp;

has eventId   => ( is => 'ro', isa => Str, required => 1 );
has eventName => ( is => 'ro', isa => Str, required => 1 );

has timestamp    => ( is => 'ro', isa => Int, required => 1 );
has isoTimestamp => ( is => 'ro', isa => Str, required => 1 );

with 'WebService::Telenor::GBE::Entity';

my %classes = (
    "com.comoyo.events.billable.BillableEvent" => "WebService::Telenor::GBE::Event::Billing",
    "com.comoyo.events.right.RightActive"      => "WebService::Telenor::GBE::Event::RightActive",
    "com.comoyo.events.right.RightGranted"     => "WebService::Telenor::GBE::Event::RightGranted",
    "com.comoyo.events.right.RightDeleted"     => "WebService::Telenor::GBE::Event::RightDeleted",
    "com.comoyo.events.right.RightSuspended"   => "WebService::Telenor::GBE::Event::RightSuspended",
);

for my $class (values %classes) {
    eval "require $class";
    die $@ if $@;
}

sub from_hash {
    my ($class, %hash) = @_;
    my $target = $classes{$hash{eventName}};
    croak "no event class for $hash{eventName}" unless $target;
    $target->new(%hash);
}

1;
