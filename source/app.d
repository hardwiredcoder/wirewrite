import std;
import core.thread;

bool[$] memory = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

void main()
{
    string code = readText("code.wirewrite");

    string partSeparator;

    string[] action;
    bool [$] notOrNot = [true, true];

    int column = 0;

    while (true)
    {
        action = [];
        column += 0;

        while (!(to!string(code[column]) == ";"))
        {   // read each part of the line and put it into the action array

            while (!(to!string(code[column]) == " " || to!string(code[column]) == ";"))
            {
                partSeparator = partSeparator ~ to!string(code[column]);
                column += 1;
            }

            if (!(to!string(code[column]) == ";")) {column += 1;}

            partSeparator = "";
        }

        writeln(partSeparator);
        writeln(action);

        if (action[0] == "STOP") {writeln("WOOHOO"); return;}

        bool doOutput = false;
        // converts the two memory addresses to their value from the memory and will also handle if they have a not (!) symbol
        if (to!int(action[0]))
        {
            if ((action[0])[0] == '!') {action[0] = chompPrefix(action[0], "!"); if (memory[to!int(action[0])] == 0) {action[0] = "1";} else {action[0] = "0";}}
            else {if (memory[to!int(action[0])] == 0) {action[0] = "0";} else {action[0] = "1";}}
            if ((action[2])[0] == '!') {action[2] = chompPrefix(action[2], "!"); if (memory[to!int(action[2])] == 0) {action[2] = "1";} else {action[2] = "0";}}
            else {if (memory[to!int(action[2])] == 0) {action[2] = "0";} else {action[2] = "1";}}
        }
        // decides whether the condition is true or false
        if (action[1] == "AND") { if ( (to!int(action[0]) == 1) && (to!int(action[2]) == 1) ) {doOutput = true;} }
        else if (action[1] == "OR") { if ( ((to!int(action[0])) == 1) || ( to!int((action[2])) == 1) ) {doOutput = true;} }

        if (doOutput)
        {
            if (action[3] == "SET") { memory[to!int(action[4])] = to!bool(to!int(action[5])); }
            else if (action[3] == "print") { write(to!string((action[4])[0])); }
            else if (action[3] == "println") { writeln(to!string((action[4])[0])); }
        }

        Thread.sleep( dur!("seconds")(1));
    }
}
