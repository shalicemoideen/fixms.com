#!/usr/bin/perl
#
# FixMyStreet:Map::Bing
# Bing maps on FixMyStreet.
#
# Copyright (c) 2010 UK Citizens Online Democracy. All rights reserved.
# Email: matthew@mysociety.org; WWW: http://www.mysociety.org/

package FixMyStreet::Map::Bing;

use strict;
use mySociety::Web qw(ent);

sub header_js {
    return '
<script type="text/javascript" src="http://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=7.0&mkt=en-GB"></script>
<script type="text/javascript" src="/js/map-bing.js"></script>
';
}

# display_map Q PARAMS
# PARAMS include:
# EASTING, NORTHING for the centre point of the map
# TYPE is 1 if the map is clickable, 2 if clickable and has a form upload,
#     0 if not clickable
# PINS is array of pins to show, location and colour
# PRE/POST are HTML to show above/below map
sub display_map {
    my ($self, $q, %params) = @_;
    $params{pre} ||= '';
    $params{post} ||= '';

    my @pins;
    foreach my $pin (@{$params{pins}}) {
        $pin->[3] ||= '';
        push @pins, "[ $pin->[0], $pin->[1], '$pin->[2]', '$pin->[3]' ]";
    }
    my $pins_js = join(",\n", @pins);

    my $out = FixMyStreet::Map::header($q, $params{type});
    my $copyright = _('Map contains Ordnance Survey data &copy; Crown copyright and database right 2010.');
    my $key = mySociety::Config::get('BING_MAPS_API_KEY');
    $out .= <<EOF;
<input type="hidden" name="latitude" id="fixmystreet.latitude" value="$params{latitude}">
<input type="hidden" name="longitude" id="fixmystreet.longitude" value="$params{longitude}">
<script type="text/javascript">
var fixmystreet = {
    'key': '$key',
    'latitude': $params{latitude},
    'longitude': $params{longitude},
    'pins': [ $pins_js ]
}
</script>
<div id="map_box">
    $params{pre}
    <div id="map"></div>
    <p id="copyright">$copyright</p>
    $params{post}
</div>
<div id="side">
EOF
    return $out;
}

1;