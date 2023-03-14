String? Function(String?)? fieldEmptyValidation(message) {
  return (value) {
    if (value!.isEmpty) {
      return "Please Enter $message";
    } else {
      return null;
    }
  };
}
