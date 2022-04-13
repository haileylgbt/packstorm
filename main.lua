-- CUSTOM FILES:
-- .psp - packstorm pool: words only
-- .pss - packstorm style: words and flows
love.filesystem.setIdentity("packstorm")

love.filesystem.createDirectory("styles/")
love.filesystem.createDirectory("pools/")

-- load the config variables from hconf.lua
hconf = require "hconf"
-- load the flow parser
flows = require "packparse"
-- styles are a table of words and flows that replicate the style of a certain packer
-- each style is stored in a .pss file in the styles folder
-- NOTE: .pss files are just lua files in disguise, so you can use lua syntax
-- when the styles are loaded in, store them in a table
styles = {}
-- when pools are loaded, store all their words in a table
-- this is so that the flow parser can use them
words = {
    nouns = {},
    adjectives = {},
    verbs = {}
}
current_style = nil
joke = "select a style and press space!"
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
    -- load the fonts
    text = {
        debug = love.graphics.newFont("fonts/UbuntuMono-Regular.ttf", 16),
        regular_small = love.graphics.newFont("fonts/Ubuntu-Regular.ttf", 16),
        regular = love.graphics.newFont("fonts/Ubuntu-Regular.ttf", 18),
        regular_big = love.graphics.newFont("fonts/Ubuntu-Regular.ttf", 20),
        title = love.graphics.newFont("fonts/Ubuntu-BoldItalic.ttf", 64),
        loading = love.graphics.newFont("fonts/Ubuntu-Bold.ttf", 48),
        joke = love.graphics.newFont("fonts/Ubuntu-Regular.ttf", 24),
        header = love.graphics.newFont("fonts/ubuntu-bold.ttf", 32)
    }
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
        style.ui_hovering = false
        style.is_current = false
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

    -- set the current style to the first style in the list

    print("Styles ready!")

    -- begin pool loading process
    print("Scanning pools folder...")
    -- get all the files in the pools folder
    local files = love.filesystem.getDirectoryItems("pools")
    -- if there are no files, print an error and wait for the user to quit
    if #files == 0 then
        love.errhand("No files found! Be sure to place your pools in the pools folder!")
        print("Press any key to quit...")
        love.event.wait()
    end
    print("Found", #files, "files! Sorting...")
    -- loop through all the files
    -- if the file is a .psp file, add to the psp file tally
    -- if the file is template.psp, do nothing
    -- if the file is not a .psp file, add to the other file tally
    local psp_files = 0
    local other_files = 0
    for i, file in ipairs(files) do
        if file:sub(-4) == ".psp" then
            psp_files = psp_files + 1
        elseif file == "template.psp" then
            -- do nothing
        else
            other_files = other_files + 1
        end
    end
    print("Files sorted!")
    -- if there are no .psp files, print an error and wait for the user to press a key to quit
    --[[ 
        if psp_files == 0 then
        love.errhand("No .psp files found! Be sure to place your pools in the pools folder!")
        print("Press any key to quit...")
        end 
    ]]
    -- print a breakdown of the files found
    print("Found", psp_files, "pools and", other_files, "other files!")
    -- if verbose is true and there's at least 1 other file, print a message to the console
    if other_files > 0 and hconf.verbose then
        print("Be sure to put images in the images folder!")
    end

    -- loop through all the files
    -- if the file is a .psp file, load using love.filesystem.load
    -- if the file is template.psp, do nothing
    -- print a message for each file that is loaded
    -- when a pool is loaded, add its nouns, verbs, and adjectives in the words table
    -- dont add the pool itself to the pools table

    for i, file in ipairs(files) do
        if file == "template.psp" then
            -- do nothing
        elseif file:sub(-4) == ".psp" then
            local pool = love.filesystem.load("pools/" .. file)()
            print("Loading pool", pool.name, "by", pool.curator)
            -- add the pool's words.nouns into words.nouns
            for i, noun in ipairs(pool.words.nouns) do
                table.insert(words.nouns, noun)
            end
            print("Loaded", #pool.words.nouns, "nouns")
            -- add the pool's words.verbs into words.verbs
            for i, verb in ipairs(pool.words.verbs) do
                table.insert(words.verbs, verb)
            end
            print("Loaded", #pool.words.verbs, "verbs")
            -- add the pool's words.adjectives into words.adjectives
            for i, adjective in ipairs(pool.words.adjectives) do
                table.insert(words.adjectives, adjective)
            end
            print("Loaded", #pool.words.adjectives, "adjectives")
            print("Loaded a total of", #pool.words.nouns + #pool.words.verbs + #pool.words.adjectives, "words!")
        end
    end

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
    -- when space is pressed, get a random flow from the current style, parse it and set the joke variable to the result
    if key == "space" and current_style then
        local flow = current_style.flows[math.random(#current_style.flows)]
        local replaced_flow = flows.parseWords(flow, words)
        local parsed_flow = flows.parseSpecial(replaced_flow)
        joke = parsed_flow
        print(joke)
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
    
    -- if the mouse is hovering over a style's button, set that style's ui_hovering variable to true
    -- if the mouse is not hovering over a style's button, set that style's ui_hovering variable to false
    for name, style in pairs(styles) do
        if mouse_x >= style.ui_buttonx and mouse_x <= style.ui_buttonx + style.ui_buttonw and mouse_y >= style.ui_buttony and mouse_y <= style.ui_buttony + style.ui_buttonh then
            style.ui_hovering = true
        else
            style.ui_hovering = false
        end
    end
    
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        for name, style in pairs(styles) do
            if x >= style.ui_buttonx and x <= style.ui_buttonx + style.ui_buttonw and y >= style.ui_buttony and y <= style.ui_buttony + style.ui_buttonh then
                current_style = style
                style.is_current = true
            else
                style.is_current = false
            end
        end
    end
end

function love.draw()
   if not ui_ready then
        love.graphics.setColor(255, 255, 255)
        -- ubuntu bold, 48, centered, middle of the screen, "loading..."
        love.graphics.setFont(text.loading)
        love.graphics.printf("loading!", 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
        -- ubuntu regular, 16, centered, below the loading message
        love.graphics.setFont(text.regular)
        love.graphics.printf("we're loading the styles and organizing the menu. if this is still hear after one second then your computer is reeeeally slow or a hidden error occured.", 0, love.graphics.getHeight() / 2 + 16, love.graphics.getWidth(), "center")
   else
        -- set color to white
        love.graphics.setColor(255, 255, 255)
        -- ubuntu bold italic, 48px, top left of window with reasonable margin, "packstorm"
        love.graphics.setFont(text.title)
        love.graphics.print("packstorm", 8, 1)
        -- ubuntu mono, small but readable, just under the title, "by hailey#0048"
        love.graphics.setFont(text.debug)
        love.graphics.print("by hailey#0048", 8, 72)

        -- draw the number of styles, total words, nouns, verbs, and adjectives in the top right corner
        -- example: "styles: 1,  words: 1, nouns: 1, verbs: 1, adjectives: 1"
        love.graphics.setFont(text.regular_small)
        love.graphics.print("words: " .. #words.nouns + #words.verbs + #words.adjectives, love.graphics.getWidth() - 128, 24)
        love.graphics.print("nouns: " .. #words.nouns, love.graphics.getWidth() - 128, 40)
        love.graphics.print("verbs: " .. #words.verbs, love.graphics.getWidth() - 128, 56)
        love.graphics.print("adjectives: " .. #words.adjectives, love.graphics.getWidth() - 128, 72)

        love.graphics.setColor(128, 128, 128, 0.25)
        love.graphics.rectangle("fill", 8, love.graphics.getHeight() - 0 - 128, love.graphics.getWidth() - 16, 100)
        love.graphics.setColor(255, 255, 255)

        -- draw the generated pack
        love.graphics.setFont(text.joke)
        love.graphics.print(joke, 16, love.graphics.getHeight() - 0 - 128 + 8)

        -- styles header
        -- ubuntu bold, 32px, above the styles list, "styles"
        love.graphics.setFont(text.header)
        love.graphics.print("styles", 8, 104)
        love.graphics.setFont(text.regular_big)
        -- draw the styles list
        -- every button has a grey filled background and white text
        -- when the mouse is over a button, add a white border
        for name, style in pairs(styles) do
            if style.ui_hovering then
                if style.is_current then
                    love.graphics.setColor(255, 255, 255, 0.85)
                else
                    love.graphics.setColor(128, 128, 128, 0.30)
                end
                love.graphics.rectangle("fill", style.ui_buttonx, style.ui_buttony, style.ui_buttonw, style.ui_buttonh)
                love.graphics.setColor(0, 255, 255, 255)
                love.graphics.rectangle("line", style.ui_buttonx, style.ui_buttony, style.ui_buttonw, style.ui_buttonh)
            else
                if style.is_current then
                    love.graphics.setColor(255, 255, 255, 255)
                else
                    love.graphics.setColor(128, 128, 128, 0.25)
                end
                
                love.graphics.rectangle("fill", style.ui_buttonx, style.ui_buttony, style.ui_buttonw, style.ui_buttonh)
            end
                --white
                if style.is_current then
                    love.graphics.setColor(0, 0, 0, 255)
                    
                else
                    love.graphics.setColor(255, 255, 255, 255)
                end
                love.graphics.print(style.name, style.ui_buttonx + 8, style.ui_buttony + 8)

            if style.ui_hovering then
                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.rectangle("fill", mouse_x + 8, mouse_y + 8, 300 + 16, 150 + 16)
                love.graphics.setColor(0, 255, 255, 255)
                love.graphics.rectangle("line", mouse_x + 8, mouse_y + 8, 300 + 16, 150 + 16)
                love.graphics.setColor(255, 255, 255, 255)
                love.graphics.print(style.author, mouse_x + 12, mouse_y + 12)
                love.graphics.printf(style.description, mouse_x + 12, mouse_y + 16 + love.graphics.getFont():getHeight(style.author), 300, "left")
            end 
        end

        -- draw a long rounded grey rectangle at the bottom middle of the screen with a big margin
        
        
    end
    -- if the user presses f3, toggle the debug overlay in the bottom left 
    if hconf.debug then
        -- ubuntu mono, 16px
        love.graphics.setFont(text.debug)
        love.graphics.setColor(0, 255, 255)
        love.graphics.print("debug! :D", 400, 0)
        love.graphics.print("fps: " .. love.timer.getFPS(), 400, 16)
        -- print the current position of the mouse
        love.graphics.print("mouse: " .. mouse_x .. ", " .. mouse_y, 400, 32)
        -- print the current style
        if current_style then
            love.graphics.print("current style: " .. current_style.name, 400, 48)
        end
    end
end
