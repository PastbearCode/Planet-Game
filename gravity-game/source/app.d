import std.stdio;
import raylib;
import random_words;
import planet_distribution; // Import the new module
import structs;
import std.conv;
import font_load;
import std.random;
import gems_scatter;
import std.algorithm;
import menus;
import std.math;

float limitToFourDecimalPlaces(float value) {
    return round(value * 10_000) / 10_000; // Rounds to four decimal places
}

string getFirstSevenCharacters(string input) {
    // Check if the input string is shorter than 7 characters
    if (input.length < 7) {
        return input; // Return the original string if it's shorter
    }
    return input[0..7]; // Slice the string to get the first 7 characters
}

float lerp(float a, float b, float t) {
    return a + (b - a) * t;
}

void main() {
    validateRaylibBinding();
    InitWindow(800, 600, "Gravity Game");
    SetTargetFPS(60);

    // List of extended ANSI characters to load into the font
    loadGameFont();

    int planetsCount = 20; // Set the number of planets
    string[] names = generate_words(planetsCount);

    float pi = 3.1415926535;

    // Place planets using the new module function
    Planet[] planets = placePlanets(planetsCount, names);
    Gem[] gems = scatterGems(planets, 7);
    

    Planet randomPlanet = planets[random(0,(planets.length-1).to!int)];
    Pivot pivot = Pivot(randomPlanet.x,randomPlanet.y,randomPlanet.r);
    Player player = Player(0.2,25,&pivot);

    Chest chest = Chest(uniform(0.0, 2 * 3.1415926535),20,&planets[random(0,(planets.length-1).to!int)]);

    setPlayer(&player);

    int gemUpdateCount = 0;

    openMenu();

    setMenuFont(font);

    float time = 0;

    float saveTime = 0;

    Camera2D camera;
    camera.target = Vector2(player.x, player.y); // Camera target
    camera.offset = Vector2(400.0f, 300.0f); // Offset
    camera.rotation = 0.0f; // Camera rotation
    camera.zoom = 1.0f; // Camera zoom

    void reload() {
        names = generate_words(planetsCount);

        // Place planets using the new module function
        planets = placePlanets(planetsCount, names);
        gems = scatterGems(planets, 7);


        randomPlanet = planets[random(0,(planets.length-1).to!int)];
        pivot = Pivot(randomPlanet.x,randomPlanet.y,randomPlanet.r);
        player = Player(0.2,25,&pivot);

        chest = Chest(uniform(0.0, 2 * 3.1415926535),20,&planets[random(0,(planets.length-1).to!int)]);

        setPlayer(&player);

        gemUpdateCount = 0;
    }

    while (!WindowShouldClose()) {
        if (menuOpen) {
            BeginDrawing();
            updateMenu();
            if (shouldReload) {
                time = 0.000;
                shouldReload = false;
                reload();
            }
            if (menuType == 1) {
                drawMenu("Planet Game");
            } else {
                drawMenu("Victory "~getFirstSevenCharacters(limitToFourDecimalPlaces(time).to!string));
            }
            EndDrawing();
        } else {
            time += GetFrameTime();

            if (IsKeyDown(87)) {
                player.t += (pi/50);
            } else if (IsKeyDown(83)) {
                player.t -= (pi/50);
            }

            

            if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) {
                Vector2 mousePos = GetMousePosition();

                // Adjust mouse position relative to the camera
                Vector2 adjustedMousePos = Vector2(mousePos.x - camera.offset.x + camera.target.x, 
                mousePos.y - camera.offset.y + camera.target.y);

                foreach (planet; planets) {
                    bool clicked = CheckCollisionPointCircle(adjustedMousePos, Vector2(planet.x, planet.y), planet.r);
                    if (clicked) {
                        pivot.tx = planet.x;
                        pivot.ty = planet.y;
                        pivot.tr = planet.r;
                        pivot.moving = true;
                        break;
                    }
                }
            }

            float smoothFactor = 0.1f; // Adjust this value to control smoothness
            camera.target.x = lerp(camera.target.x, player.x, smoothFactor);
            camera.target.y = lerp(camera.target.y, player.y, smoothFactor);
            float scroll = GetMouseWheelMove();
            if (camera.zoom > 0 && camera.zoom < 1) {
                camera.zoom += scroll;
            }

            BeginDrawing();

            BeginMode2D(camera);

            ClearBackground(Colors.RAYWHITE);

            
            
            foreach (planet; planets) {
                planet.draw();
            }

            foreach (gem; gems) {
                gem.update();
                if (gem.isCollected()) {
                    gems = gems.remove(gemUpdateCount);
                    gemUpdateCount++;
                    continue;
                }
                gemUpdateCount++;
                gem.draw();
            }
            gemUpdateCount = 0;

            chest.update();

            if (chest.isCollected(gems.length.to!int)) {
                menuType = 2;
                openMenu();
            }

            chest.draw();

            player.update();

            pivot.update();

            player.draw();

            EndMode2D();

            DrawRectangle(10,10,105,25,Colors.RED);

            DrawRectangle(10,10,105-(15*(gems.length.to!int)),25,Colors.GREEN);

            EndDrawing();
        }
    }

    // Clean up
    destroy(pivot); // Calls the destructor and frees the memory
    UnloadFont(font);
    CloseWindow(); // Close the window and OpenGL context
}
