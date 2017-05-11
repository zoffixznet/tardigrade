use TG::Env;
unit class TG::Route;
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
    use fatal;
    'templates'.IO.child($!template).extension(:0parts, $!format).open;
}
