module font_load;
import raylib;
import structs;

void loadGameFont() {
    string characters = "ÿabcdefghijklmnopqrstuvwxyzGPV0123456789." ~
                        "àáâãäåèéêëìíîïòóôõöùúûüøæœðçñÿ";

    int[] charcodes;
    foreach (dchar c; characters)
        charcodes ~= cast(int)c;


    // Load the font and specify the custom glyph range
    Font font = LoadFontEx("source/font.ttf", 32, charcodes.ptr, cast(int)charcodes.length);

    setFont(font);
}

