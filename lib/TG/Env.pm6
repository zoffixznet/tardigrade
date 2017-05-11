unit class TG::Env;

has Str:D $.path = '';

method new (%env-raw) { self.bless!CREATE-SELF(%env-raw) }
method !CREATE-SELF (\env) {
    $!path = env<PATH_INFO> || '';
    self
}
