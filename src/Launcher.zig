const builtin = @import("builtin");
const std = @import("std");
const log = std.log.scoped(.launcher);

const CompLevel = @import("viletech").CompLevel;
const c = @import("cimport.h");
const imgui = @import("viletech").imgui;
const im = imgui.h;

const imimpl = struct {
    pub const gl3 = struct {
        pub fn init() bool {
            return c.ImGui_ImplOpenGL3_Init(null);
        }

        pub fn newFrame() void {
            return c.ImGui_ImplOpenGL3_NewFrame();
        }

        pub fn renderDrawData() void {
            c.ImGui_ImplOpenGL3_RenderDrawData(c.igGetDrawData());
        }

        pub fn shutdown() void {
            return c.ImGui_ImplOpenGL3_Shutdown();
        }
    };

    pub const sdl2 = struct {
        pub fn init(window: *c.SDL_Window, renderer: ?*c.SDL_Renderer, sdl_gl_context: ?*anyopaque) bool {
            return if (renderer) |r|
                c.ImGui_ImplSDL2_InitForSDLRenderer(window, r)
            else
                c.ImGui_ImplSDL2_InitForOpenGL(window, sdl_gl_context);
        }

        pub fn newFrame() void {
            return c.ImGui_ImplSDL2_NewFrame();
        }

        pub fn processEvent(event: *const c.SDL_Event) bool {
            return c.ImGui_ImplSDL2_ProcessEvent(event);
        }

        pub fn shutdown() void {
            return c.ImGui_ImplSDL2_Shutdown();
        }
    };

    pub const sdl2_renderer = struct {
        pub fn init(renderer: *c.SDL_Renderer) bool {
            return ImGui_ImplSDLRenderer2_Init(renderer);
        }

        pub fn newFrame() void {
            return ImGui_ImplSDLRenderer2_NewFrame();
        }

        pub fn renderDrawData(renderer: *c.SDL_Renderer) void {
            ImGui_ImplSDLRenderer2_RenderDrawData(im.igGetDrawData(), renderer);
        }

        pub fn shutdown() void {
            return ImGui_ImplSDLRenderer2_Shutdown();
        }

        extern "c" fn ImGui_ImplSDLRenderer2_Init(*c.SDL_Renderer) bool;
        extern "c" fn ImGui_ImplSDLRenderer2_Shutdown() void;
        extern "c" fn ImGui_ImplSDLRenderer2_NewFrame() void;
        extern "c" fn ImGui_ImplSDLRenderer2_RenderDrawData(*im.ImDrawData, *c.SDL_Renderer) void;

        extern "c" fn ImGui_ImplSDLRenderer2_CreateFontsTexture() bool;
        extern "c" fn ImGui_ImplSDLRenderer2_DestroyFontsTexture() void;
        extern "c" fn ImGui_ImplSDLRenderer2_CreateDeviceObjects() bool;
        extern "c" fn ImGui_ImplSDLRenderer2_DestroyDeviceObjects() void;
    };
};

const sdl = struct {
    // TODO: when migrating to SDL3, move all this to a new file...

    pub const Error = error{
        RendererInit,
        SdlInit,
        SetRenderDrawColor,
        WindowInit,
    };

    var report_err_render_clear = std.once(struct {
        fn func() void {
            const err = std.mem.span(c.SDL_GetError());

            if (!std.mem.endsWith(u8, err, "undefined symbol: _udev_device_get_action")) {
                log.err("Failed to clear renderer; {s}", .{err});
            }
        }
    }.func);

    var report_err_set_render_draw_color = std.once(struct {
        fn func() void {
            log.err("Failed to set render draw color; {s}", .{std.mem.span(c.SDL_GetError())});
        }
    }.func);

    var report_err_set_render_scale = std.once(struct {
        fn func() void {
            const err = std.mem.span(c.SDL_GetError());

            if (!std.mem.endsWith(u8, err, "undefined symbol: _udev_device_get_action")) {
                log.err("Failed to set render scale; {s}", .{err});
            }
        }
    }.func);
};

