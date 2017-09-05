-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require "pubnub"
widget=require "widget"



local Count=0

local myText = display.newText( "MESSEGES WILL APPEAR HERE", display.actualContentWidth*0.5, display.actualContentHeight*0.3, native.systemFont, 16 )
myText:setFillColor( 1, 0, 0 )

local myText2 = display.newText( "", display.actualContentWidth*0.5, display.actualContentHeight*0.2, native.systemFont, 16 )
myText2:setFillColor( 1, 0, 0 )

multiplayer = pubnub.new({
    publish_key   = "pub-c-c44cd687-2237-4f28-8839-a83f6800c579",
    subscribe_key = "sub-c-a5ccd1f8-8ced-11e7-91ed-aa3b4df5deac",
    secret_key    = nil,
    ssl           = nil,
    origin        = "pubsub.pubnub.com"
})

multiplayer:subscribe({
    channel  = "Channel1",
    callback = function(message)
        Count=Count+1
        myText.text=message
        print(message)
    end,
    errorback = function()
        print("Oh no!!! Dropped 3G Conection!")
    end
    })


function send_a_message(text)
    multiplayer:publish({
        channel = "Channel1",
        message  = text2,
    callback = function(info) 
 
        -- WAS MESSAGE DELIVERED? 
        if info[1] then
            myText2.text="MESSAGE DELIVERED SUCCESSFULLY!"
            print("MESSAGE DELIVERED SUCCESSFULLY!") 
        else 
            myText2.text="MESSAGE FAILED BECAUSE"
            print("MESSAGE FAILED BECAUSE -> " .. info[2]) 
        end 
        end
    })
end

multiplayer:time(function(time) 
    -- PRINT TIME 
    print("PUBNUB SERVER TIME: " .. time) 
end)


local function textListener( event )
 
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        text2=event.target.text
        send_a_message(text2)
        multiplayer:unsubscribe({ 
        channel = "Channel1" 
        })
        multiplayer:subscribe({
    channel  = "Channel1",
    callback = function(message)
        Count=Count+1
        myText.text=message
        print(message)
    end,
    errorback = function()
        print("Oh no!!! Dropped 3G Conection!")
    end
    })

    elseif ( event.phase == "editing" ) then
    
    end
end

defaultField = native.newTextField( display.actualContentWidth*0.5, display.actualContentHeight*0.5, 180, 30 )
defaultField:addEventListener( "userInput", textListener )