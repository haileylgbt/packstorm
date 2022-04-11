-- load the config variables from hconf.lua
hconf = require "hconf"
-- styles are a table of words and flows that replicate the style of a certain packer
-- each style is stored in a .pss file in the styles folder
-- NOTE: .pss files are just lua files in disguise, so you can use lua syntax
-- when the styles are loaded in, store them in a table
styles = {}

-- print a message to the console to tell the user that the console is open for debugging purposes
if hconf.verbose then
    print("Hi there!")
    print("Don't panic, I'm not hacking into your computer or anything. I'm just here to print out information that will be useful if you need to report a crash or something.")
    print("If you still don't believe me, you can view the source code at github.com/haileylgbt/packstorm")
    print("(You can turn this message off along with other reminders by setting verbose to false in hconf.lua)")
    print("")
end
function love.load()
    -- info about the loading progress will be printed to the console
    -- this is useful for debugging
    print("LOVE started successfully! Using version", love.getVersion())
    print("Scanning styles folder...")
    -- get all the files in the styles folder
    local files = love.filesystem.getDirectoryItems("styles")
    -- if there are no files, print an error and wait for the user to quit
    if #files == 0 then
   --[[
        love.errhand("No files found! Be sure to place your styles in the styles folder!")
        print("Press any key to quit...")
        love.event.wait()
    ]]
    
    end
    print("Found", #files, "files! Sorting...")
    -- loop through all the files
    -- if the file is a .pss file, add to the pss file tally
    -- if the file is template.pss, do nothing
    -- if the file is not a .pss file, add to the other file tally
    local pss_files = 0
    local other_files = 0
    for i, file in ipairs(files) do
        if file:sub(-4) == ".pss" then
            pss_files = pss_files + 1
        elseif file == "template.pss" then
            -- do nothing
        else
            other_files = other_files + 1
        end
    end
    print("Files sorted!")
    -- if there are no .pss files, print an error and wait for the user to press a key to quit
    --[[ 
        if pss_files == 0 then
        love.errhand("No .pss files found! Be sure to place your styles in the styles folder!")
        print("Press any key to quit...")
        end 
    ]]
    -- print a breakdown of the files found
    print("Found", pss_files, "styles and", other_files, "other files!")
    -- if verbose is true and there's at least 1 other file, print a message to the console
    if other_files > 0 and hconf.verbose then
        print("Be sure to put images in the images folder!")
    end





end

function love.update(dt)
end

function love.draw()
    -- ubuntu bold italic, 48px, top left of window with reasonable margin, "packstorm"
    love.graphics.setFont(love.graphics.newFont("fonts/ubuntu-bolditalic.ttf", 64))
    love.graphics.print("packstorm", 8, 1)
    -- ubuntu mono, small but readable, just under the title, "by hailey#0048"
    love.graphics.setFont(love.graphics.newFont("fonts/ubuntumono-regular.ttf", 16))
    love.graphics.print("by hailey#0048", 8, 72)
end
