module gems_scatter;

import std.random;
import structs; // Ensure this imports the Gem struct and any necessary types
import std.conv;

// Function to scatter gems on planets
Gem[] scatterGems(Planet[] planets, int gemCount) {
    Gem[] gems;
    bool[] usedPlanets = new bool[planets.length]; // Track used planets

    // Scatter the gems
    for (int i = 0; i < gemCount; i++) {
        int randomIndex;
        do {
            randomIndex = uniform!"[]"(0, planets.length.to!int-1); // Get a random planet index
        } while (usedPlanets[randomIndex]); // Repeat until we find an unused planet

        usedPlanets[randomIndex] = true; // Mark the planet as used

        // Create a gem for the selected planet
        Gem gem = Gem();
        gem.t = uniform(0.0, 2 * 3.1415926535); // Random angle for the gem
        gem.r = 15; // Radius of the gem
        gem.p = &planets[randomIndex]; // Position the gem

        gems ~= gem; // Add the gem to the gems array
    }

    return gems; // Return the array of gems
}