const Self = @This();

const Skill = enum(u8) {
    ittyd = 1,
    hntr = 2,
    hmp = 3,
    uv = 4,
    nm = 5,
};

const Preset = struct {
    const Raw = struct {
        compatibility: CompLevel = .mbf21,
        files: []const [:0]const u8 = &.{},
        iwad: usize = 0,
        music: bool = true,
        name: [:0]const u8 = "New Preset",
        primary_file: ?usize = null,
        sfx: bool = true,
        skill: Skill = .uv,
        sound: bool = true,
    };

    const default_name = "New Preset";

    compatibility: CompLevel,
    files: std.ArrayListUnmanaged([:0]const u8),
    iwad: usize,
    music: bool,
    name: [:0]const u8,
    primary_file: ?usize,
    sfx: bool,
    skill: Skill,
    sound: bool,

    fn deinit(self: *Preset, gpa: std.mem.Allocator) void {
        defer self.* = undefined;

        if (self.name.ptr != default_name)
            gpa.free(self.name);

        for (self.files.items) |path| {
            gpa.free(path);
        }
        self.files.deinit(gpa);
    }

    fn default() Preset {
        return Preset{
            .compatibility = .mbf21,
            .files = .empty,
            .iwad = 0,
            .primary_file = null,
            .music = true,
            .name = default_name,
            .sfx = true,
            .skill = .uv,
            .sound = true,
        };
    }

    pub fn jsonStringify(self: *const Preset, jw: anytype) !void {
        try jw.beginObject();

        inline for (@typeInfo(@This()).@"struct".fields) |field| {
            try jw.objectField(field.name);

            if (comptime std.mem.indexOf(u8, @typeName(field.type), "ArrayList") != null)
                try jw.write(@field(self, field.name).items)
            else
                try jw.write(@field(self, field.name));
        }

        try jw.endObject();
    }
};

const Configuration = struct {
    const Raw = struct {
        presets: []const Preset.Raw = &.{},
        iwads: []const [:0]const u8 = &.{},
        cur_preset: usize = 0,
    };

    cur_preset: usize,
    iwads: std.ArrayListUnmanaged([:0]const u8),
    presets: std.ArrayListUnmanaged(Preset),

    fn deinit(self: *Configuration, gpa: std.mem.Allocator) void {
        defer self.* = undefined;

        for (self.iwads.items) |path| {
            gpa.free(path);
        }
        self.iwads.deinit(gpa);

        for (self.presets.items) |*preset| {
            preset.deinit(gpa);
        }
        self.presets.deinit(gpa);
    }

    pub fn jsonStringify(self: *const Configuration, jw: anytype) !void {
        try jw.beginObject();

        inline for (@typeInfo(@This()).@"struct".fields) |field| {
            try jw.objectField(field.name);

            if (comptime std.mem.indexOf(u8, @typeName(field.type), "ArrayList") != null)
                try jw.write(@field(self, field.name).items)
            else
                try jw.write(@field(self, field.name));
        }

        try jw.endObject();
    }
};

pub const Error = error{
    ImplSdl2Init,
    ImplSdl2RendererInit,
    StreamTooLong,
} || std.mem.Allocator.Error || std.fmt.AllocPrintError || std.fmt.BufPrintError ||
    std.fs.File.OpenError || std.fs.File.ReadError || std.fs.File.WriteError ||
    std.json.ParseError(std.json.Scanner) || std.json.ParseFromValueError ||
    imgui.Error || sdl.Error;

cfg: Configuration,
file_select: *imgui.SelectionBasicStorage,
gpa: std.mem.Allocator,
im_ctx: *imgui.Context,
imgui_demo: bool = false,
renderer: *c.SDL_Renderer,
window: *c.SDL_Window,
window_id: c.Uint32,

