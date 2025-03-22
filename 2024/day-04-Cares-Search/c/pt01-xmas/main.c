#include <malloc.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

static char *get_str(const char *puzzle, int x, int y, int width, int height,
                     int inc_x, int inc_y, int len) {
  static char text[32];
  int i = 0;
  for (; i < len; i++) {
    if (x < 0 || x >= width || y < 0 || y >= height)
      break;
    text[i] = puzzle[x + y * (width + 1)];
    x += inc_x;
    y += inc_y;
  }
  text[i] = 0;
  return text;
}

static int check_solutions(const char *puzzle, int x, int y, int width,
                           int height) {
  int count = 0;
  for (int inc_x = -1; inc_x <= 1; inc_x++) {
    for (int inc_y = -1; inc_y <= 1; inc_y++) {
      if (inc_x == 0 && inc_y == 0)
        continue;
      if (!strcmp(get_str(puzzle, x, y, width, height, inc_x, inc_y, 4),
                  "XMAS")) {
        count++;
      }
    }
  }
  return count;
}

static int check_puzzle(const char *puzzle, long puzzle_size) {
  int height = 0;
  int width = 0;
  int count = 0;

  while (puzzle[width] != '\n') {
    width++;
  }
  height = (puzzle_size + 1) / (width + 1);
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      char chr = puzzle[x + y * (width + 1)];
      if (chr == 'X') {
        // printf("X");
        count += check_solutions(puzzle, x, y, width, height);
      } else {
        // printf(".");
      }
    }
    // printf("\n");
  }

  return count;
}

int main(int argc, char **argv) {
  const char *input_file_path = "../../input.txt";
  for (int i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "--example") || !strcmp(argv[i], "-e")) {
      input_file_path = "../../input.example.txt";
      break;
    }
  }

  FILE *input_file = fopen(input_file_path, "r");
  fseek(input_file, 0, SEEK_END);
  long file_size = ftell(input_file);
  rewind(input_file);
  char *input = malloc(file_size + 1);

  fread(input, 1, file_size, input_file);
  input[file_size] = '\0';
  fclose(input_file);

  int result = check_puzzle(input, file_size);

  printf("result: %d\n", result);

  return 0;
}
