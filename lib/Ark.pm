package Ark;
use Mouse;

sub import {
    my $class  = shift;
    my @target = @_;

    strict->import;
    warnings->import;

    require utf8;
    utf8->import;

    my $caller = caller;

    {
        no strict 'refs';

        push @target, 'Core' unless @target;
        for my $target (@target) {
            my $pkg = "Ark::$target";
            Mouse::load_class($pkg) unless Mouse::is_class_loaded($pkg);
            push @{$caller.'::ISA'}, $pkg;

            for my $keyword (@{$pkg . '::EXPORT'}) {
                *{ $caller . '::' . $keyword } = *{ $pkg . '::' . $keyword };
            }
        }

        for my $keyword (@Mouse::EXPORT) {
            *{ $caller . '::' . $keyword } = *{ 'Mouse::' . $keyword };
        }
    }
}

sub unimport {
    my $caller = caller;

    no strict 'refs';
    for my $keyword (@Mouse::EXPORT) {
        delete ${ $caller . '::' }{$keyword};
    }
}

1;
