import 'package:reactive_forms/reactive_forms.dart';

Map<String, dynamic> _requiredTrue(AbstractControl control) {
  return control.isNotNull && control.value is String && control.value != '' ? null : {'required': true};
}
