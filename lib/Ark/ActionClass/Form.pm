package Ark::ActionClass::Form;
use Any::Moose '::Role';

use Ark::Form;

sub form { shift->{form} }

around ACTION => sub {
    my $orig = shift;

    my ($self, $action, $context, @args) = @_;
    local $self->{form};
    my $form_class = $action->attributes->{Form}->[0];
    if ($form_class) {
        $context->ensure_class_loaded($form_class);
        my $form = $form_class->new( $context->request, $context );

        $context->stash->{form} = $form;
        $self->{form}           = $form;
    }
    $orig->(@_);
};

no Any::Moose '::Role';

sub _parse_Form_attr {
    my ($self, $name, $value) = @_;
    return Form => $value;
}

1;


