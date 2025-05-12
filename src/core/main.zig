const video = @import("video");
const wad = @import("wad");

fn doomLoop() !void {
    while (!video.windowShouldClose()) {
        try video.updateDisplay();
    }
}

pub fn main() !void {

    // Initialize subsystems
    try video.initVideo();
    defer video.closeWindow();
    try wad.initWad();

    // Main Loop
    try doomLoop();
}
