module structs;
import raylib;
import std.conv;
import std.math;

Font font;

void setFont(Font f) {
    font = f;
}


struct Planet {
    string name;
    int x;
    int y;
    int r;
    Color color;


    void draw() {
        DrawCircle(x,y,r,color);
        int textSize = MeasureText(name.ptr, 32);
        DrawTextEx(font, name.ptr, Vector2(x - (textSize / 2), y - 16), 32.0f, 1.0f, Colors.BLACK);
    }
}

struct Pivot {
    int x;
    int y;
    int r;
    bool moving = false;
    int tx = 0;
    int ty = 0;
    int tr = 0;
    int percentage = 0;

    void movePoint() {
        // Ensure percentage is between 0 and 100
        if (percentage < 0) {
            percentage = 0;
            moving = false;
            return;
        }

        if (percentage > 48) {
            percentage = 0;
            r = tr;
            x = tx;
            y = ty;
            moving = false;
            return;
        }

        // Calculate the new position and radius using lerp
        x += (tx - x) * percentage / 100;
        y += (ty - y) * percentage / 100;
        r += (tr - r) * percentage / 100; // Assuming target radius is 0, can be adjusted
    }

    void update() {
        if (moving) {
            percentage += 2;
            movePoint();
        }
    }
}


struct Player {
    float t;
    int r;
    Pivot* p;
    int x = 0;
    int y = 0;

    void update() {
        x = (p.x + (p.r + ((r/3)*2)) * cos(t)).to!int;
        y = (p.y + (p.r + ((r/3)*2)) * sin(t)).to!int;
    }

    void draw() {
        if (p.moving) {
            DrawLineEx(Vector2(x,y),Vector2(p.tx,p.ty),3,Colors.PINK);
        }
        DrawCircle(x,y,r,Colors.SKYBLUE);
    }
}

Player* plr;

void setPlayer(Player* p) {
    plr = p;
}

struct Gem {
    float t;
    int r;
    Planet* p;
    int x = 0;
    int y = 0;
    bool collected = false;

    void collect() {
        collected = true;
    }

    void update() {
        x = (p.x + (p.r + ((r/3)*2)) * cos(t)).to!int;
        y = (p.y + (p.r + ((r/3)*2)) * sin(t)).to!int;
    }

    bool isCollected() {
        bool isColliding = CheckCollisionCircles(Vector2(plr.x,plr.y), plr.r,Vector2(x,y), r);
        if (isColliding) {
            return true;
        }
        return false;
    }

    void draw() {
        if (collected == false) {
            DrawCircle(x,y,r,Colors.SKYBLUE);
        }
    }
}

struct Chest {
    float t;
    int r;
    Planet* p;
    int x = 0;
    int y = 0;

    void update() {
        x = (p.x + (p.r + ((r/3)*2)) * cos(t)).to!int;
        y = (p.y + (p.r + ((r/3)*2)) * sin(t)).to!int;
    }

    bool isCollected(int count) {
        bool isColliding = CheckCollisionCircles(Vector2(plr.x,plr.y), plr.r,Vector2(x,y), r);
        if (isColliding && count == 0) {
            return true;
        }
        return false;
    }

    void draw() {
        DrawCircle(x,y,r,Colors.BROWN);
    }
}