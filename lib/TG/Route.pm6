unit class TG::Route;

use IO::Path::ChildSecure;
use TG::Env;
use TG::Stash;
use Template::Mojo;

subset RouteType of Str where any <get post>;

has RouteType:D $.type  = 'get';
has Int:D       $.code  = 200;
has Str:D       $.route is required;
has Str:D       $.template = $!route;
has Str:D       $.format   = 'html';
has             &.before;

method ACCEPTS (TG::Route:D: TG::Env $env) {
    $!route eq $env.path
}

method headers {
    ['Content-type' => 'text/html' ]
}

method data {
    my $t = 'templates'.IO.&child-secure($!template)
        .extension(:0parts, $!format).slurp;
    my $stash = TG::Stash.new;
    &.before and call-by-count &.before, $stash, $t;
    {
        my $*S := $stash;
        [Template::Mojo.new($t).render]
    }
}

sub call-by-count (&c, $stash, $t) {
    &c.count == 0 ?? c()
      !! &c.count == 1 ?? c($stash)
        !! c $stash, $t
}
