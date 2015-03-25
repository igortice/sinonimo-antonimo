--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:2e8d87be9edf34ba9075dce14433b860:dcd0cb5cdea192ab4bf4e9e373875b44:befb12fafd6522eddf773d8ec8fb1765$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- bg_blue1
            x=2,
            y=2,
            width=320,
            height=480,

        },
        {
            -- bg_blue2
            x=324,
            y=2,
            width=320,
            height=480,

        },
        {
            -- bg_blue3
            x=646,
            y=2,
            width=320,
            height=480,

        },
    },
    
    sheetContentWidth = 968,
    sheetContentHeight = 484
}

SheetInfo.frameIndex =
{

    ["bg_blue1"] = 1,
    ["bg_blue2"] = 2,
    ["bg_blue3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