pub fn init(gpa: std.mem.Allocator) Error!Self {
    const start_instant = std.time.Instant.now() catch null;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const user_dir = std.mem.span(c.I_ConfigDir());
    var new_config = false;

    var buf: [std.fs.max_path_bytes:0]u8 = undefined;
    const cfg_path = std.fmt.bufPrintZ(
        buf[0..],
        "{s}{c}launcher.json",
        .{ user_dir, std.fs.path.sep },
    ) catch |err| {
        // TODO: Windows users should get a friendly pop-up or some such.
        log.err("Config. folder path longer than system maximum: {s}", .{user_dir});
        return err;
    };

    var cfg_file = std.fs.openFileAbsolute(
        cfg_path,
        .{ .mode = .read_write },
    ) catch |err| switch (err) {
        error.FileNotFound => blk: {
            var f = try std.fs.createFileAbsolute(cfg_path, .{ .read = true });
            try f.writeAll("{}\n");
            new_config = true;
            break :blk f;
        },
        else => return err,
    };
    defer cfg_file.close();

    var cfg_txt = std.ArrayList(u8).init(arena.allocator());
    // defer cfg_txt.deinit(); Unnecessary because of arena.
    try cfg_file.reader().readAllArrayList(&cfg_txt, 1024 * 1024);
    const cfg_txt_z = try cfg_txt.toOwnedSliceSentinel(0);

    const cfg_raw = if (cfg_txt_z.len <= 2)
        Configuration.Raw{}
    else
        try std.json.parseFromSliceLeaky(
            Configuration.Raw,
            arena.allocator(),
            cfg_txt_z,
            .{},
        );

    if (c.SDL_Init(c.SDL_INIT_VIDEO | c.SDL_INIT_TIMER | c.SDL_INIT_GAMECONTROLLER) != 0) {
        return error.SdlInit;
    }
    errdefer c.SDL_Quit();

    const window = c.SDL_CreateWindow(
        // TODO: append version to window title.
        "VileTech Launcher",
        // TODO: `viletech/launcher.json` config file for this stuff?
        c.SDL_WINDOWPOS_CENTERED,
        c.SDL_WINDOWPOS_CENTERED,
        800,
        600,
        c.SDL_WINDOW_RESIZABLE | c.SDL_WINDOW_SHOWN,
    ) orelse return error.WindowInit;
    errdefer c.SDL_DestroyWindow(window);
    const window_id = c.SDL_GetWindowID(window);

    const renderer = c.SDL_CreateRenderer(
        window,
        -1,
        c.SDL_RENDERER_PRESENTVSYNC | c.SDL_RENDERER_ACCELERATED,
    ) orelse return error.RendererInit;
    errdefer c.SDL_DestroyRenderer(renderer);

    const im_ctx = try imgui.Context.init();
    errdefer im_ctx.deinit();

    const ret = Self{
        .cfg = Configuration{
            .iwads = blk: {
                var iwads = try std.ArrayListUnmanaged([:0]const u8)
                    .initCapacity(gpa, cfg_raw.iwads.len);

                for (cfg_raw.iwads) |path| {
                    try iwads.append(gpa, try gpa.dupeZ(u8, path));
                }

                break :blk iwads;
            },
            .presets = blk0: {
                var presets = try std.ArrayListUnmanaged(Preset)
                    .initCapacity(gpa, cfg_raw.presets.len);

                for (cfg_raw.presets) |preset| {
                    try presets.append(gpa, Preset{
                        .compatibility = preset.compatibility,
                        .files = blk1: {
                            var files = try std.ArrayListUnmanaged([:0]const u8)
                                .initCapacity(gpa, preset.files.len);

                            for (preset.files) |path| {
                                try files.append(gpa, try gpa.dupeZ(u8, path));
                            }

                            break :blk1 files;
                        },
                        .iwad = preset.iwad,
                        .music = preset.music,
                        .name = try gpa.dupeZ(u8, preset.name),
                        .primary_file = preset.primary_file,
                        .sfx = preset.sfx,
                        .skill = preset.skill,
                        .sound = preset.sound,
                    });
                }

                break :blk0 presets;
            },
            .cur_preset = cfg_raw.cur_preset,
        },
        .file_select = try imgui.SelectionBasicStorage.init(),
        .gpa = gpa,
        .im_ctx = im_ctx,
        .renderer = renderer,
        .window = window,
        .window_id = window_id,
    };

    set_window_icon: {
        const bytes = @embedFile("viletech.png");
        const rwop = c.SDL_RWFromConstMem(bytes.ptr, @intCast(bytes.len));

        if (rwop == null) {
            log.err(
                "Failed to set window icon; {s}",
                .{std.mem.span(c.SDL_GetError())},
            );
            break :set_window_icon;
        }
        defer _ = c.SDL_RWclose(rwop);

        const surface = c.IMG_LoadPNG_RW(rwop);

        if (surface == null) {
            log.err(
                "Failed to read window icon PNG: {s}",
                .{std.mem.span(c.IMG_GetError())},
            );
            break :set_window_icon;
        }
        defer c.SDL_FreeSurface(surface);

        c.SDL_SetWindowIcon(ret.window, surface);
    }

    if (!imimpl.sdl2.init(window, renderer, null))
        return error.ImplSdl2Init;
    errdefer imimpl.sdl2.shutdown();

    if (!imimpl.sdl2_renderer.init(renderer))
        return error.ImplSdl2RendererInit;
    errdefer imimpl.sdl2_renderer.shutdown();

    const io: *im.ImGuiIO = im.igGetIO().?;
    const ini_path = try std.fmt.allocPrintZ(
        // TODO: re-architect so the main core can be initialized earlier for cheap,
        // allowing us to use its long-term arena here.
        std.heap.c_allocator,
        "{s}{c}imgui.ini",
        .{ std.mem.span(c.I_ConfigDir()), std.fs.path.sep },
    );
    io.IniFilename = ini_path.ptr;
    io.ConfigFlags |= im.ImGuiConfigFlags_DockingEnable |
        im.ImGuiConfigFlags_NavEnableKeyboard |
        im.ImGuiConfigFlags_NavEnableGamepad;
    im.igStyleColorsDark(null);

    if (std.time.Instant.now() catch null) |i| {
        const elapsed = i.since(start_instant.?);
        log.info("Launcher start-up took {} ms", .{elapsed / std.time.ns_per_ms});
    }

    return ret;
}

