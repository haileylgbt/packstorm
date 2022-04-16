-- PACKPARSE
-- Copyright (c) 2022, cudsys studios
-- All rights reserved.
-- shoutouts to tracery

-- a flow is a template that is filled with randomly picked words from the pools
-- flows are processed much like a simplistic version of Tracery
-- example: "You look like a [adjective] [noun]." becomes "You look like a fruity banana."
-- the parser also supports verb tenses.
-- example: "I was [verb]ing away." becomes "I was running away."

grammar = require "grammar"

local packparse = {
    -- parseFlow takes a string (t) and a table of words (w) as input
    -- it then returns a processed string with the words replaced
    -- t needs to be a string and include at least 1 replaceable word
    -- w needs to be a table of words that include a nouns, adjectives, and verbs table
    -- stage 1: word tag replacement
    -- a word tag is a word surrounded by square brackets
    -- example: "[adjective]"
    -- the parser will randomly pick a word from the adjectives table and replace the tag
    -- example: "You look like a [adjective] [noun]." becomes "You look like a fruity banana."
    -- stage 2: special tag replacement
    -- a special tag is a word surrounded by curly brackets
    -- example: "{a/n}"
    -- the parser will replace the tag with something depending on the tag
    -- examples:
    -- "{a/n}" becomes "a" or "an" depending on the context
    -- "{d10}" becomes a random number between 1 and 10
    -- stage 3: grammar fixing
    -- the parser will fix grammar errors in the flow
    -- examples:
    -- "I was runing away." becomes "I was running away."
    -- "I maked a mess." becomes "I made a mess."
    -- "She swimed away." becomes "She swam away."
    parse = function(t, w)
        local r = t
        -- stage 1
        local n = w.nouns
        local a = w.adjectives
        local v = w.verbs
        local nn = #n
        local aa = #a
        local vv = #v
        local rn = math.random(nn)
        local ra = math.random(aa)
        local rv = math.random(vv)
        r = string.gsub(r, "%[noun%]", n[rn])
        r = string.gsub(r, "%[adjective%]", a[ra])
        r = string.gsub(r, "%[verb%]", v[rv])
        -- stage 2
        -- {a/n} becomes "a" or "an" depending on the context
        -- example: "{a/n} apple" becomes "an apple" whereas "{a/n} pineapple" becomes "a pineapple"
        r = string.gsub(r, "%{a/n%}", function()
            -- if the character 2 characters ahead (including space) from the closing curly bracket is a vowel, then return "an"
            if string.sub(r, string.find(r, "%}") + 2, string.find(r, "%}") + 2) == "a" or string.sub(r, string.find(r, "%}") + 2, string.find(r, "%}") + 2) == "e" or string.sub(r, string.find(r, "%}") + 2, string.find(r, "%}") + 2) == "i" or string.sub(r, string.find(r, "%}") + 2, string.find(r, "%}") + 2) == "o" or string.sub(r, string.find(r, "%}") + 2, string.find(r, "%}") + 2) == "u" then
                return "an"
            else
                return "a"
            end
        end)
        r = string.gsub(r, "%{nword%}", "nigga")
        
        -- stage 3
        -- check if a word matches a string with an odd index from the grammar table.
        -- if it is, replace it with the string next in the table
        -- if a word matches a string with an even index from the grammar table, then do nothing

        -- check for odd index
        for i = 1, #grammar, 2 do
            if string.find(r, grammar[i]) then
                r = string.gsub(r, grammar[i], grammar[i + 1])
            end
        end
        return r
    end
    

    
    


}   

return packparse


    --[[ parseFlow = function(t, w)
        local r = t
        local n = w.nouns
        local a = w.adjectives
        local v = w.verbs
        local nn = #n
        local aa = #a
        local vv = #v
        local rn = math.random(nn)
        local ra = math.random(aa)
        local rv = math.random(vv)
        r = string.gsub(r, "%[noun%]", n[rn])
        r = string.gsub(r, "%[adjective%]", a[ra])
        r = string.gsub(r, "%[verb%]", v[rv])
        return r
    end ]]