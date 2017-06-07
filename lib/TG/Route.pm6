unit class TG::Route;

use IO::Path::ChildSecure;
use TG::Env;

subset RouteType of Str where any <get post>;

has RouteType:D $.type  = 'get';
has Int:D       $.code  = 200;
has Str:D       $.route is required;
has Str:D       $.template = $!route;
has Str:D       $.format   = 'html';

method ACCEPTS (TG::Route:D: TG::Env $env) {
    dd [ $!route, $env.path ];
    $!route eq $env.path
}

method headers {
    ['Content-type' => 'text/html' ]
}

method data {
    my $template-file = child-secure 'templates'.IO, $!template;
    $template-file.extension(:0parts, $!format).open
}
