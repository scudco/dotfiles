# trackbar.pl
# 
# This little script will do just one thing: it will draw a line each time you
# switch away from a window. This way, you always know just upto where you've
# been reading that window :) It also removes the previous drawn line, so you
# don't see double lines.
#
# Usage: 
#
#     The script works right out of the box, but if you want you can change
#     the working by /set'ing the following variables:
#
#     trackbar_string       The characters to repeat to draw the bar
#     trackbar_style        The style for the bar, %r is red for example
#                           See formats.txt that came with irssi
#
#     /mark is a command that will redraw the line at the bottom.  However!  This
#     requires irssi version after 20021228.  otherwise you'll get the error
#     redraw: unknown command, and your screen is all goofed up :)
#
#     /upgrade & buf.pl notice: This version tries to remove the trackbars before 
#     the upgrade is done, so buf.pl does not restore them, as they are not removeable
#     afterwards by trackbar.  Unfortiounatly, to make this work, trackbar and buf.pl
#     need to be loaded in a specific order.  Please experiment to see which order works
#     for you (strangely, it differs from configuration to configuration, something I will
#     try to fix in a next version) 
#
# Authors:
#   - Main maintainer & author: Peter 'kinlo' Leurs
#   - Many thanks to Timo 'cras' Sirainen for putting me on the way
#   - UTF-8 patches by Johan 'Ion' Kiviniemi
#   - on-upgrade-remove-line patch by Uwe Dudenhoeffer
#
# Version history:
#  1.3: - Upgrade now removes the trackbars. 
#       - Some code cleanups, other defaults
#       - /mark sets the line to the bottom
#  1.2: - Support for utf-8
#       - How the bar looks can now be configured with trackbar_string 
#         and trackbar_style
#  1.1: - Fixed bug when closing window
#  1.0: - Initial release
#
# Known bugs:
#  - if you /clear a window, it will be uncleared when returning to the window
#    This is probably a bug in irssi
#  - if you resize your irssi (in xterm or so) the bar is not resized 
#    (but will be on leaving the channel)
#  - changing the trackbar style is only visible after returning to a window
#
# Whishlist/todo:
#  - instead of drawing a line, just invert timestamp or something, 
#    to save a line (but I don't think this is possible with current irssi)
#  - some pageup keybinding possibility, to scroll up upto the trackbar
#  - <@coekie> kinlo: if i switch to another window, in another split window, i 
#              want the trackbar to go down in the previouswindow in  that splitwindow :)
#  - < bob_2> anyway to clear the line once the window is read?
#  - < elho> kinlo: wishlist item: a string that gets prepended to the repeating pattern
#  - < elho> an option to still have the timestamp in front of the bar
#  - < elho> oh and an option to not draw it in the status window :P
#
# BTW: when you have feature requests, mailing a patch that works is the fastest way
# to get it added :p

use strict;
use 5.6.1;
use Irssi;
use Irssi::TextUI;

our $VERSION = "1.3";

our %IRSSI = (
    authors     => "Peter 'kinlo' Leurs",
    contact     => "peter\@pfoe.be",
    name        => "trackbar",
    description => "Shows a bar where you've last read a window",
    license     => "GPLv2",
    url         => "http://www.pfoe.be/~peter/trackbar/",
    changed     => "Thu Feb 20 16:18:08 2003",
);

our %config;
$config{'term_utf8'} = lc(Irssi::settings_get_str('term_type')) eq 'utf-8';

# UTF-8 char 9476 is "box drawings light triple dash horizontal".
Irssi::settings_add_str('trackbar',
    'trackbar_string' => $config{'term_utf8'} ? pack('U*', 0x2500) : '-');
$config{'trackbar_string'} = Irssi::settings_get_str('trackbar_string');

Irssi::settings_add_str('trackbar', 'trackbar_style' => '%K');
$config{'trackbar_style'} = Irssi::settings_get_str('trackbar_style');

Irssi::signal_add(
    'setup changed' => sub {
        $config{'term_utf8'} =
          lc(Irssi::settings_get_str('term_type')) eq 'utf-8';
        $config{'trackbar_string'} = Irssi::settings_get_str('trackbar_string');
        $config{'trackbar_style'}  = Irssi::settings_get_str('trackbar_style');
        if ($config{'trackbar_style'} =~ /(?<!%)[^%]|%%|%$/) {
            Irssi::print(
                "trackbar: %RWarning!%n 'trackbar_style' seems to contain "
                . "printable characters. Only use format codes (read "
                . "formats.txt).", MSGLEVEL_CLIENTERROR);
        }
    }
);

Irssi::signal_add(
    'window changed' => sub {
        my (undef, $oldwindow) = @_;

        if ($oldwindow) {
            my $line = $oldwindow->view()->get_bookmark('trackbar');
            $oldwindow->view()->remove_line($line) if defined $line;
            $oldwindow->print(line($oldwindow->{'width'}), MSGLEVEL_NEVER);
            $oldwindow->view()->set_bookmark_bottom('trackbar');
        }
    }
);

sub line {
    my $width  = shift;
    my $string = $config{'trackbar_string'};
    $string = '-' unless defined $string;

    # This is a horrible kludge. I guess this is Irssi's bug:
    #   my $quake = pack 'U*', 8364;    # EUR symbol
    #   Irssi::settings_add_str 'temp', 'temp_foo' => $quake;
    #   Irssi::print length $quake;
    #       # prints 1
    #   Irssi::print length Irssi::settings_get_str 'temp_foo';
    #       # prints 3
    #
    # According to perlunicode(1), "Beginning with version 5.6, Perl uses
    # logically wide characters to represent strings internally. This internal
    # representation of strings uses the UTF-8 encoding."
    # Maybe Irssi::settings_get_str() should return stuff in that "internal
    # UTF-8 representation"?
    if ($config{'term_utf8'}) {
        $string = pack 'U*', unpack 'U*', $string;
    }

    my $length = length $string;
    if ($length == 0) {
        $string = '-';
        $length = 1;
    }

    my $times = $width / $length;
    $times = int(1 + $times) if $times != int($times);
    $string =~ s/%/%%/g;
    return $config{'trackbar_style'} . substr($string x $times, 0, $width);
}

# Remove trackbars on upgrade - but this doesn't really work if the scripts are not loaded in the correct order... watch out!

Irssi::signal_add_first( 'session save' => sub {
	    for my $window (Irssi::windows) {	
		next unless defined $window;
		my $line = $window->view()->get_bookmark('trackbar');
		$window->view()->remove_line($line) if defined $line;
	    }
	}
);

sub cmd_mark {
    my $window = Irssi::active_win();
#    return unless defined $window;
    my $line = $window->view()->get_bookmark('trackbar');
    $window->view()->remove_line($line) if defined $line;
    $window->print(line($window->{'width'}), MSGLEVEL_NEVER);
    $window->view()->set_bookmark_bottom('trackbar');
    Irssi::command("redraw");    
}

Irssi::command_bind('mark',   'cmd_mark');
