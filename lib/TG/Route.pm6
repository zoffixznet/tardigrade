unit class TG::Route;

use IO::Path::ChildSecure;
use TG::Env;
use TG::Stash;
use Template::Mojo;

subset RouteType of Str where any <get post>;

has RouteType:D $.type  = 'get';
has Int:D       $.code  = 200;
has Str:D       $.route is required;
has Str:D       $.format   = 'html';
has             &.before;
has Template::Mojo:D $.template is required;

submethod TWEAK (:$route, :$template) {
    $!template = Template::Mojo.new:
      'templates'.IO.&child-secure($template || $route)
          .extension(:0parts, $!format).slurp
}

method ACCEPTS (TG::Route:D: TG::Env $env) {
    $!route eq $env.path
}

method headers {
    ['Content-type' => 'text/html' ]
}

method data {
    my $stash = TG::Stash.new;
    &.before and (&c.count ?? &.before($stash) !! &.before());
    [($t).render: $stash]
}
