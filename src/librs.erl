-module(librs).
-export([truly_random/0, dot/2, scale/2, div1/2, add/2, sub/2, unit/1, make/3, get/1, length_squared/1]).
-nifs([truly_random/0, dot/2, scale/2, div1/2, add/2, sub/2, unit/1, make/3, get/1, length_squared/1]).
-on_load(init/0).

init() ->
    ok = erlang:load_nif("priv/librslib", 0).

scale(v, s) -> 
    exit(nif_library_not_loaded).

dot(v, s) -> 
    exit(nif_library_not_loaded).

div1(v, s) -> 
    exit(nif_library_not_loaded).

add(v, s) -> 
    exit(nif_library_not_loaded).

sub(v, s) -> 
    exit(nif_library_not_loaded).

unit(v) -> 
    exit(nif_library_not_loaded).

make(a, b, c) -> 
    exit(nif_library_not_loaded).

get(vec) ->
    exit(nif_library_not_loaded).

length_squared(v) -> 
    exit(nif_library_not_loaded).

truly_random() ->
    exit(nif_library_not_loaded).

