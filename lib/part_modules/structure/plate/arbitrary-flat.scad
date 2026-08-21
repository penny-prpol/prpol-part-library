// ─────────────────────────────────────────────────────────────────────────────
// arbitrary flat
//
// Builds a flat plate from a text layout: an array of strings containing two
// characters. "X" places a 10 x 10 flat unit with the standard 3.2 mm hole in
// its middle, "O" leaves a blank 10 x 10 space.
//
// The array may hold any number of strings and the strings may be any length,
// but every string must be the same length (the module asserts this). Reading
// order: layout[0] is the row at y = 0, read left to right along +X.
//
// The body is a union of pre-holed flat() pieces: one per maximal horizontal
// run of "X" cells and one per maximal vertical run. Every cell is covered
// by two overlapping pieces, so no piece edge ever lands on an interior
// surface line: there are no V-grooves, and every true outer edge keeps the
// standard chamfer.


module arbitrary_flat(
    layout = [
        "XXXXXXXXXXOX",
        "XOOOOOOOOXOX",
        "XOOOOXOOOXOX",
        "XXXXOXXXXXOX"
    ],
    plate_thickness = 2.5,
    chamfer_depth = 0.75,
    hole_diameter = 3.2,
    hole_faces = 20
){
    row_count = len(layout);
    column_count = len(layout[0]);

    row_lengths = [for (row = layout) len(row)];
    assert(max(row_lengths) == min(row_lengths),
        "\narbitrary_flat: every string in layout must be the same length.");

    for (row = layout)
        for (cell = row)
            assert(cell == "X" || cell == "O",
                "\narbitrary_flat: layout may only contain \"X\" and \"O\".");

    // Length of the horizontal run of "X" cells starting at start_column of row.
    function horizontal_run_length(row, start_column, length) =
        (start_column + length < column_count && row[start_column + length] == "X")
            ? horizontal_run_length(row, start_column, length + 1)
            : length;

    // Length of the vertical run of "X" cells starting at start_row of column_index.
    function vertical_run_length(start_row, column_index, length) =
        (start_row + length < row_count && layout[start_row + length][column_index] == "X")
            ? vertical_run_length(start_row, column_index, length + 1)
            : length;

    // Horizontal pieces: one per maximal run in each row.
    for (row_index = [0 : row_count - 1]) {
        row = layout[row_index];
        for (column_index = [0 : column_count - 1]) {
            is_run_start = row[column_index] == "X"
                && (column_index == 0 || row[column_index - 1] != "X");
            if (is_run_start) {
                translate([column_index * 10, row_index * 10, 0])
                flat(
                    dimensions = [horizontal_run_length(row, column_index, 0), 1],
                    plate_thickness = plate_thickness,
                    chamfer_depth = chamfer_depth,
                    hole_diameter = hole_diameter,
                    hole_faces = hole_faces
                );
            }
        }
    }

    // Vertical pieces: one per maximal run in each column. They overlap the
    // horizontal pieces, so every interior piece edge is covered and no
    // V-groove remains where pieces would otherwise meet.
    for (column_index = [0 : column_count - 1]) {
        for (row_index = [0 : row_count - 1]) {
            is_run_start = layout[row_index][column_index] == "X"
                && (row_index == 0 || layout[row_index - 1][column_index] != "X");
            if (is_run_start) {
                translate([column_index * 10, row_index * 10, 0])
                flat(
                    dimensions = [1, vertical_run_length(row_index, column_index, 0)],
                    plate_thickness = plate_thickness,
                    chamfer_depth = chamfer_depth,
                    hole_diameter = hole_diameter,
                    hole_faces = hole_faces
                );
            }
        }
    }
}
