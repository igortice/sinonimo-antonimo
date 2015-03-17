--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:78def81faeafd9bd53f7538c9f198a2d:29002bb2040edd67dee3d8d1950ecb77:9db397ddbdf1447cc67fb2c8acf6179d$
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
            -- cores1
            x=2,
            y=2,
            width=320,
            height=480,

        },
        {
            -- cores2
            x=324,
            y=2,
            width=320,
            height=479,

        },
        {
            -- cores3
            x=646,
            y=2,
            width=319,
            height=479,

        },
    },

    sheetContentWidth = 967,
    sheetContentHeight = 484
}

SheetInfo.frameIndex =
{

    ["cores1"] = 1,
    ["cores2"] = 2,
    ["cores3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
