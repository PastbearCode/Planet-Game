module planet_distribution;

import std.math;
import std.random;
import structs; // Assuming Planet is defined in structs
import raylib;
import std.conv;
import std.datetime;

// Function to generate a random integer within a specified range
int random(int min, int max) {
    return uniform!"[]"(min, max);
}

// Function to check if a position is valid for placing a planet
bool isValidPosition(Planet[] planets, Planet newPlanet) {
    foreach (planet; planets) {
        float distance = sqrt((pow(newPlanet.x - planet.x, 2) + pow(newPlanet.y - planet.y, 2)).to!float);
        if (distance < ((newPlanet.r+25) + (planet.r+25))) {
            return false; // Overlapping
        }
    }
    return true; // No overlaps found
}

Color getRandomColor() {
    ubyte r = random(0, 255).to!ubyte; // Random Red value
    ubyte g = random(0, 255).to!ubyte; // Random Green value
    ubyte b = random(0, 255).to!ubyte; // Random Blue value
    ubyte a = 255; // Fully opaque

    return Color(r, g, b, a); // Create and return the Color
}

// Function to place planets
Planet[] placePlanets(int planetsCount, string[] names) {
    Planet[] planets;
    for (int i = 0; i < planetsCount; i++) {
        Color color = getRandomColor(); // You can randomize colors if needed
        int size = random(50, 100);
        Planet newPlanet;

        bool placed = false;
        int attempts = 0;
        const int maxAttempts = 100; // Limit attempts to find a valid position

        while (!placed && attempts < maxAttempts) {
            newPlanet = Planet(names[i], random(size / 2, 800 - size / 2), random(size / 2, 600 - size / 2), size, color);
            if (isValidPosition(planets, newPlanet)) {
                placed = true; // Valid position found
            }
            attempts++;
        }

        if (placed) {
            planets ~= newPlanet; // Add the new planet to the array if placed successfully
        }
    }
    return planets;
}