pub fn deinit(self: *Self) void {
    defer self.* = undefined;
    imimpl.sdl2_renderer.shutdown();
    imimpl.sdl2.shutdown();
    self.im_ctx.deinit();
    c.SDL_DestroyRenderer(self.renderer);
    c.SDL_DestroyWindow(self.window);
    c.SDL_Quit();
    self.cfg.deinit(self.gpa);
}

pub fn cArguments(
    self: *const Self,
    arena: std.mem.Allocator,
) std.mem.Allocator.Error!std.ArrayList([*:0]u8) {
    std.debug.assert(self.cfg.presets.items.len > 0);
    const preset = &self.cfg.presets.items[self.cfg.cur_preset];

    var ret = std.ArrayList([*:0]u8).init(arena);

    try ret.append(try arena.dupeZ(u8, "-iwad"));
    try ret.append((try arena.dupeZ(u8, self.cfg.iwads.items[preset.iwad])).ptr);

    try ret.append(try arena.dupeZ(u8, "-cl"));
    try ret.append(try std.fmt.allocPrintZ(
        arena,
        "{}",
        .{@intFromEnum(preset.compatibility)},
    ));

    if (preset.files.items.len > 0)
        try ret.append(try arena.dupeZ(u8, "-file"));

    for (preset.files.items) |path|
        try ret.append((try arena.dupeZ(u8, path)).ptr);

    if (preset.primary_file) |prim| {
        try ret.append(try arena.dupeZ(u8, "-data"));

        const data_dir = try std.fmt.allocPrintZ(
            arena,
            "{s}{c}{s}{c}{s}",
            .{
                c.I_ConfigDir(),
                std.fs.path.sep,
                std.fs.path.stem(self.cfg.iwads.items[preset.iwad]),
                std.fs.path.sep,
                std.fs.path.stem(preset.files.items[prim]),
            },
        );

        std.mem.replaceScalar(u8, data_dir, ' ', '-');

        for (data_dir, 0..) |char, i|
            data_dir[i] = std.ascii.toLower(char);

        try ret.append(data_dir.ptr);
    }

    if (!preset.sound) {
        try ret.append(try arena.dupeZ(u8, "-nosound"));
    } else {
        if (!preset.music) {
            try ret.append(try arena.dupeZ(u8, "-nomusic"));
        }

        if (!preset.sfx) {
            try ret.append(try arena.dupeZ(u8, "-nosfx"));
        }
    }

    return ret;
}

