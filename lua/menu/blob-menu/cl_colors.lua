
menu = menu or {}
menu.colors = {
    background = Color(22, 22, 22, 254),
    accent1 = Color(0, 130, 254), -- Color(95, 51, 253),
    shadow = Color(18, 18, 18),
    text = Color(255, 255, 255),
    text2 = Color(210, 210, 210),
    active_underline = Color(255, 255, 255),
    bottom_bg = Color(0,0,0,40),
    textentry_outline_selected = Color(255, 255, 255, 255 * .6),
    textentry_outline = Color(255, 255, 255, 255 * .3),
    server_background = Color(35,35,35,252),
    gmod_color = Color(255, 255, 255),
    timer_color = Color(255, 255, 255),

    active_map = Color(255, 255, 255),
    inactive_map = Color(22, 22, 22)
}

menu.colors.accent2 = ColorAlpha(menu.colors.accent1, 89)
menu.colors.accent_dark = Color(math.max(menu.colors.accent1.r - 20, 0), math.max(menu.colors.accent1.g - 20, 0), math.max(menu.colors.accent1.b - 20, 0))