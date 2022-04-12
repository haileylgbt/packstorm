-- a flow is a template that is filled with randomly picked words from the pools
-- flows are processed much like a simplistic version of Tracery
-- example: "You look like a [adjective] [noun]." becomes "You look like a fruity banana."
-- the parser also supports verb tenses.
-- example: "I was [verb]ing away." becomes "I was running away."

local flow = {

    -- parseFlow takes a string (t) and a table of words (w) as input
    -- it then returns a processed string with the words replaced
    -- t needs to be a string and include at least 1 replaceable word
    -- w needs to be a table of words that include a nouns, adjectives, and verbs table
    -- if the replaeable word is a verb ending with an e that's immediately followed by "ing", it will be replaced with the verb in the past tense
    -- words surrounded by curly braces are special and are affected by certain conditions
    -- example: {a/n} will either be "a" or "an" depending on if the next letter is a vowel or not
    parseFlow = function(t, w)
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
        r = string.gsub(r, "%{a/n%}", string.sub(n[rn], 1, 1) == "a" and "an" or "a")
        return r
    end

    -- this is like my 10th time rewriting this function and for some reason this is the one that works so we're rolling with it
    
    


}   

return flow


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