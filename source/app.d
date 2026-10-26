import std;
import core.thread;
import arsd.terminal;

bool[] memory = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
// this is the fake memory that wirewrite code uses

string[] action;
// each element that is added to this array is each word or argument (part) in a line

string chars = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-+_`~<>,.?/:;\"'{}[]|\\█▓▒░▔▕√©\n\t";
// this is the character list that I created for the function PRINT, PRINTLN, and INPUT

string[$] functionList = ["SET", "REPEAT", "STOP", "PRINT", "PRINTLN", "INPUT"];
// im not gonna even explain this one. i think you already get it

void main()
{
    string code = readText("code.wirewrite") ~ "\n";
    // auto adds a new line because the interpreter will not work unless the file ends with an empty line for some reason
    //
    int column;

    string partSeparator;

    while (true)
    {
        // the reason why there are two while loops is for the REPEAT function. Repeating requires breaking out of a loop so that the code can be reread as if the interpreter just started at line one

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

            if (!(action.length == 0))
            {
                int functionCallPosition = 0;
                while (functionCallPosition < action.length  &&  !functionList[].canFind(action[functionCallPosition]))
                {
                    functionCallPosition += 1;
                }

                if (functionCallPosition == 0)
                {
                    string temp = functions(0);

                    if (temp == "break") { break; }
                    else if (temp == "return") { return; }
                }
                else if (functionCallPosition == 1)
                {
                    giveActionValueByMemoryAddress(0);

                    if (to!int(action[0]))
                    {
                        string temp = functions(1);

                        if (temp == "break") { break; }
                        else if (temp == "return") { return; }
                    }
                }
                else if (functionCallPosition > 2)
                {
                    int i = 0;
                    while (i < functionCallPosition-2)
                    {
                        giveActionValueByMemoryAddress(i);
                        giveActionValueByMemoryAddress(i+2);

                        if (!gates(i+1)) { break; }

                        i += 2;
                    }

                    if (!(i < functionCallPosition-2))
                    {
                        string temp = functions(functionCallPosition);

                        if (temp == "break") { break; }
                        else if (temp == "return") { return; }
                    }
                }
            }

            column += 1;
        }
    }
}

string functions(int functionPosition)
{   // this function contains all of the wirewrite functions. if you are creating your own, be sure to put the name in the "functionList" array at the top
    if (action[functionPosition] == "SET")
    {
        while (memory.length <= to!int(action[functionPosition + 1]))
        {
            memory = memory ~ 0;
        }
        memory[to!int(action[functionPosition + 1])] = to!bool(to!int(action[functionPosition + 2]));
    }
    else if (action[functionPosition] == "REPEAT") { return "break"; }
    else if (action[functionPosition] == "STOP") { return "return"; }
    else if (action[functionPosition] == "PRINT")
    {
        write(chars[(memory[0] * 1) + (memory[1] * 2) + (memory[2] * 4) + (memory[3] * 8) + (memory[4] * 16) + (memory[5] * 32) + (memory[6] * 64)]);
    }
    else if (action[functionPosition] == "PRINTLN")
    {
        writeln(chars[(memory[0] * 1) + (memory[1] * 2) + (memory[2] * 4) + (memory[3] * 8) + (memory[4] * 16) + (memory[5] * 32) + (memory[6] * 64)]);
    }
    else if (action[functionPosition] == "INPUT")
    {
        dchar key = RealTimeConsoleInput(new Terminal(ConsoleOutputType.linear), ConsoleInputFlags.raw).getch();
        intToMemory(to!int(chars.countUntil(key)), 7);
    }

    return "";
}

void intToMemory(int number, int addressOfFirstSlot)
{   // this will automatically convert integers to binary form and write it to the memory array
    int[$] valueBySlot = [1, 2, 4, 8, 16, 32, 64, 128];

    for (int i = 6; i >= 0; i--)
    {
        if (number >= valueBySlot[i])
        {
            memory[addressOfFirstSlot + i] = 1;

            if (number != valueBySlot[i])
            {
                intToMemory(number - valueBySlot[i], addressOfFirstSlot);
            }

            return;
        }
    }
}

bool gates(int gatePosition)
{   // these are logical gates that the wirewrite script can use
    if (action[gatePosition] == "AND") { if ( (to!int(action[gatePosition - 1]) == 1) && (to!int(action[gatePosition + 1]) == 1) ) {return true;} }
    else if (action[gatePosition] == "OR") { if ( ((to!int(action[gatePosition - 1])) == 1) || ( to!int(action[gatePosition + 1]) == 1) ) {return true;} }
    else if (action[gatePosition] == "NAND") { if (!( ((to!int(action[gatePosition - 1])) == 1) && ( to!int((action[gatePosition + 1])) == 1)) ) {return true;} }
    else if (action[gatePosition] == "NOR") { if ( ((to!int(action[gatePosition - 1])) == 0) && ( to!int((action[gatePosition + 1])) == 0) ) {return true;} }
    else if (action[gatePosition] == "XOR") { if ( (((to!int(action[gatePosition - 1])) == 1) || ( to!int(action[gatePosition + 1]) == 1)) && !(((to!int(action[gatePosition - 1])) == 1) && ( to!int(action[gatePosition + 1]) == 1)) ) {return true;} }
    else if (action[gatePosition] == "NXOR") { if ( !((((to!int(action[gatePosition - 1])) == 1) || ( to!int(action[gatePosition + 1]) == 1)) && !(((to!int(action[gatePosition - 1])) == 1) && ( to!int(action[gatePosition + 1]) == 1))) ) {return true;} }

    return false;
}

void giveActionValueByMemoryAddress(int addressPosition)
{
    if ((action[addressPosition])[0] == '!')
    {
        action[addressPosition] = chompPrefix(action[addressPosition], "!");

        while (memory.length <= to!int(action[addressPosition]))
        {
            memory = memory ~ 0;
        }

        if (memory[to!int(action[addressPosition])] == 0)
        {
            action[addressPosition] = "1";
        }
        else
        {
            action[addressPosition] = "0";
        }
    }
    else
    {
        while (memory.length <= to!int(action[addressPosition]))
        {
            memory = memory ~ 0;
        }

        if (memory[to!int(action[addressPosition])] == 0)
        {
            action[addressPosition] = "0";
        }
        else
        {
            action[addressPosition] = "1";
        }
    }
}