pub fn saveConfig(self: *Self) Error!void {
    const user_dir = std.mem.span(c.I_ConfigDir());

    var buf: [std.fs.max_path_bytes:0]u8 = undefined;
    const cfg_path = std.fmt.bufPrintZ(
        buf[0..],
        "{s}{c}launcher.json",
        .{ user_dir, std.fs.path.sep },
    ) catch |err| {
        // TODO: Windows users should get a friendly pop-up or some such.
        log.err("Config. folder path longer than system maximum: {s}", .{user_dir});
        return err;
    };

    var cfg_file = try std.fs.createFileAbsolute(cfg_path, .{});
    defer cfg_file.close();

    try std.json.stringify(self.cfg, .{ .whitespace = .indent_4 }, cfg_file.writer());
}

/// Returns `false` if the user closes the launcher.
pub fn loop(self: *Self) Error!bool {
    const io: *im.ImGuiIO = im.igGetIO().?;

    outer: while (true) {
        var event: c.SDL_Event = undefined;

        while (c.SDL_PollEvent(&event) != 0) {
            _ = imimpl.sdl2.processEvent(&event);

            switch (@as(c_int, @intCast(event.type))) {
                c.SDL_QUIT => return false,
                c.SDL_WINDOWEVENT => {
                    if (event.window.windowID == self.window_id) {
                        switch (event.window.event) {
                            else => {},
                        }
                    }
                },
                else => {},
            }
        }

        if ((c.SDL_GetWindowFlags(self.window) & c.SDL_WINDOW_MINIMIZED) != 0) {
            c.SDL_Delay(10);
            continue :outer;
        }

        imimpl.sdl2_renderer.newFrame();
        imimpl.sdl2.newFrame();
        im.igNewFrame();

        defer {
            im.igRender();

            if (c.SDL_RenderSetScale(
                self.renderer,
                io.DisplayFramebufferScale.x,
                io.DisplayFramebufferScale.y,
            ) == 0) {
                sdl.report_err_set_render_scale.call();
            }

            if (c.SDL_RenderClear(self.renderer) == 0) {
                sdl.report_err_render_clear.call();
            }

            imimpl.sdl2_renderer.renderDrawData(self.renderer);
            c.SDL_RenderPresent(self.renderer);
        }

        if (builtin.mode == .Debug and self.imgui_demo) {
            im.igShowDemoWindow(&self.imgui_demo);
        }

        const dock_id = im.igDockSpaceOverViewport(
            0,
            im.igGetMainViewport(),
            im.ImGuiDockNodeFlags_None,
            null,
        );
        _ = dock_id;

        if (im.igBeginMainMenuBar()) {
            defer im.igEndMainMenuBar();

            if (im.igMenuItem_Bool("Exit", null, false, true)) {
                return false;
            }

            if (im.igMenuItem_Bool(
                "Start",
                null,
                false,
                self.cfg.presets.items.len > 0 and self.cfg.iwads.items.len > 0,
            )) {
                break :outer;
            }

            if (builtin.mode == .Debug) {
                _ = im.igCheckbox("ImGui Demo", &self.imgui_demo);
            }
        }

        // TODO: if user config is freshly-generated, these windows will all be
        // floating. Preferably, detect when this is the case and dock them all.

        if (im.igBegin("Presets", null, im.ImGuiWindowFlags_MenuBar)) {
            try self.layoutPresetWindow();
        }
        im.igEnd();

        if (im.igBegin("Load Order", null, im.ImGuiWindowFlags_MenuBar)) {
            self.layoutLoadOrderWindow();
        }
        im.igEnd();

        if (im.igBegin("Settings", null, im.ImGuiWindowFlags_None)) {
            self.layoutSettingsWindow();
        }
        im.igEnd();
    }

    return true;
}

