module random_words;
import std.random;
import std.stdio;

string[] vowels = [
    "a","e","i","o","u","à","á","â","ã","ä",
    "å","è","é","ê","ë","ì","í","î","ï","ò","ó",
    "ô","õ","ö","ù","ú","û","ü","ø","æ","œ","ð"
];

string[] consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z"];

string[] syllables;

string[] generate_words(int count) {
    //create syllables
    for (int i = 0; i < 100; i++) {
        int vowelRand = uniform!"[]"(0,31);
        int consonant = i % 21;

        string syllable = consonants[consonant]~vowels[vowelRand];

        //writeln(syllable);

        syllables ~= syllable;
    }
    //generate words
    string[] words;

    for (int i = 0; i < 100; i++) {
        int length = uniform!"[]"(1,4);
        string word = "";
        for (int j = 0; j < length; j++) {
            int num = uniform!"[]"(0,99);
            word ~= syllables[num];
        }
        words ~= word;
    }

    return words;
}