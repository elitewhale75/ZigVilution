const rl = @import("raylib");

pub fn initVideo() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "ZigDOOM");
    rl.setTargetFPS(35);
}

pub fn updateDisplay() void {
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(.black);

    rl.drawText("ZigDOOM", 190, 200, 20, .red);
}

pub fn closeWindow() void {
    rl.closeWindow();
}

pub fn windowShouldClose() bool {
    return rl.windowShouldClose();
}
