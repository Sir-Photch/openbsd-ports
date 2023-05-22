# ex:ts=8 sw=4:
# $OpenBSD: Tty.pm,v 1.15 2023/05/22 06:41:06 espie Exp $
#
# Copyright (c) 2010-2013 Marc Espie <espie@openbsd.org>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use v5.36;

use DPB::MiniCurses;

# subclass of Reporter that's specifically used to report on a tty

package DPB::Reporter::Tty;
our @ISA = qw(DPB::MiniCurses DPB::Reporter DPB::Limiter);

sub handle_window($self)
{
	$self->set_cursor;
	$self->SUPER::handle_window;
}

sub set_sig_handlers($self)
{
	$self->SUPER::set_sig_handlers;
	OpenBSD::Handler->register(
	    sub {
		$self->reset_cursor; 
	    });
}

sub filter($)
{
	'report_tty';
}

sub create($class, $state)
{
	my $self = $class->SUPER::create($state);
	$self->{record} = $state->{log_user}->open('>>', $state->{record})
	    if defined $state->{record};
	$self->{extra} = '';	# for myprint
	$self->create_terminal;
	$self->set_sig_handlers;
	# no cursor, to avoid flickering
	$self->set_cursor;
	return $self;
}

sub report($self, $force = 0)
{
	if ($self->{force}) {
		$force = 1;
		undef $self->{force};
	}
	$self->limit($force, 150, "REP", 1,
	    sub() {
		my $msg = "";
		for my $prod (@{$self->{producers}}) {
			my $r = $prod->report_tty($self->{state});
			if (defined $r) {
				$msg.= $r;
			}
		}
		$msg .= $self->{extra};
		if ($msg ne $self->{msg} || $self->{continued}) {
			# The "record" output is used by dpb-replay, 
			# so it's just each new display prefixed with 
			# a timestamp
			print {$self->{record}} "@@@", CORE::time(), "\n", $msg
			    if defined $self->{record};
			$self->{continued} = 0;
			my $method = $self->{write};
			$self->$method($msg);
			$self->{msg} = $msg;
		}
	    });
}

sub myprint($self, @msg)
{
	for my $string (@msg) {
		$string =~ s/^\t/       /gm; # XXX dirty hack for warn
		$self->{extra} .= $string;
	}
}

1;
