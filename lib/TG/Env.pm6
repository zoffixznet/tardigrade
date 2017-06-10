unit class TG::Env;

use URI::Encode;

has Str:D $.path  = '';
has Map:D $.q = Map.new;

method new (%env-raw) { self.bless!CREATE-SELF(%env-raw) }
method !CREATE-SELF (\env) {
    $!q    = parse-q env<QUERY_STRING>;
    $!path = env<PATH_INFO> || '';
    self
}

sub parse-q (\q) {
    my %params;
    for grep *.so, map |*.split(';'), |q.split: '&' {
        my ($key, $value) = .split("=", 2)[0,1].map: {
            $_ ?? .&uri_decode !! ""
        }
        %params.push: $key => $value;
    }
    %params.Map;
}
