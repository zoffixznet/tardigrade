unit class TG;
use HTTP::Server::Tiny;
use TG::Router;
use TG::Route;
use TG::Env;

has Str $.host = '0.0.0.0';
has Int $.port = 3333;

has TG::Router:D       $!router = TG::Router.new;
has HTTP::Server::Tiny $!server;

multi method get(Str $route) {
    $!router.add: TG::Route.new: :$route;
    self
}

multi method get(Pair (:key($route), :value($template))) {
    $!router.add: TG::Route.new: :$route, :$template;
    self
}

method start {
    HTTP::Server::Tiny.new(:$!host , :$!port).run: -> $env-raw {
        my $env = TG::Env.new: $env-raw;
        my $route = $!router.match: $env;
        start [$route.code, $route.headers, $route.data]
    }
}
