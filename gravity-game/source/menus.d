module menus;

import raylib;

Font mfont;

void setMenuFont(Font f) {
    mfont = f;
}

bool menuOpen = false;

int menuType = 1;

bool shouldReload;

void openMenu() {
    menuOpen = !menuOpen;
    if (menuType == 2 && !menuOpen) {
        shouldReload = true;
    }
}

void drawMenu(string text) {
    if (menuOpen) {
        ClearBackground(Colors.RAYWHITE);
        DrawTextEx(mfont, text.ptr, Vector2(304,250), 32.0f, 1.0f, Colors.BLACK);
        if (menuType == 2) {
            DrawRectangle(539,250,100,100,Colors.RAYWHITE);
            DrawRectangle(304,282,100,100,Colors.RAYWHITE);
        }
    }
}

void updateMenu() {
    if (IsKeyPressed(257)) {
        openMenu();
    }
}