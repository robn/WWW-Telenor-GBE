package WebService::Telenor::GBE;

# ABSTRACT: Client library for Telenor Digital backend API

use namespace::sweep;

use Moo;
use Type::Utils qw(class_type);
use Types::Standard qw(Str HashRef Bool);
use JSON qw(encode_json decode_json);
use URI::Escape qw(uri_escape);
use HTTP::Tiny;
use Carp;

use WebService::Telenor::GBE::User;
use WebService::Telenor::GBE::Queue;

my $API_VERSION_TYPE = 'application/vnd.comoyo.api-v20120202+json';
my $DEFAULT_HOST = 'api.comoyo.com';

my (%TEMPLATE, %LINK);
do {
  my $def = decode_json(join '', grep { not m/^\s*#/ } <DATA>);
  %TEMPLATE = %{$def->{templates}};
  %LINK = %{$def->{links}};

  # XXX sigh, this one is missing
  $TEMPLATE{'eventqueue-ack'} = '/event/queue/{queuename}/ack{?receiptId}';
};

has host     => ( is => 'ro', isa => Str, default => $DEFAULT_HOST );
has username => ( is => 'ro', isa => Str, required => 1 );
has password => ( is => 'ro', isa => Str, required => 1 );

has debug => ( is => 'ro', isa => Bool, default => 0 );

has _ua => (
    is  => 'lazy',
    isa => class_type("HTTP::Tiny"),
);
sub _build__ua {
    my ($self) = @_;
    require MIME::Base64;
    my $auth = $self->username.":".$self->password;
    HTTP::Tiny->new(
        default_headers => {
            authorization => "Basic ".MIME::Base64::encode_base64($auth, ""),
            accept        => $API_VERSION_TYPE,
        },
        timeout => 10,
    );
}

has _link => (
    is => 'lazy',
    isa => HashRef,
);
sub _build__link {
    my ($self) = @_;
    my $host = $self->host;
    return \%LINK if $host eq $DEFAULT_HOST;
    return { map { my $x = $LINK{$_}; $x =~ s/$DEFAULT_HOST/$host/eg; $_ => $x } keys %LINK };
}

sub _build_url {
  my ($self, $template, %args) = @_;

  my $url;

  # full url, use as-is
  if ($template =~ q{^https://}) {
    $url = $template;
  }

  # template name
  elsif (exists $TEMPLATE{$template}) {
    $url = $TEMPLATE{$template};

    # replace lead component with link
    $url =~ s{^(\w+)}{$self->_link->{$1}}e;

    # leading /, append to the base link
    $url =~ s{^/}{"https://".$self->host."/"}e;
  }

  # link name
  elsif ($self->_link->{$template}) {
    $url = $self->_link->{$template};
  }

  croak "unknown template or link '$template'" unless $url;

  # figure out which template parameters we need
  my %wanted = map { $_ => 1 } $url =~ m/\{[?&]?([^\}]+)\}/g;
  my @missing = grep { not exists $args{$_} } keys %wanted;
  my @extra = grep { not exists $wanted{$_} } keys %args;
  croak "missing args for template '$template': ".join(" ", @missing) if @missing;
  croak "unknown args for template '$template': ".join(" ", @extra) if @extra;

  # and fill them out
  $url =~ s/\{([?&])([^\}]+)\}/"$1$2=".uri_escape($args{$2})/eg;
  $url =~ s/\{([^\}]+)\}/uri_escape($args{$1})/eg;

  return $url;
}

sub _unpack {
  my ($self, $res) = @_;

  if ($self->debug) {
    require HTTP::Response;
    require Hash::MultiValue;
    print STDERR HTTP::Response->new(
        $res->{status},
        $res->{reason},
        [ Hash::MultiValue->from_mixed($res->{headers})->flatten ],
        $res->{content},
    )->as_string;
  }

  if ($res->{content}) {
    $res->{data} = $res->{headers}->{"content-type"} =~ m/json$/ ?
      eval { decode_json($res->{content}) } // {} : {};
  }

  return $res;
}

sub get {
  my ($self, $template, %args) = @_;

  my ($url) = $self->_build_url($template, %args);

  return $self->_unpack($self->_ua->get($url));
}

sub post {
  my $postargs = ref $_[-1] eq "HASH" ? pop @_ : {};
  my ($self, $template, %args) = @_;

  my ($url) = $self->_build_url($template, %args);

  return $self->_unpack($self->_ua->post($url, {
    headers => {
      'content-type' => $API_VERSION_TYPE,
    },
    content => encode_json($postargs),
  }));
}

sub post_form {
  my $postargs = ref $_[-1] eq "HASH" ? pop @_ : {};
  my ($self, $template, %args) = @_;

  my ($url) = $self->_build_url($template, %args);

  return $self->_unpack($self->_ua->post($url, $postargs));
}

sub delete {
  my ($self, $template, %args) = @_;

  my ($url) = $self->_build_url($template, %args);

  return $self->_unpack($self->_ua->delete($url));
}

# class delegates
sub get_user_by_userid   { WebService::Telenor::GBE::User->get_by_userid(@_) }
sub get_user_by_username { WebService::Telenor::GBE::User->get_by_username(@_) }
sub get_user_by_phone    { WebService::Telenor::GBE::User->get_by_phone(@_) }
sub create_user          { WebService::Telenor::GBE::User->create(@_) }

sub get_queue { WebService::Telenor::GBE::Queue->new(_gbe => shift, @_) }

1;

__DATA__
#
# URL templates. Perhaps better would be to pull this automatically,
# but we don't want to do it on every module load and storing it is
# fiddly. This should do to recreate it:
#
# $ curl -ks https://api.comoyo.com/id/ | json_pp -json_opt=canonical,pretty
{
   "links" : {
      "authentication" : "https://api.comoyo.com/id/auth",
      "available" : "https://api.comoyo.com/id/available",
      "instrumentation" : "https://api.comoyo.com/id/inst",
      "sso" : "https://api.comoyo.com/id/sso",
      "users" : "https://api.comoyo.com/id/users"
   },
   "templates" : {
      "eventqueue-next" : "/event/queue/{queuename}/next",
      "tnc" : "tnc",
      "user-accounts-collection" : "users/{userid}/accounts",
      "user-accounts-identity" : "users/{userid}/accounts/{accountid}",
      "user-collection" : "users",
      "user-identity" : "users/{userid}",
      "user-lookup-by-phone" : "users?type=phone{&phone}",
      "user-lookup-by-username" : "users{?username}",
      "user-mails-collection" : "users/{userid}/mails",
      "user-mails-identity" : "users/{userid}/mails/{mailid}",
      "user-phones-collection" : "users/{userid}/phones",
      "user-phones-identity" : "users/{userid}/phones/{phoneid}",
      "user-rights-collection" : "users/{userid}/rights",
      "user-rights-identity" : "users/{userid}/rights/{rightid}",
      "user-rights-sessions-collection" : "users/{userid}/rights/{rightid}/sessions",
      "user-rights-sessions-identity" : "users/{userid}/rights/{rightid}/sessions/{sessionId}",
      "user-subs-collection" : "users/{userid}/subs",
      "user-subs-identity" : "users/{userid}/subs/{subsid}",
      "user-tnc" : "users/{userid}/tnc"
   }
}
