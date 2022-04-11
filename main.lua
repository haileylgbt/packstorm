-- load the config variables from hconf.lua
hconf = require "hconf"
-- styles are a table of words and flows that replicate the style of a certain packer
-- each style is stored in a .pss file in the styles folder
-- NOTE: .pss files are just lua files in disguise, so you can use lua syntax
-- when the styles are loaded in, store them in a table
styles = {}
current_style = nil
-- print a message to the console to tell the user that the console is open for debugging purposes
if hconf.verbose then
    print("Hi there!")
    print("Don't panic, I'm not hacking into your computer or anything. I'm just here to print out information that will be useful if you need to report a crash or something.")
    print("If you still don't believe me, you can view the source code at github.com/haileylgbt/packstorm")
    print("(You can turn this message off along with other reminders by setting verbose to false in hconf.lua)")
    print("")
end

ui_ready = false
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

    -- loop through all the files
    -- if the file is a .pss file, load using love.filesystem.load
    -- if the file is template.pss, do nothing
    -- print a message for each file that is loaded
    -- index the styles table by the name of the file
    for i, file in ipairs(files) do
        if file == "template.pss" then
            -- do nothing
        elseif file:sub(-4) == ".pss" then
            local style = love.filesystem.load("styles/" .. file)()
            print("Loaded style", style.name, "by", style.author)
            styles[style.name] = style
        end
    end
    print("Styles loaded!")
    print("Creating style buttons...")
    for name, style in pairs(styles) do
        style.ui_buttonx = 0
        style.ui_buttony = 0
        style.ui_buttonw = 200
        style.ui_buttonh = 50
        style.ui_listindex = nil
    end

    -- sort the styles alphabetically and set each style's ui_listindex to its index 
    -- in the sorted list
    print("Indexing styles alphabetically...")
    local sorted_styles = {}
    for name, style in pairs(styles) do
        table.insert(sorted_styles, style)
    end
    table.sort(sorted_styles, function(a, b) return a.name < b.name end)
    for i, style in ipairs(sorted_styles) do
        style.ui_listindex = i
    end

    print("Styles fully loaded!")

    print("UI is ready!")
    ui_ready = true


end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
    if key == "f3" then
        hconf.debug = not hconf.debug
    end
 end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    -- calculate the position of each button and set each style's ui_buttonx, ui_buttony and ui_listindex variables
    -- the beginning of the list is under the styles header (8, 128)
    -- each button should be spaced out by 8 pixels vertically
    for name, style in pairs(styles) do
        style.ui_buttonx = 8
        style.ui_buttony = 150 + (style.ui_listindex - 1) * style.ui_buttonh * 1.25
    end
    
end

function love.draw()
    -- if the user presses f3, toggle the debug overlay
    if hconf.debug then
        -- ubuntu mono, 16px
        love.graphics.setFont(love.graphics.newFont("fonts/UbuntuMono-Regular.ttf", 16))
        love.graphics.setColor(0, 255, 255)
        love.graphics.print("debug! :D", 0, 0)
        -- print the current position of the mouse
        love.graphics.print("mouse: " .. mouse_x .. ", " .. mouse_y, 0, 16)

    end
   if not ui_ready then
        love.graphics.setColor(255, 255, 255)
        -- ubuntu bold, 48, centered, middle of the screen, "loading..."
        love.graphics.setFont(love.graphics.newFont("fonts/ubuntu-bold.ttf", 48))
        love.graphics.printf("loading!", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
        -- ubuntu regular, 16, centered, below the loading message
        love.graphics.setFont(love.graphics.newFont("fonts/ubuntu-regular.ttf", 18))
        love.graphics.printf("we're loading the styles and organizing the menu. if this is still hear after one second then your computer is reeeeally slow or a hidden error occured.", 0, love.graphics.getHeight() / 2 + 16, love.graphics.getWidth(), "center")
   else
        -- set color to white
        love.graphics.setColor(255, 255, 255)
        -- ubuntu bold italic, 48px, top left of window with reasonable margin, "packstorm"
        love.graphics.setFont(love.graphics.newFont("fonts/ubuntu-bolditalic.ttf", 64))
        love.graphics.print("packstorm", 8, 1)
        -- ubuntu mono, small but readable, just under the title, "by hailey#0048"
        love.graphics.setFont(love.graphics.newFont("fonts/ubuntumono-regular.ttf", 16))
        love.graphics.print("by hailey#0048", 8, 72)

        -- styles header
        -- ubuntu bold, 32px, above the styles list, "styles"
        love.graphics.setFont(love.graphics.newFont("fonts/ubuntu-bold.ttf", 32))
        love.graphics.print("styles", 8, 104)
        -- set font to ubuntu regular 32px
        love.graphics.setFont(love.graphics.newFont("fonts/ubuntu-regular.ttf", 20))
        -- draw the styles list
        -- every button has a grey filled background and white text
        -- when the mouse is over a button, add a white border
        for name, style in pairs(styles) do
            if mouse_x >= style.ui_buttonx and mouse_x <= style.ui_buttonx + style.ui_buttonw and mouse_y >= style.ui_buttony and mouse_y <= style.ui_buttony + style.ui_buttonh then
                love.graphics.setColor(128, 128, 128, 0.30)
                love.graphics.rectangle("fill", style.ui_buttonx, style.ui_buttony, style.ui_buttonw, style.ui_buttonh)
                love.graphics.setColor(0, 255, 255, 255)
                love.graphics.rectangle("line", style.ui_buttonx, style.ui_buttony, style.ui_buttonw, style.ui_buttonh)
                
                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.rectangle("fill", mouse_x + 8, mouse_y + 8, 300 + 16, 150 + 16)
                love.graphics.setColor(0, 255, 255, 255)
                love.graphics.rectangle("line", mouse_x + 8, mouse_y + 8, 300 + 16, 150 + 16)
                love.graphics.setColor(255, 255, 255, 255)
                love.graphics.print(style.author, mouse_x + 12, mouse_y + 12)
                love.graphics.printf(style.description, mouse_x + 12, mouse_y + 16 + love.graphics.getFont():getHeight(style.author), 300, "left")
            else
                love.graphics.setColor(128, 128, 128, 0.25)
                love.graphics.rectangle("fill", style.ui_buttonx, style.ui_buttony, style.ui_buttonw, style.ui_buttonh)
            end
                --white
                love.graphics.setColor(255, 255, 255, 255)
                love.graphics.print(style.name, style.ui_buttonx + 8, style.ui_buttony + 8)

               
        end

    end
end
