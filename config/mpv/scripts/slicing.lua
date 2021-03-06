local msg = require "mp.msg"
local utils = require "mp.utils"
local options = require "mp.options"

local cut_pos = nil
local copy_audio = true
local o = {
    target_dir = "~",
    vcodec = "",
    acodec = "",
    prevf = "",
    vf = "",
    hqvf = "",
    postvf = "",
    opts = "",
    ext = "mp4",
    command_template = [[
        ffmpeg -v warning -y -stats
        -ss $shift -i '$in' -t $duration
        -c:v copy -c:a copy  '$out.$ext'
    ]],
}
options.read_options(o)

function timestamp(duration)
    local hours = duration / 3600
    local minutes = duration % 3600 / 60
    local seconds = duration % 60
    return string.format("%02d:%02d:%02.03f", hours, minutes, seconds)
end

function makeString(l)
        if l < 1 then return nil end -- Check for l < 1
        local s = "" -- Start string
        for i = 1, l do
                s = s .. string.char(math.random(48, 57)) -- Generate random number from 32 to 126, turn it into character and add to string
        end
        return s -- Return string
end

function osd(str)
    return mp.osd_message(str, 3)
end

function log(str)
    local logpath = string.format("%s/%s",
        o.target_dir:gsub("~", os.getenv("HOME")),
        "mpv_slicing.log")
    f = io.open(logpath, "a")
    f:write(string.format("# %s\n%s\n",
        os.date("%Y-%m-%d %H:%M:%S"),
        str))
    f:close()
end

function escape(str)
    return str:gsub("\\", "\\\\"):gsub("'", "'\\''")
end

function trim(str)
    return str:gsub("^%s+", ""):gsub("%s+$", "")
end

function get_csp()
    local csp = mp.get_property("colormatrix")
    if csp == "bt.601" then return "bt601"
        elseif csp == "bt.709" then return "bt709"
        elseif csp == "smpte-240m" then return "smpte240m"
        else
            local err = "Unknown colorspace: " .. csp
            osd(err)
            error(err)
    end
end

function get_outname(shift, endpos)
    local name = mp.get_property("filename")
    name = makeString(10) .. name
    return name
end

function cut(shift, endpos)
    local cmd = trim(o.command_template:gsub("%s+", " "))
    local inpath = escape(utils.join_path(
        utils.getcwd(),
        mp.get_property("stream-path")))
    -- TODO: Windows?
    local outpath = escape(string.format("%s/%s",
        o.target_dir:gsub("~", "/mnt/coffre1/downloadsP/cuted/"),
        get_outname(shift, endpos)))

    cmd = cmd:gsub("$shift", shift)
    cmd = cmd:gsub("$duration", endpos - shift)
    cmd = cmd:gsub("$vcodec", o.vcodec)
    cmd = cmd:gsub("$acodec", o.acodec)
    cmd = cmd:gsub("$audio", copy_audio and "" or "-an")
    cmd = cmd:gsub("$prevf", o.prevf)
    cmd = cmd:gsub("$vf", o.vf)
    cmd = cmd:gsub("$hqvf", o.hqvf)
    cmd = cmd:gsub("$postvf", o.postvf)
    cmd = cmd:gsub("$matrix", get_csp())
    cmd = cmd:gsub("$opts", o.opts)
    -- Beware that input/out filename may contain replacing patterns.
    cmd = cmd:gsub("$ext", o.ext)
    cmd = cmd:gsub("$out", outpath)
    cmd = cmd:gsub("$in", inpath, 1)

    msg.info(cmd)
    log(cmd)
    os.execute(cmd)
end

function toggle_mark()
    local pos = mp.get_property_number("time-pos")
    if cut_pos then
        local shift, endpos = cut_pos, pos
        if shift > endpos then
            shift, endpos = endpos, shift
        end
        if shift == endpos then
            osd("Cut fragment is empty")
        else
            cut_pos = nil
            osd(string.format("Cut fragment: %s - %s",
                timestamp(shift),
                timestamp(endpos)))
            cut(shift, endpos)
        end
    else
        cut_pos = pos
        osd(string.format("Marked %s as start position", timestamp(pos)))
    end
end

function toggle_audio()
    copy_audio = not copy_audio
    osd("Audio capturing is " .. (copy_audio and "enabled" or "disabled"))
end

mp.add_key_binding("c", "slicing_mark", toggle_mark)
mp.add_key_binding("a", "slicing_audio", toggle_audio)
