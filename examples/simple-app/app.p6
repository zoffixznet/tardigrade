#!/usr/bin/env perl6
use lib <lib ../../lib>;
use TG;

TG.new {
    .get: '/', :template<index>;
    .get: '/hello';
    .start;
}
