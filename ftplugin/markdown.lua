vim.opt_local.modeline = false

local function get_date()
    return os.date("%Y-%m-%d")
end

local function create_abbrev(lhs, rhs)
    vim.cmd(string.format("iabbrev <buffer> <silent> %s %s", lhs, rhs))
end

-- Basic abbreviations
create_abbrev(":u", string.format("📅 %s<Esc>", get_date()))
create_abbrev(":d", string.format("✅ %s<Esc>", get_date()))

-- Complex abbreviations with multiple dates and positioning
create_abbrev(":l", string.format("# ➕ %s 🔽<Esc>15hi", get_date()))
create_abbrev(":m", string.format("# ➕ %s 📅 %s 🔼<Esc>28hi", get_date(), get_date()))
create_abbrev(":h", string.format("# ➕ %s 📅 %s ⏫<Esc>28hi", get_date(), get_date()))
