#!/usr/bin/env roundup

describe "spaceman-diff: generates ascii image diffs!"

spaceman="./spaceman-diff"

run_spaceman() {
  readonly output_file=$(mktemp /tmp/XXXXX)
  $spaceman "$@" > "$output_file"
  echo "$output_file"
}

it_shows_help_with_no_argv() {
  $spaceman | grep USAGE
}

it_renders_diff() {
  output_file=$(run_spaceman \
    test/images/flag.png \
    test/images/flag.png a190ba 100644 \
    test/images/gooder-flag.png 000000 100644)

  grep -F "OLD: flag.png (84 KB)" < "$output_file"
  grep -F "NEW: gooder-flag.png (9 KB)" < "$output_file"

  rm "$output_file"
}

it_works_with_output_filenames_containing_spaces() {
  output_file=$(run_spaceman \
    "test/images/flag.png" \
    "test/images/flag.png" a190ba 100644 \
    "test/images/with spaces.png" 000000 100644)

  grep -F 'OLD: flag.png (84 KB)' < "$output_file"
  grep -F 'NEW: with spaces.png (9 KB)' < "$output_file"

  rm "$output_file"
}

it_works_with_input_filenames_containing_spaces() {
  output_file=$(run_spaceman \
    "test/images/with spaces.png" \
    "test/images/with spaces.png" a190ba 100644 \
    "test/images/flag.png" 000000 100644)

  grep -F 'OLD: with spaces.png (9 KB)' < "$output_file"
  grep -F 'NEW: flag.png (84 KB)' < "$output_file"

  rm "$output_file"
}
