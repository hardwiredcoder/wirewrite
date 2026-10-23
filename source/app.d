import std;
import core.thread;

string printchars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-+_`~<>,.?/:;\"'{}[]|\\";

void main()
{
    bool[$] memory = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    string code = readText("code.wirewrite");

    string partSeparator;

    string[] action;

    int column;

    while (true)
    {
        column = 0;
        while (true)
        {
            action = [];
            partSeparator = "";

            while (!(to!string(code[column]) == "\n"))
            {   // read each part of the line and put it into the action array

                while (!(to!string(code[column]) == " " || to!string(code[column]) == "\n"))
                {
                    partSeparator = partSeparator ~ to!string(code[column]);
                    column += 1;
                }

                if (to!string(code[column]) == " " && !(to!string(code[column]) == "\n")) { column += 1; }

                action = action ~ [partSeparator];
                partSeparator = "";
            }


            if (action[0] == "SET") { memory[to!int(action[1])] = to!bool(to!int(action[2])); }
            else if (action[0] == "REPEAT") { break; }
            else if (action[0] == "STOP") { return; }
            else if (action[0] == "PRINT")
            {
                write(printchars[(memory[0] * 1) + (memory[1] * 2) + (memory[2] * 4) + (memory[3] * 8) + (memory[4] * 16) + (memory[5] * 32) + (memory[6] * 64)]);
            }
            else if (action[0] == "PRINTLN")
            {
                writeln(printchars[(memory[0] * 1) + (memory[1] * 2) + (memory[2] * 4) + (memory[3] * 8) + (memory[4] * 16) + (memory[5] * 32) + (memory[6] * 64)]);
            }

            else if (action[1] == "SET" || action[1] == "REPEAT" || action[1] == "STOP" || action[1] == "PRINT" || action[1] == "PRINTLN")
            {
                if ((action[0])[0] == '!') { action[0] = chompPrefix(action[0], "!"); if (memory[to!int(action[0])] == 0) { action[0] = "1"; } else { action[0] = "0"; } }
                else { if (memory[to!int(action[0])] == 0) { action[0] = "0"; } else { action[0] = "1"; } }

                {
                    string temp = functions(memory, action, 1);
                    if (temp == "break") {break;}
                    else if (temp == "return") {return;}
                }
            }
            else
            {
                // converts the two memory addresses to their value from the memory and will also handle if they have a not (!) symbol


                // decides whether the condition is true or false

                if (gates(action, 1))
                {
                    {
                        string temp = functions(memory, action, 3);
                        if (temp == "break") {break;}
                        else if (temp == "return") {return;}
                    }
                }
            }

            while (to!string(code[column]) == "\n") {column += 1;}
        }
    }
}

string functions(bool[] memory, string[] action, int functionPosition)
{
    if (action[functionPosition] == "SET") { memory[to!int(action[functionPosition + 1])] = to!bool(to!int(action[functionPosition + 2])); }
    else if (action[functionPosition] == "REPEAT") { return "break"; }
    else if (action[functionPosition] == "STOP") { return "return"; }
    else if (action[functionPosition] == "PRINT")
    {
        write(printchars[(memory[0] * 1) + (memory[1] * 2) + (memory[2] * 4) + (memory[3] * 8) + (memory[4] * 16) + (memory[5] * 32) + (memory[6] * 64)]);
    }
    else if (action[functionPosition] == "PRINTLN")
    {
        writeln(printchars[(memory[0] * 1) + (memory[1] * 2) + (memory[2] * 4) + (memory[3] * 8) + (memory[4] * 16) + (memory[5] * 32) + (memory[6] * 64)]);
    }

    return "";
}

bool gates(string[] action, int gatePosition)
{
    if (action[gatePosition] == "AND") { if ( (to!int(action[gatePosition - 1]) == 1) && (to!int(action[gatePosition + 1]) == 1) ) {return true;} }
    else if (action[gatePosition] == "OR") { if ( ((to!int(action[gatePosition - 1])) == 1) || ( to!int(action[gatePosition + 1]) == 1) ) {return true;} }
    else if (action[gatePosition] == "NAND") { if (!( ((to!int(action[gatePosition - 1])) == 1) && ( to!int((action[gatePosition + 1])) == 1)) ) {return true;} }
    else if (action[gatePosition] == "NOR") { if ( ((to!int(action[gatePosition - 1])) == 0) && ( to!int((action[gatePosition + 1])) == 0) ) {return true;} }
    else if (action[gatePosition] == "XOR") { if ( (((to!int(action[gatePosition - 1])) == 1) || ( to!int(action[gatePosition + 1]) == 1)) && !(((to!int(action[gatePosition - 1])) == 1) && ( to!int(action[gatePosition + 1]) == 1)) ) {return true;} }

    return false;
}

void giveActionValueByMemoryAddress()
{
    if ((action[0])[0] == '!') { action[0] = chompPrefix(action[0], "!"); if (memory[to!int(action[0])] == 0) { action[0] = "1"; } else { action[0] = "0"; } }
    else { if (memory[to!int(action[0])] == 0) { action[0] = "0"; } else { action[0] = "1"; } }
    if ((action[2])[0] == '!') { action[2] = chompPrefix(action[2], "!"); if (memory[to!int(action[2])] == 0) { action[2] = "1"; } else { action[2] = "0"; } }
    else { if (memory[to!int(action[2])] == 0) {action[2] = "0";} else {action[2] = "1";}}
}

// im working on the function giveActionValueByMemoryAddress
