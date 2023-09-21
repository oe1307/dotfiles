on run {input, parameters}
    -- If run without input, open random file at $HOME
    try
        set filename to POSIX path of input
    on error
        set filename to ""
    end try
    -- Set your editor here
    set myEditor to "jupyter notebook"
    set installCmd to "(which jupyter || pip install jupyter) && "
    -- Open the file and auto exit after done
    set myCmd to installCmd & myEditor & " " & quote & filename & quote & " && exit"
    tell application "iTerm"
        create window with default profile
        tell current session of current window
            write text myCmd
        end tell
    end tell
    return input
end run
