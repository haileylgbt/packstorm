-- PACKPARSE
-- Copyright (c) 2022, cudsys studios
-- All rights reserved.
-- shoutouts to tracery

-- a flow is a template that is filled with randomly picked words from the pools
-- flows are processed much like a simplistic version of Tracery
-- example: "You look like a [adjective] [noun]." becomes "You look like a fruity banana."
-- the parser also supports verb tenses.
-- example: "I was [verb]ing away." becomes "I was running away."

local packparse = {

    -- parseFlow takes a string (t) and a table of words (w) as input
    -- it then returns a processed string with the words replaced
    -- t needs to be a string and include at least 1 replaceable word
    -- w needs to be a table of words that include a nouns, adjectives, and verbs table
    parseWords = function(t, w)
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
    end,

    -- parseSpecial takes a string (t) as input
    -- it then returns a string with the special tags replaced
    -- t needs to be a string and include at least 1 replaceable word
    -- special tags:
    -- {a/n} - is replaced with "a" or "an" depending on the next word
    parseSpecial = function(t)
        local r = t
        -- {a/n} - if the next word starts with a vowel, replace with "an"
        --       - if the next word starts with a consonant, replace with "a"
        -- locate the special tag
        local s = string.find(r, "%{a/n%}")
        -- keep track of the position of the special tag
        local s_pos = s
        -- look at the next letter after the special tag
        local s_next = string.sub(r, s + 1, s + 1)
        -- if the next letter is a, e, i, o,
        return r 
    end
    

    -- fixGrammar takes a string (t) as input
    -- it then returns a processed string with corrected grammar
    -- t needs to be a string
    -- the function correct most common grammar errors that will most likely appear in a parsed flow
    -- errors it covers:
    --  - verb tenses: fixes the spelling of verbs in past or present tense
    --      - "-eing" -> "-ing"
    --      - "makeed" -> "made"
    --      - "-ming" or "-ning" -> "-mming" or "-nning"
    --      - "-med" or "ned" -> "-am"
    --      - and so on
    --  - more will be added as I find them

    
    


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