unit class TG::Route;

use IO::Path::ChildSecure;
use TG::Env;
use TG::Stash;
use Template::Mojo;

subset RouteType of Str:D where any <get post>;

has RouteType        $.type;
has Int:D            $.code   is required;
has Str:D            $.route  is required;
has Str:D            $.format is required;
has                  &.before;
has Template::Mojo:D $.template  is required;

submethod BUILD (
    Str:D     :$!route!,
    RouteType :$!type = 'get',
    Int:D     :$!code = 200,
              :$!format = 'html',
              :&!before,
    Str:D     :$template = $!route,
) {
    $!template = Template::Mojo.new:
      'templates'.IO.&child-secure($template)
          .extension(:0parts, $!format).slurp;
}

method ACCEPTS (TG::Route:D: TG::Env $env) {
    $!route eq $env.path
}

method headers {
    ['Content-type' => 'text/html' ]
}

method data {
    my $stash = TG::Stash.new;
    &!before and (&!before.count ?? &!before($stash) !! &!before());
    [$!template.render: $stash]
}
