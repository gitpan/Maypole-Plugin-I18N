package Maypole::Plugin::I18N;

use strict;
use NEXT;
use I18N::LangTags::Detect;

our $VERSION = '0.02';

Maypole::Config->mk_accessors(qw(lang lexicon));

=head1 NAME

Maypole::Plugin::I18N - Internationalization for Maypole

=head1 SYNOPSIS

Simple example:

    package MyApp;

    use Maypole::Application qw(I18N);

    MyApp->config->lexicon('/path/to/po/files');
    MyApp->config->lang('de');
    MyApp->setup( 'dbi:Pg:dbname=myapp', 'myuser', 'mypass');

    MyApp->lang('no');
    
    print $r->maketext('Hello Maypole');

    [% request.maketext('Hello Maypole') %]

Use a macro if you're lazy:
    
    [% MACRO l(text, args) BLOCK;
        request.maketext(text, args);
    END; %]

    [% l('Hello Maypole') %]
    [% l('Hello [_1]', 'Maypole') %]
    [% l('lalala[_1]lalala[_2]', ['test', 'foo']) %]

=head1 DESCRIPTION

Supports po/mo files (directory must be specified in $r->config->lexicon)

    # de.po
    msgid "Hello Maypole"
    msgstr "Hallo Maibaum"

and Maketext classes under the ::I18N:: namespace of your application.

    package MyApp::I18N::de;
    use base 'MyApp::I18N';
    %Lexicon = ( 'Hello Maypole' => 'Hallo Maibaum' );
    1;

$r->config->lang is used when $r->lang is not set.

Note that you need Maypole 2.0 or newer to use this module!

=cut

sub lang {
    my ( $r, $lang ) = @_;
    $r->{lang} = $lang if $lang;
    return $r->{lang} || $r->config->lang || I18N::LangTags::Detect::detect;
}

sub maketext {
    my $r = shift;
    _loc_lang( $r->lang || $r->config->lang );
    return _loc( $_[0], @{ $_[1] } ) if ( ref $_[1] eq 'ARRAY' );
    return _loc(@_);
}

sub setup {
    my $r = shift;
    $r->NEXT::DISTINCT::setup(@_);
    require Locale::Maketext::Simple;
    import Locale::Maketext::Simple
      Class  => $r,
      Export => '_loc',
      Path   => $r->config->lexicon;
}

=head1 AUTHOR

Sebastian Riedel, C<sri@oook.de>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
