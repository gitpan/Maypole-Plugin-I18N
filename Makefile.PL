use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Maypole::Plugin::I18N',
    AUTHOR       => 'Sebastian Riedel (sri@oook.de)',
    VERSION_FROM => 'I18N.pm',
    PREREQ_PM    => { Maypole => '2.0', 'Locale::Maketext::Simple' => 0 }
);
