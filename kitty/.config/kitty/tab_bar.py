from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb

LEFT = ""
RIGHT = ""

C_ACTIVE_BG = as_rgb(0x7AA2F7)
C_ACTIVE_FG = as_rgb(0x1F2335)
C_INACTIVE_BG = as_rgb(0x3B4261)
C_INACTIVE_FG = as_rgb(0x636DA6)
C_BAR_BG = as_rgb(0x1D202F)
C_ACCENT = as_rgb(0x9ECE6A)

ICONS = {
    "nvim": "",
    "vim": "",
    "git": "",
    "lazygit": "",
    "python": "",
    "python3": "",
    "ipython": "",
    "node": "",
    "npm": "",
    "docker": "",
    "ssh": "",
    "cargo": "",
    "rustc": "",
    "go": "",
    "htop": "",
    "btop": "",
    "top": "",
    "make": "",
    "cmake": "",
    "lua": "",
    "ruby": "",
    "java": "",
}
ICON_DEFAULT = ""


def _icon(title):
    if not title:
        return ICON_DEFAULT
    cmd = title.strip().split()[0].split("/")[-1].lower()
    if cmd in ICONS:
        return ICONS[cmd]
    for prefix in ("python", "node", "ruby"):
        if cmd.startswith(prefix):
            return ICONS[prefix]
    return ICON_DEFAULT


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    tab_bg = C_ACTIVE_BG if tab.is_active else C_INACTIVE_BG
    tab_fg = C_ACTIVE_FG if tab.is_active else C_INACTIVE_FG

    # Left rounded cap
    screen.cursor.fg = tab_bg
    screen.cursor.bg = C_BAR_BG
    screen.draw(LEFT)

    # Icon
    screen.cursor.fg = tab_fg
    screen.cursor.bg = tab_bg
    screen.draw(f" {_icon(tab.title)} ")

    # Title with truncation
    suffix_len = 1
    if tab.num_windows > 1:
        suffix_len += len(f" +{tab.num_windows}")
    budget = max(0, max_tab_length - (screen.cursor.x - before) - suffix_len - 2)

    title = f"{index}: {tab.title}"
    if len(title) > budget:
        title = title[: budget - 1] + "…" if budget > 1 else ""
    screen.draw(title)

    # Window count badge
    if tab.num_windows > 1:
        screen.cursor.fg = C_ACCENT if tab.is_active else C_INACTIVE_FG
        screen.cursor.bg = tab_bg
        screen.draw(f" +{tab.num_windows}")

    # Trailing space
    screen.cursor.fg = tab_fg
    screen.cursor.bg = tab_bg
    screen.draw(" ")

    # Right rounded cap
    screen.cursor.fg = tab_bg
    screen.cursor.bg = C_BAR_BG
    screen.draw(RIGHT)

    # Gap between tabs
    screen.cursor.fg = C_BAR_BG
    screen.cursor.bg = C_BAR_BG
    screen.draw(" ")

    return screen.cursor.x
