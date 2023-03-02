void main() {
  print("------------------");
  print("LOOP 1");
  print("------------------");
  for (int row = 1; row <= 10; row++) {
    print("*" * row);
  }
  print("------------------");
  print("LOOP 2");
  print("------------------");
  for (int row = 10; row >= 1; row--) {
    print("*" * row);
  }

  print("------------------");
  print("REVERSE LOOP");
  print("------------------");
  for (int i = 1; i < 10; i++) {
    String response = "";
    print(i);

    response = response + " " * (10 - i);
    print(response);

    response = response + "*" * i;
    print(response);
  }
}
