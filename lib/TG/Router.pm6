unit class TG::Router;
use TG::Env;
use TG::Route;
has @!routes;

method add (TG::Route $route) {
    @!routes.push: $route;
}

method match (TG::Env $env) {
    @!routes.first: *.ACCEPTS: $env
      orelse TG::Route.new: :route</404>, :code<404>;
}
