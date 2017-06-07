unit class TG::Route;

# use IO::Path::ChildSecure;
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

sub child-secure (\SELF, \child) {
      use nqp;
              say nqp::if(
            nqp::istype((my $kid := SELF.child(child).resolve: :completely),
              Failure),
            $kid, # we failed to resolve the kid, return the Failure
            nqp::if(
              nqp::istype((my $res-self := SELF.resolve: :completely), Failure),
              $res-self, # failed to resolve invocant, return the Failure
              nqp::if(
                nqp::iseq_s(
                  ($_ := nqp::concat($res-self.absolute, SELF.SPEC.dir-sep)),
                  nqp::substr($kid.absolute, 0, nqp::chars($_))),
                $kid, # kid appears to be kid-proper; return it. Otherwise fail
                fail X::IO::NotAChild.new:
  :path($res-self.absolute), :child($kid.absolute))));
}