fn layoutLoadOrderWindow(self: *Self) void {
    var default_preset = Preset.default();
    const preset = self.currentPreset(&default_preset);
    im.igBeginDisabled(self.cfg.presets.items.len < 1);
    defer im.igEndDisabled();

    var iwad_buf = std.mem.zeroes([std.fs.max_path_bytes:0]u8);
    var fba = std.heap.FixedBufferAllocator.init(iwad_buf[0..]);

    im.igSeparatorText("IWAD");

    for (self.cfg.iwads.items, 0..) |path, i| {
        defer fba.reset();
        const basename = fba.allocator().dupeZ(u8, std.fs.path.basename(path)) catch path;
        if (im.igSelectable_Bool(
            basename.ptr,
            preset.iwad == i,
            im.ImGuiSelectableFlags_None,
            .{},
        )) preset.iwad = i;

        if (im.igIsItemHovered(
            im.ImGuiHoveredFlags_DelayShort | im.ImGuiHoveredFlags_NoSharedDelay,
        )) {
            im.igSetTooltip("%s", path.ptr);
        }
    }

    if (im.igButton("Add", .{})) {
        // TODO: migrate from SDL2 to 3, use its file dialog API here.
    }

    im.igSeparatorText("PWADs");

    var ms_io = im.igBeginMultiSelect(
        im.ImGuiMultiSelectFlags_None,
        self.file_select.size,
        @intCast(preset.files.items.len),
    ).?;
    self.file_select.applyRequests(@ptrCast(ms_io));

    for (preset.files.items, 0..) |path, i| {
        defer fba.reset();
        const basename = fba.allocator().dupeZ(u8, std.fs.path.basename(path)) catch path;
        const id = imgui.Id.from(i);

        im.igPushID_Int(@intCast(i));
        self.file_select.setItemSelected(id, im.igSelectable_Bool(
            basename.ptr,
            self.file_select.contains(id),
            im.ImGuiSelectableFlags_None,
            .{},
        ));
        im.igPopID();

        if (im.igBeginPopupContextItem(null, im.ImGuiPopupFlags_MouseButtonRight)) {
            defer im.igEndPopup();

            if (im.igButton("Delete", .{})) {
                // TODO
            }

            if (im.igButton("Move Up", .{})) {
                // TODO
            }

            if (im.igButton("Move Down", .{})) {
                // TODO
            }

            if (im.igButton("Show in File Explorer", .{})) {
                switch (builtin.os.tag) {
                    .linux => blk: {
                        const dirname = std.fs.path.dirname(path) orelse break :blk;

                        const rr = std.process.Child.run(.{
                            .allocator = self.gpa,
                            .argv = &.{ "xdg-open", dirname },
                        }) catch break :blk; // TODO: notify user of error via some kind of pop-up.

                        _ = rr;
                    },
                    else => {}, // TODO: notify user this OS is unsupported via some kind of pop-up.
                }
            }
        }

        if (im.igIsItemHovered(
            im.ImGuiHoveredFlags_DelayShort | im.ImGuiHoveredFlags_NoSharedDelay,
        )) {
            im.igSetTooltip("%s", path.ptr);
        }

        imgui.sameLine(.{});
        const is_primary = if (preset.primary_file) |p| p == i else false;

        if (im.igRadioButton_Bool("Primary", is_primary))
            preset.primary_file = i;
    }

    ms_io = im.igEndMultiSelect();
    self.file_select.applyRequests(@ptrCast(ms_io));

    if (im.igButton("Add File", .{})) {
        // TODO: migrate from SDL2 to 3, use its file dialog API here.
    }

    imgui.sameLine(.{});

    if (im.igButton("Add Folder", .{})) {
        // TODO: migrate from SDL2 to 3, use its file dialog API here.
    }
}

fn layoutPresetWindow(self: *Self) Error!void {
    if (im.igBeginMenuBar()) {
        defer im.igEndMenuBar();

        if (im.igButton("New##launcher.presets.new", .{})) {
            self.cfg.cur_preset = self.cfg.presets.items.len;
            try self.cfg.presets.append(self.gpa, Preset.default());
        }
    }

    var sfa = std.heap.stackFallback(1024, self.gpa);
    const allo = sfa.get();

    for (self.cfg.presets.items, 0..) |*preset, i| {
        const name = try std.fmt.allocPrintZ(allo, "{s}##preset[{}]", .{ preset.name, i });
        defer allo.free(name);

        if (im.igSelectable_Bool(
            name,
            self.cfg.cur_preset == i,
            im.ImGuiSelectableFlags_None,
            .{},
        )) self.cfg.cur_preset = i;
    }
}

fn layoutSettingsWindow(self: *Self) void {
    var default_preset = Preset.default();
    const preset = self.currentPreset(&default_preset);
    im.igBeginDisabled(self.cfg.presets.items.len < 1);
    defer im.igEndDisabled();

    if (im.igTreeNode_Str("Audio")) {
        defer im.igTreePop();

        _ = im.igCheckbox("All Sound", &preset.sound);
        imgui.sameLine(.{});

        im.igBeginDisabled(!preset.sound);
        _ = im.igCheckbox("Music", &preset.music);
        imgui.sameLine(.{});
        _ = im.igCheckbox("Sound Effects", &preset.sfx);
        im.igEndDisabled();
    }

    if (im.igTreeNode_Str("Graphics")) {
        defer im.igTreePop();
    }

    im.igSetNextItemOpen(true, im.ImGuiCond_Once);

    if (im.igTreeNode_Str("Gameplay")) {
        defer im.igTreePop();

        const skill_choices: []const struct { [:0]const u8, Skill } = &.{
            .{ "1: I'm Too Young to Die", .ittyd },
            .{ "2: Hey, Not Too Rough", .hntr },
            .{ "3: Hurt Me Plenty", .hmp },
            .{ "4: Ultra-Violence", .uv },
            .{ "5: Nightmare!", .nm },
        };

        if (im.igBeginCombo(
            "Skill",
            skill_choices[@intFromEnum(preset.skill) - 1].@"0",
            im.ImGuiComboFlags_None,
        )) {
            defer im.igEndCombo();

            for (skill_choices) |choice| {
                if (im.igSelectable_Bool(
                    choice.@"0",
                    preset.skill == choice.@"1",
                    im.ImGuiSelectableFlags_None,
                    .{},
                )) preset.skill = choice.@"1";
            }
        }

        const complevel_choices: []const struct { [:0]const u8, CompLevel } = &.{
            .{ "2: Doom 2", .doom2_v1_9 },
            .{ "3: Ultimate Doom", .ult_doom },
            .{ "4: Final Doom", .final_doom },
            .{ "11: MBF", .mbf },
            .{ "21: MBF21", .mbf21 },
        };

        if (im.igBeginCombo(
            "Compatibility",
            preset.compatibility.prettyName(),
            im.ImGuiComboFlags_None,
        )) {
            defer im.igEndCombo();

            for (complevel_choices) |choice| {
                if (im.igSelectable_Bool(
                    choice.@"0",
                    preset.compatibility == choice.@"1",
                    im.ImGuiSelectableFlags_None,
                    .{},
                )) preset.compatibility = choice.@"1";
            }
        }
    }

    if (im.igTreeNode_Str("Demo Sync")) {
        defer im.igTreePop();
    }
}

fn currentPreset(self: *Self, default: *Preset) *Preset {
    // By now, if no game presets exist, `cur_preset` should be zero.
    if (self.cfg.cur_preset >= self.cfg.presets.items.len)
        return default;
    return &self.cfg.presets.items[self.cfg.cur_preset];
}
